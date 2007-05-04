Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289AbXEDNzZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2007 09:55:25 -0400
Subject: Re: airo works badly
From: Dan Williams <dcbw@redhat.com>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Matteo Croce <rootkit85@yahoo.it>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <463B28F1.4020107@redhat.com>
References: <200705041410.02269.rootkit85@yahoo.it>
	 <463B28F1.4020107@redhat.com>
Content-Type: text/plain
Date: Fri, 04 May 2007 09:58:51 -0400
Message-Id: <1178287131.26720.23.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-05-04 at 14:37 +0200, Michal Schmidt wrote:
> (CCing linux-wireless, other people might have ideas)
> 
> Matteo Croce skrev:
> > Every day i gets offline after reading this in the syslog:

Is this 340 or a 350?  MiniPCI or PC-Card?  Can you give us the PCI
device numbers (from lspci) or the PC-Card manufacturer and device id
(available from lshal)?

What firmware version as well?  Post the output of the following and
scrub MAC addresses if you like.

cat /proc/driver/aironet/eth0/Status

If we can't determine anything with this, would you be willing to post
your card to a developer so we can diagnose?  I personally have a few
airo 350 cards, both MPCI and PCMCIA, and none of them exhibit this
problem.

Dan

> > May  3 15:25:30 raver kernel: airo(): Probing for PCI adapters
> > May  3 15:25:30 raver kernel: airo(eth0): cmd:111 status:7f11 rsp0:2 rsp1:0 rsp2:0
> > May  3 15:25:30 raver kernel: airo(eth0): Doing fast bap_reads
> > May  3 15:25:30 raver kernel: airo(eth0): WPA is supported.
> > May  3 15:25:30 raver kernel: airo(eth0): MAC enabled 0:d:29:4f:c:be
> > May  3 15:25:30 raver kernel: airo(): Finished probing for PCI adapters
> > May  3 17:59:36 raver kernel: airo(eth0): Bad size 8192
> > May  3 18:47:52 raver kernel: airo(eth0): Bad size 8192
> > May  3 19:05:47 raver kernel: airo(eth0): Bad size 8192
> > May  3 19:08:08 raver kernel: airo(eth0): Bad size 8192
> > May  3 19:20:07 raver kernel: airo(eth0): airo: BAP setup error too many retries
> > May  3 19:20:07 raver kernel: airo(eth0): airo: BAP setup error too many retries
> > May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> > May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> > May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> > May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> > May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> > May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> > May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> > May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> > May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> > May  3 19:20:10 raver kernel: airo(eth0): airo: BAP setup error too many retries
> > May  3 19:20:10 raver kernel: airo(eth0): airo: BAP setup error too many retries
> 
> Hi,
> 
> What kernel version are you using? Is this a regression? If so, what was
> the last version that worked well?
> What if you rmmod the driver and then reload it? Does it make it work again?
> What hardware is it exactly? The airo driver supports more than one type
> of card.
> Are you doing anything special with the card, like running some wifi
> monitoring application for instance?
> 
> Michal
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

