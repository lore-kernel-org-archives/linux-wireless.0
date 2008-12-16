Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:14627 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbYLPPmr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 10:42:47 -0500
Received: by an-out-0708.google.com with SMTP id d40so1319123and.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2008 07:42:46 -0800 (PST)
Message-ID: <b6c5339f0812160742h63538d6ax689f95902ffdc6b5@mail.gmail.com> (sfid-20081216_164257_290756_C2F2F726)
Date: Tue, 16 Dec 2008 10:42:45 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Benoit PAPILLAULT" <benoit.papillault@free.fr>
Subject: Re: [PATCH] ath5k: Updated padding stuff for the RX and TX side. TX side has been 100%
Cc: "Jouni Malinen" <j@w1.fi>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
In-Reply-To: <b6c5339f0812160722nab8516cj1ed4e6d397060d9d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_2790_10307841.1229442165517"
References: <1229351698-21116-1-git-send-email-benoit.papillault@free.fr>
	 <20081215170613.GA22627@jm.kir.nu> <4946C6D9.1060101@free.fr>
	 <b6c5339f0812160722nab8516cj1ed4e6d397060d9d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_2790_10307841.1229442165517
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Dec 16, 2008 at 10:22 AM, Bob Copeland <bcopeland@gmail.com> wrote:
> On Mon, Dec 15, 2008 at 4:06 PM, Benoit PAPILLAULT
> <benoit.papillault@free.fr> wrote:

> Well, anyway John already picked up your earlier (better, IMHO) patch.
> Now we just need to fix the tx descriptors :)

i.e. something like the following (attached as well because gmail will
destroy it).  I only compile-tested it.

diff --git a/drivers/net/wireless/ath5k/ath5k.h
b/drivers/net/wireless/ath5k/ath5k.h
index 13df119..183ffc8 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -1350,4 +1350,9 @@ static inline u32 ath5k_hw_bitswap(u32 val,
unsigned int bits)
 	return retval;
 }

+static inline int ath5k_pad_size(int hdrlen)
+{
+	return (hdrlen < 24) ? 0 : hdrlen & 3;
+}
+
 #endif
diff --git a/drivers/net/wireless/ath5k/base.c
b/drivers/net/wireless/ath5k/base.c
index f222b4a..0c3e186 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1754,8 +1754,8 @@ accept:
 		 * not try to remove padding from short control frames that do
 		 * not have payload. */
 		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-		padsize = hdrlen & 3;
-		if (padsize && hdrlen >= 24) {
+		padsize = ath5k_pad_size(hdrlen);
+		if (padsize) {
 			memmove(skb->data + padsize, skb->data, hdrlen);
 			skb_pull(skb, padsize);
 		}
@@ -2620,8 +2620,8 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * if this is not the case we add the padding after the header
 	 */
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	padsize = hdrlen & 3;
-	if (padsize && hdrlen >= 24) {
+	padsize = ath5k_pad_size(hdrlen);
+	if (padsize) {

 		if (skb_headroom(skb) < padsize) {
 			ATH5K_ERR(sc, "tx hdrlen not %%4: %d not enough"
diff --git a/drivers/net/wireless/ath5k/desc.c
b/drivers/net/wireless/ath5k/desc.c
index 5e362a7..b40a928 100644
--- a/drivers/net/wireless/ath5k/desc.c
+++ b/drivers/net/wireless/ath5k/desc.c
@@ -71,7 +71,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah,
struct ath5k_desc *desc,
 	/* Verify and set frame length */

 	/* remove padding we might have added before */
-	frame_len = pkt_len - (hdr_len & 3) + FCS_LEN;
+	frame_len = pkt_len - ath5k_pad_size(hdr_len) + FCS_LEN;

 	if (frame_len & ~AR5K_2W_TX_DESC_CTL0_FRAME_LEN)
 		return -EINVAL;
@@ -202,7 +202,7 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 	/* Verify and set frame length */

 	/* remove padding we might have added before */
-	frame_len = pkt_len - (hdr_len & 3) + FCS_LEN;
+	frame_len = pkt_len - ath5k_pad_size(hdr_len) + FCS_LEN;

 	if (frame_len & ~AR5K_4W_TX_DESC_CTL0_FRAME_LEN)
 		return -EINVAL;


-- 
Bob Copeland %% www.bobcopeland.com

------=_Part_2790_10307841.1229442165517
Content-Type: text/x-diff; name=fix_pad.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fosp80280
Content-Disposition: attachment; filename=fix_pad.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aDVrL2F0aDVrLmggYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9hdGg1ay9hdGg1ay5oCmluZGV4IDEzZGYxMTkuLjE4M2ZmYzggMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aDVrL2F0aDVrLmgKKysrIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvYXRoNWsvYXRoNWsuaApAQCAtMTM1MCw0ICsxMzUwLDkgQEAgc3RhdGljIGlu
bGluZSB1MzIgYXRoNWtfaHdfYml0c3dhcCh1MzIgdmFsLCB1bnNpZ25lZCBpbnQgYml0cykKIAly
ZXR1cm4gcmV0dmFsOwogfQogCitzdGF0aWMgaW5saW5lIGludCBhdGg1a19wYWRfc2l6ZShpbnQg
aGRybGVuKQoreworCXJldHVybiAoaGRybGVuIDwgMjQpID8gMCA6IGhkcmxlbiAmIDM7Cit9CisK
ICNlbmRpZgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoNWsvYmFzZS5jIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoNWsvYmFzZS5jCmluZGV4IGYyMjJiNGEuLjBjM2UxODYg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aDVrL2Jhc2UuYworKysgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9hdGg1ay9iYXNlLmMKQEAgLTE3NTQsOCArMTc1NCw4IEBAIGFjY2Vw
dDoKIAkJICogbm90IHRyeSB0byByZW1vdmUgcGFkZGluZyBmcm9tIHNob3J0IGNvbnRyb2wgZnJh
bWVzIHRoYXQgZG8KIAkJICogbm90IGhhdmUgcGF5bG9hZC4gKi8KIAkJaGRybGVuID0gaWVlZTgw
MjExX2dldF9oZHJsZW5fZnJvbV9za2Ioc2tiKTsKLQkJcGFkc2l6ZSA9IGhkcmxlbiAmIDM7Ci0J
CWlmIChwYWRzaXplICYmIGhkcmxlbiA+PSAyNCkgeworCQlwYWRzaXplID0gYXRoNWtfcGFkX3Np
emUoaGRybGVuKTsKKwkJaWYgKHBhZHNpemUpIHsKIAkJCW1lbW1vdmUoc2tiLT5kYXRhICsgcGFk
c2l6ZSwgc2tiLT5kYXRhLCBoZHJsZW4pOwogCQkJc2tiX3B1bGwoc2tiLCBwYWRzaXplKTsKIAkJ
fQpAQCAtMjYyMCw4ICsyNjIwLDggQEAgYXRoNWtfdHgoc3RydWN0IGllZWU4MDIxMV9odyAqaHcs
IHN0cnVjdCBza19idWZmICpza2IpCiAJICogaWYgdGhpcyBpcyBub3QgdGhlIGNhc2Ugd2UgYWRk
IHRoZSBwYWRkaW5nIGFmdGVyIHRoZSBoZWFkZXIKIAkgKi8KIAloZHJsZW4gPSBpZWVlODAyMTFf
Z2V0X2hkcmxlbl9mcm9tX3NrYihza2IpOwotCXBhZHNpemUgPSBoZHJsZW4gJiAzOwotCWlmIChw
YWRzaXplICYmIGhkcmxlbiA+PSAyNCkgeworCXBhZHNpemUgPSBhdGg1a19wYWRfc2l6ZShoZHJs
ZW4pOworCWlmIChwYWRzaXplKSB7CiAKIAkJaWYgKHNrYl9oZWFkcm9vbShza2IpIDwgcGFkc2l6
ZSkgewogCQkJQVRINUtfRVJSKHNjLCAidHggaGRybGVuIG5vdCAlJTQ6ICVkIG5vdCBlbm91Z2gi
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGg1ay9kZXNjLmMgYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9hdGg1ay9kZXNjLmMKaW5kZXggNWUzNjJhNy4uYjQwYTkyOCAxMDA2NDQK
LS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoNWsvZGVzYy5jCisrKyBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2F0aDVrL2Rlc2MuYwpAQCAtNzEsNyArNzEsNyBAQCBhdGg1a19od19zZXR1cF8y
d29yZF90eF9kZXNjKHN0cnVjdCBhdGg1a19odyAqYWgsIHN0cnVjdCBhdGg1a19kZXNjICpkZXNj
LAogCS8qIFZlcmlmeSBhbmQgc2V0IGZyYW1lIGxlbmd0aCAqLwogCiAJLyogcmVtb3ZlIHBhZGRp
bmcgd2UgbWlnaHQgaGF2ZSBhZGRlZCBiZWZvcmUgKi8KLQlmcmFtZV9sZW4gPSBwa3RfbGVuIC0g
KGhkcl9sZW4gJiAzKSArIEZDU19MRU47CisJZnJhbWVfbGVuID0gcGt0X2xlbiAtIGF0aDVrX3Bh
ZF9zaXplKGhkcl9sZW4pICsgRkNTX0xFTjsKIAogCWlmIChmcmFtZV9sZW4gJiB+QVI1S18yV19U
WF9ERVNDX0NUTDBfRlJBTUVfTEVOKQogCQlyZXR1cm4gLUVJTlZBTDsKQEAgLTIwMiw3ICsyMDIs
NyBAQCBzdGF0aWMgaW50IGF0aDVrX2h3X3NldHVwXzR3b3JkX3R4X2Rlc2Moc3RydWN0IGF0aDVr
X2h3ICphaCwKIAkvKiBWZXJpZnkgYW5kIHNldCBmcmFtZSBsZW5ndGggKi8KIAogCS8qIHJlbW92
ZSBwYWRkaW5nIHdlIG1pZ2h0IGhhdmUgYWRkZWQgYmVmb3JlICovCi0JZnJhbWVfbGVuID0gcGt0
X2xlbiAtIChoZHJfbGVuICYgMykgKyBGQ1NfTEVOOworCWZyYW1lX2xlbiA9IHBrdF9sZW4gLSBh
dGg1a19wYWRfc2l6ZShoZHJfbGVuKSArIEZDU19MRU47CiAKIAlpZiAoZnJhbWVfbGVuICYgfkFS
NUtfNFdfVFhfREVTQ19DVEwwX0ZSQU1FX0xFTikKIAkJcmV0dXJuIC1FSU5WQUw7Cg==
------=_Part_2790_10307841.1229442165517--
