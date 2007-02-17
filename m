Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965134AbXBQMEb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 07:04:31 -0500
Subject: Re: even more breakage in wireless-dev.git
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jiri Benc <jbenc@suse.cz>
In-Reply-To: <1171707838.3487.11.camel@johannes.berg>
References: <1171707838.3487.11.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-h+C3RppjpuFK4rYhXZXH"
Date: Sat, 17 Feb 2007 13:03:41 +0100
Message-Id: <1171713822.3655.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-h+C3RppjpuFK4rYhXZXH
Content-Type: multipart/mixed; boundary="=-1L3kOYkWdIJWUz0OOPhz"


--=-1L3kOYkWdIJWUz0OOPhz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-02-17 at 11:23 +0100, Johannes Berg wrote:
> Hah, I get to complain too.

and I also give some debugging info........

> [  441.994183] bcm43xx_d80211: Radio turned off
> [  442.310739] eth1: skb_queue not empty
> [  442.313338] Unable to handle kernel paging request for data at address=
 0x6b6b6b73

> [  442.315881] NIP [C0030ADC] tasklet_action+0x80/0xec

ok so I was guessing that we free a used tasklet, and I'm right.
Attached is a debug patch that gave me the following log instead of the
oops:

[  281.135208] bcm43xx_d80211: Radio turned off
[  281.371838] eth1: skb_queue not empty
[  281.372089] attempt to free scheduled tasklet c0506188 in object c050600=
0!
[  281.372107] will leak memory instead!
[  281.372122] Call Trace:
[  281.372138] [E8FF9CD0] [C0009024] show_stack+0x3c/0x194 (unreliable)
[  281.372199] [E8FF9D00] [C0030900] __tasklet_free_check+0x70/0x98
[  281.372244] [E8FF9D20] [C007F670] kfree+0x78/0x120
[  281.372288] [E8FF9D40] [F208A104] cfg80211_dev_free+0x24/0x38 [cfg80211]
[  281.372358] [E8FF9D60] [F208A580] wiphy_class_dev_release+0x14/0x24 [cfg=
80211]
[  281.372406] [E8FF9D70] [C01D04D8] class_dev_release+0x74/0x9c
[  281.372450] [E8FF9D90] [C016ED7C] kobject_cleanup+0x70/0xd4
[  281.372490] [E8FF9DB0] [C016FD30] kref_put+0x54/0x6c
[  281.372537] [E8FF9DC0] [C016ECFC] kobject_put+0x24/0x34
[  281.372573] [E8FF9DD0] [C01CF5EC] class_device_put+0x1c/0x2c
[  281.372613] [E8FF9DE0] [F208A0D0] wiphy_free+0x14/0x24 [cfg80211]
[  281.372655] [E8FF9DF0] [F224AACC] ieee80211_free_hw+0x24/0x38 [80211]
[  281.372744] [E8FF9E10] [F24836F8] bcm43xx_wireless_exit+0x24/0x38 [bcm43=
xx_d80211]
[  281.372813] [E8FF9E30] [F2081464] ssb_device_remove+0x34/0x54 [ssb]
[  281.372863] [E8FF9E40] [C01CEA08] __device_release_driver+0x88/0xc0
[  281.372910] [E8FF9E50] [C01CF180] driver_detach+0x110/0x140
[  281.372949] [E8FF9E70] [C01CE49C] bus_remove_driver+0x8c/0xc8
[  281.372987] [E8FF9E90] [C01CF208] driver_unregister+0x18/0x34
[  281.373025] [E8FF9EB0] [F2081CBC] ssb_driver_unregister+0x14/0x24 [ssb]
[  281.373078] [E8FF9EC0] [F249B7F4] bcm43xx_exit+0x18/0x35e4 [bcm43xx_d802=
11]
[  281.373126] [E8FF9ED0] [C004CC98] sys_delete_module+0x1ac/0x210
[  281.373173] [E8FF9F40] [C0011380] ret_from_syscall+0x0/0x38
[  281.373223] --- Exception: c01 at 0xff6ae18
[  281.373253]     LR =3D 0x10001214

As you can see (compile with debug info and get the struct sizes etc.),
the tasklet in question must be=20

	struct tasklet_struct tasklet;

in struct ieee80211_local. Now to figure out why it is scheduled while
we do ieee80211_free_hw, but I think that's good enough for me today.


johannes

--=-1L3kOYkWdIJWUz0OOPhz
Content-Disposition: attachment; filename=tasklet-free-debug.patch
Content-Type: text/x-vhdl; name=tasklet-free-debug.patch; charset=utf-8
Content-Transfer-Encoding: base64

LS0tDQoga2VybmVsL3NvZnRpcnEuYyB8ICAgMjMgKysrKysrKysrKysrKysrKysrKysrKysNCiBt
bS9zbGFiLmMgICAgICAgIHwgICAgNiArKysrKy0NCiAyIGZpbGVzIGNoYW5nZWQsIDI4IGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KLS0tIHdpcmVsZXNzLWRldi5vcmlnL2tlcm5lbC9z
b2Z0aXJxLmMJMjAwNy0wMi0xNyAxMTozNTo1Mi4zODE3Nzc0MjEgKzAxMDANCisrKyB3aXJlbGVz
cy1kZXYva2VybmVsL3NvZnRpcnEuYwkyMDA3LTAyLTE3IDExOjU5OjU0LjQzMTc3NzQyMSArMDEw
MA0KQEAgLTM1Myw2ICszNTMsMjkgQEAgdm9pZCBmYXN0Y2FsbCBfX3Rhc2tsZXRfc2NoZWR1bGUo
c3RydWN0IA0KIA0KIEVYUE9SVF9TWU1CT0woX190YXNrbGV0X3NjaGVkdWxlKTsNCiANCitpbnQg
ZmFzdGNhbGwgX190YXNrbGV0X2ZyZWVfY2hlY2soY2hhciAqZnJvbSwgdW5zaWduZWQgbG9uZyBs
ZW4pDQorew0KKwlzdHJ1Y3QgdGFza2xldF9zdHJ1Y3QgKnQ7DQorCXVuc2lnbmVkIGxvbmcgc3Rh
cnQgPSAodW5zaWduZWQgbG9uZykgZnJvbTsNCisJaW50IHJldCA9IDA7DQorDQorCS8qIHJlYWxs
eSBzaG91bGQgY2hlY2sgYWxsIENQVXMgYnV0IEkgb25seSBoYXZlIG9uZQ0KKwkgKiByaWdodCBu
b3cgc28gSSdtIGZpbmUuIGhhaCEgKi8NCisJdCA9IF9fZ2V0X2NwdV92YXIodGFza2xldF92ZWMp
Lmxpc3Q7DQorCXdoaWxlICh0KSB7DQorCQl1bnNpZ25lZCBsb25nIHR1bCA9ICh1bnNpZ25lZCBs
b25nKXQ7DQorCQlpZiAodHVsID49IHN0YXJ0ICYmIHR1bCA8IChzdGFydCtsZW4pKSB7DQorCQkJ
cHJpbnRrKEtFUk5fRVJSICJhdHRlbXB0IHRvIGZyZWUgc2NoZWR1bGVkIHRhc2tsZXQgJXAgaW4g
b2JqZWN0ICVwIVxuIiwgdCwgZnJvbSk7DQorCQkJcHJpbnRrKEtFUk5fRVJSICJ3aWxsIGxlYWsg
bWVtb3J5IGluc3RlYWQhXG4iKTsNCisJCQlkdW1wX3N0YWNrKCk7DQorCQkJcmV0ID0gLUVCVVNZ
Ow0KKwkJfQ0KKwkJdCA9IHQtPm5leHQ7DQorCX0NCisNCisJcmV0dXJuIHJldDsNCit9DQorDQog
dm9pZCBmYXN0Y2FsbCBfX3Rhc2tsZXRfaGlfc2NoZWR1bGUoc3RydWN0IHRhc2tsZXRfc3RydWN0
ICp0KQ0KIHsNCiAJdW5zaWduZWQgbG9uZyBmbGFnczsNCi0tLSB3aXJlbGVzcy1kZXYub3JpZy9t
bS9zbGFiLmMJMjAwNy0wMi0xNyAxMTozNjo1Ni4xODE3Nzc0MjEgKzAxMDANCisrKyB3aXJlbGVz
cy1kZXYvbW0vc2xhYi5jCTIwMDctMDItMTcgMTE6NDU6MTcuMTYxNzc3NDIxICswMTAwDQpAQCAt
Mzc0Nyw2ICszNzQ3LDkgQEAgRVhQT1JUX1NZTUJPTChrbWVtX2NhY2hlX2ZyZWUpOw0KICAqIERv
bid0IGZyZWUgbWVtb3J5IG5vdCBvcmlnaW5hbGx5IGFsbG9jYXRlZCBieSBrbWFsbG9jKCkNCiAg
KiBvciB5b3Ugd2lsbCBydW4gaW50byB0cm91YmxlLg0KICAqLw0KKw0KK2V4dGVybiBpbnQgZmFz
dGNhbGwgX190YXNrbGV0X2ZyZWVfY2hlY2soY2hhciAqZnJvbSwgdW5zaWduZWQgbG9uZyBsZW5n
dGgpOw0KKw0KIHZvaWQga2ZyZWUoY29uc3Qgdm9pZCAqb2JqcCkNCiB7DQogCXN0cnVjdCBrbWVt
X2NhY2hlICpjOw0KQEAgLTM3NTgsNyArMzc2MSw4IEBAIHZvaWQga2ZyZWUoY29uc3Qgdm9pZCAq
b2JqcCkNCiAJa2ZyZWVfZGVidWdjaGVjayhvYmpwKTsNCiAJYyA9IHZpcnRfdG9fY2FjaGUob2Jq
cCk7DQogCWRlYnVnX2NoZWNrX25vX2xvY2tzX2ZyZWVkKG9ianAsIG9ial9zaXplKGMpKTsNCi0J
X19jYWNoZV9mcmVlKGMsICh2b2lkICopb2JqcCk7DQorCWlmIChfX3Rhc2tsZXRfZnJlZV9jaGVj
ayhvYmpwLCBvYmpfc2l6ZShjKSkgPT0gMCkNCisJCV9fY2FjaGVfZnJlZShjLCAodm9pZCAqKW9i
anApOw0KIAlsb2NhbF9pcnFfcmVzdG9yZShmbGFncyk7DQogfQ0KIEVYUE9SVF9TWU1CT0woa2Zy
ZWUpOw0K


--=-1L3kOYkWdIJWUz0OOPhz--

--=-h+C3RppjpuFK4rYhXZXH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF1u8d/ETPhpq3jKURAnRUAKCqcOyCgmwSnmyQlZCOXNM6xU09qwCgqSiE
WZsWZ6QYD+iIa3H8M4VoFFw=
=6D34
-----END PGP SIGNATURE-----

--=-h+C3RppjpuFK4rYhXZXH--

