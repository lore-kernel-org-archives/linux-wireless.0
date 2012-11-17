Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:39859 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2KQGt5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 01:49:57 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFC 4/4] iw: add mesh awake window to mesh config
Date: Fri, 16 Nov 2012 22:49:39 -0800
Message-Id: <1353134979-13314-5-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121117_081526_021223_F72F56E7)
In-Reply-To: <1353134979-13314-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134979-13314-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The awake window is the duration the local STA will stay awake after sending
its own beacon in PS mode. The value can be modified as part of the mesh
params.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 mesh.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mesh.c b/mesh.c
index b2eb69d..c8de327 100644
--- a/mesh.c
+++ b/mesh.c
@@ -261,6 +261,8 @@ const static struct mesh_param_descr _mesh_param_descrs[] =
 	_my_nla_put_u8, _parse_u8, _print_u8},
 	{"mesh_power_mode", NL80211_MESHCONF_POWER_MODE,
 	_my_nla_put_u8, _parse_u8_power_mode, _print_u8_power_mode},
+	{"mesh_awake_window", NL80211_MESHCONF_AWAKE_WINDOW,
+	_my_nla_put_u16, _parse_u16, _print_u16_in_TUs},
 };
 
 static void print_all_mesh_param_descr(void)
-- 
1.7.9.5

