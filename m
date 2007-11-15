Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4085 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbXKOVez (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 16:34:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?utf-8?q?Miguel=20Bot=C3=B3n?= <mboton.lkml@gmail.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] iwlwifi: remove redundant initialization of final_mode
Date: Thu, 15 Nov 2007 16:31:25 -0500
Message-Id: <1195162285-26439-1-git-send-email-linville@tuxdriver.com> (sfid-20071115_213505_634915_95B05490)
In-Reply-To: <200711102049.32921.mboton.lkml@gmail.com>
References: <200711102049.32921.mboton.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Problem identified by Miguel Bot=C3=B3n <mboton.lkml@gmail.com>, altern=
ate
solution suggested by Zhu Yi <yi.zhu@intel.com>, patch by me. :-)

Cc: Miguel Bot=C3=B3n <mboton.lkml@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/=
wireless/iwlwifi/iwl3945-base.c
index e2cbd9e..15937c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2139,7 +2139,7 @@ static int iwl3945_update_power_cmd(struct iwl394=
5_priv *priv,
=20
 static int iwl3945_send_power_mode(struct iwl3945_priv *priv, u32 mode=
)
 {
-	u32 final_mode =3D mode;
+	u32 uninitialized_var(final_mode);
 	int rc;
 	struct iwl3945_powertable_cmd cmd;
=20
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/=
wireless/iwlwifi/iwl4965-base.c
index ef17a98..30acd13 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2218,7 +2218,7 @@ static int iwl4965_update_power_cmd(struct iwl496=
5_priv *priv,
=20
 static int iwl4965_send_power_mode(struct iwl4965_priv *priv, u32 mode=
)
 {
-	u32 final_mode =3D mode;
+	u32 uninitialized_var(final_mode);
 	int rc;
 	struct iwl4965_powertable_cmd cmd;
=20
--=20
1.5.3.3

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
