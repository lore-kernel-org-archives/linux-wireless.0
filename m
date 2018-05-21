Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:43946 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750909AbeEUWnn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 18:43:43 -0400
Date: Mon, 21 May 2018 15:43:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Hahn, Maital" <maitalm@ti.com>,
        "Altshul, Maxim" <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Loewy, Chen" <c-loewy@ti.com>
Subject: Re: [EXTERNAL] [PATCHv2 0/5] Runtime PM support for wlcore
Message-ID: <20180521224339.GD98604@atomide.com> (sfid-20180522_004347_036873_D6DAF2DD)
References: <20180517185029.71716-1-tony@atomide.com>
 <bff51dcc6fd441d9ab42db273219aaf4@ti.com>
 <20180521163830.GZ98604@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180521163830.GZ98604@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Tony Lindgren <tony@atomide.com> [180521 16:40]:
> * Reizer, Eyal <eyalr@ti.com> [180521 07:31]:
> > > Here's a series of patches to add runtime PM support for wlcore. It does not
> > > yet implement autosuspend support, but let's get this tested first as the
> > > autosuspend can mask enable/disable issues easily.
> > 
> > Testing on BBB+WL1837 cape, scan, recovery, down/up and basic traffic seems ok now.
> > Of course we need to test some more.
> 
> Thanks for testing. Yes let's do more testing, no rush with these.
> Hopefully they'll be ready for v4.19 merge window though.
> 
> > Standard suspend/resume seems to work ok as well.
> > Ennabling wowlan and suspending is  crashing on resume. See below.
> > 
> > root@am335x-evm:/usr/share/wl18xx# iw phy0 wowlan enable any dme
> > root@am335x-evm:/usr/share/wl18xx#
> > root@am335x-evm:/usr/share/wl18xx# echo mem > /sys/power/state
> > [  541.567039] PM: suspend entry (deep)
> > [  541.570688] PM: Syncing filesystems ... done.
> > [  541.594277] Freezing user space processes ... (elapsed 0.001 seconds) done.
> > [  541.603160] OOM killer disabled.
> > [  541.606738] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
> > [  541.615984] Suspending console(s) (use no_console_suspend to debug)
> > [  542.895091] pm33xx pm33xx: PM: Successfully put all powerdomains to target state
> > [  542.895091] PM: Wakeup source UART
> > [  542.919791] net eth0: initializing cpsw version 1.12 (0)
> > [  543.017880] SMSC LAN8710/LAN8720 4a101000.mdio:00: attached PHY driver [SMSC LAN8710/LAN8720] (mii_bus:phy_addr=4a101000.mdio:00, irq=POLL)
> > [  543.027646] ------------[ cut here ]------------
> > [  543.028023] WARNING: CPU: 0 PID: 932 at drivers/net/wireless/ti/wlcore/cmd.c:76 wlcore_cmd_send_failsafe+0x498/0x4f8 [wlcore]
> 
> This warning is because wlcore is wlcore is still in ELP. This is
> somehow possible even though we call pm_runtime_get_sync() in
> wl1271_op_resume(). Anyways, I'll try to reproduce it here.

Sorry I can't somehow get my beagleboard to wake-up from suspend,
I'm almost certain that worked the last time I tried.

Anyways, maybe the following patch fixes this if you care to
test again.

Regards,

Tony

8< ------------------------
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1867,8 +1867,6 @@ static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
 			if (ret)
 				wl12xx_queue_recovery_work(wl);
 		}
-
-		wlcore_enable_interrupts(wl);
 	}
 
 	if (pending_recovery) {
@@ -1877,6 +1875,8 @@ static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
 		goto out_sleep;
 	}
 
+	wlcore_enable_interrupts(wl);
+
 	ret = pm_runtime_get_sync(wl->dev);
 	if (ret < 0) {
 		pm_runtime_put_noidle(wl->dev);
