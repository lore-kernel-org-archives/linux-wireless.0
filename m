Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr70137.outbound.protection.outlook.com ([40.107.7.137]:31087
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731105AbeGRRk2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jul 2018 13:40:28 -0400
From: Jean-Pierre TOSONI <jp.tosoni@acksys.fr>
To: =?Windows-1252?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Ben Greear <greearb@candelatech.com>,
        SEDE <s.deronne@televic.com>,
        Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        ath10k <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Setting tx retry count in ath10k
Date: Wed, 18 Jul 2018 17:01:32 +0000
Message-ID: <AM4PR0101MB230575D91CEE21630A723466E4530@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com> (sfid-20180718_190217_305940_3544565F)
References: <b0f67dd7-dea9-508e-7ad9-f6db3ac88b90@candelatech.com>
 <e9b42b3d-2d03-ca69-5532-fbae08fdec5d@uni-rostock.de>
 <8b9713fe-7573-f009-d002-13df73315898@televic.com>
 <9dd76e58-b514-26f2-2fe9-0c9a7f798054@candelatech.com>
 <AM4PR0101MB2305917B39A84BBE13FDFAD1E4530@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
 <ea2ff457-e84e-8395-148d-8d90a749a40d@candelatech.com>
 <877els5xax.fsf@toke.dk>
In-Reply-To: <877els5xax.fsf@toke.dk>
Content-Type: multipart/mixed;
        boundary="_002_AM4PR0101MB230575D91CEE21630A723466E4530AM4PR0101MB2305_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_AM4PR0101MB230575D91CEE21630A723466E4530AM4PR0101MB2305_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

Hi Ben,

I attached the patch. Please remind that it applies to ath9k.

At the end there are 3 comments in French, translation follows:
1) " longretry gives directly the transmit count, the +1 is useless.
     Should rather have -1 to account for the first try"
2) " The retries just made for this frame must be added in to know
     If the max was overstepped"
3) " Add the 1st try (probably useless).
     Upstream version adds 1 to A-MPDU retries but I don't understand why.
     Since above I removed the +1 to fix the count, I add +1 here once per
     frame in case the "+1" is actually hiding a bug in the upstream versio=
n"

@Toke: As you can see in the patch, the value 30 was the fixed value define=
d
 in ath9k, I kept it for compatibility only (and that's why I wanted to mak=
e
 it configurable :-)
On another hand, Minstrel in mac80211 seems to vary retries according to wh=
at
you say, i.e. Minstrel tries to stay below a certain amount of time, but th=
is
only applies to short/long retries.

Jean-Pierre

> -----Message d'origine-----
> De=A0: Toke H=F8iland-J=F8rgensen [mailto:toke@toke.dk]
> Envoy=E9=A0: mercredi 18 juillet 2018 18:22
> =C0=A0: Ben Greear; Jean-Pierre TOSONI; SEDE; Benjamin Beichler; ath10k; =
linux-wireless@vger.kernel.org
> Objet=A0: Re: Setting tx retry count in ath10k
>=20
> Ben Greear <greearb@candelatech.com> writes:
>=20
> > On 07/18/2018 08:50 AM, Jean-Pierre TOSONI wrote:
> >> Hi,
> >>
> >> We made retries configurable in our mac80211+ath9k system, and we ende=
d with 3 counts:
> >> 1) short retry count, defaults to 4
> >> 2) long retrys count, defauts to 7
> >> 3) software retry count, defaults to 30
> >> This last one is used separately for each frame in an aggregated frame=
, since they can be
> separately acknowledged.
> >
> > Did you have to change code for #3, and if so, can you share the patch?
> >
> > I wonder also if retries should be different for different types of
> > data. For instance, if someone is using UDP, maybe they don't care so
> > much about lost packets and would prefer a lower retry count. Or,
> > maybe IP type-of-service could be taken into account and retry frames
> > different amounts based on ToS?
>=20
> For general internet traffic, a retry count of 30 is way too high; that
> is up to 120 ms of HOL blocking latency. Better to just drop the packet
> at that point.
>=20
> Ideally, the retry count should be dynamically calculated in units of
> time (which would depend on the rate and aggregate size), and also take
> queueing time into account. I've been meaning to experiment with this
> for minstrel and ath9k, but haven't gotten around to it...
>=20
> -Toke

--_002_AM4PR0101MB230575D91CEE21630A723466E4530AM4PR0101MB2305_
Content-Type: application/octet-stream;
	name="a919-acksys-Add-parameter-for-software-retry.patch"
Content-Description: a919-acksys-Add-parameter-for-software-retry.patch
Content-Disposition: attachment;
	filename="a919-acksys-Add-parameter-for-software-retry.patch"; size=4644;
	creation-date="Wed, 18 Jul 2018 16:59:43 GMT";
	modification-date="Wed, 18 Jul 2018 16:59:24 GMT"
Content-Transfer-Encoding: base64

RnJvbSAzYjYxNGQ3MTlhNmZiODA2ZmVmN2ZjNTYwODQxZTZjOTNlODEyNzUzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/Qz1DMz1BOWRyaWM9MjBERUJBUkdFPz0gPGNl
ZHJpYy5kZWJhcmdlQGFja3N5cy5mcj4KRGF0ZTogVGh1LCA1IEp1biAyMDE0IDEyOjEzOjA1ICsw
MjAwClN1YmplY3Q6IFtQQVRDSCAyLzJdIEFkZCBwYXJhbWV0ZXIgZm9yIHNvZnR3YXJlIHJldHJ5
CgpXaGVuIHRoZSBhZ2dyZWdhdGUgZnJhbWUgYXJlIHNlbnQsIHRoZSBBVEg5SyBtYW5hZ2UgYSBz
b2Z3YXJlIHJldHJpZXMuClRoZSBtYXhpbXVtIHNvZndhcmUgcmV0cmllcyBpcyBzZXQgdG8gQVRI
OUtfU1dfTUFYX1JFVFJJRVMgKDMwKQpjb25zdGFudC4KCkFkZCBtYXhfc3dfcmV0cmllcyBmaWVs
ZCBpbiBhdGhfc29mdGMgc3RydWN0dXJlLgpTZXQgdGhlIGRlZmF1bHQgdmFsdWUgdG8gQVRIOUtf
U1dfTUFYX1JFVFJJRVMgKHRvIGtlZXAgYmFja3dhcmQKY29tcGF0aWJpbGl0eSkuCkFkZCBlbnRy
eSBpbiBkZWJ1Z2ZzIHRvIGNvbmZpZ3VyZSB0aGlzIG5ldyB2YWx1ZS4KLS0tCiBkcml2ZXJzL25l
dC93aXJlbGVzcy9hdGgvYXRoOWsvYXRoOWsuaCB8ICAgIDEgKwogZHJpdmVycy9uZXQvd2lyZWxl
c3MvYXRoL2F0aDlrL2RlYnVnLmMgfCAgIDQxICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrCiBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvaW5pdC5jICB8ICAgIDEgKwogZHJp
dmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL3htaXQuYyAgfCAgICAyICstCiA0IGZpbGVzIGNo
YW5nZWQsIDQ0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCi0tLSBhL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2F0aC9hdGg5ay9hdGg5ay5oCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0
aC9hdGg5ay9hdGg5ay5oCkBAIC05OTAsNiArOTkwLDcgQEAgc3RydWN0IGF0aF9zb2Z0YyB7CiAK
IAl1OCBndHRfY250OwogCXUzMiBpbnRyc3RhdHVzOworCXU4IG1heF9zd19yZXRyaWVzOwogCXUx
NiBwc19mbGFnczsgLyogUFNfKiAqLwogCWJvb2wgcHNfZW5hYmxlZDsKIAlib29sIHBzX2lkbGU7
Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9kZWJ1Zy5jCisrKyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9kZWJ1Zy5jCkBAIC0xMjk2LDYgKzEyOTYsNDUgQEAg
dm9pZCBhdGg5a19nZXRfZXRfc3RhdHMoc3RydWN0IGllZWU4MDIxMQogCVdBUk5fT04oaSAhPSBB
VEg5S19TU1RBVFNfTEVOKTsKIH0KIAorc3RhdGljIHNzaXplX3QgcmVhZF9maWxlX21heF9zd19y
ZXRyaWVzKHN0cnVjdCBmaWxlICpmaWxlLCBjaGFyIF9fdXNlciAqdXNlcl9idWYsCisJCQkgICAg
IHNpemVfdCBjb3VudCwgbG9mZl90ICpwcG9zKQoreworCXN0cnVjdCBhdGhfc29mdGMgKnNjID0g
ZmlsZS0+cHJpdmF0ZV9kYXRhOworCWNoYXIgYnVmWzMyXTsKKwl1bnNpZ25lZCBpbnQgbGVuOwor
CisJbGVuID0gc3ByaW50ZihidWYsICIlZFxuIiwgc2MtPm1heF9zd19yZXRyaWVzKTsKKwlyZXR1
cm4gc2ltcGxlX3JlYWRfZnJvbV9idWZmZXIodXNlcl9idWYsIGNvdW50LCBwcG9zLCBidWYsIGxl
bik7Cit9CisKK3N0YXRpYyBzc2l6ZV90IHdyaXRlX21heF9zd19yZXRyaWVzKHN0cnVjdCBmaWxl
ICpmaWxlLCBjb25zdCBjaGFyIF9fdXNlciAqdXNlcl9idWYsCisJCQkgICAgIHNpemVfdCBjb3Vu
dCwgbG9mZl90ICpwcG9zKQoreworCXN0cnVjdCBhdGhfc29mdGMgKnNjID0gZmlsZS0+cHJpdmF0
ZV9kYXRhOworCXVuc2lnbmVkIGxvbmcgbWF4X3N3X3JldHJpZXM7CisJY2hhciBidWZbMzJdOwor
CXNzaXplX3QgbGVuOworCisJbGVuID0gbWluKGNvdW50LCBzaXplb2YoYnVmKSAtIDEpOworCWlm
IChjb3B5X2Zyb21fdXNlcihidWYsIHVzZXJfYnVmLCBsZW4pKQorCQlyZXR1cm4gLUVGQVVMVDsK
KworCWJ1ZltsZW5dID0gJ1wwJzsKKwlpZiAoa3N0cnRvdWwoYnVmLCAwLCAmbWF4X3N3X3JldHJp
ZXMpKQorCQlyZXR1cm4gLUVJTlZBTDsKKworCXNjLT5tYXhfc3dfcmV0cmllcyA9IG1heF9zd19y
ZXRyaWVzOworCXJldHVybiBjb3VudDsKK30KKworc3RhdGljIGNvbnN0IHN0cnVjdCBmaWxlX29w
ZXJhdGlvbnMgZm9wc19tYXhfc3dfcmV0cmllcyA9IHsKKwkucmVhZCA9IHJlYWRfZmlsZV9tYXhf
c3dfcmV0cmllcywKKwkud3JpdGUgPSB3cml0ZV9tYXhfc3dfcmV0cmllcywKKwkub3BlbiA9IHNp
bXBsZV9vcGVuLAorCS5vd25lciA9IFRISVNfTU9EVUxFLAorCS5sbHNlZWsgPSBkZWZhdWx0X2xs
c2VlaywKK307CisKIHZvaWQgYXRoOWtfZGVpbml0X2RlYnVnKHN0cnVjdCBhdGhfc29mdGMgKnNj
KQogewogCWF0aDlrX2Ntbl9zcGVjdHJhbF9kZWluaXRfZGVidWcoJnNjLT5zcGVjX3ByaXYpOwpA
QCAtMTU1MCw2ICsxNTg5LDggQEAgaW50IGF0aDlrX2luaXRfZGVidWcoc3RydWN0IGF0aF9odyAq
YWgpCiAJCQkgICZhaC0+cnhjaGFpbm1hc2spOwogCWRlYnVnZnNfY3JlYXRlX3U4KCJ0eF9jaGFp
bm1hc2siLCBTX0lSVVNSLCBzYy0+ZGVidWcuZGVidWdmc19waHksCiAJCQkgICZhaC0+dHhjaGFp
bm1hc2spOworCWRlYnVnZnNfY3JlYXRlX2ZpbGUoIm1heF9zd19yZXRyaWVzIiwgU19JUlVTUiB8
IFNfSVdVU1IsCisJCQkgICAgc2MtPmRlYnVnLmRlYnVnZnNfcGh5LCBzYywgJmZvcHNfbWF4X3N3
X3JldHJpZXMpOwogCWRlYnVnZnNfY3JlYXRlX2ZpbGUoImFuaSIsIFNfSVJVU1IgfCBTX0lXVVNS
LAogCQkJICAgIHNjLT5kZWJ1Zy5kZWJ1Z2ZzX3BoeSwgc2MsICZmb3BzX2FuaSk7CiAJZGVidWdm
c19jcmVhdGVfYm9vbCgicGFwcmQiLCBTX0lSVVNSIHwgU19JV1VTUiwgc2MtPmRlYnVnLmRlYnVn
ZnNfcGh5LAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvaW5pdC5jCisrKyBi
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9pbml0LmMKQEAgLTM4Myw2ICszODMsNyBA
QCBzdGF0aWMgdm9pZCBhdGg5a19pbml0X21pc2Moc3RydWN0IGF0aF9zCiAJc2MtPnNwZWNfcHJp
di5zcGVjX2NvbmZpZy5lbmRsZXNzID0gZmFsc2U7CiAJc2MtPnNwZWNfcHJpdi5zcGVjX2NvbmZp
Zy5wZXJpb2QgPSAweEZGOwogCXNjLT5zcGVjX3ByaXYuc3BlY19jb25maWcuZmZ0X3BlcmlvZCA9
IDB4RjsKKwlzYy0+bWF4X3N3X3JldHJpZXMgPSBBVEhfTUFYX1NXX1JFVFJJRVM7CiB9CiAKIHN0
YXRpYyB2b2lkIGF0aDlrX2luaXRfcGNvZW1fcGxhdGZvcm0oc3RydWN0IGF0aF9zb2Z0YyAqc2Mp
Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay94bWl0LmMKKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL3htaXQuYwpAQCAtNDcxLDcgKzQ3MSw5IEBAIHN0YXRp
YyB2b2lkIGF0aF90eF9jb21wbGV0ZV9hZ2dyKHN0cnVjdAogCiAJbWVtY3B5KHJhdGVzLCBiZi0+
cmF0ZXMsIHNpemVvZihyYXRlcykpOwogCi0JcmV0cmllcyA9IHRzLT50c19sb25ncmV0cnkgKyAx
OworCS8qIGxvbmdyZXRyeSBkb25uZSBkaXJlY3RlbWVudCBsZSBub21icmUgZGUgdHJhbnNtaXNz
aW9ucywgbGUgKzEgZXN0CisJICogaW51dGlsZS4gT24gZGV2cmFpdCBwbHV0b3QgYXZvaXIgLTEg
cG91ciBlbmxldmVyIGxlIDFlciB0cnkuICovCisJcmV0cmllcyA9IHRzLT50c19sb25ncmV0cnk7
CiAJZm9yIChpID0gMDsgaSA8IHRzLT50c19yYXRlaW5kZXg7IGkrKykKIAkJcmV0cmllcyArPSBy
YXRlc1tpXS5jb3VudDsKIApAQCAtNTYwLDEwICs1NjIsMjIgQEAgc3RhdGljIHZvaWQgYXRoX3R4
X2NvbXBsZXRlX2FnZ3Ioc3RydWN0CiAJCQlhY2tlZF9jbnQrKzsKIAkJfSBlbHNlIGlmIChmbHVz
aCkgewogCQkJdHhwZW5kaW5nID0gMTsKLQkJfSBlbHNlIGlmIChmaS0+cmV0cmllcyA8IEFUSF9N
QVhfU1dfUkVUUklFUykgeworCQl9IGVsc2UgaWYgKGZpLT5yZXRyaWVzK3JldHJpZXMgPCBzYy0+
bWF4X3N3X3JldHJpZXMpIHsKKwkJCS8qIExlcyByZXRyaWVzIHF1aSB2aWVubmVudCBkJ8OqdHJl
IGZhaXRzIHN1ciBjZXR0ZQorCQkJICogdHJhbWUgZG9pdmVudCDDqnRyZSBham91dMOpcyBwb3Vy
IHNhdm9pciBzaSBvbiBhCisJCQkgKiBkw6lwYXNzw6kgbGUgbWF4ICovCisJCQkvKgorCQkJICog
QWpvdXRlciBsZSAxZXIgZXNzYWkgKHByb2JhYmxlbWVudCBpbnV0aWxlKS4KKwkJCSAqIExhIHZl
cnNpb24gdXBzdHJlYW0gYWpvdXRlIDEgYXV4IHJldHJpZXMgZHUgQS1NUERVCisJCQkgKiBtYWlz
IGplIG5lIGNvbXByZW5kcyBwYXMgcG91cnF1b2kuCisJCQkgKiBDb21tZSBjaS1kZXNzdXMgaidh
aSByZXRpcsOpIGxlICsxIHBvdXIgY29ycmlnZXIgbGUKKwkJCSAqIGNvbXB0YWdlLCBqJ2Fqb3V0
ZSArMSB1bmUgc2V1bGUgZm9pcyBwYXIgdHJhbWUgYXUgY2FzCisJCQkgKiBvdSBsZSArMSBjYWNo
ZXJhaXQgdW4gYnVnIGRhbnMgbGEgdmVyc2lvbiB1cHN0cmVhbS4KKwkJCSAqLworCQkJaW50IHRy
eSA9ICFmaS0+cmV0cmllczsgLyogMSBzaSAxZXJlIGZvaXMsIDAgc2lub24gKi8KIAkJCWlmICh0
eG9rIHx8ICFhbi0+c2xlZXBpbmcpCiAJCQkJYXRoX3R4X3NldF9yZXRyeShzYywgdHhxLCBiZi0+
YmZfbXBkdSwKLQkJCQkJCSByZXRyaWVzKTsKKwkJCQkJCSB0cnkgKyByZXRyaWVzKTsKIAogCQkJ
dHhwZW5kaW5nID0gMTsKIAkJfSBlbHNlIHsK

--_002_AM4PR0101MB230575D91CEE21630A723466E4530AM4PR0101MB2305_--
