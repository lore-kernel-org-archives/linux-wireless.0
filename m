Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:40535 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757958Ab3DYWuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Apr 2013 18:50:12 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Thu, 25 Apr 2013 15:50:05 -0700
Subject: RE: Memory leak in mwifiex_cfg80211_scan
Message-ID: <477F20668A386D41ADCC57781B1F70430D9E14FF4C@SC-VEXCH1.marvell.com> (sfid-20130426_005017_177750_85E897FE)
References: <CAMLZHHSVd6GpmqTQyJmbsheH1utZh8mNW8d4zLtjwoONaGwbNA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E0579DB@SC-VEXCH1.marvell.com>
	<CAMLZHHQ=BNuD0UmcV8pv=6phW=W-C5C7Af6n8tLWTrzyuzPQow@mail.gmail.com>
 <CAMLZHHQXY3OuWKr_K1B9-NmZFwCcQFPNTBoOkpvT9kxWJ=ixqQ@mail.gmail.com>
In-Reply-To: <CAMLZHHQXY3OuWKr_K1B9-NmZFwCcQFPNTBoOkpvT9kxWJ=ixqQ@mail.gmail.com>
Content-Type: multipart/mixed;
	boundary="_002_477F20668A386D41ADCC57781B1F70430D9E14FF4CSCVEXCH1marve_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_477F20668A386D41ADCC57781B1F70430D9E14FF4CSCVEXCH1marve_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

> While I don't have an explanation for why kmemleak didn't detect this
> before, I have confirmed with some simple printks that mwifiex does
> not call free_netdev on the netdev that it allocates, at least when
> using the test script posted earlier in this thread. So that is
> another leak that must be fixed.

Yes it is. Attached is a patch from Amitkumar Karwar to fix it.

> > Trying to look for possible causes (memory corruption?), I can't see
> > any code that serializes scan_delay_timer_fn with mwifiex_close(), so
> > mwifiex_close freeing the scan data while scan_delay_timer_fn is using
> > it could cause badness to happen. However I haven't yet figured out
> > how to trigger scan_delay_timer_fn to execute even once (any tips?).
>=20
> I still haven't figured out how to make this code trigger, but I
> looked again, and I do believe there is a potential crash waiting for
> us here, because there is no serialization between mwifiex_close and
> the possible running of this timer (which uses user_scan_cfg).

One scan request from cfg80211 is split to multiple scan commands being sen=
t from driver to firmware.
If scan_request is cleared (e.g. mwifiex_close) during a scan command proce=
ssing, all pending scan commands will be aborted after getting response of =
previous scan command, and scan_delay_timer is modified to fire in 50ms.

With original script (mwifiex_sdio is removed), I don't see scan_delay_time=
r_fn() gets triggered either. My assumption is that the scan_pending_q has =
already been emptied, so we don't run into the same path as above.

>=20
> Also, I found another issue. Change the script to:
>=20
> insmod mwifiex_sdio.ko
> sleep 1
> ifconfig eth0 up
> iwlist eth0 scan &
> sleep 0.1
> ifconfig eth0 down

With this new script (eth0 is down), I can easily see scan_delay_timer_fn()=
 gets called.
The scan_pending_q is not emptied in this case.

>=20
> and add printk's in mwifiex_close (where user_scan_cfg is freed) and
> in mwifiex_cfg80211_scan() (where user_cfg_cfg is used and also
> freed). You can see that mwifiex_cfg80211_scan() executes at the same
> time as mwifiex_close() (and several times after) and I can't see any
> serialization here, so I think there are some other crashes here as
> well (e.g. looks like it could race and we could double-free
> user_scan_cfg).

Sorry, it's my bad. I realized that my patch to cleanup user_scan_cfg in mw=
ifiex_close() is wrong and it will cause this problem.

Please wait for another patch that fixes the memory leak in mwifiex_cfg8021=
1_scan.

Thanks,
Bing

>=20
> Thanks
> Daniel

--_002_477F20668A386D41ADCC57781B1F70430D9E14FF4CSCVEXCH1marve_
Content-Type: application/octet-stream;
	name="0001-mwifiex-fix-memory-leak-issue-when-driver-unload.patch"
Content-Description: 0001-mwifiex-fix-memory-leak-issue-when-driver-unload.patch
Content-Disposition: attachment;
	filename="0001-mwifiex-fix-memory-leak-issue-when-driver-unload.patch";
	size=1784; creation-date="Thu, 25 Apr 2013 21:49:51 GMT";
	modification-date="Thu, 25 Apr 2013 21:49:51 GMT"
Content-Transfer-Encoding: base64

RnJvbSA3MzQwZTc1M2FiMDRhNGVjYTM3ZGUwMGY2ZTE1MjdiNDZjNjAwZWJjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWl0a3VtYXIgS2Fyd2FyIDxha2Fyd2FyQG1hcnZlbGwuY29t
PgpEYXRlOiBGcmksIDI2IEFwciAyMDEzIDIwOjA1OjAzICswNTMwClN1YmplY3Q6IFtQQVRDSF0g
bXdpZmlleDogZml4IG1lbW9yeSBsZWFrIGlzc3VlIHdoZW4gZHJpdmVyIHVubG9hZAoKQWZ0ZXIg
dW5yZWdpc3Rlcl9uZXRkZXZpY2UoKSBjYWxsIHRoZSByZXF1ZXN0IGlzIHF1ZXVlZCBhbmQKcmVn
X3N0YXRlIGlzIGNoYW5nZWQgdG8gTkVUUkVHX1VOUkVHSVNURVJJTkcuCkFzIHdlIGNoZWNrIGZv
ciBORVRSRUdfVU5SRUdJU1RFUkVEIHN0YXRlLCBmcmVlX25ldGRldigpIG5ldmVyCmdldHMgZXhl
Y3V0ZWQgY2F1c2luZyBtZW1vcnkgbGVhay4KCkluaXRpYWxpemUgImRldi0+ZGVzdHJ1Y3RvciIg
dG8gZnJlZV9uZXRkZXYoKSB0byBmcmVlIGRldmljZQpkYXRhIGFmdGVyIHVucmVnaXN0cmF0aW9u
LgoKU2lnbmVkLW9mZi1ieTogQW1pdGt1bWFyIEthcndhciA8YWthcndhckBtYXJ2ZWxsLmNvbT4K
LS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L2NmZzgwMjExLmMgfCAgICAzIC0tLQog
ZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9tYWluLmMgICAgIHwgICAgMSArCiAyIGZpbGVz
IGNoYW5nZWQsIDEgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L2NmZzgwMjExLmMgYi9kcml2ZXJzL25ldC93aXJl
bGVzcy9td2lmaWV4L2NmZzgwMjExLmMKaW5kZXggYTBjYjA3Ny4uNjM2MTQ1ZCAxMDA2NDQKLS0t
IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9jZmc4MDIxMS5jCisrKyBiL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL213aWZpZXgvY2ZnODAyMTEuYwpAQCAtMjIzNCw5ICsyMjM0LDYgQEAgaW50
IG13aWZpZXhfZGVsX3ZpcnR1YWxfaW50ZihzdHJ1Y3Qgd2lwaHkgKndpcGh5LCBzdHJ1Y3Qgd2ly
ZWxlc3NfZGV2ICp3ZGV2KQogCWlmICh3ZGV2LT5uZXRkZXYtPnJlZ19zdGF0ZSA9PSBORVRSRUdf
UkVHSVNURVJFRCkKIAkJdW5yZWdpc3Rlcl9uZXRkZXZpY2Uod2Rldi0+bmV0ZGV2KTsKIAotCWlm
ICh3ZGV2LT5uZXRkZXYtPnJlZ19zdGF0ZSA9PSBORVRSRUdfVU5SRUdJU1RFUkVEKQotCQlmcmVl
X25ldGRldih3ZGV2LT5uZXRkZXYpOwotCiAJLyogQ2xlYXIgdGhlIHByaXYgaW4gYWRhcHRlciAq
LwogCXByaXYtPm5ldGRldiA9IE5VTEw7CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL213aWZpZXgvbWFpbi5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9tYWluLmMK
aW5kZXggZGRiZjg1Yy4uZTRlNGJiOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
bXdpZmlleC9tYWluLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9tYWluLmMK
QEAgLTY1NSw2ICs2NTUsNyBAQCB2b2lkIG13aWZpZXhfaW5pdF9wcml2X3BhcmFtcyhzdHJ1Y3Qg
bXdpZmlleF9wcml2YXRlICpwcml2LAogCQkJCQkJc3RydWN0IG5ldF9kZXZpY2UgKmRldikKIHsK
IAlkZXYtPm5ldGRldl9vcHMgPSAmbXdpZmlleF9uZXRkZXZfb3BzOworCWRldi0+ZGVzdHJ1Y3Rv
ciA9IGZyZWVfbmV0ZGV2OwogCS8qIEluaXRpYWxpemUgcHJpdmF0ZSBzdHJ1Y3R1cmUgKi8KIAlw
cml2LT5jdXJyZW50X2tleV9pbmRleCA9IDA7CiAJcHJpdi0+bWVkaWFfY29ubmVjdGVkID0gZmFs
c2U7Ci0tIAoxLjcuMy40Cgo=

--_002_477F20668A386D41ADCC57781B1F70430D9E14FF4CSCVEXCH1marve_--
