Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out112.alice.it ([85.37.17.112]:1335 "EHLO
	smtp-out112.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbXF1Oe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2007 10:34:58 -0400
From: Matteo Croce <rootkit85@yahoo.it>
To: Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [PATCH 0/4] airo fixes
Date: Thu, 28 Jun 2007 16:34:52 +0200
References: <200706281551.37334.rootkit85@yahoo.it>
In-Reply-To: <200706281551.37334.rootkit85@yahoo.it>
MIME-Version: 1.0
Message-Id: <200706281634.52701.rootkit85@yahoo.it>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, previous mail was repeated....

> > On Wed, 2007-06-27 at 23:14 +0200, Michal Schmidt wrote:
> > Hello,
> >
> > this is a series of four patches for the airo driver:
> >
> > 1/4: airo: don't use the interface name so much before registration
> > 2/4: airo: delay parts of initialization until the netdev is up
> > 3/4: airo: disable the PCI device when unloading module
> > 4/4: airo: start with radio off
> >
> > The first two fix the race condition Matteo Croce was experiencing.
> > The third one fixes a bug I noticed during testing.
> > The last one saves some power when the card is not used.
>
> I have applied your 4 patches on both a vanilla 2.6.21.5 kernel and
> a 2.6.22-rc6 wireless-dev one, and i found that only patches 1/4 and 2/4
> are good.
> the 3/4 one gives this bogus output:
>
> airo(): Probing for PCI adapters
> PCI: Setting latency timer of device 0000:05:08.0 to 64
> airo(eth%d): cmd:111 status:7f11 rsp0:2 rsp1:0 rsp2:0
> airo(eth%d): Doing fast bap_reads
> airo(): WPA is supported.
> airo(eth0): MAC enabled 0:d:29:4f:c:be
> airo(): Finished probing for PCI adapters
>
> and the 4/4 definitely broke all:
>
> airo(): Probing for PCI adapters
> PCI: Setting latency timer of device 0000:05:08.0 to 64
> airo(eth%d): cmd:111 status:7f11 rsp0:2 rsp1:0 rsp2:0
> airo(eth%d): Doing fast bap_reads
> airo(eth%d): Bad MAC enable reason = 2, rid = 0, offset = 0
> airo(eth%d): MAC could not be enabled
> airo(): Finished probing for PCI adapters

I investigated further:
1/4 and 3/4 are OK
2/4 makes the ugly output
4/4 broke everything

also one of the 4 patches causes a random kernel panic on vanilla 2.6.21.5 but
I don't care since they are meant to be applied on another kernel tree

Bye
Matteo Croce
