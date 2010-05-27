Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:42740 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab0E0Oba (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 10:31:30 -0400
Received: by qyk13 with SMTP id 13so61730qyk.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 May 2010 07:31:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BFDEBDC.4070304@gmail.com>
References: <AANLkTimltZSc8dJPPBCibcGDaOPcQRU_5kSbenIAdi_6@mail.gmail.com>
	<AANLkTimaLEQYH4Y7HO4Fv4zT8w8AsPkaAQtk9EauX4Bt@mail.gmail.com>
	<AANLkTikRt1fUgngBQxEoEFe1VDrYVFRAoMSR53et7gxf@mail.gmail.com>
	<AANLkTim-A_TWT-flrW88gJGan47Xhm7llyrQE3ehDKU6@mail.gmail.com>
	<AANLkTim4zLxIQH2r76WZRh9kNigVNAngcK1d9-Cu65Ag@mail.gmail.com>
	<AANLkTimH3p-dBA_6ee2a0iCnPDhtPZONzCEVkzMHrUWo@mail.gmail.com>
	<AANLkTim-4UNn8acYvF7AF2FDzdC9xRY-9JS0lSurwBc6@mail.gmail.com>
	<AANLkTimYeL4KQozuTl4le9WUpObsjwp0YAx7eAYq6MBr@mail.gmail.com>
	<AANLkTikOgv6d0FlXu2-smnYPApeehjRq_j8UxEealqFC@mail.gmail.com>
	<AANLkTinynNqs6_zyTJcpi7yKiSvC5fBhbM2tVZcnoNUq@mail.gmail.com>
	<AANLkTinyGlwqq4xshLU5Ol74p0VfcUXBjBGKXlsB2pMy@mail.gmail.com>
	<AANLkTimIeTadyAhUuri2P630mpDwmBk4B90RpERLbaFE@mail.gmail.com>
	<AANLkTilXJHs8emXX4YNHbPq0SkuC4Z22NEh-T6mwUSHS@mail.gmail.com>
	<4BFDEBDC.4070304@gmail.com>
Date: Thu, 27 May 2010 10:31:29 -0400
Message-ID: <AANLkTin3VSp_FcSiadD4efE1Yo1vKiDXmOngsHEKiQmF@mail.gmail.com>
Subject: Re: ath5k past 2.6.30 breaks monitor mode (and thus the aircrack
	suite)
From: Bob Copeland <me@bobcopeland.com>
To: Richard Farina <sidhayn@gmail.com>
Cc: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Weedy <weedy2887@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: multipart/mixed; boundary=000feae9fd080c75a90487943f80
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--000feae9fd080c75a90487943f80
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, May 26, 2010 at 11:49 PM, Richard Farina <sidhayn@gmail.com> wrote:
> Bob Copeland wrote:
>> Ok, it should be enough to look at the filter flags instead of
>> the opmode -- I knew in the back of my mind that the monitor
>> stuff was bogus (part of the reason I did the patch in the first
>> place) but just got confused by what was already there I guess.
>
> I've got a lot of people very interested in this fix. Let me know what ki=
nd
> of support you need to make this happen. =A0You know where to find me on =
irc
> ;-)

Ok, can you and Weedy try this patch?

Use the attachment -- gmail will screw up the whitespace, but I included
it inline for reference.

Weedy, if you want reported-by credit can you give your full name and
preferred email address?

From: Bob Copeland <me@bobcopeland.com>
Date: Thu, 27 May 2010 08:54:38 -0400
Subject: [PATCH] ath5k: retain promiscuous setting

Commit 56d1de0a21db28e41741cfa0a66e18bc8d920554, "ath5k: clean up
filter flags setting" introduced a regression in monitor mode such
that the promisc filter flag would get lost.

Although we set the promisc flag when it changed, we did not
preserve it across subsequent calls to configure_filter.  This patch
restores the original functionality.

Cc: stable@kernel.org
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

Note, a better fix would be to just unconditionally look at new_flags,
but this is the minimal change for stable.  I'll add fixing all this
stuff up to my todo.

 drivers/net/wireless/ath/ath5k/base.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c
b/drivers/net/wireless/ath/ath5k/base.c
index 9c27623..9e023b8 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -3153,13 +3153,15 @@ static void ath5k_configure_filter(struct
ieee80211_hw *hw,

 	if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
 		if (*new_flags & FIF_PROMISC_IN_BSS) {
-			rfilt |=3D AR5K_RX_FILTER_PROM;
 			__set_bit(ATH_STAT_PROMISC, sc->status);
 		} else {
 			__clear_bit(ATH_STAT_PROMISC, sc->status);
 		}
 	}

+	if (test_bit(ATH_STAT_PROMISC, sc->status))
+		rfilt |=3D AR5K_RX_FILTER_PROM;
+
 	/* Note, AR5K_RX_FILTER_MCAST is already enabled */
 	if (*new_flags & FIF_ALLMULTI) {
 		mfilt[0] =3D  ~0;
--=20
1.6.3.3


--=20
Bob Copeland %% www.bobcopeland.com

--000feae9fd080c75a90487943f80
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-ath5k-retain-promiscuous-setting.patch"
Content-Disposition: attachment;
	filename="0001-ath5k-retain-promiscuous-setting.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g9pphx9y0

RnJvbSBiZWZlNDdhODRhMjIzMTJlMDU0N2QwNGNkM2QyNTBiMGU0OWVjZjU0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCb2IgQ29wZWxhbmQgPG1lQGJvYmNvcGVsYW5kLmNvbT4KRGF0
ZTogVGh1LCAyNyBNYXkgMjAxMCAwODo1NDozOCAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIGF0aDVr
OiByZXRhaW4gcHJvbWlzY3VvdXMgc2V0dGluZwoKQ29tbWl0IDU2ZDFkZTBhMjFkYjI4ZTQxNzQx
Y2ZhMGE2NmUxOGJjOGQ5MjA1NTQsICJhdGg1azogY2xlYW4gdXAKZmlsdGVyIGZsYWdzIHNldHRp
bmciIGludHJvZHVjZWQgYSByZWdyZXNzaW9uIGluIG1vbml0b3IgbW9kZSBzdWNoCnRoYXQgdGhl
IHByb21pc2MgZmlsdGVyIGZsYWcgd291bGQgZ2V0IGxvc3QuCgpBbHRob3VnaCB3ZSBzZXQgdGhl
IHByb21pc2MgZmxhZyB3aGVuIGl0IGNoYW5nZWQsIHdlIGRpZCBub3QKcHJlc2VydmUgaXQgYWNy
b3NzIHN1YnNlcXVlbnQgY2FsbHMgdG8gY29uZmlndXJlX2ZpbHRlci4gIFRoaXMgcGF0Y2gKcmVz
dG9yZXMgdGhlIG9yaWdpbmFsIGZ1bmN0aW9uYWxpdHkuCgpDYzogc3RhYmxlQGtlcm5lbC5vcmcK
U2lnbmVkLW9mZi1ieTogQm9iIENvcGVsYW5kIDxtZUBib2Jjb3BlbGFuZC5jb20+Ci0tLQoKTm90
ZSwgYSBiZXR0ZXIgZml4IHdvdWxkIGJlIHRvIGp1c3QgdW5jb25kaXRpb25hbGx5IGxvb2sgYXQg
bmV3X2ZsYWdzLApidXQgdGhpcyBpcyB0aGUgbWluaW1hbCBjaGFuZ2UgZm9yIHN0YWJsZS4gIEkn
bGwgYWRkIGZpeGluZyBhbGwgdGhpcwpzdHVmZiB1cCB0byBteSB0b2RvLgoKIGRyaXZlcnMvbmV0
L3dpcmVsZXNzL2F0aC9hdGg1ay9iYXNlLmMgfCAgICA0ICsrKy0KIDEgZmlsZXMgY2hhbmdlZCwg
MyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2F0aC9hdGg1ay9iYXNlLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRo
NWsvYmFzZS5jCmluZGV4IDljMjc2MjMuLjllMDIzYjggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2F0aC9hdGg1ay9iYXNlLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRo
L2F0aDVrL2Jhc2UuYwpAQCAtMzE1MywxMyArMzE1MywxNSBAQCBzdGF0aWMgdm9pZCBhdGg1a19j
b25maWd1cmVfZmlsdGVyKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogCiAJaWYgKGNoYW5nZWRf
ZmxhZ3MgJiAoRklGX1BST01JU0NfSU5fQlNTIHwgRklGX09USEVSX0JTUykpIHsKIAkJaWYgKCpu
ZXdfZmxhZ3MgJiBGSUZfUFJPTUlTQ19JTl9CU1MpIHsKLQkJCXJmaWx0IHw9IEFSNUtfUlhfRklM
VEVSX1BST007CiAJCQlfX3NldF9iaXQoQVRIX1NUQVRfUFJPTUlTQywgc2MtPnN0YXR1cyk7CiAJ
CX0gZWxzZSB7CiAJCQlfX2NsZWFyX2JpdChBVEhfU1RBVF9QUk9NSVNDLCBzYy0+c3RhdHVzKTsK
IAkJfQogCX0KIAorCWlmICh0ZXN0X2JpdChBVEhfU1RBVF9QUk9NSVNDLCBzYy0+c3RhdHVzKSkK
KwkJcmZpbHQgfD0gQVI1S19SWF9GSUxURVJfUFJPTTsKKwogCS8qIE5vdGUsIEFSNUtfUlhfRklM
VEVSX01DQVNUIGlzIGFscmVhZHkgZW5hYmxlZCAqLwogCWlmICgqbmV3X2ZsYWdzICYgRklGX0FM
TE1VTFRJKSB7CiAJCW1maWx0WzBdID0gIH4wOwotLSAKMS42LjMuMwoK
--000feae9fd080c75a90487943f80--
