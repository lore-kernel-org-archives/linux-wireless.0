Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52112 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514AbaDXHXT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 03:23:19 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "quozl@laptop.org" <quozl@laptop.org>
CC: John Tobias <john.tobias.ph@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Chris Ball <cjb@laptop.org>
Date: Thu, 24 Apr 2014 00:22:54 -0700
Subject: RE: [PATCH 2/2] mwifiex: don't clear cmd_sent flag in timeout
 handler
Message-ID: <477F20668A386D41ADCC57781B1F70430F70A2AB5E@SC-VEXCH1.marvell.com> (sfid-20140424_092333_070516_7DEBC59D)
References: <1397710914-10061-1-git-send-email-bzhao@marvell.com>
 <1397710914-10061-2-git-send-email-bzhao@marvell.com>
 <CACUGKYMWqr2-YAXhPzo8GfPPYBd2xoD_zf56FzqpkzN=X80X8A@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F70430F70686650@SC-VEXCH1.marvell.com>
 <20140418044619.GF24166@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F706868D4@SC-VEXCH1.marvell.com>
 <20140419003410.GB14606@us.netrek.org>
In-Reply-To: <20140419003410.GB14606@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

> > > I'm interested to know if the "firmware hangs" that you experiment
> > > with prevent autonomous RF TX, or if RF TX typically proceeds.
> >
> > It depends. Even if firmware hangs the hardware is still alive.
> > So you could see beacons and probe responses from the card if hardware
> > has been programmed before firmware hangs.
> 
> Thanks.  I neglected to mention the time period; beacons and probe
> responses are seen for many minutes after the timeout report by the driver,
> and I have not yet tested for how long this lasts.  The probe responses are in
> reply to new probe requests.  It makes me think the card is working fine,
> apart from not communicating with the host.
> 
> HOST_INSTATUS_REG, RD_BITMAP_{U,L} are all zero when read at the
> timeout.

This means that the firmware does not have any packet (command response, event, rx data) for host.

> [   83.663071] mwifiex_sdio: Resetting card (3000ms) ...
> [   83.668157] mwifiex_sdio mmc0:0001:1: curr_cmd is still in processing
> [   83.677902] mwifiex_sdio mmc0:0001:1: failed to get signal information
> [   83.684925] mwifiex_sdio mmc0:0001:1: PREP_CMD: card is removed
> [   83.713537] mmc0: card 0001 removed
> [   83.713537] mwifiex_sdio: removed host
> [   87.660599] mwifiex_sdio: delayed
> [   87.703045] mwifiex_sdio: added host
> [   87.740247] mmc0: new high speed SDIO card at address 0001
> [   97.911584] mwifiex_sdio mmc0:0001:1: FW failed to be active in time
> 
> But bringing the card back to life has failed.  It seems to depend on what
> command was outstanding; get RSSI vs MAC multicast address.

Unlikely, it's just a coincidence.

> 
> Is there another patch needed?  I looked through all the patches but none
> seemed to relate to this.

No other patch is needed if mmc host power off/up is implemented.

> 
> What about forcing a reset instead of using power?  We have a host GPIO
> tied to the reset input on the card.

Usually toggling 8787 PDn pin is sufficient to power cycle the chip. But if that's not working for whatever reason it's worth a try on RESETn pin.

Thanks,
Bing

