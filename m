Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout9.freenet.de ([195.4.92.99]:52884 "EHLO mout9.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab1HXL7x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 07:59:53 -0400
Message-Id: <201108241159.p7OBxipD003869@mail.maya.org> (sfid-20110824_135956_740605_B76C0831)
Date: Wed, 24 Aug 2011 13:59:49 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [compat-wireless-3.1-rc1-1] rt2800usb crashes the machine
In-Reply-To: <20110824090340.GA2277@redhat.com>
References: <4E536DD8.6030308@01019freenet.de>
	<20110824090340.GA2277@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Stanislaw,

thank you for spending your time for this problem!

Am Wed, 24 Aug 2011 11:03:41 +0200
schrieb Stanislaw Gruszka <sgruszka@redhat.com>:

> On Tue, Aug 23, 2011 at 11:07:36AM +0200, Andreas Hartmann wrote:
> > using rt2800usb with a Linksys WUSB600N v2 (rt3572) crashes the complete
> > machine (SMP, Core i5, linux 3.0) on unloading the module after using it
> > for a short period of time:
> > - 2 times netperf -t TCP_MAERTS -H host
> > - 2 times netperf -t TCP_STREAM -H host
> > 
> > The error message in /var/log/messages is:
> > 
> > phy0 -> rt2800_wait_wpdma_ready: Error - WPDMA TX/RX busy, aborting
> > 
> > After the crash, you have to hard reset the machine.
> Did you hibernate machine anytime before the rmmod ?

No, there was no suspend / resume done with this module at all.

I think, the problem of this hang is located elsewhere. To get more
information, I switched on debugging of the rt2x00-driver and did the
tests again. During the tests, I get tons of these warnings
in /var/log/messages:


Aug 24 13:01:55 pc kernel: [22286.549510] phy0 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 36
Aug 24 13:01:55 pc kernel: [22286.549530] phy0 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 37
Aug 24 13:01:55 pc kernel: [22286.549546] phy0 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 39
Aug 24 13:01:55 pc kernel: [22286.549560] phy0 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 40
Aug 24 13:01:55 pc kernel: [22286.550511] phy0 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 42
Aug 24 13:01:55 pc kernel: [22286.550749] phy0 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 44
Aug 24 13:01:55 pc kernel: [22286.550766] phy0 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 46
Aug 24 13:01:55 pc kernel: [22286.550780] phy0 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 47
Aug 24 13:01:55 pc kernel: [22286.551756] phy0 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 48
Aug 24 13:01:55 pc kernel: [22286.552006] phy0 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 50
Aug 24 13:01:55 pc kernel: [22286.552032] phy0 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 52

(about 144/s)

Another entry is:

Aug 24 12:59:46 pc kernel: [22157.608241] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler

The measured throughput is:

- to STA (-> where rt2800usb runs) is about 4 MB/s.
- from STA is about 1 _k_B/s.

The Linksys WUSB600N V2 dongle should have a throughput of about 10 M/s
in both directions! I think, if the handling of the queues is fixed,
the problem of the hanging machine will be gone, too!


If I should test some patches or if you want need some more information
- please ask, I'll try to provide them!


Kind regards,
Andreas
