Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:36833 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbdCAABa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Feb 2017 19:01:30 -0500
Received: by mail-pg0-f48.google.com with SMTP id s67so12426929pgb.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2017 16:00:12 -0800 (PST)
Received: from [10.4.0.31] ([67.137.71.162])
        by smtp.gmail.com with ESMTPSA id c64sm6246458pfa.45.2017.02.28.15.50.53
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Feb 2017 15:50:53 -0800 (PST)
From: Alexis Green <agreen@uniumwifi.com>
Reply-To: agreen@cococorp.com
To: linux-wireless@vger.kernel.org
Subject: [PATCH] iw: Add support for
 NL80211_MESHCONF_HWMP_ALWAYS_MAX_DISCOVERIES netlink attribute
Message-ID: <58B60CD9.9050507@cococorp.com> (sfid-20170301_010247_660133_09DA8EB5)
Date: Tue, 28 Feb 2017 15:50:49 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This attributes allows configuring mesh to either do only minimum
number of discovery attempts (up to MaxPREretries) or always do
MaxPREretries number of tries even when getting responses.

Signed-off-by: Alexis Green <agreen@uniumwifi.com>
---
 mesh.c    | 3 +++
 nl80211.h | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/mesh.c b/mesh.c
index 97f236b..b828408 100644
--- a/mesh.c
+++ b/mesh.c
@@ -264,6 +264,9 @@ const static struct mesh_param_descr _mesh_param_descrs[] =
 	_my_nla_put_u16, _parse_u16, _print_u16_in_TUs},
 	{"mesh_plink_timeout", NL80211_MESHCONF_PLINK_TIMEOUT,
 	_my_nla_put_u32, _parse_u32, _print_u32_in_seconds},
+	{"mesh_hwmp_always_max_discoveries",
+	NL80211_MESHCONF_HWMP_ALWAYS_MAX_DISCOVERIES,
+	_my_nla_put_u8, _parse_u8_as_bool, _print_u8},
 };
 
 static void print_all_mesh_param_descr(void)
diff --git a/nl80211.h b/nl80211.h
index 56368e9..bb53e8b 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -3352,6 +3352,8 @@ enum nl80211_mesh_power_mode {
  *	established peering with for longer than this time (in seconds), then
  *	remove it from the STA's list of peers. You may set this to 0 to disable
  *	the removal of the STA. Default is 30 minutes.
+ * @NL80211_MESHCONF_HWMP_ALWAYS_MAX_DISCOVERIES: whether to always perform
+ *	number of discovery attempts equal to MaxPREQretries (default is FALSE)
  *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
@@ -3385,6 +3387,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_POWER_MODE,
 	NL80211_MESHCONF_AWAKE_WINDOW,
 	NL80211_MESHCONF_PLINK_TIMEOUT,
+	NL80211_MESHCONF_HWMP_ALWAYS_MAX_DISCOVERIES,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
-- 
2.5.0.rc3
