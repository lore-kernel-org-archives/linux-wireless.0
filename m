Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:62572 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbYLLWcn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 17:32:43 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1578824rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2008 14:32:43 -0800 (PST)
Message-ID: <69e28c910812121432h62ff39a4h45d4183d457a4a20@mail.gmail.com> (sfid-20081212_233246_286194_13E0A7B9)
Date: Fri, 12 Dec 2008 23:32:42 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [RFC 3/3] mac80211: Document the new Radiotap TX flags in Documentation/networking/mac80211-injection.txt
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_27835_13947873.1229121163066"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_27835_13947873.1229121163066
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Update Documentation/networking/mac80211-injection.txt to include the
following 2 new flags:

 * IEEE80211_RADIOTAP_TX_FLAGS

   IEEE80211_RADIOTAP_F_TX_NO_ACK: Transmit the packet once with no waiting=
 for
=09=09=09=09   an ACK and no retrying if no ACK received
   IEEE80211_RADIOTAP_F_TX_NO_SEQ: Use the sequence number already present =
in
=09=09=09=09   the 802.11 header, do not generate a new one
=09=09=09=09   in the driver/stack. Useful when injecting
=09=09=09=09   fragments with the same sequence number.

In addition, update the language somewhat to stop refering to "three
parameters" (there are more than 3, even without this patch).

Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>

---

Patch also available as an attachment in case Gmail decides to damage it.

diff --git a/Documentation/networking/mac80211-injection.txt
b/Documentation/networking/mac80211-injection.txt
index 84906ef..c6e35ff 100644
--- a/Documentation/networking/mac80211-injection.txt
+++ b/Documentation/networking/mac80211-injection.txt
@@ -12,7 +12,7 @@ following format:
 The radiotap format is discussed in
 ./Documentation/networking/radiotap-headers.txt.

-Despite 13 radiotap argument types are currently defined, most only make s=
ense
+Of the 13 radiotap argument types currently defined, most only make sense
 to appear on received packets.  The following information is parsed from t=
he
 radiotap headers and used to control injection:

@@ -40,10 +40,20 @@ radiotap headers and used to control injection:
 =09=09=09      this flag is only reliable when software
 =09=09=09      fragmentation is enabled)

+
+ * IEEE80211_RADIOTAP_TX_FLAGS
+
+   IEEE80211_RADIOTAP_F_TX_NO_ACK: Transmit the packet once with no waitin=
g for
+=09=09=09=09   an ACK and no retrying if no ACK received
+   IEEE80211_RADIOTAP_F_TX_NO_SEQ: Use the sequence number already present=
 in
+=09=09=09=09   the 802.11 header, do not generate a new one
+=09=09=09=09   in the driver/stack. Useful when injecting
+=09=09=09=09   fragments with the same sequence number.
+
 The injection code can also skip all other currently defined radiotap fiel=
ds
 facilitating replay of captured radiotap headers directly.

-Here is an example valid radiotap header defining these three parameters
+Here is an example valid radiotap header defining three of these parameter=
s:

 =090x00, 0x00, // <-- radiotap version
 =090x0b, 0x00, // <- radiotap header length

------=_Part_27835_13947873.1229121163066
Content-Type: application/octet-stream;
 name=0003-mac80211-document-the-new-radiotap-tx-flags-in-mac80211-injection-txt.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_foneznav0
Content-Disposition: attachment;
 filename=0003-mac80211-document-the-new-radiotap-tx-flags-in-mac80211-injection-txt.patch

ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vbmV0d29ya2luZy9tYWM4MDIxMS1pbmplY3Rpb24u
dHh0IGIvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL21hYzgwMjExLWluamVjdGlvbi50eHQKaW5k
ZXggODQ5MDZlZi4uYzZlMzVmZiAxMDA2NDQKLS0tIGEvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5n
L21hYzgwMjExLWluamVjdGlvbi50eHQKKysrIGIvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL21h
YzgwMjExLWluamVjdGlvbi50eHQKQEAgLTEyLDcgKzEyLDcgQEAgZm9sbG93aW5nIGZvcm1hdDoK
IFRoZSByYWRpb3RhcCBmb3JtYXQgaXMgZGlzY3Vzc2VkIGluCiAuL0RvY3VtZW50YXRpb24vbmV0
d29ya2luZy9yYWRpb3RhcC1oZWFkZXJzLnR4dC4KIAotRGVzcGl0ZSAxMyByYWRpb3RhcCBhcmd1
bWVudCB0eXBlcyBhcmUgY3VycmVudGx5IGRlZmluZWQsIG1vc3Qgb25seSBtYWtlIHNlbnNlCitP
ZiB0aGUgMTMgcmFkaW90YXAgYXJndW1lbnQgdHlwZXMgY3VycmVudGx5IGRlZmluZWQsIG1vc3Qg
b25seSBtYWtlIHNlbnNlCiB0byBhcHBlYXIgb24gcmVjZWl2ZWQgcGFja2V0cy4gIFRoZSBmb2xs
b3dpbmcgaW5mb3JtYXRpb24gaXMgcGFyc2VkIGZyb20gdGhlCiByYWRpb3RhcCBoZWFkZXJzIGFu
ZCB1c2VkIHRvIGNvbnRyb2wgaW5qZWN0aW9uOgogCkBAIC00MCwxMCArNDAsMjAgQEAgcmFkaW90
YXAgaGVhZGVycyBhbmQgdXNlZCB0byBjb250cm9sIGluamVjdGlvbjoKIAkJCSAgICAgIHRoaXMg
ZmxhZyBpcyBvbmx5IHJlbGlhYmxlIHdoZW4gc29mdHdhcmUKIAkJCSAgICAgIGZyYWdtZW50YXRp
b24gaXMgZW5hYmxlZCkKIAorCisgKiBJRUVFODAyMTFfUkFESU9UQVBfVFhfRkxBR1MKKworICAg
SUVFRTgwMjExX1JBRElPVEFQX0ZfVFhfTk9fQUNLOiBUcmFuc21pdCB0aGUgcGFja2V0IG9uY2Ug
d2l0aCBubyB3YWl0aW5nIGZvcgorCQkJCSAgIGFuIEFDSyBhbmQgbm8gcmV0cnlpbmcgaWYgbm8g
QUNLIHJlY2VpdmVkCisgICBJRUVFODAyMTFfUkFESU9UQVBfRl9UWF9OT19TRVE6IFVzZSB0aGUg
c2VxdWVuY2UgbnVtYmVyIGFscmVhZHkgcHJlc2VudCBpbgorCQkJCSAgIHRoZSA4MDIuMTEgaGVh
ZGVyLCBkbyBub3QgZ2VuZXJhdGUgYSBuZXcgb25lCisJCQkJICAgaW4gdGhlIGRyaXZlci9zdGFj
ay4gVXNlZnVsIHdoZW4gaW5qZWN0aW5nCisJCQkJICAgZnJhZ21lbnRzIHdpdGggdGhlIHNhbWUg
c2VxdWVuY2UgbnVtYmVyLgorCiBUaGUgaW5qZWN0aW9uIGNvZGUgY2FuIGFsc28gc2tpcCBhbGwg
b3RoZXIgY3VycmVudGx5IGRlZmluZWQgcmFkaW90YXAgZmllbGRzCiBmYWNpbGl0YXRpbmcgcmVw
bGF5IG9mIGNhcHR1cmVkIHJhZGlvdGFwIGhlYWRlcnMgZGlyZWN0bHkuCiAKLUhlcmUgaXMgYW4g
ZXhhbXBsZSB2YWxpZCByYWRpb3RhcCBoZWFkZXIgZGVmaW5pbmcgdGhlc2UgdGhyZWUgcGFyYW1l
dGVycworSGVyZSBpcyBhbiBleGFtcGxlIHZhbGlkIHJhZGlvdGFwIGhlYWRlciBkZWZpbmluZyB0
aHJlZSBvZiB0aGVzZSBwYXJhbWV0ZXJzOgogCiAJMHgwMCwgMHgwMCwgLy8gPC0tIHJhZGlvdGFw
IHZlcnNpb24KIAkweDBiLCAweDAwLCAvLyA8LSByYWRpb3RhcCBoZWFkZXIgbGVuZ3RoCg==
------=_Part_27835_13947873.1229121163066--
