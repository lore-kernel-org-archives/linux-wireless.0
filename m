Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:18173 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbYKMQ01 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 11:26:27 -0500
Received: by wf-out-1314.google.com with SMTP id 27so972921wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 08:26:26 -0800 (PST)
Message-ID: <b6c5339f0811130826p138ceae1hc6fc55bf7cf5c595@mail.gmail.com> (sfid-20081113_172631_651705_41BDF66F)
Date: Thu, 13 Nov 2008 11:26:26 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Xu, Martin" <martin.xu@intel.com>
Subject: Re: [ath5k-devel] [Bug 11749] Ath5k driver has too many interrupts per second at idle
Cc: "Nick Kossifidis" <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"yang.y.yi@gmail.com" <yang.y.yi@gmail.com>,
	"Vikram Kandukuri" <Vikram.Kandukuri@atheros.com>,
	"Jothikumar Mothilal" <Jothikumar.Mothilal@atheros.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"Liu, Bing Wei" <bing.wei.liu@intel.com>,
	"Selbak, Rolla N" <rolla.n.selbak@intel.com>,
	"Wang, Yong Y" <yong.y.wang@intel.com>
In-Reply-To: <9F0C1DB20AFA954FA1DA05309350433D41083496@pdsmsx503.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <bug-11749-13098@http.bugzilla.kernel.org/>
	 <20081013150525.884BC108058@picon.linux-foundation.org>
	 <43e72e890810131206u75fd68e8p5416d7456ff44097@mail.gmail.com>
	 <40f31dec0810131214j1709534fl2a95bb844d08513b@mail.gmail.com>
	 <9F0C1DB20AFA954FA1DA05309350433D41083496@pdsmsx503.ccr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 13, 2008 at 1:12 AM, Xu, Martin <martin.xu@intel.com> wrote:
> Hi all:
> I have a patch that can be used to fix the bug.
> The patch resolved the issue by disabling the beacon filter when disassociated with AP and enabling beacon when associate with AP.
> See http://bugzilla.kernel.org/show_bug.cgi?id=11749
> Please review it. Thanks!

Thanks for the patch!

I think the basic idea is ok (we only have beacons if PRBRESP_PROMISC is set
or if we are in STA mode _and_ associated, or in IBSS mode).  However, there
are lots of CodingStyle issues with the patch.  Please run
scripts/checkpatch.pl on it and fix the corresponding whitespace issues.

+static void
+enable_beacon_filter(struct ieee80211_hw *hw)
+{
+        struct ath5k_softc *sc = hw->priv;
+        struct ath5k_hw *ah = sc->ah;
+        u32 rfilt;
+        rfilt = ath5k_hw_get_rx_filter(ah);
+        if ( !(rfilt & AR5K_RX_FILTER_BEACON) ){

Probably not worth it to do the test, since this isn't going to get
called that often.

+                rfilt |= AR5K_RX_FILTER_BEACON;
+                ath5k_hw_set_rx_filter(ah,rfilt);
+                sc->filter_flags = rfilt;
+        }
+        rfilt = ath5k_hw_get_rx_filter(ah);
+        return;

Above two lines are unnecessary.

+}

You remove a heap of code by making this set_beacon_filter(hw, bool enable)
and cleaning up the branches in bss_info_changed.  I believe this can race
with configure_filter as well (but configure_filter already races with
anything that touches sc->status...).

> @@ -179,6 +179,7 @@ struct ath5k_softc {
>
>        struct timer_list       calib_tim;      /* calibration timer */
>        int                     power_level;    /* Requested tx power in dbm */
> +       bool                    assoc;          /* assocate state */
>  };

s/assocate/associate.  Also in ath5k we sometimes use sc->status for such
flags, though this could go either way.

-- 
Bob Copeland %% www.bobcopeland.com
