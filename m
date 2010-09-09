Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4834 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab0IIPgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 11:36:14 -0400
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 9 Sep 2010 08:35:51 -0700
Subject: RE: [PATCH 16/16] iwlwifi: clear is_internal_short_scan when fail
 to initiate scan
Message-ID: <E9954878DD1FB34FAE5187FB88C58A3501280FDC4D@orsmsx506.amr.corp.intel.com>
References: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
 <1284040354-31703-17-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284040354-31703-17-git-send-email-sgruszka@redhat.com>
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
Subject: [PATCH 16/16] iwlwifi: clear is_internal_short_scan when fail to initiate scan

In case we fail to request scan we need to clear
priv->is_internal_short_scan. Otherwise we pretend we perform internal
short scan. Next external scan request will be differed, but never
performed nor canceled because STATUS_SCANNING bit is cleared.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index b841016..c3f2957 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -381,14 +381,15 @@ static int __must_check iwl_scan_initiate(struct iwl_priv *priv,
                        internal ? "internal short " : "");

        set_bit(STATUS_SCANNING, &priv->status);
-
        priv->is_internal_short_scan = internal;
+
Not needed

Thanks
Wey
