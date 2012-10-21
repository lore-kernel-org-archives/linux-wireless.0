Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59042 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab2JUJXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2012 05:23:14 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so938926wey.19
        for <linux-wireless@vger.kernel.org>; Sun, 21 Oct 2012 02:23:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHbMyCZQzj43W1zsFQ=P5PtVn9bAeVW=t7Srk5TuxHSqHua=jA@mail.gmail.com>
References: <CAHbMyCb7S1faT_GH8KBag0SVX+7uhC-4qLJOR-DhStpzSMNDqQ@mail.gmail.com>
	<1349099476.4315.12.camel@dcbw.foobar.com>
	<CAHbMyCZQzj43W1zsFQ=P5PtVn9bAeVW=t7Srk5TuxHSqHua=jA@mail.gmail.com>
Date: Sun, 21 Oct 2012 11:23:12 +0200
Message-ID: <CAHbMyCbW5ZbzTuYfqO6LhTKZc627pUVBPtGWoYoDPgUTojQEbQ@mail.gmail.com> (sfid-20121021_112320_696949_9C12DDD9)
Subject: Re: [Kernel Bug] 3.6, wpasupplicant 1.0, broadcom-sta 6.20.55.19
From: Jasmine Hassan <jasmine.aura@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend@broadcom.com>
Content-Type: multipart/mixed; boundary=f46d044280e63a760604cc8e49da
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--f46d044280e63a760604cc8e49da
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

forgot to re-attach the patch

On Sun, Oct 21, 2012 at 11:21 AM, Jasmine Hassan <jasmine.aura@gmail.com> w=
rote:
> (resent to list as plain text)
>
> Hi,
>
> @Dan, yes. Though it's mixed/propietary, it would be great if at least
> Broadcom would publish specifications for the PHY (LCN40 rev 3) to
> allow others who are interested (as Rafa=C5=82 Mi=C5=82ecki) to develop
> open-source drivers.
>
> Luckily this time, the issue was in the part of the driver where
> source is available.
>
> --
>
> Frank Vanderham, maintainer of the same driver (wireless-bcm43142) in
> the AUR, turned my attention to changes suggested by another user
> (andreyv) on broadcom-wl, also in the AUR.
> https://aur.archlinux.org/packages.php?ID=3D19514&comments=3Dall
>
> He noticed warnings while compiling the module against kernel 3.6.2:
> aur-broadcom-wl/src/src/wl/
> sys/wl_cfg80211.c:1647:2: warning: initialization from incompatible
> pointer type [enabled by default]
> aur-broadcom-wl/src/src/wl/sys/wl_cfg80211.c:1647:2: warning: (near
> initialization for 'wl_cfg80211_ops.scan') [enabled by default]
>
> And noted:
> ---
> In Linux's <net/cfg80211.h> we see
>
> int (*scan)(struct wiphy *wiphy,
> struct cfg80211_scan_request *request);
>
> but in the module we have
>
> static s32 wl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
> struct cfg80211_scan_request *request);
> ---
>
> Surely, doing a diff between 3.5.0 and 3.6.0
> headers/include/net/cfg80211.h, one notices that net_device was moved
> to wireless_dev, and subsequently the (second) parameter to
> cfg80211_scan was dropped.
>
> Looking at commits affecting drivers/net/wireless/brcm80211/brcmfmac/
> from March onwards, one finds:
> ---
> commit fd0142844efa85d89017c89227a0f03de1eee327
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Mon Jun 18 19:17:03 2012 +0200
>
>     nl80211: move scan API to wdev
>
>     The new P2P Device will have to be able to scan for
>     P2P search, so move scanning to use struct wireless_dev
>     instead of struct net_device.
> ---
>
> Adapt a patch (attached) using LINUX_VERSION_CODE conditionals, as to
> not break support for pre-3.6 kernels, and problem solved.
>
> However, scan results seem quite limited. That is, discovered BSSID's
> are noticeably fewer compared to results on 3.2.x-3.5.x, either via
> `/sbin/iwlist wlan1 scanning`, or networkmanager. Only 3-5 are show by
> iwlist, sometimes none, and network manager lists 6 at most.
> Same driver on 3.5 (or prior) quickly picks up at least 15 BSSIDs.
>
> Is there something obviously wrong with the patch?
>
> Best,
> Jasmine
>
>
> On Mon, Oct 1, 2012 at 3:51 PM, Dan Williams <dcbw@redhat.com> wrote:
>>
>> On Mon, 2012-10-01 at 11:25 +0200, Jasmine Hassan wrote:
>> > Hi,
>> >
>> > I posted this a few days ago against 3.6-rc7, but got no response.
>> > http://marc.info/?l=3Dlinux-wireless&m=3D134875589522742&w=3D2
>> >
>> > Tested again today against 3.6 stable, and still triggering kernel bug=
.
>> > Attached updated kernel trace from syslog.
>>
>> Since that's the closed proprietary driver, there's pretty much nothing
>> anyone here can do about it, since we don't have the source code.  The
>> ball is in Broadcom's court.
>>
>> Dan
>>

--f46d044280e63a760604cc8e49da
Content-Type: application/octet-stream; name="08-kernel_3.6_onwards.patch"
Content-Disposition: attachment; filename="08-kernel_3.6_onwards.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h8jy7hok0

RGVzY3JpcHRpb246IG5sODAyMTE6IG1vdmUgc2NhbiBBUEkgdG8gd2RldgogYmFzZWQgb24gbGlu
dXgud2lyZWxlc3MgY29tbWl0IGZkMDE0Mjg0NGVmYTg1ZDg5MDE3Yzg5MjI3YTBmMDNkZTFlZWUz
MjcKIGJ5IEpvaGFubmVzIEJlcmcgPGpvaGFubmVzLmJlcmdAaW50ZWwuY29tPgogLgogIFRoZSBu
ZXcgUDJQIERldmljZSB3aWxsIGhhdmUgdG8gYmUgYWJsZSB0byBzY2FuIGZvciBQMlAgc2VhcmNo
LCBzbyBtb3ZlIAogIHNjYW5uaW5nIHRvIHVzZSBzdHJ1Y3Qgd2lyZWxlc3NfZGV2IGluc3RlYWQg
b2Ygc3RydWN0IG5ldF9kZXZpY2UuCi0tLSBhL2FtZDY0L3NyYy93bC9zeXMvd2xfY2ZnODAyMTEu
YworKysgYi9hbWQ2NC9zcmMvd2wvc3lzL3dsX2NmZzgwMjExLmMKQEAgLTQ2LDcgKzQ2LDEwIEBA
IHUzMiB3bF9kYmdfbGV2ZWwgPSBXTF9EQkdfRVJSIHwgV0xfREJHX0kKIAogc3RhdGljIHMzMiB3
bF9jZmc4MDIxMV9jaGFuZ2VfaWZhY2Uoc3RydWN0IHdpcGh5ICp3aXBoeSwgc3RydWN0IG5ldF9k
ZXZpY2UgKm5kZXYsCiAgICAgICAgICAgIGVudW0gbmw4MDIxMV9pZnR5cGUgdHlwZSwgdTMyICpm
bGFncywgc3RydWN0IHZpZl9wYXJhbXMgKnBhcmFtcyk7Ci1zdGF0aWMgczMyIHdsX2NmZzgwMjEx
X3NjYW4oc3RydWN0IHdpcGh5ICp3aXBoeSwgc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsCitzdGF0
aWMgczMyIHdsX2NmZzgwMjExX3NjYW4oc3RydWN0IHdpcGh5ICp3aXBoeSwKKyNpZiBMSU5VWF9W
RVJTSU9OX0NPREUgPCBLRVJORUxfVkVSU0lPTigzLCA2LCAwKQorICAgICAgICAgICBzdHJ1Y3Qg
bmV0X2RldmljZSAqbmRldiwKKyNlbmRpZgogICAgICAgICAgICBzdHJ1Y3QgY2ZnODAyMTFfc2Nh
bl9yZXF1ZXN0ICpyZXF1ZXN0KTsKIHN0YXRpYyBzMzIgd2xfY2ZnODAyMTFfc2V0X3dpcGh5X3Bh
cmFtcyhzdHJ1Y3Qgd2lwaHkgKndpcGh5LCB1MzIgY2hhbmdlZCk7CiBzdGF0aWMgczMyIHdsX2Nm
ZzgwMjExX2pvaW5faWJzcyhzdHJ1Y3Qgd2lwaHkgKndpcGh5LCBzdHJ1Y3QgbmV0X2RldmljZSAq
ZGV2LApAQCAtNDgyLDkgKzQ4NSwxNSBAQCB3bF9jZmc4MDIxMV9jaGFuZ2VfaWZhY2Uoc3RydWN0
IHdpcGh5ICp3CiB9CiAKIHN0YXRpYyBzMzIKLXdsX2NmZzgwMjExX3NjYW4oc3RydWN0IHdpcGh5
ICp3aXBoeSwgc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsCit3bF9jZmc4MDIxMV9zY2FuKHN0cnVj
dCB3aXBoeSAqd2lwaHksCisjaWYgTElOVVhfVkVSU0lPTl9DT0RFIDwgS0VSTkVMX1ZFUlNJT04o
MywgNiwgMCkKKyAgICAgICAgICAgICAgICAgc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsCisjZW5k
aWYKICAgICAgICAgICAgICAgICAgc3RydWN0IGNmZzgwMjExX3NjYW5fcmVxdWVzdCAqcmVxdWVz
dCkKIHsKKyNpZiBMSU5VWF9WRVJTSU9OX0NPREUgPj0gS0VSTkVMX1ZFUlNJT04oMywgNiwgMCkK
KwlzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiA9IHJlcXVlc3QtPndkZXYtPm5ldGRldjsKKyNlbmRp
ZgogCXN0cnVjdCB3bF9jZmc4MDIxMV9wcml2ICp3bCA9IG5kZXZfdG9fd2wobmRldik7CiAJc3Ry
dWN0IGNmZzgwMjExX3NzaWQgKnNzaWRzOwogCXN0cnVjdCB3bF9jZmc4MDIxMV9zY2FuX3JlcSAq
c3IgPSB3bF90b19zcih3bCk7Cg==
--f46d044280e63a760604cc8e49da--
