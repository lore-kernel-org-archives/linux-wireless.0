Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:44436 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbaDSAee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2014 20:34:34 -0400
Date: Sat, 19 Apr 2014 10:34:10 +1000
From: James Cameron <quozl@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: John Tobias <john.tobias.ph@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 2/2] mwifiex: don't clear cmd_sent flag in timeout handler
Message-ID: <20140419003410.GB14606@us.netrek.org> (sfid-20140419_023438_654265_E510CFB6)
References: <1397710914-10061-1-git-send-email-bzhao@marvell.com>
 <1397710914-10061-2-git-send-email-bzhao@marvell.com>
 <CACUGKYMWqr2-YAXhPzo8GfPPYBd2xoD_zf56FzqpkzN=X80X8A@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F70430F70686650@SC-VEXCH1.marvell.com>
 <20140418044619.GF24166@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F706868D4@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F706868D4@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 18, 2014 at 12:16:07PM -0700, Bing Zhao wrote:
> Hi James,
> 
> > > That "adapter->cmd_sent = false" was hoping the firmware is
> > > still alive and can respond to a new command. The reality is
> > > that the timeout usually indicates the firmware has already
> > > hung. Sending another command won't recover it in this case.
> > 
> > I'm dealing with a firmware hang when more than 13 nodes are in an
> > ad-hoc IBSS, and I've just found out isn't entirely a firmware
> > hang; in that we can see beacons and probe responses from the
> > card, using tcpdump and monitor mode.
> > 
> > I'm interested to know if the "firmware hangs" that you experiment
> > with prevent autonomous RF TX, or if RF TX typically proceeds.
> 
> It depends. Even if firmware hangs the hardware is still alive.
> So you could see beacons and probe responses from the card if
> hardware has been programmed before firmware hangs.

Thanks.  I neglected to mention the time period; beacons and probe
responses are seen for many minutes after the timeout report by the
driver, and I have not yet tested for how long this lasts.  The probe
responses are in reply to new probe requests.  It makes me think the
card is working fine, apart from not communicating with the host.

HOST_INSTATUS_REG, RD_BITMAP_{U,L} are all zero when read at the
timeout.

I am reliably reproducing this particular problem.

> > > I guess you are using SDIO chip. If your host controller
> > > supports MMC_POWER_OFF/UP, you can reset the chip with this
> > > approach:
> > >
> > >         mmc_remove_host(host);
> > >         /* some delay */
> > >         mmc_add_host(host);
> > 
> > Thanks, adding that to my list of things to try, as I am using
> > SDIO too.
> 
> This code (with 20ms delay) is already in latest driver. Your
> platform and controller may require a longer delay.

Thanks.  This is the patch I found:

	mwifiex: add support for SDIO card reset

and it isn't in our tree yet.

Yes, we may need to test the delay required.  We have a host GPIO
that drives power to the card.  We have discharge clamps on that path
as well.  mmc_* is configured through device-tree to use the GPIO,
which we use for suspend and resume.  We have power-delay-ms
properties but they aren't used.

I've been testing the patch with 3000ms delay, and additional output:

	pr_err("Resetting card (3000ms) ...\n");
	mmc_remove_host(reset_host);
	pr_err("removed host\n");
	mdelay(3000);
	pr_err("delayed\n");
	mmc_add_host(reset_host);
	pr_err("added host\n");

If the host joins an IBSS with 10 peers, and three more peers added,
the wireless LED stays on, and:

[  105.023274] mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func: Timeout cmd id (1397865681.433582) = 0xa4, act = 0x0
[  105.033735] mwifiex_sdio mmc0:0001:1: num_data_h2c_failure = 0
[  105.039533] mwifiex_sdio mmc0:0001:1: num_cmd_h2c_failure = 0
[  105.045235] mwifiex_sdio mmc0:0001:1: num_cmd_timeout = 1
[  105.045245] mwifiex_sdio mmc0:0001:1: num_tx_timeout = 0
[  105.055866] mwifiex_sdio mmc0:0001:1: last_cmd_index = 3
[  105.061148] mwifiex_sdio mmc0:0001:1: last_cmd_resp_index = 2
[  105.066868] mwifiex_sdio mmc0:0001:1: last_event_index = 3
[  105.072320] mwifiex_sdio mmc0:0001:1: data_sent=0 cmd_sent=1
[  105.077944] mwifiex_sdio mmc0:0001:1: ps_mode=0 ps_state=0
[  105.083408] mwifiex_sdio: Resetting card (3000ms) ...
[  105.083408] mwifiex_sdio mmc0:0001:1: curr_cmd is still in processing
[  105.098195] mwifiex_sdio mmc0:0001:1: cmd timeout

This is mmc_remove_host not returning.  I've no idea why yet.  +CC cjb.

If the host joins an IBSS with with 13 peers, the wireless LED goes
off, and:

[   83.603038] mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func: Timeout cmd id (1397865805.48239) = 0x10, act = 0x1
[   83.613425] mwifiex_sdio mmc0:0001:1: num_data_h2c_failure = 0
[   83.613425] mwifiex_sdio mmc0:0001:1: num_cmd_h2c_failure = 0
[   83.624911] mwifiex_sdio mmc0:0001:1: num_cmd_timeout = 1
[   83.624918] mwifiex_sdio mmc0:0001:1: num_tx_timeout = 0
[   83.635542] mwifiex_sdio mmc0:0001:1: last_cmd_index = 2
[   83.640833] mwifiex_sdio mmc0:0001:1: last_cmd_resp_index = 1
[   83.646542] mwifiex_sdio mmc0:0001:1: last_event_index = 2
[   83.652002] mwifiex_sdio mmc0:0001:1: data_sent=1 cmd_sent=1
[   83.657612] mwifiex_sdio mmc0:0001:1: ps_mode=0 ps_state=0
[   83.663071] mwifiex_sdio: Resetting card (3000ms) ...
[   83.668157] mwifiex_sdio mmc0:0001:1: curr_cmd is still in processing
[   83.677902] mwifiex_sdio mmc0:0001:1: failed to get signal information
[   83.684925] mwifiex_sdio mmc0:0001:1: PREP_CMD: card is removed
[   83.713537] mmc0: card 0001 removed
[   83.713537] mwifiex_sdio: removed host
[   87.660599] mwifiex_sdio: delayed
[   87.703045] mwifiex_sdio: added host
[   87.740247] mmc0: new high speed SDIO card at address 0001
[   97.911584] mwifiex_sdio mmc0:0001:1: FW failed to be active in time

But bringing the card back to life has failed.  It seems to depend on
what command was outstanding; get RSSI vs MAC multicast address.

Is there another patch needed?  I looked through all the patches but
none seemed to relate to this.

What about forcing a reset instead of using power?  We have a host
GPIO tied to the reset input on the card.

-- 
James Cameron
http://quozl.linux.org.au/
