Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48521 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab0HUA3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Aug 2010 20:29:18 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, geoclue@lists.freedesktop.org,
	David.Quan@atheros.com, kevin@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/2] iw: make is_alpha2() available to other objects
Date: Fri, 20 Aug 2010 20:29:15 -0400
Message-Id: <1282350556-16523-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1282350556-16523-1-git-send-email-lrodriguez@atheros.com>
References: <1282350556-16523-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be used by a new GeoClue based regulatory hint command.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 iw.h  |    1 +
 reg.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/iw.h b/iw.h
index c21f093..771a190 100644
--- a/iw.h
+++ b/iw.h
@@ -137,6 +137,7 @@ void print_ssid_escaped(const uint8_t len, const uint8_t *data);
 int nl_get_multicast_id(struct nl_sock *sock, const char *family, const char *group);
 
 char *reg_initiator_to_string(__u8 initiator);
+bool is_alpha2(char *alpha2);
 
 const char *get_reason_str(uint16_t reason);
 const char *get_status_str(uint16_t status);
diff --git a/reg.c b/reg.c
index 7f82e08..bbdc2fc 100644
--- a/reg.c
+++ b/reg.c
@@ -28,7 +28,7 @@ static bool isalpha_upper(char letter)
 	return false;
 }
 
-static bool is_alpha2(char *alpha2)
+bool is_alpha2(char *alpha2)
 {
 	if (isalpha_upper(alpha2[0]) && isalpha_upper(alpha2[1]))
 		return true;
-- 
1.7.0.4

