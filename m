Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:60442 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752399Ab2B1GFS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 01:05:18 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/6 V2] mwifiex: correct bitrates advertised to cfg80211
Date: Mon, 27 Feb 2012 22:04:11 -0800
Message-Id: <1330409056-4399-2-git-send-email-bzhao@marvell.com> (sfid-20120228_070523_441962_D5B1AB18)
In-Reply-To: <1330409056-4399-1-git-send-email-bzhao@marvell.com>
References: <1330409056-4399-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

1. Driver and firmware do not support 22Mbps and 72Mbps bitrates.
Remove them from the rate table advertised to cfg80211.

2. First 4 rates from mwifiex_rates table are not valid for
5GHz/A band. Set correct bitrate array's index and no of rates for
ieee80211_supported_band for 5GHz band.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
V2: updated the commit description (Johanness Berg)

 drivers/net/wireless/mwifiex/cfg80211.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 7b98ce0..2a1fc32 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -613,7 +613,6 @@ static struct ieee80211_rate mwifiex_rates[] = {
 	{.bitrate = 20, .hw_value = 4, },
 	{.bitrate = 55, .hw_value = 11, },
 	{.bitrate = 110, .hw_value = 22, },
-	{.bitrate = 220, .hw_value = 44, },
 	{.bitrate = 60, .hw_value = 12, },
 	{.bitrate = 90, .hw_value = 18, },
 	{.bitrate = 120, .hw_value = 24, },
@@ -622,7 +621,6 @@ static struct ieee80211_rate mwifiex_rates[] = {
 	{.bitrate = 360, .hw_value = 72, },
 	{.bitrate = 480, .hw_value = 96, },
 	{.bitrate = 540, .hw_value = 108, },
-	{.bitrate = 720, .hw_value = 144, },
 };
 
 /* Channel definitions to be advertised to cfg80211 */
@@ -688,8 +686,8 @@ static struct ieee80211_channel mwifiex_channels_5ghz[] = {
 static struct ieee80211_supported_band mwifiex_band_5ghz = {
 	.channels = mwifiex_channels_5ghz,
 	.n_channels = ARRAY_SIZE(mwifiex_channels_5ghz),
-	.bitrates = mwifiex_rates - 4,
-	.n_bitrates = ARRAY_SIZE(mwifiex_rates) + 4,
+	.bitrates = mwifiex_rates + 4,
+	.n_bitrates = ARRAY_SIZE(mwifiex_rates) - 4,
 };
 
 
-- 
1.7.0.2

