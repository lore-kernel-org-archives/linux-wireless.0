Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50057 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030385Ab2CFMIF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 07:08:05 -0500
Received: by mail-lpp01m010-f46.google.com with SMTP id j13so5931162lah.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Mar 2012 04:08:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120306115321.GB31306@redhat.com>
References: <20120305164813.GB2979@redhat.com>
	<CAGXE3d9==tT-ukfn5RO9xTEfw=YXO=FAVJob2WMFJS-FS8j9GQ@mail.gmail.com>
	<20120306115321.GB31306@redhat.com>
Date: Tue, 6 Mar 2012 13:08:04 +0100
Message-ID: <CAL1gcdNZR6KoZeQkW1EaZp5ptH9X5M+vhpo7pnPyUvkE6p6qDg@mail.gmail.com> (sfid-20120306_130813_308887_C3162558)
Subject: Re: [PATCH 3.3] rt2x00: fix random stalls
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Tue, Mar 6, 2012 at 12:53 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Tue, Mar 06, 2012 at 08:45:21AM +0100, Helmut Schaa wrote:
>> > -       if (!rt2x00queue_threshold(entry->queue))
>> > +       if (!rt2x00queue_threshold(entry->queue)) {
>> > +               spin_lock_irq(&entry->queue->tx_lock);
>> >                rt2x00queue_unpause_queue(entry->queue);
>> > +               spin_unlock_irq(&entry->queue->tx_lock);
>>
>> Why do we need to disable interrupts here? spin_lock_bh should
>> be sufficient.
>
> I'm not 100% sure, and I was to lazy to find out, and chose safer
> version. I guess I need to find out now ...
>

That is actually a good point of Helmut. In all other cases where the tx_lock
is used we actually use spin_lock and spin_unlock. AFAIK we shouldn't mix
the different spinlock variants, so with this the other uses may have to change
as well.

---
Gertjan
