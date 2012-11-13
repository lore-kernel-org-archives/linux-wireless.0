Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62423 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab2KMTzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 14:55:43 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so5258823pad.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 11:55:43 -0800 (PST)
Message-ID: <50A2A5BC.1030303@cozybit.com> (sfid-20121113_205602_978261_022C75C4)
Date: Tue, 13 Nov 2012 11:55:40 -0800
From: Marco Porsch <marco@cozybit.com>
MIME-Version: 1.0
To: adrian@freebsd.org
CC: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: issue with ath9k_htc and mesh mode powersave
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

my name is Marco Porsch, I am currently implementing mesh mode powersave 
as part of mac80211 and some wireless drivers.

When testing with a ath9k_htc TL-WN721N and monitoring the power 
consumption on the USB cable, I see the following behaviour:

during normal mesh operation in powersave mode the power consumption 
rises to 120mA (~55mA is the usual current in PS mode without activity) 
and stays stuck at that level until ifdown. Mesh leave + join does not 
reset it to normal behaviour. Sometimes it only takes few seconds until 
the power consumption gets stuck; sometimes it works fine for multiple 
minutes.

I have no idea what is the reason for that behaviour.
No obvious debug output is given despite all ath9k debugs enabled. I can 
only suspect the hardware expects some managed-mode only event from the 
access point that we do not have there in mesh mode.
When looking at the NDA firmware I did not see anything related to power 
save mode that could help.

Do you have any idea what could be the reason for that behaviour? Or any 
hints for debugging the issue?


Regards,
Marco



PS:

For testing I use a simplistic "mesh awake window" implementation that 
queues waking up from sleep mode after beacon preparation and sets a 
timer for going to sleep again after the awake window is expired. I 
added a bool in_awake_window that blocks going to NETWORKSLEEP when set. 
The code looks like:

@@ -473,6 +495,14 @@ void ath9k_htc_swba(struct ath9k_htc_priv *priv,
  	ath9k_htc_send_buffered(priv, slot);
  	ath9k_htc_send_beacon(priv, slot);

+	/* mesh awake window */
+	if (priv->ah->opmode == NL80211_IFTYPE_MESH_POINT && priv->ps_enabled) {
+		priv->in_awake_window = true;
+		ieee80211_queue_work(priv->hw, &priv->ps_work);
+		mod_timer(&priv->awake_window_timer, jiffies +
+				usecs_to_jiffies(1024 * priv->awake_window) +
+				priv->ah->config.sw_beacon_response_time);
+	}
  }

When the timer expires it calls:

@@ -276,6 +284,14 @@ void ath9k_ps_work(struct work_struct *work)
  	ath9k_htc_setpower(priv, ATH9K_PM_NETWORK_SLEEP);
  }

+void ath9k_htc_mesh_awake_window_timer(unsigned long data)
+{
+	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *) data;
+
+	priv->in_awake_window = false;
+	ieee80211_queue_work(priv->hw, &priv->ps_work);
+}
+


PPS:

Some further hacking revealed that reading AR_RTC_STATUS before and 
after REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN) shows the 
following

normal behaviour:

[ 301.655141] ath: phy0: AR_RTC_STATUS before: 02
[ 301.661079] ath: phy0: AR_RTC_STATUS after : 04

when being stuck it changes to:

[ 302.677066] ath: phy0: AR_RTC_STATUS before: 02
[ 302.683085] ath: phy0: AR_RTC_STATUS after : 02
