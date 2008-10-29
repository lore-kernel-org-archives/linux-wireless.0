Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:43076 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340AbYJ2V2r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 17:28:47 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] ieee80211: compile fixes
To: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 29 Oct 2008 17:28:43 -0400
Message-ID: <20081029212843.1583.62881.stgit@dv.roinet.com> (sfid-20081029_222903_370231_6FF8D10C)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use comma, not semicolon in ieee80211_parse_info_param().  Declare ssid
in ieee80211_wx_set_encode().

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 net/ieee80211/ieee80211_rx.c |    2 +-
 net/ieee80211/ieee80211_wx.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/ieee80211/ieee80211_rx.c b/net/ieee80211/ieee80211_rx.c
index b0bc39d..d6d5317 100644
--- a/net/ieee80211/ieee80211_rx.c
+++ b/net/ieee80211/ieee80211_rx.c
@@ -1178,7 +1178,7 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 
 			IEEE80211_DEBUG_MGMT("MFIE_TYPE_SSID: '%s' len=%d.\n",
 					     print_ssid(ssid, network->ssid,
-							network->ssid_len);
+							network->ssid_len),
 					     network->ssid_len);
 			break;
 
diff --git a/net/ieee80211/ieee80211_wx.c b/net/ieee80211/ieee80211_wx.c
index 698a856..70665e1 100644
--- a/net/ieee80211/ieee80211_wx.c
+++ b/net/ieee80211/ieee80211_wx.c
@@ -310,6 +310,7 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 	int i, key, key_provided, len;
 	struct ieee80211_crypt_data **crypt;
 	int host_crypto = ieee->host_encrypt || ieee->host_decrypt || ieee->host_build_iv;
+	DECLARE_SSID_BUF(ssid);
 
 	IEEE80211_DEBUG_WX("SET_ENCODE\n");
 
