Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from snoopy.schmut.com ([185.37.248.246]:34888 "EHLO
        snoopy.schmut.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759964AbdJQTmX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 15:42:23 -0400
Subject: Re: iwlwifi crash with hostapd
To: linux-wireless@vger.kernel.org
References: <6e51916a-6178-5620-8f45-54705c1b4d98@schmut.com>
 <20171012212454.GB4362@us.netrek.org>
 <b985bbb0-ec49-0506-871e-b65837b05be2@schmut.com>
 <20171016033727.GB13209@us.netrek.org>
From: Mario Theodoridis <mario@schmut.com>
Message-ID: <2f83cea3-1760-1557-c0ff-0d40ab20f9e8@schmut.com> (sfid-20171017_214227_149795_F906352A)
Date: Tue, 17 Oct 2017 21:35:39 +0200
MIME-Version: 1.0
In-Reply-To: <20171016033727.GB13209@us.netrek.org>
Content-Type: multipart/mixed;
 boundary="------------64FC0F624318833FBABC4441"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------64FC0F624318833FBABC4441
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit



On 16.10.2017 05:37, James Cameron wrote:
> On Sun, Oct 15, 2017 at 06:21:36PM +0200, Mario Theodoridis wrote:
>> Thanks for the pointers, James.
>>
>> On 12.10.2017 23:24, James Cameron wrote:
>>> There's a good chance this problem has been fixed already.  You
>>> are using a v4.4 kernel with many patches applied by Ubuntu.  Here, we
>>> are more concerned with the latest kernels, and v4.4 is quite old.
>>>
>>> Please test some of the later kernels, see
>>> https://wiki.ubuntu.com/Kernel/MainlineBuilds
>>>
>>> In particular, test v4.13 or v4.14-rc4.
>>
>> I'm having a hard time with that, because the virtualbox-dkms build fails
>> with the 4.13 kernel, and virtualbox unfortunately is essential.
> 
> Is virtualbox essential for reproducing the problem, or essential for
> your general use?

It is essential for general use, like Internet connectivity.

> If the former, then that's interesting.
> 
> If the latter, then you might instead test the v4.13 or v14-rc4
> kernels for only the problem, and then revert to an older kernel after
> testing.
> 
> Either way, to use virtualbox-dkms with a later kernel you may be able
> to upgrade just the virtualbox packages from a later Ubuntu release.
> 
> See https://packages.ubuntu.com/virtualbox-dkms and
> https://packages.ubuntu.com/virtualbox for the later versions available.
> 
> Purpose of the test can be to help isolate the cause, not only to
> solve your problem.

Thanks for the info.

> 
> [...]
> You might also try with later firmware package.
> See https://packages.ubuntu.com/linux-firmware
> 
> You might also test with booting installation media in live-mode,
> ignoring the internal disk.

Ok, that was completely off the radar.


I ended up going the other way. I still had a 4.4.0-79-generic kernel 
and booted that. It does not have this problem.
After checking out
git://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/xenial
i tried to find the culprit but was not able to trace the back trace to 
a potential null pointer or some such. I got stuck at 
iwl_mvm_send_cmd_pdu_status not finding a reference to 
iwl_mvm_disable_txq from there.

I did got the following diff though

git diff Ubuntu-4.4.0-79.100 Ubuntu-4.4.0-93.116 -- 
drivers/net/wireless/iwlwifi/ drivers/net/wireless/mac80211_hwsim.c > 
wifi.patch

I don't know whether this came from upstream or was ubuntu sourced.

This fixed the issue for now, but now i'm stuck on that kernel :(

While i'm perfectly comfortable with user land C, i have no kernel 
experience (clue stick links definitely welcome).



-- 
Mit freundlichen Grüßen/Best regards

Mario Theodoridis

--------------64FC0F624318833FBABC4441
Content-Type: text/x-diff;
 name="wifi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="wifi.patch"

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index b3ad34e..1eb1a82 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -729,12 +729,15 @@ static inline bool iwl_enable_tx_ampdu(const struct iwl_cfg *cfg)
 
 static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
-				   enum ieee80211_ampdu_mlme_action action,
-				   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-				   u8 buf_size, bool amsdu)
+				   struct ieee80211_ampdu_params *params)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int ret = -EINVAL;
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
+	u8 buf_size = params->buf_size;
 	struct iwl_station_priv *sta_priv = (void *) sta->drv_priv;
 
 	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index ce12717..1a8ea77 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -826,13 +826,16 @@ iwl_mvm_ampdu_check_trigger(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
-				    enum ieee80211_ampdu_mlme_action action,
-				    struct ieee80211_sta *sta, u16 tid,
-				    u16 *ssn, u8 buf_size, bool amsdu)
+				    struct ieee80211_ampdu_params *params)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
 	bool tx_agg_ref = false;
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
+	u8 buf_size = params->buf_size;
 
 	IWL_DEBUG_HT(mvm, "A-MPDU action on addr %pM tid %d: action %d\n",
 		     sta->addr, tid, action);
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0cd9512..019d716 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1817,10 +1817,12 @@ static int mac80211_hwsim_testmode_cmd(struct ieee80211_hw *hw,
 
 static int mac80211_hwsim_ampdu_action(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
-				       enum ieee80211_ampdu_mlme_action action,
-				       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-				       u8 buf_size, bool amsdu)
+				       struct ieee80211_ampdu_params *params)
 {
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+
 	switch (action) {
 	case IEEE80211_AMPDU_TX_START:
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
@@ -2537,7 +2539,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 
 	tasklet_hrtimer_init(&data->beacon_timer,
 			     mac80211_hwsim_beacon,
-			     CLOCK_MONOTONIC_RAW, HRTIMER_MODE_ABS);
+			     CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 
 	spin_lock_bh(&hwsim_radio_lock);
 	list_add_tail(&data->list, &hwsim_radios);

--------------64FC0F624318833FBABC4441--
