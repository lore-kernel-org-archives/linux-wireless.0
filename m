Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:46177 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbeDERPi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 13:15:38 -0400
Received: by mail-wr0-f169.google.com with SMTP id d1so29628073wrj.13
        for <linux-wireless@vger.kernel.org>; Thu, 05 Apr 2018 10:15:37 -0700 (PDT)
MIME-Version: 1.0
From: Roman Kiryanov <rkir@google.com>
Date: Thu, 05 Apr 2018 17:15:25 +0000
Message-ID: <CAOGAQerAFv5JOAuJHkpVFasVn4A1ZFA09zN8=NfqDzb1RftPqw@mail.gmail.com> (sfid-20180405_191541_774439_7EB87731)
Subject: PATCH [1/1]: wireless: mac80211_hwsim: support/ignore power state changes
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: Bjoern Johansson <bjoernj@google.com>,
        Greg Kroah-Hartman <gregkh@google.com>, Bo Hu <bohu@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bjoern Johansson <bjoernj@google.com>

Indicate support for power state changes and handle them by calling an
empty function.
The important part is "ieee80211_hw_set(hw, SUPPORTS_PS);" at the
bottom of the diff. Without this upper layers in the kernel will return an
error code when trying to set the power state because the driver doesn't
indicate power state support. This in turn causes VTS
(Android Vendor Test Suite) failures because the WiFi HAL can't enable
power saving mode. The remaining code is just there to deal with the
incoming state change request.

Signed-off-by: Bjoern Johansson <bjoernj@google.com>
Signed-off-by: Lingfeng Yang <lfy@google.com>
Signed-off-by: Roman Kiryanov <rkir@google.com>
---
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1637,6 +1637,11 @@ static const char * const hwsim_chanwidths[] = {
         [NL80211_CHAN_WIDTH_160] = "vht160",
  };

+static void mac80211_power_state_changed(bool enabled)
+{
+       /* TODO: Do something when the power state changes */
+}
+
  static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
  {
         struct mac80211_hwsim_data *data = hw->priv;
@@ -1649,6 +1654,11 @@ static int mac80211_hwsim_config(struct ieee80211_hw
*hw, u32 changed)
         };
         int idx;

+       if (changed & IEEE80211_CONF_CHANGE_PS) {
+               bool enabled = (conf->flags & IEEE80211_CONF_PS) != 0;
+               mac80211_power_state_changed(enabled);
+       }
+
         if (conf->chandef.chan)
                 wiphy_dbg(hw->wiphy,
                           "%s (freq=%d(%d - %d)/%s idle=%d ps=%d
smps=%s)\n",
@@ -2650,7 +2660,9 @@ static int mac80211_hwsim_new_radio(struct genl_info
*info,
         ieee80211_hw_set(hw, AMPDU_AGGREGATION);
         ieee80211_hw_set(hw, MFP_CAPABLE);
         ieee80211_hw_set(hw, SIGNAL_DBM);
+       ieee80211_hw_set(hw, SUPPORTS_PS);
         ieee80211_hw_set(hw, TDLS_WIDER_BW);
+
         if (rctbl)
                 ieee80211_hw_set(hw, SUPPORTS_RC_TABLE);
