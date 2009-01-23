Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:35395 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760876AbZAWBUl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 20:20:41 -0500
Received: by ewy13 with SMTP id 13so3205357ewy.13
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 17:20:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d7a260e8d188b785d0d2be743c8c5461@localhost>
References: <87priffb95.fsf@litku.valot.fi>
	 <20090122183448.GC3646@tuxdriver.com>
	 <d7a260e8d188b785d0d2be743c8c5461@localhost>
Date: Fri, 23 Jan 2009 02:20:38 +0100
Message-ID: <2d0a357f0901221720w65e5bf44w96bc94303bc2ac82@mail.gmail.com> (sfid-20090123_022053_224634_97056563)
Subject: Re: iwl3945 regression: associates but no data is transfered
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: samuel@sortiz.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015174bdfd859ae4504611c3214
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0015174bdfd859ae4504611c3214
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Thanks Samuel, this works.

-SD

----- BEGIN series -----

# 00xx-series: All patches against wireless-testing (master-2009-01-21)
0000-patches-against-wl-v2.6.29-rc2-11925-g88e5942
#
# 01xx-series: Patches from <kernel.org>
0100-patch-2.6.29-rc2-git1
#
# 02xx-series: Patches from wl-mailing-list
0200-Revert-mac80211-Fixed-BSSID-handling-revisited.patch

----- END series -----

On Fri, Jan 23, 2009 at 12:41 AM,  <samuel@sortiz.org> wrote:
>
> On Thu, 22 Jan 2009 13:34:48 -0500, "John W. Linville"
> <linville@tuxdriver.com> wrote:
>> On Thu, Jan 22, 2009 at 08:26:14PM +0200, Kalle Valo wrote:
>>> Hello,
>>>
>>> I upgraded to the latest wireless-testing and my iwl3945 is now
>>> broken. It can associate but no data is transfered after that. Tried
>>> with open and wep modes. With dhcp I cannot get ip and with static ip
>>> ping to the gateway doesn't work.
>>>
>>> Any hints?
>>
>> Lots of iwlwifi stuff merged yesterday...
> The bad commit seems to be e32b1b9a33759e8a83ac566c4c43f23ed5d6343b, which
> is not iwlwifi related.
> Even though it's an mlme commit, it doesnt seem to affect other drivers (at
> least b43 and ath5k).
> I'll come up soon with a proper fix, but for now iwl3945 users should
> revert that commit locally.
>
> Cheers,
> Samuel.
>
>>
>> Chatre, Reinette (1):
>>       iwl3945: add debugging for wrong command queue
>>
>> Helmut Schaa (2):
>>       iwl3945: fix some warnings when compiled without debug
>>       iwlagn: fix hw-rfkill while the interface is down
>>
>> Jay Sternberg (4):
>>       iwlwifi: correct Kconfig to prevent following entries from not
>>       indenting
>>       iwlwifi: remove static from 5000 structures
>>       iwlwifi: add recognition of Intel WiFi Link 6000 and 6050 Series
>>       iwlwifi: add recognition of Intel WiFi Link 100 Series
>>
>> Reinette Chatre (1):
>>       iwlwifi: return NETDEV_TX_OK from _tx ops
>>
>> Samuel Ortiz (3):
>>       iwl3945: Use iwl_txq_update_write_ptr
>>       iwlwifi: Add TFD library operations
>>       iwl3945: Use iwl-hcmd host command routines
>>
>> Winkler, Tomas (6):
>>       iwlwifi: make iwl-power.c more readable
>>       iwlwifi: fix iwl_mac_set_key and iwl3945_mac_set_key
>>       iwlwifi: kill iwl3945_scan_cancel and iwl3945_scan_cancel_timeout
>>       iwlwifi: kill scan39
>>       iwlwifi: remove unused or twice defined members in iwl_priv
>>       iwlwifi: eliminate power_data_39.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--0015174bdfd859ae4504611c3214
Content-Type: text/x-diff; charset=US-ASCII;
	name="0200-Revert-mac80211-Fixed-BSSID-handling-revisited.patch"
Content-Disposition: attachment;
	filename="0200-Revert-mac80211-Fixed-BSSID-handling-revisited.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fqa611l40

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9tbG1lLmMgYi9uZXQvbWFjODAyMTEvbWxtZS5jCmlu
ZGV4IGNhOWU0MTUuLmI5ZTRiOTMgMTAwNjQ0Ci0tLSBhL25ldC9tYWM4MDIxMS9tbG1lLmMKKysr
IGIvbmV0L21hYzgwMjExL21sbWUuYwpAQCAtMTYxNCw3ICsxNjE0LDYgQEAgc3RhdGljIGludCBp
ZWVlODAyMTFfc3RhX2pvaW5faWJzcyhzdHJ1Y3QgaWVlZTgwMjExX3N1Yl9pZl9kYXRhICpzZGF0
YSwKIAogCWllZWU4MDIxMV9zdGFfZGVmX3dtbV9wYXJhbXMoc2RhdGEsIGJzcyk7CiAKLQlpZnN0
YS0+ZmxhZ3MgfD0gSUVFRTgwMjExX1NUQV9QUkVWX0JTU0lEX1NFVDsKIAlpZnN0YS0+c3RhdGUg
PSBJRUVFODAyMTFfU1RBX01MTUVfSUJTU19KT0lORUQ7CiAJbW9kX3RpbWVyKCZpZnN0YS0+dGlt
ZXIsIGppZmZpZXMgKyBJRUVFODAyMTFfSUJTU19NRVJHRV9JTlRFUlZBTCk7CiAKQEAgLTE3NTgs
OCArMTc1Nyw3IEBAIHN0YXRpYyB2b2lkIGllZWU4MDIxMV9yeF9ic3NfaW5mbyhzdHJ1Y3QgaWVl
ZTgwMjExX3N1Yl9pZl9kYXRhICpzZGF0YSwKIAkJICAgICAgICh1bnNpZ25lZCBsb25nIGxvbmcp
KHJ4X3RpbWVzdGFtcCAtIGJlYWNvbl90aW1lc3RhbXApLAogCQkgICAgICAgamlmZmllcyk7CiAj
ZW5kaWYgLyogQ09ORklHX01BQzgwMjExX0lCU1NfREVCVUcgKi8KLQkJaWYgKGJlYWNvbl90aW1l
c3RhbXAgPiByeF90aW1lc3RhbXAgJiYKLQkJICAgIG1lbWNtcChzZGF0YS0+dS5zdGEuYnNzaWQs
IG1nbXQtPmJzc2lkLCBFVEhfQUxFTikgIT0gMCkgeworCQlpZiAoYmVhY29uX3RpbWVzdGFtcCA+
IHJ4X3RpbWVzdGFtcCkgewogI2lmZGVmIENPTkZJR19NQUM4MDIxMV9JQlNTX0RFQlVHCiAJCQlw
cmludGsoS0VSTl9ERUJVRyAiJXM6IGJlYWNvbiBUU0YgaGlnaGVyIHRoYW4gIgogCQkJICAgICAg
ICJsb2NhbCBUU0YgLSBJQlNTIG1lcmdlIHdpdGggQlNTSUQgJXBNXG4iLApAQCAtMjE3OSwxOCAr
MjE3NywxOSBAQCBzdGF0aWMgaW50IGllZWU4MDIxMV9zdGFfY3JlYXRlX2lic3Moc3RydWN0IGll
ZWU4MDIxMV9zdWJfaWZfZGF0YSAqc2RhdGEsCiAJaW50IGk7CiAJaW50IHJldDsKIAotCWlmIChz
ZGF0YS0+dS5zdGEuZmxhZ3MgJiBJRUVFODAyMTFfU1RBX0JTU0lEX1NFVCkgewotCQltZW1jcHko
YnNzaWQsIGlmc3RhLT5ic3NpZCwgRVRIX0FMRU4pOwotCX0gZWxzZSB7Ci0JCS8qIEdlbmVyYXRl
IHJhbmRvbSwgbm90IGJyb2FkY2FzdCwgbG9jYWxseSBhZG1pbmlzdGVyZWQgQlNTSUQuIE1peCBp
bgotCQkgKiBvd24gTUFDIGFkZHJlc3MgdG8gbWFrZSBzdXJlIHRoYXQgZGV2aWNlcyB0aGF0IGRv
IG5vdCBoYXZlIHByb3BlcgotCQkgKiByYW5kb20gbnVtYmVyIGdlbmVyYXRvciBnZXQgZGlmZmVy
ZW50IEJTU0lELiAqLwotCQlnZXRfcmFuZG9tX2J5dGVzKGJzc2lkLCBFVEhfQUxFTik7Ci0JCWZv
ciAoaSA9IDA7IGkgPCBFVEhfQUxFTjsgaSsrKQotCQkJYnNzaWRbaV0gXj0gc2RhdGEtPmRldi0+
ZGV2X2FkZHJbaV07Ci0JCWJzc2lkWzBdICY9IH4weDAxOwotCQlic3NpZFswXSB8PSAweDAyOwot
CX0KKyNpZiAwCisJLyogRWFzaWVyIHRlc3RpbmcsIHVzZSBmaXhlZCBCU1NJRC4gKi8KKwltZW1z
ZXQoYnNzaWQsIDB4ZmUsIEVUSF9BTEVOKTsKKyNlbHNlCisJLyogR2VuZXJhdGUgcmFuZG9tLCBu
b3QgYnJvYWRjYXN0LCBsb2NhbGx5IGFkbWluaXN0ZXJlZCBCU1NJRC4gTWl4IGluCisJICogb3du
IE1BQyBhZGRyZXNzIHRvIG1ha2Ugc3VyZSB0aGF0IGRldmljZXMgdGhhdCBkbyBub3QgaGF2ZSBw
cm9wZXIKKwkgKiByYW5kb20gbnVtYmVyIGdlbmVyYXRvciBnZXQgZGlmZmVyZW50IEJTU0lELiAq
LworCWdldF9yYW5kb21fYnl0ZXMoYnNzaWQsIEVUSF9BTEVOKTsKKwlmb3IgKGkgPSAwOyBpIDwg
RVRIX0FMRU47IGkrKykKKwkJYnNzaWRbaV0gXj0gc2RhdGEtPmRldi0+ZGV2X2FkZHJbaV07CisJ
YnNzaWRbMF0gJj0gfjB4MDE7CisJYnNzaWRbMF0gfD0gMHgwMjsKKyNlbmRpZgogCiAJcHJpbnRr
KEtFUk5fREVCVUcgIiVzOiBDcmVhdGluZyBuZXcgSUJTUyBuZXR3b3JrLCBCU1NJRCAlcE1cbiIs
CiAJICAgICAgIHNkYXRhLT5kZXYtPm5hbWUsIGJzc2lkKTsKQEAgLTIyNTEsOSArMjI1MCw2IEBA
IHN0YXRpYyBpbnQgaWVlZTgwMjExX3N0YV9maW5kX2lic3Moc3RydWN0IGllZWU4MDIxMV9zdWJf
aWZfZGF0YSAqc2RhdGEsCiAJCSAgICBtZW1jbXAoaWZzdGEtPnNzaWQsIGJzcy0+c3NpZCwgYnNz
LT5zc2lkX2xlbikgIT0gMAogCQkgICAgfHwgIShic3MtPmNhcGFiaWxpdHkgJiBXTEFOX0NBUEFC
SUxJVFlfSUJTUykpCiAJCQljb250aW51ZTsKLQkJaWYgKChpZnN0YS0+ZmxhZ3MgJiBJRUVFODAy
MTFfU1RBX0JTU0lEX1NFVCkgJiYKLQkJICAgIG1lbWNtcChpZnN0YS0+YnNzaWQsIGJzcy0+YnNz
aWQsIEVUSF9BTEVOKSAhPSAwKQotCQkJY29udGludWU7CiAjaWZkZWYgQ09ORklHX01BQzgwMjEx
X0lCU1NfREVCVUcKIAkJcHJpbnRrKEtFUk5fREVCVUcgIiAgIGJzc2lkPSVwTSBmb3VuZFxuIiwg
YnNzLT5ic3NpZCk7CiAjZW5kaWYgLyogQ09ORklHX01BQzgwMjExX0lCU1NfREVCVUcgKi8KQEAg
LTIyNzAsOSArMjI2Niw3IEBAIHN0YXRpYyBpbnQgaWVlZTgwMjExX3N0YV9maW5kX2lic3Moc3Ry
dWN0IGllZWU4MDIxMV9zdWJfaWZfZGF0YSAqc2RhdGEsCiAJCSAgICAgICAiJXBNXG4iLCBic3Np
ZCwgaWZzdGEtPmJzc2lkKTsKICNlbmRpZiAvKiBDT05GSUdfTUFDODAyMTFfSUJTU19ERUJVRyAq
LwogCi0JaWYgKGZvdW5kICYmCi0JICAgICgoIShpZnN0YS0+ZmxhZ3MgJiBJRUVFODAyMTFfU1RB
X1BSRVZfQlNTSURfU0VUKSkgfHwKLQkgICAgIG1lbWNtcChpZnN0YS0+YnNzaWQsIGJzc2lkLCBF
VEhfQUxFTikgIT0gMCkpIHsKKwlpZiAoZm91bmQgJiYgbWVtY21wKGlmc3RhLT5ic3NpZCwgYnNz
aWQsIEVUSF9BTEVOKSAhPSAwKSB7CiAJCWludCByZXQ7CiAJCWludCBzZWFyY2hfZnJlcTsKIApA
QCAtMjYxMCwxNiArMjYwNCwxNiBAQCBpbnQgaWVlZTgwMjExX3N0YV9zZXRfc3NpZChzdHJ1Y3Qg
aWVlZTgwMjExX3N1Yl9pZl9kYXRhICpzZGF0YSwgY2hhciAqc3NpZCwgc2l6ZQogCQltZW1zZXQo
aWZzdGEtPnNzaWQsIDAsIHNpemVvZihpZnN0YS0+c3NpZCkpOwogCQltZW1jcHkoaWZzdGEtPnNz
aWQsIHNzaWQsIGxlbik7CiAJCWlmc3RhLT5zc2lkX2xlbiA9IGxlbjsKKwkJaWZzdGEtPmZsYWdz
ICY9IH5JRUVFODAyMTFfU1RBX1BSRVZfQlNTSURfU0VUOwogCX0KIAotCWlmc3RhLT5mbGFncyAm
PSB+SUVFRTgwMjExX1NUQV9QUkVWX0JTU0lEX1NFVDsKLQogCWlmIChsZW4pCiAJCWlmc3RhLT5m
bGFncyB8PSBJRUVFODAyMTFfU1RBX1NTSURfU0VUOwogCWVsc2UKIAkJaWZzdGEtPmZsYWdzICY9
IH5JRUVFODAyMTFfU1RBX1NTSURfU0VUOwogCi0JaWYgKHNkYXRhLT52aWYudHlwZSA9PSBOTDgw
MjExX0lGVFlQRV9BREhPQykgeworCWlmIChzZGF0YS0+dmlmLnR5cGUgPT0gTkw4MDIxMV9JRlRZ
UEVfQURIT0MgJiYKKwkgICAgIShpZnN0YS0+ZmxhZ3MgJiBJRUVFODAyMTFfU1RBX0JTU0lEX1NF
VCkpIHsKIAkJaWZzdGEtPmlic3Nfam9pbl9yZXEgPSBqaWZmaWVzOwogCQlpZnN0YS0+c3RhdGUg
PSBJRUVFODAyMTFfU1RBX01MTUVfSUJTU19TRUFSQ0g7CiAJCXJldHVybiBpZWVlODAyMTFfc3Rh
X2ZpbmRfaWJzcyhzZGF0YSwgaWZzdGEpOwpAQCAtMjYzOSwxOCArMjYzMywzNiBAQCBpbnQgaWVl
ZTgwMjExX3N0YV9nZXRfc3NpZChzdHJ1Y3QgaWVlZTgwMjExX3N1Yl9pZl9kYXRhICpzZGF0YSwg
Y2hhciAqc3NpZCwgc2l6ZQogaW50IGllZWU4MDIxMV9zdGFfc2V0X2Jzc2lkKHN0cnVjdCBpZWVl
ODAyMTFfc3ViX2lmX2RhdGEgKnNkYXRhLCB1OCAqYnNzaWQpCiB7CiAJc3RydWN0IGllZWU4MDIx
MV9pZl9zdGEgKmlmc3RhOworCWludCByZXM7CisJYm9vbCB2YWxpZDsKIAogCWlmc3RhID0gJnNk
YXRhLT51LnN0YTsKKwl2YWxpZCA9IGlzX3ZhbGlkX2V0aGVyX2FkZHIoYnNzaWQpOworCisJaWYg
KG1lbWNtcChpZnN0YS0+YnNzaWQsIGJzc2lkLCBFVEhfQUxFTikgIT0gMCkgeworCQlpZih2YWxp
ZCkKKwkJCW1lbWNweShpZnN0YS0+YnNzaWQsIGJzc2lkLCBFVEhfQUxFTik7CisJCWVsc2UKKwkJ
CW1lbXNldChpZnN0YS0+YnNzaWQsIDAsIEVUSF9BTEVOKTsKKwkJcmVzID0gMDsKKwkJLyoKKwkJ
ICogSGFjayEgU2VlIGFsc28gaWVlZTgwMjExX3N0YV9zZXRfc3NpZC4KKwkJICovCisJCWlmIChu
ZXRpZl9ydW5uaW5nKHNkYXRhLT5kZXYpKQorCQkJcmVzID0gaWVlZTgwMjExX2lmX2NvbmZpZyhz
ZGF0YSwgSUVFRTgwMjExX0lGQ0NfQlNTSUQpOworCQlpZiAocmVzKSB7CisJCQlwcmludGsoS0VS
Tl9ERUJVRyAiJXM6IEZhaWxlZCB0byBjb25maWcgbmV3IEJTU0lEIHRvICIKKwkJCSAgICAgICAi
dGhlIGxvdy1sZXZlbCBkcml2ZXJcbiIsIHNkYXRhLT5kZXYtPm5hbWUpOworCQkJcmV0dXJuIHJl
czsKKwkJfQorCX0KIAotCWlmIChpc192YWxpZF9ldGhlcl9hZGRyKGJzc2lkKSkgewotCQltZW1j
cHkoaWZzdGEtPmJzc2lkLCBic3NpZCwgRVRIX0FMRU4pOworCWlmICh2YWxpZCkKIAkJaWZzdGEt
PmZsYWdzIHw9IElFRUU4MDIxMV9TVEFfQlNTSURfU0VUOwotCX0gZWxzZSB7Ci0JCW1lbXNldChp
ZnN0YS0+YnNzaWQsIDAsIEVUSF9BTEVOKTsKKwllbHNlCiAJCWlmc3RhLT5mbGFncyAmPSB+SUVF
RTgwMjExX1NUQV9CU1NJRF9TRVQ7Ci0JfQogCi0JcmV0dXJuIGllZWU4MDIxMV9zdGFfc2V0X3Nz
aWQoc2RhdGEsIGlmc3RhLT5zc2lkLCBpZnN0YS0+c3NpZF9sZW4pOworCXJldHVybiAwOwogfQog
CiBpbnQgaWVlZTgwMjExX3N0YV9zZXRfZXh0cmFfaWUoc3RydWN0IGllZWU4MDIxMV9zdWJfaWZf
ZGF0YSAqc2RhdGEsIGNoYXIgKmllLCBzaXplX3QgbGVuKQo=
--0015174bdfd859ae4504611c3214--
