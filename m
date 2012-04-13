Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35869 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762681Ab2DMApT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 20:45:19 -0400
Received: by pbcun15 with SMTP id un15so2987275pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 17:45:19 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: javier@cozybit.com, marco.porsch@etit.tu-chemnitz.de,
	devel@lists.open80211s.org, Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH 1/2] iw: add mesh conf parameter "mesh_sync_offset_max_neighor"
Date: Thu, 12 Apr 2012 17:45:12 -0700
Message-Id: <1334277913-13959-1-git-send-email-ashok@cozybit.com> (sfid-20120413_024534_482295_253B1F17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maximum number of neighbors to synchronize to for mesh default synchronization
method

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 mesh.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/mesh.c b/mesh.c
index b2c7208..12147a2 100644
--- a/mesh.c
+++ b/mesh.c
@@ -116,6 +116,11 @@ static void _print_u16_in_TUs(struct nlattr *a)
 	printf("%d TUs", nla_get_u16(a));
 }
 
+static void _print_u32(struct nlattr *a)
+{
+	printf("%d", nla_get_u32(a));
+}
+
 static void _print_u32_timeout(struct nlattr *a)
 {
 	printf("%u milliseconds", nla_get_u32(a));
@@ -179,6 +184,9 @@ const static struct mesh_param_descr _mesh_param_descrs[] =
 	_my_nla_put_u8, _parse_u8, _print_u8},
 	{"mesh_fwding", NL80211_MESHCONF_FORWARDING,
 	_my_nla_put_u8, _parse_u8_as_bool, _print_u8},
+	{"mesh_sync_offset_max_neighor",
+	NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR,
+	_my_nla_put_u32, _parse_u32, _print_u32},
 };
 
 static void print_all_mesh_param_descr(void)
-- 
1.7.5.4

