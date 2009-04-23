Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:20642 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbZDWRgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 13:36:25 -0400
Received: by fg-out-1718.google.com with SMTP id d23so34928fga.17
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 10:36:23 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 23 Apr 2009 19:36:08 +0200
Message-ID: <69e28c910904231036l5fb331d5u81bcbe92b7f40179@mail.gmail.com> (sfid-20090423_193628_219130_9CA02A99)
Subject: [PATCH 3/5] iwlwifi: Fix handling of retry count of NO_ACK frames in
	iwl-{3945|agn}-rs
To: John Linville <linville@tuxdriver.com>, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: multipart/mixed; boundary=000e0cd25e8e98cae104683c510b
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--000e0cd25e8e98cae104683c510b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Make PID check for IEEE80211_TX_CTL_NO_ACK instead of
is_multicast_ether_addr when determining whether to use the lowest
rate, and set the retry count to 0 (total try count =3D 1) if
IEEE80211_TX_CTL_NO_ACK is set.

Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>

---
Patch also available as an attachment if Gmail linewraps it.

 iwl-3945-rs.c |    7 ++++---
 iwl-agn-rs.c  |   14 +++++++-------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index f63a9c5..814afaf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -683,11 +683,10 @@ static void rs_get_rate(void *priv_r, struct
ieee80211_sta *sta,
 	if (sta)
 		rate_mask =3D sta->supp_rates[sband->band];

-	/* Send management frames and broadcast/multicast data using lowest
-	 * rate. */
+	/* Send management frames and NO_ACK data using lowest rate. */
 	fc =3D le16_to_cpu(hdr->frame_control);
 	if ((fc & IEEE80211_FCTL_FTYPE) !=3D IEEE80211_FTYPE_DATA ||
-	    is_multicast_ether_addr(hdr->addr1) ||
+	    info->flags & IEEE80211_TX_CTL_NO_ACK ||
 	    !sta || !priv_sta) {
 		IWL_DEBUG_RATE(priv, "leave: No STA priv data to update!\n");
 		if (!rate_mask)
@@ -696,6 +695,8 @@ static void rs_get_rate(void *priv_r, struct
ieee80211_sta *sta,
 		else
 			info->control.rates[0].idx =3D
 					rate_lowest_index(sband, sta);
+		if (info->flags & IEEE80211_TX_CTL_NO_ACK)
+			info->control.rates[0].count =3D 1;
 		return;
 	}

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 98b6b37..c52652d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -829,7 +829,7 @@ static void rs_tx_status(void *priv_r, struct
ieee80211_supported_band *sband,
 	IWL_DEBUG_RATE_LIMIT(priv, "get frame ack response, update rate
scale window\n");

 	if (!ieee80211_is_data(hdr->frame_control) ||
-	    is_multicast_ether_addr(hdr->addr1))
+	    info->flags & IEEE80211_TX_CTL_NO_ACK)
 		return;

 	/* This packet was aggregated but doesn't carry rate scale info */
@@ -2005,11 +2005,10 @@ static void rs_rate_scale_perform(struct iwl_priv *=
priv,

 	IWL_DEBUG_RATE(priv, "rate scale calculate new rate for skb\n");

-	/* Send management frames and broadcast/multicast data using
-	 * lowest rate. */
+	/* Send management frames and NO_ACK data using lowest rate. */
 	/* TODO: this could probably be improved.. */
 	if (!ieee80211_is_data(hdr->frame_control) ||
-	    is_multicast_ether_addr(hdr->addr1))
+	    info->flags & IEEE80211_TX_CTL_NO_ACK)
 		return;

 	if (!sta || !lq_sta)
@@ -2456,16 +2455,17 @@ static void rs_get_rate(void *priv_r, struct
ieee80211_sta *sta, void *priv_sta,
 	if (sta)
 		mask_bit =3D sta->supp_rates[sband->band];

-	/* Send management frames and broadcast/multicast data using lowest
-	 * rate. */
+	/* Send management frames and NO_ACK data using lowest rate. */
 	if (!ieee80211_is_data(hdr->frame_control) ||
-	    is_multicast_ether_addr(hdr->addr1) || !sta || !lq_sta) {
+	    info->flags & IEEE80211_TX_CTL_NO_ACK || !sta || !lq_sta) {
 		if (!mask_bit)
 			info->control.rates[0].idx =3D
 					rate_lowest_index(sband, NULL);
 		else
 			info->control.rates[0].idx =3D
 					rate_lowest_index(sband, sta);
+		if (info->flags & IEEE80211_TX_CTL_NO_ACK)
+			info->control.rates[0].count =3D 1;
 		return;
 	}

--000e0cd25e8e98cae104683c510b
Content-Type: text/x-patch; charset=US-ASCII; name="iwlwifi-fix-no-ack-retry-count.patch"
Content-Disposition: attachment;
	filename="iwlwifi-fix-no-ack-retry-count.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ftvqg8qf0

IGl3bC0zOTQ1LXJzLmMgfCAgICA3ICsrKystLS0KIGl3bC1hZ24tcnMuYyAgfCAgIDE0ICsrKysr
KystLS0tLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLTM5NDUt
cnMuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLTM5NDUtcnMuYwppbmRleCBm
NjNhOWM1Li44MTRhZmFmIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZp
L2l3bC0zOTQ1LXJzLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtMzk0
NS1ycy5jCkBAIC02ODMsMTEgKzY4MywxMCBAQCBzdGF0aWMgdm9pZCByc19nZXRfcmF0ZSh2b2lk
ICpwcml2X3IsIHN0cnVjdCBpZWVlODAyMTFfc3RhICpzdGEsCiAJaWYgKHN0YSkKIAkJcmF0ZV9t
YXNrID0gc3RhLT5zdXBwX3JhdGVzW3NiYW5kLT5iYW5kXTsKIAotCS8qIFNlbmQgbWFuYWdlbWVu
dCBmcmFtZXMgYW5kIGJyb2FkY2FzdC9tdWx0aWNhc3QgZGF0YSB1c2luZyBsb3dlc3QKLQkgKiBy
YXRlLiAqLworCS8qIFNlbmQgbWFuYWdlbWVudCBmcmFtZXMgYW5kIE5PX0FDSyBkYXRhIHVzaW5n
IGxvd2VzdCByYXRlLiAqLwogCWZjID0gbGUxNl90b19jcHUoaGRyLT5mcmFtZV9jb250cm9sKTsK
IAlpZiAoKGZjICYgSUVFRTgwMjExX0ZDVExfRlRZUEUpICE9IElFRUU4MDIxMV9GVFlQRV9EQVRB
IHx8Ci0JICAgIGlzX211bHRpY2FzdF9ldGhlcl9hZGRyKGhkci0+YWRkcjEpIHx8CisJICAgIGlu
Zm8tPmZsYWdzICYgSUVFRTgwMjExX1RYX0NUTF9OT19BQ0sgfHwKIAkgICAgIXN0YSB8fCAhcHJp
dl9zdGEpIHsKIAkJSVdMX0RFQlVHX1JBVEUocHJpdiwgImxlYXZlOiBObyBTVEEgcHJpdiBkYXRh
IHRvIHVwZGF0ZSFcbiIpOwogCQlpZiAoIXJhdGVfbWFzaykKQEAgLTY5Niw2ICs2OTUsOCBAQCBz
dGF0aWMgdm9pZCByc19nZXRfcmF0ZSh2b2lkICpwcml2X3IsIHN0cnVjdCBpZWVlODAyMTFfc3Rh
ICpzdGEsCiAJCWVsc2UKIAkJCWluZm8tPmNvbnRyb2wucmF0ZXNbMF0uaWR4ID0KIAkJCQkJcmF0
ZV9sb3dlc3RfaW5kZXgoc2JhbmQsIHN0YSk7CisJCWlmIChpbmZvLT5mbGFncyAmIElFRUU4MDIx
MV9UWF9DVExfTk9fQUNLKQorCQkJaW5mby0+Y29udHJvbC5yYXRlc1swXS5jb3VudCA9IDE7CiAJ
CXJldHVybjsKIAl9CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkv
aXdsLWFnbi1ycy5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLXJzLmMK
aW5kZXggOThiNmIzNy4uYzUyNjUyZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
aXdsd2lmaS9pd2wtYWduLXJzLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9p
d2wtYWduLXJzLmMKQEAgLTgyOSw3ICs4MjksNyBAQCBzdGF0aWMgdm9pZCByc190eF9zdGF0dXMo
dm9pZCAqcHJpdl9yLCBzdHJ1Y3QgaWVlZTgwMjExX3N1cHBvcnRlZF9iYW5kICpzYmFuZCwKIAlJ
V0xfREVCVUdfUkFURV9MSU1JVChwcml2LCAiZ2V0IGZyYW1lIGFjayByZXNwb25zZSwgdXBkYXRl
IHJhdGUgc2NhbGUgd2luZG93XG4iKTsKIAogCWlmICghaWVlZTgwMjExX2lzX2RhdGEoaGRyLT5m
cmFtZV9jb250cm9sKSB8fAotCSAgICBpc19tdWx0aWNhc3RfZXRoZXJfYWRkcihoZHItPmFkZHIx
KSkKKwkgICAgaW5mby0+ZmxhZ3MgJiBJRUVFODAyMTFfVFhfQ1RMX05PX0FDSykKIAkJcmV0dXJu
OwogCiAJLyogVGhpcyBwYWNrZXQgd2FzIGFnZ3JlZ2F0ZWQgYnV0IGRvZXNuJ3QgY2FycnkgcmF0
ZSBzY2FsZSBpbmZvICovCkBAIC0yMDA1LDExICsyMDA1LDEwIEBAIHN0YXRpYyB2b2lkIHJzX3Jh
dGVfc2NhbGVfcGVyZm9ybShzdHJ1Y3QgaXdsX3ByaXYgKnByaXYsCiAKIAlJV0xfREVCVUdfUkFU
RShwcml2LCAicmF0ZSBzY2FsZSBjYWxjdWxhdGUgbmV3IHJhdGUgZm9yIHNrYlxuIik7CiAKLQkv
KiBTZW5kIG1hbmFnZW1lbnQgZnJhbWVzIGFuZCBicm9hZGNhc3QvbXVsdGljYXN0IGRhdGEgdXNp
bmcKLQkgKiBsb3dlc3QgcmF0ZS4gKi8KKwkvKiBTZW5kIG1hbmFnZW1lbnQgZnJhbWVzIGFuZCBO
T19BQ0sgZGF0YSB1c2luZyBsb3dlc3QgcmF0ZS4gKi8KIAkvKiBUT0RPOiB0aGlzIGNvdWxkIHBy
b2JhYmx5IGJlIGltcHJvdmVkLi4gKi8KIAlpZiAoIWllZWU4MDIxMV9pc19kYXRhKGhkci0+ZnJh
bWVfY29udHJvbCkgfHwKLQkgICAgaXNfbXVsdGljYXN0X2V0aGVyX2FkZHIoaGRyLT5hZGRyMSkp
CisJICAgIGluZm8tPmZsYWdzICYgSUVFRTgwMjExX1RYX0NUTF9OT19BQ0spCiAJCXJldHVybjsK
IAogCWlmICghc3RhIHx8ICFscV9zdGEpCkBAIC0yNDU2LDE2ICsyNDU1LDE3IEBAIHN0YXRpYyB2
b2lkIHJzX2dldF9yYXRlKHZvaWQgKnByaXZfciwgc3RydWN0IGllZWU4MDIxMV9zdGEgKnN0YSwg
dm9pZCAqcHJpdl9zdGEsCiAJaWYgKHN0YSkKIAkJbWFza19iaXQgPSBzdGEtPnN1cHBfcmF0ZXNb
c2JhbmQtPmJhbmRdOwogCi0JLyogU2VuZCBtYW5hZ2VtZW50IGZyYW1lcyBhbmQgYnJvYWRjYXN0
L211bHRpY2FzdCBkYXRhIHVzaW5nIGxvd2VzdAotCSAqIHJhdGUuICovCisJLyogU2VuZCBtYW5h
Z2VtZW50IGZyYW1lcyBhbmQgTk9fQUNLIGRhdGEgdXNpbmcgbG93ZXN0IHJhdGUuICovCiAJaWYg
KCFpZWVlODAyMTFfaXNfZGF0YShoZHItPmZyYW1lX2NvbnRyb2wpIHx8Ci0JICAgIGlzX211bHRp
Y2FzdF9ldGhlcl9hZGRyKGhkci0+YWRkcjEpIHx8ICFzdGEgfHwgIWxxX3N0YSkgeworCSAgICBp
bmZvLT5mbGFncyAmIElFRUU4MDIxMV9UWF9DVExfTk9fQUNLIHx8ICFzdGEgfHwgIWxxX3N0YSkg
ewogCQlpZiAoIW1hc2tfYml0KQogCQkJaW5mby0+Y29udHJvbC5yYXRlc1swXS5pZHggPQogCQkJ
CQlyYXRlX2xvd2VzdF9pbmRleChzYmFuZCwgTlVMTCk7CiAJCWVsc2UKIAkJCWluZm8tPmNvbnRy
b2wucmF0ZXNbMF0uaWR4ID0KIAkJCQkJcmF0ZV9sb3dlc3RfaW5kZXgoc2JhbmQsIHN0YSk7CisJ
CWlmIChpbmZvLT5mbGFncyAmIElFRUU4MDIxMV9UWF9DVExfTk9fQUNLKQorCQkJaW5mby0+Y29u
dHJvbC5yYXRlc1swXS5jb3VudCA9IDE7CiAJCXJldHVybjsKIAl9CiAK
--000e0cd25e8e98cae104683c510b--
