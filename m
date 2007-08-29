Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33264 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbXH2IgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 04:36:04 -0400
Subject: Re: mac80211 AP mode powersaving problems?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <87sl63prsg.fsf@nokia.com>
References: <1186990509.27916.38.camel@johannes.berg>
	 <87lkccf30m.fsf@tikku.osso.net> <1187270479.5141.44.camel@johannes.berg>
	 <87643f4kkh.fsf@nokia.com> <1187275344.23489.6.camel@johannes.berg>
	 <871wdphsus.fsf@nokia.com> <1188290911.7837.65.camel@johannes.berg>
	 <87absbsz5f.fsf@nokia.com> <1188299159.7837.96.camel@johannes.berg>
	 <87sl63prsg.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EXpAYGnRaZalYDfNc3qx"
Date: Wed, 29 Aug 2007 02:58:29 +0200
Message-Id: <1188349109.7837.147.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EXpAYGnRaZalYDfNc3qx
Content-Type: multipart/mixed; boundary="=-ssAhLEXRfOiiQPBjgoVA"


--=-ssAhLEXRfOiiQPBjgoVA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey,

Good news. I figured out the DTIM thing and the multicast frame queue
stuff. For multicast frames, you simply send them down queue four and
they are dequeued and sent by the ucode after the DTIM beacon.

> But that's not all, also multicast frames (including ARP broadcast)
> are not buffered correctly. They are sent randomly instead of directly
> after a DTIM beacon. Also Multicast bit is not set and DTIM is always
> zero even though DTIM period is two.

Actually, they were sent right away because we enqueued them to queue
zero, not queue four.

Please try the attached patches. I haven't implemented the set_tim()
callback yet, but the device should now wake up for multicast traffic,
not for unicast yet. The patches work for me on a heavily patched kernel
('everything' plus http://johannes.sipsolutions.net/patches/kernel/all/)

I'll update the specs to indicate that
 (1) the tim offset shm thing needs to be set as well as the dtim period
 (2) queue four must be used for multicast frames [in client mode we
     never send multicast frames so doing it unconditionally is fine]
 (3) updating the beacon on every beacon interrupt isn't necessary, it
     only needs to be updated if it has changed (it works fine even if
     you update it, it's just not necessary)
 (4) the TIM is software controlled and should be set by the driver with
     help from the beacon interrupt.
 (5) the 0xa8 (=3D=3D0x54*2) shm offset needs to be described, it's the
     "last multicast frame" for clearing the more-data bit and 0xffff is
     a special value that causes the microcode to clear the more-data
     bit on all multicast frames (odd, and I don't know why that would
     be useful, probably something with IBSS when we're not beaconing)

Due to the last point, I'm not entirely sure these patches are correct.
And I haven't bothered about PIO, do we even have access to that queue
there?

As for the whole beacon handling... I suggest that we change mac80211 to
give the beacon head and beacon tail to the driver like it gets it from
hostapd. Thing is, we first go to all the effort to build a valid beacon
frame, but then the driver gets to parse it all out again. That's dumb.
Hardware that has beaconing offload and implements the set_tim()
callback needs to know the TIM position, so it's probably better off
knowing the beacon head and tail. Drivers that call get_beacon() don't
care about conf->beacon except that they need to free it. Not obvious,
and many are probably buggy.

johannes

--=-ssAhLEXRfOiiQPBjgoVA
Content-Disposition: attachment; filename=055-b43-timb-position.patch
Content-Type: text/x-vhdl; name=055-b43-timb-position.patch; charset=utf-8
Content-Transfer-Encoding: base64

LS0tDQogZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL21haW4uYyB8ICAgMTIgKysrKysrKysrKy0t
DQogMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCi0t
LSB3aXJlbGVzcy1kZXYub3JpZy9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvbWFpbi5jCTIwMDct
MDgtMjkgMDE6NDM6NDQuNDA0NjE4Njk1ICswMjAwDQorKysgd2lyZWxlc3MtZGV2L2RyaXZlcnMv
bmV0L3dpcmVsZXNzL2I0My9tYWluLmMJMjAwNy0wOC0yOSAwMTo0Mzo0Ni45NTQ2MTg2OTUgKzAy
MDANCkBAIC0xMTgwLDYgKzExODAsNyBAQCBzdGF0aWMgdm9pZCBiNDNfd3JpdGVfYmVhY29uX3Rl
bXBsYXRlKHN0DQogCWxlbiA9IG1pbigoc2l6ZV90KSBkZXYtPmNhY2hlZF9iZWFjb24tPmxlbiwN
CiAJCSAgMHgyMDAgLSBzaXplb2Yoc3RydWN0IGI0M19wbGNwX2hkcjYpKTsNCiAJZGF0YSA9IChj
b25zdCB1OCAqKShkZXYtPmNhY2hlZF9iZWFjb24tPmRhdGEpOw0KKwlwcmludGsoS0VSTl9ERUJV
RyAid3JpdGluZyBiZWFjb25cbiIpOw0KIAliNDNfd3JpdGVfdGVtcGxhdGVfY29tbW9uKGRldiwg
ZGF0YSwNCiAJCQkJICBsZW4sIHJhbV9vZmZzZXQsIHNobV9zaXplX29mZnNldCwgcmF0ZSk7DQog
fQ0KQEAgLTEyNDIsNiArMTI0MywxMyBAQCBzdGF0aWMgdTggKmI0M19nZW5lcmF0ZV9wcm9iZV9y
ZXNwKHN0cnVjDQogCQkJbWVtY3B5KGRlc3RfZGF0YSArIGRlc3RfcG9zLCBzcmNfZGF0YSArIHNy
Y19wb3MsDQogCQkJICAgICAgIGVsZW1fc2l6ZSk7DQogCQkJZGVzdF9wb3MgKz0gZWxlbV9zaXpl
Ow0KKwkJfSBlbHNlIHsNCisJCQlwcmludGsoS0VSTl9ERUJVRyAiVElNIGlzIGF0IDB4JXhcbiIs
IGRlc3RfcG9zKTsNCisJCQlwcmludGsoS0VSTl9ERUJVRyAiRFRJTSBwZXJpb2QgaXMgJWRcbiIs
IHNyY19kYXRhW3NyY19wb3MgKyAzXSk7DQorCQkJYjQzX3NobV93cml0ZTE2KGRldiwgQjQzX1NI
TV9TSEFSRUQsDQorCQkJCQlCNDNfU0hNX1NIX1RJTUJQT1MsIGRlc3RfcG9zICsgNiAvKiBQTENQ
ICovKTsNCisJCQliNDNfc2htX3dyaXRlMTYoZGV2LCBCNDNfU0hNX1NIQVJFRCwNCisJCQkJCUI0
M19TSE1fU0hfRFRJTVBFUiwgc3JjX2RhdGFbc3JjX3BvcyArIDNdKTsNCiAJCX0NCiAJfQ0KIAkq
ZGVzdF9zaXplID0gZGVzdF9wb3M7DQpAQCAtMTM3MSwxMiArMTM3OSwxMiBAQCBzdGF0aWMgdm9p
ZCBoYW5kbGVfaXJxX2JlYWNvbihzdHJ1Y3QgYjQzDQogCQlyZXR1cm47DQogCX0NCiAJaWYgKCEo
c3RhdHVzICYgMHgxKSkgew0KLQkJYjQzX3dyaXRlX2JlYWNvbl90ZW1wbGF0ZShkZXYsIDB4Njgs
IDB4MTgsIEI0M19DQ0tfUkFURV8xTUIpOw0KKy8vCQliNDNfd3JpdGVfYmVhY29uX3RlbXBsYXRl
KGRldiwgMHg2OCwgMHgxOCwgQjQzX0NDS19SQVRFXzFNQik7DQogCQlzdGF0dXMgfD0gMHgxOw0K
IAkJYjQzX3dyaXRlMzIoZGV2LCBCNDNfTU1JT19TVEFUVVMyX0JJVEZJRUxELCBzdGF0dXMpOw0K
IAl9DQogCWlmICghKHN0YXR1cyAmIDB4MikpIHsNCi0JCWI0M193cml0ZV9iZWFjb25fdGVtcGxh
dGUoZGV2LCAweDQ2OCwgMHgxQSwgQjQzX0NDS19SQVRFXzFNQik7DQorLy8JCWI0M193cml0ZV9i
ZWFjb25fdGVtcGxhdGUoZGV2LCAweDQ2OCwgMHgxQSwgQjQzX0NDS19SQVRFXzFNQik7DQogCQlz
dGF0dXMgfD0gMHgyOw0KIAkJYjQzX3dyaXRlMzIoZGV2LCBCNDNfTU1JT19TVEFUVVMyX0JJVEZJ
RUxELCBzdGF0dXMpOw0KIAl9DQo=


--=-ssAhLEXRfOiiQPBjgoVA
Content-Disposition: attachment; filename=057-b43-mcast.patch
Content-Type: text/x-vhdl; name=057-b43-mcast.patch; charset=utf-8
Content-Transfer-Encoding: base64

LS0tDQogZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL2RtYS5jICB8ICAgMTkgKysrKysrKysrKysr
KysrKy0tLQ0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My94bWl0LmMgfCAgIDEwICsrKysrKysr
KysNCiAyIGZpbGVzIGNoYW5nZWQsIDI2IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQoN
Ci0tLSB3aXJlbGVzcy1kZXYub3JpZy9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvZG1hLmMJMjAw
Ny0wOC0yOSAwMjoyMjoyOS4wODQ2MTg2OTUgKzAyMDANCisrKyB3aXJlbGVzcy1kZXYvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYjQzL2RtYS5jCTIwMDctMDgtMjkgMDI6NDU6MzguNTc0NjE4Njk1ICsw
MjAwDQpAQCAtMTAzOCw2ICsxMDM4LDggQEAgc3RhdGljIHUxNiBnZW5lcmF0ZV9jb29raWUoc3Ry
dWN0IGI0M19kbQ0KIAkgKiBpbiB0aGUgbG93ZXIgMTIgYml0cy4NCiAJICogTm90ZSB0aGF0IHRo
ZSBjb29raWUgbXVzdCBuZXZlciBiZSAwLCBhcyB0aGlzDQogCSAqIGlzIGEgc3BlY2lhbCB2YWx1
ZSB1c2VkIGluIFJYIHBhdGguDQorCSAqIEl0IGNhbiBhbHNvIG5vdCBiZSAweEZGRkYgYmVjYXVz
ZSB0aGF0IGlzIHNwZWNpYWwNCisJICogZm9yIG11bHRpY2FzdCBmcmFtZXMuDQogCSAqLw0KIAlz
d2l0Y2ggKHJpbmctPmluZGV4KSB7DQogCWNhc2UgMDoNCkBAIC0xMDU2LDcgKzEwNTgsNyBAQCBz
dGF0aWMgdTE2IGdlbmVyYXRlX2Nvb2tpZShzdHJ1Y3QgYjQzX2RtDQogCQljb29raWUgPSAweEUw
MDA7DQogCQlicmVhazsNCiAJY2FzZSA1Og0KLQkJY29va2llID0gMHhGMDAwOw0KKwkJY29va2ll
ID0gMHg5MDAwOw0KIAkJYnJlYWs7DQogCX0NCiAJQjQzX1dBUk5fT04oc2xvdCAmIH4weDBGRkYp
Ow0KQEAgLTEwODgsNyArMTA5MCw3IEBAIHN0cnVjdCBiNDNfZG1hcmluZyAqcGFyc2VfY29va2ll
KHN0cnVjdCANCiAJY2FzZSAweEUwMDA6DQogCQlyaW5nID0gZG1hLT50eF9yaW5nNDsNCiAJCWJy
ZWFrOw0KLQljYXNlIDB4RjAwMDoNCisJY2FzZSAweDkwMDA6DQogCQlyaW5nID0gZG1hLT50eF9y
aW5nNTsNCiAJCWJyZWFrOw0KIAlkZWZhdWx0Og0KQEAgLTEyMDUsNyArMTIwNywxOCBAQCBpbnQg
YjQzX2RtYV90eChzdHJ1Y3QgYjQzX3dsZGV2ICpkZXYsDQogCWludCBlcnIgPSAwOw0KIAl1bnNp
Z25lZCBsb25nIGZsYWdzOw0KIA0KLQlyaW5nID0gcHJpb3JpdHlfdG9fdHhyaW5nKGRldiwgY3Rs
LT5xdWV1ZSk7DQorCWlmIChza2ItPmxlbiA8IDUpIHsNCisJCXByaW50ayhLRVJOX0VSUiAicmVh
bGx5IHNob3J0IGZyYW1lXG4iKTsNCisJCXJldHVybiAtRUlPOw0KKwl9DQorDQorCWlmIChza2It
PmRhdGFbNF0gJiAxKSB7DQorCQlyaW5nID0gZGV2LT5kbWEudHhfcmluZzQ7DQorCQkvKiBzZXQg
bW9yZSBkYXRhIGJpdCwgdWNvZGUgd2lsbCBjbGVhciBvbiB0aGUgbGFzdCBmcmFtZSAqLw0KKwkJ
c2tiLT5kYXRhWzFdIHw9IDB4MjA7DQorCX0gZWxzZSB7DQorCQlyaW5nID0gcHJpb3JpdHlfdG9f
dHhyaW5nKGRldiwgY3RsLT5xdWV1ZSk7DQorCX0NCiAJc3Bpbl9sb2NrX2lycXNhdmUoJnJpbmct
PmxvY2ssIGZsYWdzKTsNCiAJQjQzX1dBUk5fT04oIXJpbmctPnR4KTsNCiAJaWYgKHVubGlrZWx5
KGZyZWVfc2xvdHMocmluZykgPCBTTE9UU19QRVJfUEFDS0VUKSkgew0KLS0tIHdpcmVsZXNzLWRl
di5vcmlnL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My94bWl0LmMJMjAwNy0wOC0yOSAwMjozOTo1
My44ODQ2MTg2OTUgKzAyMDANCisrKyB3aXJlbGVzcy1kZXYvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
YjQzL3htaXQuYwkyMDA3LTA4LTI5IDAyOjQ3OjM0LjMwNDYxODY5NSArMDIwMA0KQEAgLTE5NSw2
ICsxOTUsMTYgQEAgc3RhdGljIHZvaWQgZ2VuZXJhdGVfdHhoZHJfZnc0KHN0cnVjdCBiNA0KIAl1
MTYgcGh5X2N0bCA9IDA7DQogCXU4IGV4dHJhX2Z0ID0gMDsNCiANCisJLyoNCisJICogZ2l2ZSBt
aWNyb2NvZGUgdGhlIGNvb2tpZSBvZiB0aGUgbGFzdCBmcmFtZSBpbiB0aGUgbXVsdGljYXN0DQor
CSAqIHF1ZXVlIHNvIGl0IGNhbiBjbGVhciB0aGUgbW9yZS1kYXRhIGJpdCBpbiBpdA0KKwkgKi8N
CisJLyogRklYTUU6IHNob3VsZCByZWFsbHkgY2hlY2sgdGhlIHF1ZXVlIG9yIHNvbWV0aGluZyAq
Lw0KKwlpZiAoKGNvb2tpZSAmIDB4RjAwMCkgPT0gMHg5MDAwKSB7DQorCQkvKiBGSVhNRTogbG9j
a2luZyAqLw0KKwkJYjQzX3NobV93cml0ZTE2KGRldiwgQjQzX1NITV9TSEFSRUQsIDB4NTQqMiwg
Y29va2llKTsNCisJfQ0KKw0KIAltZW1zZXQodHhoZHIsIDAsIHNpemVvZigqdHhoZHIpKTsNCiAN
CiAJcmF0ZSA9IHR4Y3RsLT50eF9yYXRlOw0K


--=-ssAhLEXRfOiiQPBjgoVA--

--=-EXpAYGnRaZalYDfNc3qx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1MS1/ETPhpq3jKURAgsiAKCf0kmtE9Rq0U220Os8s9+HDFGmWwCfdYoE
wRFqju1eatHR1MDj21W+zlA=
=6VPP
-----END PGP SIGNATURE-----

--=-EXpAYGnRaZalYDfNc3qx--

