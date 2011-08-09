Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab1HIKBm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 06:01:42 -0400
Date: Tue, 9 Aug 2011 12:01:12 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: rt2800usb: fix races in tx queue
Message-ID: <20110809100110.GE2152@redhat.com> (sfid-20110809_120146_286689_3276AF13)
References: <20110804124653.GB5739@redhat.com>
 <CAOZOX0Xpv9OPqx2Y3GnajhmDvx3GyL1xTAjEOYjOToWcQxB6bA@mail.gmail.com>
 <20110808092914.GA2168@redhat.com>
 <CAOZOX0WM2gzOETSsJ1hR623ie1_eqcfS13bDoLxrJugcZ-Si4g@mail.gmail.com>
 <4E404AE5.1030307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E404AE5.1030307@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 08, 2011 at 10:45:25PM +0200, Gertjan van Wingerde wrote:
> >> Here is part of code where we exit the loop (and whole function) and do
> >> not remove head "reg" from tx_status fifo - and read it again when
> >> _txdone work is called next time.
> > 
> > Well but for what reason would we want to read the register again? If
> > we found an status report
> > for a queue which does not have pending items, then in this change it
> > would mean that the
> > status report is intended for a TX frame which has yet to be enqueued
> > to the hardware.
> > 
> > Obviously this means a mismatch between the TX status report and the
> > actual frame to which it
> > is being connected.
> 
> Hmm, if I understood the patch description correctly, then there may be a race in the code,
> where we actually read the TX status report before we have had the chance to handle the TX done
> URB interrupt. As far as I understood it, it are not spurious TX status reports for frames that
> were never submitted to the HW.
> If that is really the case then it is quite reasonable to wait a little bit until the TX done
> code has been executed and then process the TX status report again. 
> However, we must be damn sure that this is really what happens.
> 
> Stanislaw, please confirm (or deny) that my understanding is correct.


In this loop

                while (!rt2x00queue_empty(queue)) {
                        entry = rt2x00queue_get_entry(queue,Q_INDEX_DONE);
                        if (rt2800usb_txdone_entry_check(entry, reg))
                                break;
                }
we can process entry that is currently added to tx queue and nulify skb.

This can happen if we return false from rt2800usb_txdone_entry_check(),
so only when reg does not match ((wcid != tx_wcid) || (ack != tx_ack) ||
(pid != tx_pid)), or previous entry is ENTRY_DATA_IO_FAILED.

Stanislaw
