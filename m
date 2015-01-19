Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:59877 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbbASJOc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 04:14:32 -0500
Received: by mail-we0-f177.google.com with SMTP id l61so8518659wev.8
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2015 01:14:30 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, martin@darmstadt.freifunk.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC/RFT] ath10k: enable IBSS in multi-vif
Date: Mon, 19 Jan 2015 10:13:53 +0100
Message-Id: <1421658833-13311-1-git-send-email-michal.kazior@tieto.com> (sfid-20150119_101440_192339_3C0F0412)
In-Reply-To: <54B97B96.4040903@darmstadt.freifunk.net>
References: <54B97B96.4040903@darmstadt.freifunk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 999.999.0.636 firmware seems to support
concurrent IBSS + AP/STA. At least basic stuff
works so enable it since some people are
interested in this stuff.

If it's broken we can fix, restrict or disable it
later.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
Hi Martin,

Feel free to take this patch and run whatever case
you had in mind. If this proves to work for you
without any major issues (like notorious crashes,
traffic issues and such) I guess we could try
pulling this upstream.

Make sure you use 999.999.0.636 firmware. The 10.x
doesn't support IBSS at all.


 drivers/net/wireless/ath/ath10k/mac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9524bc5..11170ce 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5032,6 +5032,10 @@ static const struct ieee80211_iface_limit ath10k_if_limits[] = {
 	.max	= 7,
 	.types	= BIT(NL80211_IFTYPE_AP)
 	},
+	{
+	.max	= 1,
+	.types	= BIT(NL80211_IFTYPE_ADHOC)
+	},
 };
 
 static const struct ieee80211_iface_limit ath10k_10x_if_limits[] = {
-- 
1.8.5.3

