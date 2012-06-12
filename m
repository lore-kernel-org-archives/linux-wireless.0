Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36938 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab2FLKGs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 06:06:48 -0400
From: "Spinadel, David" <david.spinadel@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>
Subject: RE: [RFC/RFT] mac80211: stop connection monitor on dissassoc
Date: Tue, 12 Jun 2012 10:05:52 +0000
Message-ID: <F781B6216F70FE49AB7B89F25E2F80C0187B2A@HASMSX103.ger.corp.intel.com> (sfid-20120612_120651_611790_01811321)
References: <20120612095850.GA2612@redhat.com>
In-Reply-To: <20120612095850.GA2612@redhat.com>
Content-Type: multipart/mixed;
	boundary="_002_F781B6216F70FE49AB7B89F25E2F80C0187B2AHASMSX103gercorpi_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_F781B6216F70FE49AB7B89F25E2F80C0187B2AHASMSX103gercorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Stanislav.
This problem is not easy to reproduce.
Attached my patch I just sent to Johannes, it seems to work here.=20
It basically the same change as yours, but I also removed stop_poll from ie=
ee80211_sta_connection_lost().

Thanks,
David=20

>From af52e5f1f6b7c5d89fdc1866f554a495717a61ad Mon Sep 17 00:00:00 2001
From: David Spinadel <david.spinadel@intel.com>
Date: Tue, 12 Jun 2012 09:59:45 +0300
Subject: [PATCH] mac80211: stop polling in disassocition

Change-Id: If16d1a2316259ced4f6647efba422203e9400179
Signed-off-by: David Spinadel <david.spinadel@intel.com>
---
 net/mac80211/mlme.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0f45d02..9aefcc3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1329,6 +1329,8 @@ static void ieee80211_set_disassoc(struct ieee80211_s=
ub_if_data *sdata,
 	u32 changed =3D 0;
 	u8 bssid[ETH_ALEN];
=20
+	ieee80211_stop_poll(sdata);
+
 	ASSERT_MGD_MTX(ifmgd);
=20
 	if (WARN_ON_ONCE(tx && !frame_buf))
@@ -2592,8 +2594,6 @@ static void ieee80211_sta_connection_lost(struct ieee=
80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd =3D &sdata->u.mgd;
 	u8 frame_buf[DEAUTH_DISASSOC_LEN];
=20
-	ieee80211_stop_poll(sdata);
-
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH, reason,
 			       false, frame_buf);
 	mutex_unlock(&ifmgd->mtx);
--=20
1.7.1



-----Original Message-----
From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]=20
Sent: Tuesday, June 12, 2012 12:59
To: linux-wireless@vger.kernel.org; Spinadel, David
Cc: Johannes Berg
Subject: [RFC/RFT] mac80211: stop connection monitor on dissassoc

Looks like is possible to do not kick of deferred scan when connection moni=
toring is pending and on the same time we disconnect.

David, I can not recreate this problem locally, does below patch fix the pr=
oblem on your tests.

Thanks
Stanislaw

---
 net/mac80211/mlme.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c index d7134c1..1e207=
48 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1425,6 +1425,8 @@ static void ieee80211_set_disassoc(struct ieee80211_s=
ub_if_data *sdata,
 	del_timer_sync(&sdata->u.mgd.bcn_mon_timer);
 	del_timer_sync(&sdata->u.mgd.timer);
 	del_timer_sync(&sdata->u.mgd.chswitch_timer);
+
+	ieee80211_stop_poll(sdata);
 }
=20
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
--
1.7.1

---------------------------------------------------------------------
A member of the Intel Corporation group of companies

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--_002_F781B6216F70FE49AB7B89F25E2F80C0187B2AHASMSX103gercorpi_
Content-Type: application/octet-stream;
	name="0001-mac80211-stop-polling-in-disassocition.patch"
Content-Description: 0001-mac80211-stop-polling-in-disassocition.patch
Content-Disposition: attachment;
	filename="0001-mac80211-stop-polling-in-disassocition.patch"; size=1144;
	creation-date="Tue, 12 Jun 2012 10:05:57 GMT";
	modification-date="Tue, 12 Jun 2012 07:08:19 GMT"
Content-Transfer-Encoding: base64

RnJvbSBhZjUyZTVmMWY2YjdjNWQ4OWZkYzE4NjZmNTU0YTQ5NTcxN2E2MWFkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBTcGluYWRlbCA8ZGF2aWQuc3BpbmFkZWxAaW50ZWwu
Y29tPgpEYXRlOiBUdWUsIDEyIEp1biAyMDEyIDA5OjU5OjQ1ICswMzAwClN1YmplY3Q6IFtQQVRD
SF0gbWFjODAyMTE6IHN0b3AgcG9sbGluZyBpbiBkaXNhc3NvY2l0aW9uCgpDaGFuZ2UtSWQ6IElm
MTZkMWEyMzE2MjU5Y2VkNGY2NjQ3ZWZiYTQyMjIwM2U5NDAwMTc5ClNpZ25lZC1vZmYtYnk6IERh
dmlkIFNwaW5hZGVsIDxkYXZpZC5zcGluYWRlbEBpbnRlbC5jb20+Ci0tLQogbmV0L21hYzgwMjEx
L21sbWUuYyB8ICAgIDQgKystLQogMSBmaWxlcyBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbmV0L21hYzgwMjExL21sbWUuYyBiL25ldC9tYWM4
MDIxMS9tbG1lLmMKaW5kZXggMGY0NWQwMi4uOWFlZmNjMyAxMDA2NDQKLS0tIGEvbmV0L21hYzgw
MjExL21sbWUuYworKysgYi9uZXQvbWFjODAyMTEvbWxtZS5jCkBAIC0xMzI5LDYgKzEzMjksOCBA
QCBzdGF0aWMgdm9pZCBpZWVlODAyMTFfc2V0X2Rpc2Fzc29jKHN0cnVjdCBpZWVlODAyMTFfc3Vi
X2lmX2RhdGEgKnNkYXRhLAogCXUzMiBjaGFuZ2VkID0gMDsKIAl1OCBic3NpZFtFVEhfQUxFTl07
CiAKKwlpZWVlODAyMTFfc3RvcF9wb2xsKHNkYXRhKTsKKwogCUFTU0VSVF9NR0RfTVRYKGlmbWdk
KTsKIAogCWlmIChXQVJOX09OX09OQ0UodHggJiYgIWZyYW1lX2J1ZikpCkBAIC0yNTkyLDggKzI1
OTQsNiBAQCBzdGF0aWMgdm9pZCBpZWVlODAyMTFfc3RhX2Nvbm5lY3Rpb25fbG9zdChzdHJ1Y3Qg
aWVlZTgwMjExX3N1Yl9pZl9kYXRhICpzZGF0YSwKIAlzdHJ1Y3QgaWVlZTgwMjExX2lmX21hbmFn
ZWQgKmlmbWdkID0gJnNkYXRhLT51Lm1nZDsKIAl1OCBmcmFtZV9idWZbREVBVVRIX0RJU0FTU09D
X0xFTl07CiAKLQlpZWVlODAyMTFfc3RvcF9wb2xsKHNkYXRhKTsKLQogCWllZWU4MDIxMV9zZXRf
ZGlzYXNzb2Moc2RhdGEsIElFRUU4MDIxMV9TVFlQRV9ERUFVVEgsIHJlYXNvbiwKIAkJCSAgICAg
ICBmYWxzZSwgZnJhbWVfYnVmKTsKIAltdXRleF91bmxvY2soJmlmbWdkLT5tdHgpOwotLSAKMS43
LjEKCg==

--_002_F781B6216F70FE49AB7B89F25E2F80C0187B2AHASMSX103gercorpi_--

