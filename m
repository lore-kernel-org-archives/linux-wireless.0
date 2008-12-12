Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:62572 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbYLLWcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 17:32:36 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1578824rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2008 14:32:35 -0800 (PST)
Message-ID: <69e28c910812121432k1f62b4a4sfb7124940afe974d@mail.gmail.com> (sfid-20081212_233241_303659_ADBD8F48)
Date: Fri, 12 Dec 2008 23:32:35 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [RFC 1/3] cfg80211: Add a "Do not wait for an ACK" and a "Do not override the present sequence number" flag to the TX flags field of the Radiotap header
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_27830_25038536.1229121155383"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_27830_25038536.1229121155383
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Add 2 new flags to the "TX Flags" radiotap header field that control
certain aspects of packet injection:

IEEE80211_RADIOTAP_F_TX_NO_ACK: Transmission shall not expect an ACK
frame and not retry when no ACK is received
IEEE80211_RADIOTAP_F_TX_NO_SEQ: Transmission shall use the sequence
and fragment numbers already present in the IEEE 802.11 packet header,
rather than generating one at driver/stack-level

The first flag is useful when an userspace app wants to inject packets
that should not be ACKed according to the IEEE 802.11:2007 standard
(e.g. multicast frames, ACKs, beacons, etc.). The second flag enables
userspace injectors to control the sequence and fragment numbers of
the transmitted frame, allowing e.g. injection of fragments with an
identical sequence number and an incrementing fragment number.

Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>

---

Patch also available as an attachment, in case it gets damaged by Gmail.

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radio=
tap.h
index d364fd5..4e28c0c 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -247,6 +247,9 @@ enum ieee80211_radiotap_type {
 =09=09=09=09=09=09 * retries */
 #define IEEE80211_RADIOTAP_F_TX_CTS=090x0002=09/* used cts 'protection' */
 #define IEEE80211_RADIOTAP_F_TX_RTS=090x0004=09/* used rts/cts handshake *=
/
+#define IEEE80211_RADIOTAP_F_TX_NOACK=090x0008=09/* frame should not be AC=
Ked */
+#define IEEE80211_RADIOTAP_F_TX_NOSEQ=090x0010=09/* sequence number handle=
d
+=09=09=09=09=09=09 * by userspace */

 /* Ugly macro to convert literal channel numbers into their mhz equivalent=
s
  * There are certianly some conditions that will break this (like
feeding it '30')

------=_Part_27830_25038536.1229121155383
Content-Type: application/octet-stream;
 name=0001-cfg80211-add-no-ack-and-no-seq-override-tx-flags.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fonelzze0
Content-Disposition: attachment;
 filename=0001-cfg80211-add-no-ack-and-no-seq-override-tx-flags.patch

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2llZWU4MDIxMV9yYWRpb3RhcC5oIGIvaW5jbHVkZS9u
ZXQvaWVlZTgwMjExX3JhZGlvdGFwLmgKaW5kZXggZDM2NGZkNS4uNGUyOGMwYyAxMDA2NDQKLS0t
IGEvaW5jbHVkZS9uZXQvaWVlZTgwMjExX3JhZGlvdGFwLmgKKysrIGIvaW5jbHVkZS9uZXQvaWVl
ZTgwMjExX3JhZGlvdGFwLmgKQEAgLTI0Nyw2ICsyNDcsOSBAQCBlbnVtIGllZWU4MDIxMV9yYWRp
b3RhcF90eXBlIHsKIAkJCQkJCSAqIHJldHJpZXMgKi8KICNkZWZpbmUgSUVFRTgwMjExX1JBRElP
VEFQX0ZfVFhfQ1RTCTB4MDAwMgkvKiB1c2VkIGN0cyAncHJvdGVjdGlvbicgKi8KICNkZWZpbmUg
SUVFRTgwMjExX1JBRElPVEFQX0ZfVFhfUlRTCTB4MDAwNAkvKiB1c2VkIHJ0cy9jdHMgaGFuZHNo
YWtlICovCisjZGVmaW5lIElFRUU4MDIxMV9SQURJT1RBUF9GX1RYX05PQUNLCTB4MDAwOAkvKiBm
cmFtZSBzaG91bGQgbm90IGJlIEFDS2VkICovCisjZGVmaW5lIElFRUU4MDIxMV9SQURJT1RBUF9G
X1RYX05PU0VRCTB4MDAxMAkvKiBzZXF1ZW5jZSBudW1iZXIgaGFuZGxlZAorCQkJCQkJICogYnkg
dXNlcnNwYWNlICovCiAKIC8qIFVnbHkgbWFjcm8gdG8gY29udmVydCBsaXRlcmFsIGNoYW5uZWwg
bnVtYmVycyBpbnRvIHRoZWlyIG1oeiBlcXVpdmFsZW50cwogICogVGhlcmUgYXJlIGNlcnRpYW5s
eSBzb21lIGNvbmRpdGlvbnMgdGhhdCB3aWxsIGJyZWFrIHRoaXMgKGxpa2UgZmVlZGluZyBpdCAn
MzAnKQo=
------=_Part_27830_25038536.1229121155383--
