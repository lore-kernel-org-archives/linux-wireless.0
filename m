Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50770 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab0IIPrF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 11:47:05 -0400
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 9 Sep 2010 08:46:57 -0700
Subject: RE: [PATCH 13/14] iwlwifi: cleanup scan initiate check
Message-ID: <E9954878DD1FB34FAE5187FB88C58A3501280FDC82@orsmsx506.amr.corp.intel.com>
References: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
 <1284040354-31703-14-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284040354-31703-14-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gruszka,

-----Original Message-----
From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
Sent: Thursday, September 09, 2010 6:53 AM
To: Johannes Berg; Guy, Wey-Yi W; Chatre, Reinette; John W. Linville
Cc: linux-wireless@vger.kernel.org; Stanislaw Gruszka
Subject: [PATCH 13/14] iwlwifi: cleanup scan initiate check

Remove redundand checks and use iwl_is_ready_rf().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 10b0ccc..9cc4901 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -361,7 +361,7 @@ static int __must_check iwl_scan_initiate(struct iwl_priv *priv,

        cancel_delayed_work(&priv->scan_check);

-       if (!iwl_is_ready(priv)) {
+       if (!iwl_is_ready_rf(priv)) {
                IWL_WARN(priv, "request scan called when driver not ready.\n");
                return -EIO;
        }
@@ -372,26 +372,11 @@ static int __must_check iwl_scan_initiate(struct iwl_priv *priv,
                return -EBUSY;
        }

-       if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-               IWL_DEBUG_SCAN(priv, "Aborting scan due to device shutdown\n");
-               return -EIO;
-       }
-
        if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
                IWL_DEBUG_HC(priv, "Scan request while abort pending.\n");
                return -EBUSY;
        }

-       if (iwl_is_rfkill(priv)) {
-               IWL_DEBUG_HC(priv, "Aborting scan due to RF Kill activation\n");
-               return -EIO;
-       }
-
-       if (!test_bit(STATUS_READY, &priv->status)) {
-               IWL_DEBUG_HC(priv, "Scan request while uninitialized.\n");
-               return -EBUSY;
-       }
-
        IWL_DEBUG_INFO(priv, "Starting %sscan...\n",
                        internal ? "internal short " : "");


Same cleanup for 3945?

Thanks
Wey

