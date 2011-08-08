Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:52745 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1HHJn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 05:43:56 -0400
Received: by iye16 with SMTP id 16so8700086iye.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 02:43:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110808092914.GA2168@redhat.com>
References: <20110804124653.GB5739@redhat.com>
	<CAOZOX0Xpv9OPqx2Y3GnajhmDvx3GyL1xTAjEOYjOToWcQxB6bA@mail.gmail.com>
	<20110808092914.GA2168@redhat.com>
Date: Mon, 8 Aug 2011 11:43:55 +0200
Message-ID: <CAOZOX0WM2gzOETSsJ1hR623ie1_eqcfS13bDoLxrJugcZ-Si4g@mail.gmail.com> (sfid-20110808_114400_199985_56A4864E)
Subject: Re: [PATCH] rt2x00: rt2800usb: fix races in tx queue
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> On Sat, Aug 06, 2011 at 01:06:51PM +0200, Ivo Van Doorn wrote:
>> On Thu, Aug 4, 2011 at 2:46 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> > -static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
>> > +static int rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
>> >  {
>> >        struct data_queue *queue;
>> >        struct queue_entry *entry;
>> >        u32 reg;
>> >        u8 qid;
>> >
>> > -       while (kfifo_get(&rt2x00dev->txstatus_fifo, &reg)) {
>> > +       while (kfifo_peek(&rt2x00dev->txstatus_fifo, &reg)) {
>>
>> I'm not too sure about this change, why do you need to do kfifo_peek
>> and add gotos to the end of the while-loop to remove the item from the queue?
>> There is no condition in which the obtained value from kfifo-peek
>> will require it to be read again later (because when the value couldn't be
>> handled we are throwing it away anyway using kfifo_skip).
>
> There is new case (see below) where it is needed. I can get rid of goto,
> that will make code a bit cleaner. There is place for optimization, mainly
> make tx_status fifo per queue, but for now I just want to fix kernel crashes.
>
>> >                /* TX_STA_FIFO_PID_QUEUE is a 2-bit field, thus
>> >                 * qid is guaranteed to be one of the TX QIDs
>> > @@ -517,25 +517,39 @@ static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
>> >                if (unlikely(!queue)) {
>> >                        WARNING(rt2x00dev, "Got TX status for an unavailable "
>> >                                           "queue %u, dropping\n", qid);
>> > -                       continue;
>> > +                       goto next_reg;
>> >                }
>> >
>> >                /*
>> >                 * Inside each queue, we process each entry in a chronological
>> >                 * order. We first check that the queue is not empty.
>> >                 */
>> > -               entry = NULL;
>> > -               while (!rt2x00queue_empty(queue)) {
>> > +               while (1) {
>> > +                       entry = NULL;
>> > +
>> > +                       if (rt2x00queue_empty(queue))
>> > +                               break;
>> > +
>> >                        entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
>> > +
>> > +                       if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
>> > +                           !test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags)) {
>> > +                               WARNING(rt2x00dev, "Data pending for entry %u"
>> > +                                       "in queue %u\n", entry->entry_idx, qid);
>> > +                               return 1;
>
> Here is part of code where we exit the loop (and whole function) and do
> not remove head "reg" from tx_status fifo - and read it again when
> _txdone work is called next time.

Well but for what reason would we want to read the register again? If
we found an status report
for a queue which does not have pending items, then in this change it
would mean that the
status report is intended for a TX frame which has yet to be enqueued
to the hardware.

Obviously this means a mismatch between the TX status report and the
actual frame to which it
is being connected.

Ivo
