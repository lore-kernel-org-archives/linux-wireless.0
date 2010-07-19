Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49101 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756791Ab0GSX5Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 19:57:16 -0400
Subject: Re: iwlagn and many firmware restarts with Fedora kernel
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: drago01 <drago01@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1279582174.4572.43.camel@localhost.localdomain>
References: <1279565034.4572.36.camel@localhost.localdomain>
	 <AANLkTinGUQjPoMRmt_jeFgpxLhzma7qhfR14t_tWLvO1@mail.gmail.com>
	 <1279582174.4572.43.camel@localhost.localdomain>
Content-Type: multipart/mixed; boundary="=-MCUlmAADUH/HR60gvu0p"
Date: Mon, 19 Jul 2010 16:56:38 -0700
Message-Id: <1279583798.28066.3.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MCUlmAADUH/HR60gvu0p
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi drago,

On Mon, 2010-07-19 at 16:29 -0700, Marcel Holtmann wrote:
> Hi,
> 
> > > so during the last few weeks, I have seen a huge amount of firmware
> > > restarts with my Intel 5350 card and Fedora 13 kernel (2.6.33.6-147).
> > >
> > > iwlagn 0000:03:00.0: low ack count detected, restart firmware
> > > iwlagn 0000:03:00.0: On demand firmware reload
> > > iwlagn 0000:03:00.0: Stopping AGG while state not ON or starting
> > > iwlagn 0000:03:00.0: queue number out of range: 0, must be 10 to 19
> > >
> > > If this happens then I don't see it once, I normally see this 10-20
> > > times and the connectivity is stalled until the cards comes back to
> > > life. I have seen patches that should have fixed this symptom, but they
> > > might be also send to -stable since this is a major hassle.
> > >
> > > The time without connectivity is something around 4-5 minutes or longer
> > > when this happens. Not really funny.
> > 
> > This happens here too even with the 2.6.34.1-9.fc13.x86_64 kernel;
> > when this happens reloading the iwlagn module seems to be the only
> > (quick) way to get it back to life.
> 
> the quick way is re-loading the module, that is true. Otherwise you have
> to sit it out. It always comes back nicely and starts working again.
> 
Are you using 5350? here I attach a "RFC patch", could you give a try to
see if it help?

Regards
Wey

--=-MCUlmAADUH/HR60gvu0p
Content-Disposition: attachment; filename*0=0001-iwlwifi-extend-the-stuck-queue-monitor-timer-for-53.patc; filename*1=h
Content-Type: text/x-patch; name="0001-iwlwifi-extend-the-stuck-queue-monitor-timer-for-53.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From d399851898df57fc03d513c2a336d3f3745b0d10 Mon Sep 17 00:00:00 2001
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date: Mon, 19 Jul 2010 16:38:19 -0700
Subject: [PATCH 1/1] iwlwifi: extend the stuck queue monitor timer for 5350 device

Different hardware has differnet behavior, extend the monitor period
timer from 1 second to 5 seconds to avoid the un-necessary firmware reload

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 68e282b..4325a53 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -642,7 +642,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 30853c8..d439b80 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1051,6 +1051,7 @@ struct iwl_event_log {
 
 /* timer constants use to monitor and recover stuck tx queues in mSecs */
 #define IWL_MONITORING_PERIOD  (1000)
+#define IWL_LONG_MONITORING_PERIOD  (5000)
 #define IWL_ONE_HUNDRED_MSECS   (100)
 #define IWL_SIXTY_SECS          (60000)
 
-- 
1.5.6.3


--=-MCUlmAADUH/HR60gvu0p--

