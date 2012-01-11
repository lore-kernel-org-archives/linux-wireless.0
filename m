Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail198.messagelabs.com ([216.82.254.163]:54750 "HELO
	mail198.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932778Ab2AKSee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 13:34:34 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Subject: [PATCH 2/2] mac80211: Fix the maximum transmit power with power constraint
Date: Wed, 11 Jan 2012 20:34:30 +0200
Message-ID: <5EFF534737810441B0F97C2792E49C2DD20372@ILMAIL01.dspg.com> (sfid-20120111_193437_603649_2C151F32)
From: "Hong Wu" <Hong.Wu@dspg.com>
To: <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The local maximum transmit power for a channel is defined as the maximum
regulatory transmission power minus the local power constraint specified
for the channel in the Power Constraint element. (7.3.2.15 IEEE80211 2007)

Signed-off-by: Hong Wu <hong.wu@dspg.com>
---
 net/mac80211/main.c |    3 ++-
 net/mac80211/mlme.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0a0d94a..6192caa 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -155,7 +155,8 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
            power = chan->max_power;
      else
            power = local->power_constr_level ?
-                 (chan->max_power - local->power_constr_level) :
+                 min(chan->max_power,
+                       (chan->max_reg_power  - local->power_constr_level)) :
                  chan->max_power;
 
      if (local->user_power_level >= 0)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ecb4c84..95d3964 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -547,7 +547,7 @@ static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
      if (pwr_constr_elem_len != 1)
            return;
 
-     if ((*pwr_constr_elem <= conf->channel->max_power) &&
+     if ((*pwr_constr_elem <= conf->channel->max_reg_power) &&
          (*pwr_constr_elem != sdata->local->power_constr_level)) {
            sdata->local->power_constr_level = *pwr_constr_elem;
            ieee80211_hw_config(sdata->local, 0);
-- 
1.7.0.4




______________________________________________________________________
DSP Group, Inc. automatically scans all emails and attachments using MessageLabs Email Security System.
_____________________________________________________________________
