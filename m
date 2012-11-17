Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:48835 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2KQGtw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 01:49:52 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFC 1/4] iw: add beacon interval and DTIM period to mesh config
Date: Fri, 16 Nov 2012 22:49:36 -0800
Message-Id: <1353134979-13314-2-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121117_074954_743677_515C2C9D)
In-Reply-To: <1353134979-13314-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134979-13314-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Beacon interval and DTIM period can be changed during mesh runtime like any
other mesh params and will immediately take effect.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 mesh.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mesh.c b/mesh.c
index 4fdad6a..26fd1b8 100644
--- a/mesh.c
+++ b/mesh.c
@@ -217,6 +217,10 @@ const static struct mesh_param_descr _mesh_param_descrs[] =
 	{"mesh_hwmp_confirmation_interval",
 	NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
 	_my_nla_put_u16, _parse_u16, _print_u16_in_TUs},
+	{"mesh_beacon_interval", NL80211_MESHCONF_BEACON_INTERVAL,
+	_my_nla_put_u16, _parse_u16, _print_u16_in_TUs},
+	{"mesh_dtim_period", NL80211_MESHCONF_DTIM_PERIOD,
+	_my_nla_put_u8, _parse_u8, _print_u8},
 };
 
 static void print_all_mesh_param_descr(void)
-- 
1.7.9.5

