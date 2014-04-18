Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11858 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457AbaDRTRd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2014 15:17:33 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "quozl@laptop.org" <quozl@laptop.org>
CC: John Tobias <john.tobias.ph@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Date: Fri, 18 Apr 2014 12:16:07 -0700
Subject: RE: [PATCH 2/2] mwifiex: don't clear cmd_sent flag in timeout
 handler
Message-ID: <477F20668A386D41ADCC57781B1F70430F706868D4@SC-VEXCH1.marvell.com> (sfid-20140418_211737_673746_7C307DCC)
References: <1397710914-10061-1-git-send-email-bzhao@marvell.com>
 <1397710914-10061-2-git-send-email-bzhao@marvell.com>
 <CACUGKYMWqr2-YAXhPzo8GfPPYBd2xoD_zf56FzqpkzN=X80X8A@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F70430F70686650@SC-VEXCH1.marvell.com>
 <20140418044619.GF24166@us.netrek.org>
In-Reply-To: <20140418044619.GF24166@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

> > That "adapter->cmd_sent = false" was hoping the firmware is still
> > alive and can respond to a new command. The reality is that the
> > timeout usually indicates the firmware has already hung. Sending
> > another command won't recover it in this case.
> 
> I'm dealing with a firmware hang when more than 13 nodes are in an ad-hoc
> IBSS, and I've just found out isn't entirely a firmware hang; in that we can see
> beacons and probe responses from the card, using tcpdump and monitor
> mode.
> 
> I'm interested to know if the "firmware hangs" that you experiment with
> prevent autonomous RF TX, or if RF TX typically proceeds.

It depends. Even if firmware hangs the hardware is still alive.
So you could see beacons and probe responses from the card if hardware has been programmed before firmware hangs.

> > I guess you are using SDIO chip. If your host controller supports
> > MMC_POWER_OFF/UP, you can reset the chip with this approach:
> >
> >         mmc_remove_host(host);
> >         /* some delay */
> >         mmc_add_host(host);
> 
> Thanks, adding that to my list of things to try, as I am using SDIO too.

This code (with 20ms delay) is already in latest driver. Your platform and controller may require a longer delay.

Regards,
Bing
