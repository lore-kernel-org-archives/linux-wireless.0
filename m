Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:36847 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965160Ab3DTAxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 20:53:55 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: correct bss_mode check while appending vht operation IE
Date: Fri, 19 Apr 2013 17:44:43 -0700
Message-ID: <1366418684-6148-3-git-send-email-bzhao@marvell.com> (sfid-20130420_025358_188277_B409215F)
In-Reply-To: <1366418684-6148-1-git-send-email-bzhao@marvell.com>
References: <1366418684-6148-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

priv->bss_mode uses NL80211_IFTYPE_* definitions.
HostCmd_BSS_MODE_IBSS is used in ad-hoc start/join command between
driver and firmware.

Coincidentally both HostCmd_BSS_MODE_IBSS and NL80211_IFTYPE_STATION
are defined as 2. That explains why nobody complained.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11ac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11ac.c b/drivers/net/wireless/mwifiex/11ac.c
index 966a78f..5e0eec4 100644
--- a/drivers/net/wireless/mwifiex/11ac.c
+++ b/drivers/net/wireless/mwifiex/11ac.c
@@ -200,7 +200,7 @@ int mwifiex_cmd_append_11ac_tlv(struct mwifiex_private *priv,
 
 	/* VHT Operation IE */
 	if (bss_desc->bcn_vht_oper) {
-		if (priv->bss_mode == HostCmd_BSS_MODE_IBSS) {
+		if (priv->bss_mode == NL80211_IFTYPE_STATION) {
 			vht_op = (struct mwifiex_ie_types_vht_oper *)*buffer;
 			memset(vht_op, 0, sizeof(*vht_op));
 			vht_op->header.type =
-- 
1.7.0.2

