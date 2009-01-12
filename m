Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59058 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371AbZALUAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 15:00:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] =?utf-8?q?iwl3945:=20fix=20"=E2=80=98power=5Fidx=E2=80=99=20may=20be=20used=20uninitialized"=20warning?=
Date: Mon, 12 Jan 2009 14:49:00 -0500
Message-Id: <1231789741-13433-4-git-send-email-linville@tuxdriver.com> (sfid-20090112_210112_903019_09A01B11)
In-Reply-To: <1231789741-13433-3-git-send-email-linville@tuxdriver.com>
References: <>
 <1231789741-13433-1-git-send-email-linville@tuxdriver.com>
 <1231789741-13433-2-git-send-email-linville@tuxdriver.com>
 <1231789741-13433-3-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/iwlwifi/iwl-3945.c: In function =E2=80=98iwl3945_t=
xpower_set_from_eeprom=E2=80=99:
drivers/net/wireless/iwlwifi/iwl-3945.c:2222: warning: =E2=80=98power_i=
dx=E2=80=99 may be used uninitialized in this function

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wire=
less/iwlwifi/iwl-3945.c
index 8fdb342..45cfa1c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2219,7 +2219,7 @@ int iwl3945_txpower_set_from_eeprom(struct iwl394=
5_priv *priv)
 		/* set tx power value for all OFDM rates */
 		for (rate_index =3D 0; rate_index < IWL_OFDM_RATES;
 		     rate_index++) {
-			s32 power_idx;
+			s32 uninitialized_var(power_idx);
 			int rc;
=20
 			/* use channel group's clip-power table,
--=20
1.5.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
