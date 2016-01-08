Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:35301 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbcAHGEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2016 01:04:55 -0500
Received: by mail-lf0-f43.google.com with SMTP id c192so169342111lfe.2
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2016 22:04:54 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC PATCH] brcmfmac: keep device specific settings when changing country
Date: Fri,  8 Jan 2016 07:04:40 +0100
Message-Id: <1452233080-11569-1-git-send-email-zajec5@gmail.com> (sfid-20160108_070458_382268_7A98190D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When changing country driver has to submit two values: alpha2 and
rev(ision). We don't want to change revision as it's device specific.
So far we were submitting value -1 in hope firmware will treat it as
invalid and will simply keep using the old one. It doesn't work however,
firmware treats -1 as 0 which may result in setting wrong revision.

Solve it by reading current value and submit it back with changed
country.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 17658b3..dcd8c8d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6236,8 +6236,14 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
 			brcmf_err("not a ISO3166 code\n");
 			return;
 		}
+
 	memset(&ccreq, 0, sizeof(ccreq));
-	ccreq.rev = cpu_to_le32(-1);
+	if (brcmf_fil_iovar_data_get(ifp, "country", &ccreq, sizeof(ccreq))) {
+		brcmf_err("could not obtain country info\n");
+		return;
+	}
+
+	memset(ccreq.country_abbrev, 0, sizeof(ccreq.country_abbrev));
 	memcpy(ccreq.ccode, req->alpha2, sizeof(req->alpha2));
 	if (brcmf_fil_iovar_data_set(ifp, "country", &ccreq, sizeof(ccreq))) {
 		brcmf_err("firmware rejected country setting\n");
-- 
1.8.4.5

