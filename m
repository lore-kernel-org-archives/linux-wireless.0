Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:44848 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab3CTWJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 18:09:55 -0400
Received: by mail-ee0-f50.google.com with SMTP id e51so1452408eek.9
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2013 15:09:54 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Marco Fonseca <marco@tampabay.rr.com>
Subject: Re: carl9170: monitor mode hangs due to channel changes
Date: Wed, 20 Mar 2013 23:09:47 +0100
Cc: linux-wireless@vger.kernel.org
References: <20130320205013.GA3462@192.168.1.10>
In-Reply-To: <20130320205013.GA3462@192.168.1.10>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201303202309.47596.chunkeey@googlemail.com> (sfid-20130320_231000_226816_AECB0503)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Wednesday, March 20, 2013 09:50:13 PM Marco Fonseca wrote:
> I'm seeing a problem with the carl driver. If I change channels
> repeatedly on the 2.4ghz band, monitoring (e.g. tcpdump) will
> eventually halt.  I've seen this on various versions of the carl
> driver/firmware (both from 1.9.4 to 1.9.7)
thanks for reporting this. You could try either of the attached
patch and test if it alleviate the issue. If the patches do help
then the problem is caused by rf/phy (code) [which is a problem
since the rf/phy parts are taken from the vendor driver as we
have no docs or specs for it].

Regards,
	Chr
--

Patch 1: just reinitialize AGC_CONTROL
(can also be moved behind CMD_FREQ_START)
---
diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index b72c09c..7fffee6 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -1638,6 +1638,13 @@ int carl9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 		cmd = CARL9170_CMD_FREQUENCY;
 	}
 
+	err = carl9170_write_reg(ar, AR9170_PHY_REG_AGC_CONTROL,
+		carl9170_def_val(AR9170_PHY_REG_AGC_CONTROL,
+				 channel->band == IEEE80211_BAND_2GHZ,
+				 conf_is_ht40(&ar->hw->conf)));
+	if (err)
+		return err;
+
 	err = carl9170_exec_cmd(ar, CARL9170_CMD_FREQ_START, 0, NULL, 0, NULL);
 	if (err)
 		return err;
---


Patch 2: always do warm reset when changing channels
---
diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index b72c09c..643cc57 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -1578,7 +1578,7 @@ int carl9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 	u32 cmd, tmp, offs = 0, new_ht = 0;
 	int err;
 	enum carl9170_bw bw;
-	bool warm_reset;
+	bool warm_reset = true;
 	struct ieee80211_channel *old_channel = NULL;
 
 	bw = nl80211_to_carl(_bw);
@@ -1592,14 +1592,7 @@ int carl9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 	/* may be NULL at first setup */
 	if (ar->channel) {
 		old_channel = ar->channel;
-		warm_reset = (old_channel->band != channel->band) ||
-			     (old_channel->center_freq ==
-			      channel->center_freq) ||
-			     (ar->ht_settings != new_ht);
-
 		ar->channel = NULL;
-	} else {
-		warm_reset = true;
 	}
 
 	/* HW workaround */
---
