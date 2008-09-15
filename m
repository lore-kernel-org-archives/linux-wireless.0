Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39804 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbYIOVaG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 17:30:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: dcbw@redhat.com, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: correct "limited range of data type" warning
Date: Mon, 15 Sep 2008 17:27:42 -0400
Message-Id: <1221514062-30679-1-git-send-email-linville@tuxdriver.com> (sfid-20080915_233009_981931_D040CA00)
In-Reply-To: <>
References: <>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/libertas/wext.o
drivers/net/wireless/libertas/wext.c: In function =E2=80=98lbs_get_rts=E2=
=80=99:
drivers/net/wireless/libertas/wext.c:307: warning: comparison is always
false due to limited range of data type

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/libertas/wext.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireles=
s/libertas/wext.c
index 1156be5..11297dc 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -281,7 +281,7 @@ static int lbs_set_rts(struct net_device *dev, stru=
ct iw_request_info *info,
 	if (vwrq->disabled)
 		val =3D MRVDRV_RTS_MAX_VALUE;
=20
-	if (val < MRVDRV_RTS_MIN_VALUE || val > MRVDRV_RTS_MAX_VALUE)
+	if (val > MRVDRV_RTS_MAX_VALUE) /* min rts value is 0 */
 		return -EINVAL;
=20
 	ret =3D lbs_set_snmp_mib(priv, SNMP_MIB_OID_RTS_THRESHOLD, (u16) val)=
;
@@ -304,8 +304,7 @@ static int lbs_get_rts(struct net_device *dev, stru=
ct iw_request_info *info,
 		goto out;
=20
 	vwrq->value =3D val;
-	vwrq->disabled =3D ((val < MRVDRV_RTS_MIN_VALUE)
-			  || (val > MRVDRV_RTS_MAX_VALUE));
+	vwrq->disabled =3D val > MRVDRV_RTS_MAX_VALUE; /* min rts value is 0 =
*/
 	vwrq->fixed =3D 1;
=20
 out:
--=20
1.5.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
