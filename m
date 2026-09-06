Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7E93B3C11
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 17:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788716210; cv=pass; b=reAWXup7coDBa4gqc1Q2FaQO4HmQ02faMGXzBHRIbRfvLUeE3WBDpa49vM+lYrbbr0fmhoBkE/XMhfNpmw35wqzjjURKSt1ZlIWt8jfQIFHVOdP/73qUTZbtyiNuzmiTn6MFfLoK0jxjvFrJS0Jv7V3p+sKsMwXvLjF2LVetWyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788716210; c=relaxed/simple;
	bh=hUjLRgjrgowp0i0P2xMGQ4DD+NQrDuloDDM39ZZRMm8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=fWd0S+ivTIXdBHSK9/itfGL1tAB2Ao8hrr2yGtzeU37xBm0rfWRoJrNIz59KRvXi1G+6fpcIrSd+HAZRmgaE083siKTE0wDleSXMpkWGn6taMs82mtQndnczGGmkUbntPjl0frOYgyKAk5joSqi3JA0W4WU550hrZ5Yu7TggRHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WX74UTPo; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WX74UTPo"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a7fa3a442bso1743329a12.3
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 10:36:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788716204; cv=none;
        d=google.com; s=arc-20260327;
        b=kCWKWo25f/KkeJvigjlqiYkQz6No2zDUX6I1GDWvfZ1+jhPjIczXCeW2xkWWxAaaMH
         ubjm8A7kGvMuuQF1bWzjichb+CwsKixRMnWFNOda/15Xddm74o+ecVBkANGD8tNMbyRS
         k0ZVtVGyyuk7xUg11EUNEXz/ly5q7Ob8BB76FnvIgsVWPofgW4kLrLZWjP7N50qMF2/p
         Y4JtbD+lObOO2YhKnPNH2AJLKjv4Jaw5UuK1B+h3oPcvht7NFrxcdx4ED1BHNXYMV4l4
         YDH0f10n8jXc38QY1HFham3ZUu2KZ+pGY/6hJXk8rbY6OccoMq+S/huLY7nrd+HY9ymZ
         tj3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=W68pxWnJ4nVG9Xx75MrQvOMJOvBGiOHZo170rUdyK14=;
        fh=I5ez6iLIRgR5zpWjhZQG6WwgzyOX5ru1iFh4YI7xB6o=;
        b=Rc73ocbGPs2D5ISDQLRqZ1ce8uHMSSXSrXzWvrSiCiyVbxkwm6zWEyQ/DnO24P2EVB
         X/+vADhl+GfJFyDEySnKaRJLQMHcEtnp53L5xgrTshfNu/nw8xwDXkA5v2n0IaZZ8mMM
         3eK7W+GkqgA+Xh+zt8yurEIXi7l4/xNS9CNc25uyA/ZOGxDr2x+2f53QzqGLtZ7dMv5t
         w3bbj1pRoMuCA9XQtPvLTB9H+nQQGQMGg0LafMwucKJISB521c5HvrD52dhHITXOUup1
         80cgnWWiw5b1mYafvHHz6131la9qgLA8RxYosBznNMKgNoNglaQBy97ZywBV7Edf22pr
         stxA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788716204; x=1789321004; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=W68pxWnJ4nVG9Xx75MrQvOMJOvBGiOHZo170rUdyK14=;
        b=WX74UTPow3QUUe8vgacN1QG8LqD/neNvyKdq9EGSrgHp4Yyd2BXg/LMPh43Jj6fY8d
         J31j4kfuhgsUCKjigltIhCdyPM26fhnN/PB60XywrCjSF2StCH+yAZfMdf24fQs+5rJV
         C2wYEaoKuZqllQZckt7UJLwtEjdOAdTE80hNWbTbt8A0OLQ7ytgnESam3ZTorLzCmVe0
         E0PWSXRXF8IF5fELYyNBBURCZc6tyWGFd+Kc2z9dRkOGVRT6sef89Fw3qita6gRdUNvr
         TmmNiBy34+OAOAe+HY7aL/WkG6XWsQ6RUN2s8qt6N+pQKyD6sO/M3JmTDjs1XZg4sLTs
         bPaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788716204; x=1789321004;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W68pxWnJ4nVG9Xx75MrQvOMJOvBGiOHZo170rUdyK14=;
        b=g5fe2CSCxOzfr1fLLP8tv+0xsBmnnAfDqVWWLeCc+0bz14rHEUHQfXRHkPpI29aVTt
         2JIMOaJuQTDWqJB0XNpxTQbg3vfZ0/AcLAdH/O2Frnm8s8uio0e1rzCBpLIcCRJppbb+
         voBG7G2uVOJbX0+C4qonijYVACjRn/6DX/QeSRx39QeTbwKtV8k5l9CZYj0i5/GiJu+m
         EFj0DgsctcdBDysXRQJi1DDAkJeURNvzsKUQIC923JStD+YYj4ROUMF0+xMNrZxdMPzI
         p1PJNfC9Mrp/TlcTNHPzjIvFUeirVLLeo7asg+QzdTtKAQCE6hDC1kHI7yzW/jZbJg3c
         iZCg==
X-Forwarded-Encrypted: i=1; AKwUvBwyuqVqLj3ZVZB3175oGkr1Z4ydBsVtEBldGOeo5gZDZ8GMSEpuge+jO9Q4cQlSKFxkra0AklCoQ4fGDwUWTw==@vger.kernel.org
X-Gm-Message-State: AFuF++nnkuSOsXey17dQ+4VIB364/kmPedqRcsgB+Hbb/hA7gx26nRRl
	r4Lp+eoUMKKB0q+YrwO3uitXEvhwXP3WnKJEdueVTWvw/8gftggaAj20yCT6UeNJenaCShuzSEh
	CEbFnIytv7CQ7aZMdftzCdPLrQrjExGmUb0k1nSs=
X-Gm-Gg: AYBFou37kyMeYya3bj4mkfSlSo1c70sz7sy52CBqOJVu7v4buE8H942GL/1xLn5vcrb
	m1bRNBkr/EnMLC4MrrlI5lYOdpDcCcm1kZKwLgUkfGCuC+i4Vdo1P6u7jUm0r51JFKTup/PLAsV
	xNsdlayQ9gQHxw9yi3D7fPN183JqrllBMVq86HTDudNdYBl0fN6jfhR3fwubvYQPBev2+HMID/h
	23UUwXYWzilgzfh2bED1gAqHhHDXsvjGGMqQ0yvly1v9ipcgAunrgZ9N4oSzZ0kFi4yWsJonIGm
	TwbwmgJdMmLKZ9fcMbdpOAdjYa0CFXKKoR22Xczl/j+XofxgmTwofDVmxv1ztGC/+w4jxo4YHHv
	+0KrtIbr7muHApFHmPrxY
X-Received: by 2002:a05:6402:43c6:b0:6a6:32fa:1e9b with SMTP id
 4fb4d7f45d1cf-6a7e90cc231mr6407792a12.19.1788716203597; Sun, 06 Sep 2026
 10:36:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Herman Semenoff <germanaizek0@gmail.com>
Date: Sun, 6 Sep 2026 20:36:36 +0300
X-Gm-Features: AcwNN1Uv8S-4slwg5pmgRlI8WoV_Wv-oaYqJ7CKFUMBa2_5K9YHOlzZdJTeoo9g
Message-ID: <CAMnMt5Y0kp1YSDaF=Nq4yYJSMAQe8CqzNB-1eKdyKQr2E1eXQA@mail.gmail.com>
Subject: [PATCH] wifi: mt7601u: add vnd_reset parameter to fix probe failure
 on Tenda U2
To: kuba@kernel.org, kvalo@kernel.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000ebaad9065ad3f1fb"

--000000000000ebaad9065ad3f1fb
Content-Type: text/plain; charset="UTF-8"

On certain MT7601U adapters, such as Tenda U2 and
other newer hardware revisions, driver initialization consistently fails
during probe with vendor request timeouts (-110 / -ETIMEDOUT):
  mt7601u 3-14:1.0: ASIC revision: 76010001 MAC revision: 76010500
  mt7601u 3-14:1.0: Firmware Version: 0.1.00 Build: 7640 Build time:
201302052146____
  mt7601u 3-14:1.0: Vendor request req:07 off:09a8 failed:-110
  mt7601u 3-14:1.0: Vendor request req:02 off:09a8 failed:-110
  mt7601u 3-14:1.0: Vendor request req:07 off:0734 failed:-110
  mt7601u 3-14:1.0: Vendor request req:42 off:0230 failed:-110
  mt7601u 3-14:1.0: probe with driver mt7601u failed with error -110

The failure occurs because mt7601u_load_firmware() unconditionally calls
mt7601u_vendor_reset() (MT_VEND_DEV_MODE_RESET) before uploading firmware
chunks. On these devices, issuing this vendor reset leaves the internal
MCU / FCE DMA engine in an unresponsive state after the first firmware
URB is submitted. As a result, reading MT_TX_CPU_FROM_FCE_CPU_DESC_IDX
(0x09a8) immediately times out.
Introduce a boolean module parameter 'vnd_reset' (default: false) to
make this vendor reset optional. When the vendor reset is skipped,
firmware upload succeeds and the wireless interface initializes normally.

Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1716301

More issues with Tenda U2 and Linux:
- https://www.opena.tv/viewtopic.php?t=63919
- https://askubuntu.com/questions/1418850/the-problem-with-wi-fi-u2
- https://bbs.archlinux.org/viewtopic.php?id=224859
- https://www.reddit.com/r/archlinux/comments/1d6dfv5/mt7601u_usb_wifi_not_working/

Signed-off-by: Herman Semenoff <GermanAizek@aizekgroup.ru>

--000000000000ebaad9065ad3f1fb
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-PATCH-wifi-mt7601u-add-vnd_reset-parameter-to-fix-pr.diff"
Content-Disposition: attachment; 
	filename="0001-PATCH-wifi-mt7601u-add-vnd_reset-parameter-to-fix-pr.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_mtq3fs3c0>
X-Attachment-Id: f_mtq3fs3c0

RnJvbSBjMDNkNzNkMzdkZjQ0MGQwMDQ2ZDY4NDA2ZmRlMmFhMWY2MmZlMGQxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBIZXJtYW4gU2VtZW5vZmYgPEdlcm1hbkFpemVrQGFpemVrZ3Jv
dXAucnU+CkRhdGU6IFRodSwgMyBTZXAgMjAyNiAwNzoxNDozMiArMDMwMApTdWJqZWN0OiBbUEFU
Q0hdIHdpZmk6IG10NzYwMXU6IGFkZCB2bmRfcmVzZXQgcGFyYW1ldGVyIHRvIGZpeCBwcm9iZQog
ZmFpbHVyZSBvbiBUZW5kYSBVMgoKd2lmaTogbXQ3NjAxdTogYWRkIHZuZF9yZXNldCBwYXJhbWV0
ZXIgdG8gZml4IHByb2JlIGZhaWx1cmUgb24gVGVuZGEgVTIKCk9uIGNlcnRhaW4gTVQ3NjAxVSBh
ZGFwdGVycywgc3VjaCBhcyBUZW5kYSBVMiBhbmQKb3RoZXIgbmV3ZXIgaGFyZHdhcmUgcmV2aXNp
b25zLCBkcml2ZXIgaW5pdGlhbGl6YXRpb24gY29uc2lzdGVudGx5IGZhaWxzCmR1cmluZyBwcm9i
ZSB3aXRoIHZlbmRvciByZXF1ZXN0IHRpbWVvdXRzICgtMTEwIC8gLUVUSU1FRE9VVCk6CiAgbXQ3
NjAxdSAzLTE0OjEuMDogQVNJQyByZXZpc2lvbjogNzYwMTAwMDEgTUFDIHJldmlzaW9uOiA3NjAx
MDUwMAogIG10NzYwMXUgMy0xNDoxLjA6IEZpcm13YXJlIFZlcnNpb246IDAuMS4wMCBCdWlsZDog
NzY0MCBCdWlsZCB0aW1lOiAyMDEzMDIwNTIxNDZfX19fCiAgbXQ3NjAxdSAzLTE0OjEuMDogVmVu
ZG9yIHJlcXVlc3QgcmVxOjA3IG9mZjowOWE4IGZhaWxlZDotMTEwCiAgbXQ3NjAxdSAzLTE0OjEu
MDogVmVuZG9yIHJlcXVlc3QgcmVxOjAyIG9mZjowOWE4IGZhaWxlZDotMTEwCiAgbXQ3NjAxdSAz
LTE0OjEuMDogVmVuZG9yIHJlcXVlc3QgcmVxOjA3IG9mZjowNzM0IGZhaWxlZDotMTEwCiAgbXQ3
NjAxdSAzLTE0OjEuMDogVmVuZG9yIHJlcXVlc3QgcmVxOjQyIG9mZjowMjMwIGZhaWxlZDotMTEw
CiAgbXQ3NjAxdSAzLTE0OjEuMDogcHJvYmUgd2l0aCBkcml2ZXIgbXQ3NjAxdSBmYWlsZWQgd2l0
aCBlcnJvciAtMTEwCgpUaGUgZmFpbHVyZSBvY2N1cnMgYmVjYXVzZSBtdDc2MDF1X2xvYWRfZmly
bXdhcmUoKSB1bmNvbmRpdGlvbmFsbHkgY2FsbHMKbXQ3NjAxdV92ZW5kb3JfcmVzZXQoKSAoTVRf
VkVORF9ERVZfTU9ERV9SRVNFVCkgYmVmb3JlIHVwbG9hZGluZyBmaXJtd2FyZQpjaHVua3MuIE9u
IHRoZXNlIGRldmljZXMsIGlzc3VpbmcgdGhpcyB2ZW5kb3IgcmVzZXQgbGVhdmVzIHRoZSBpbnRl
cm5hbApNQ1UgLyBGQ0UgRE1BIGVuZ2luZSBpbiBhbiB1bnJlc3BvbnNpdmUgc3RhdGUgYWZ0ZXIg
dGhlIGZpcnN0IGZpcm13YXJlClVSQiBpcyBzdWJtaXR0ZWQuIEFzIGEgcmVzdWx0LCByZWFkaW5n
IE1UX1RYX0NQVV9GUk9NX0ZDRV9DUFVfREVTQ19JRFgKKDB4MDlhOCkgaW1tZWRpYXRlbHkgdGlt
ZXMgb3V0LgpJbnRyb2R1Y2UgYSBib29sZWFuIG1vZHVsZSBwYXJhbWV0ZXIgJ3ZuZF9yZXNldCcg
KGRlZmF1bHQ6IGZhbHNlKSB0bwptYWtlIHRoaXMgdmVuZG9yIHJlc2V0IG9wdGlvbmFsLiBXaGVu
IHRoZSB2ZW5kb3IgcmVzZXQgaXMgc2tpcHBlZCwKZmlybXdhcmUgdXBsb2FkIHN1Y2NlZWRzIGFu
ZCB0aGUgd2lyZWxlc3MgaW50ZXJmYWNlIGluaXRpYWxpemVzIG5vcm1hbGx5LgoKTGluazogaHR0
cHM6Ly9idWdzLmxhdW5jaHBhZC5uZXQvdWJ1bnR1Lytzb3VyY2UvbGludXgvK2J1Zy8xNzE2MzAx
CgpNb3JlIGlzc3VlcyB3aXRoIFRlbmRhIFUyIGFuZCBMaW51eDoKLSBodHRwczovL3d3dy5vcGVu
YS50di92aWV3dG9waWMucGhwP3Q9NjM5MTkKLSBodHRwczovL2Fza3VidW50dS5jb20vcXVlc3Rp
b25zLzE0MTg4NTAvdGhlLXByb2JsZW0td2l0aC13aS1maS11MgotIGh0dHBzOi8vYmJzLmFyY2hs
aW51eC5vcmcvdmlld3RvcGljLnBocD9pZD0yMjQ4NTkKLSBodHRwczovL3d3dy5yZWRkaXQuY29t
L3IvYXJjaGxpbnV4L2NvbW1lbnRzLzFkNmRmdjUvbXQ3NjAxdV91c2Jfd2lmaV9ub3Rfd29ya2lu
Zy8KClNpZ25lZC1vZmYtYnk6IEhlcm1hbiBTZW1lbm9mZiA8R2VybWFuQWl6ZWtAYWl6ZWtncm91
cC5ydT4KLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2MDF1L21jdS5jIHwg
MTUgKysrKysrKysrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9tZWRpYXRlay9t
dDc2MDF1L21jdS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3NjAxdS9tY3Uu
YwppbmRleCBiYWQ2Y2E4MjEuLmFiZjQ3NjdmMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvbWVkaWF0ZWsvbXQ3NjAxdS9tY3UuYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9t
ZWRpYXRlay9tdDc2MDF1L21jdS5jCkBAIC0xMCw2ICsxMCw3IEBACiAjaW5jbHVkZSA8bGludXgv
ZGVsYXkuaD4KICNpbmNsdWRlIDxsaW51eC91c2IuaD4KICNpbmNsdWRlIDxsaW51eC9za2J1ZmYu
aD4KKyNpbmNsdWRlIDxsaW51eC9tb2R1bGVwYXJhbS5oPgogCiAjaW5jbHVkZSAibXQ3NjAxdS5o
IgogI2luY2x1ZGUgImRtYS5oIgpAQCAtMjEsNiArMjIsMTQgQEAKICNkZWZpbmUgTUNVX0ZXX1VS
Ql9TSVpFCQkJKE1DVV9GV19VUkJfTUFYX1BBWUxPQUQgKyAxMikKICNkZWZpbmUgTUNVX1JFU1Bf
VVJCX1NJWkUJCTEwMjQKIAorc3RhdGljIGJvb2wgdm5kX3Jlc2V0OworbW9kdWxlX3BhcmFtKHZu
ZF9yZXNldCwgYm9vbCwgMDY0NCk7CitNT0RVTEVfUEFSTV9ERVNDKHZuZF9yZXNldCwgIlBlcmZv
cm0gdmVuZG9yIHJlc2V0IGR1cmluZyBmaXJtd2FyZSB1cGxvYWQgKGRlZmF1bHQ6IGZhbHNlKSIp
OworCitzdGF0aWMgYm9vbCBkaXNhYmxlX3VzYl9zZzsKK21vZHVsZV9wYXJhbShkaXNhYmxlX3Vz
Yl9zZywgYm9vbCwgMDY0NCk7CitNT0RVTEVfUEFSTV9ERVNDKGRpc2FibGVfdXNiX3NnLCAiVW51
c2VkIGNvbXBhdGliaWxpdHkgcGFyYW1ldGVyIik7CisKIHN0YXRpYyBpbmxpbmUgaW50IGZpcm13
YXJlX3J1bm5pbmcoc3RydWN0IG10NzYwMXVfZGV2ICpkZXYpCiB7CiAJcmV0dXJuIG10NzYwMXVf
cnIoZGV2LCBNVF9NQ1VfQ09NX1JFRzApID09IDE7CkBAIC00NTksOCArNDY4LDEwIEBAIHN0YXRp
YyBpbnQgbXQ3NjAxdV9sb2FkX2Zpcm13YXJlKHN0cnVjdCBtdDc2MDF1X2RldiAqZGV2KQogCW10
NzYwMXVfd3IoZGV2LCAweDk0YywgMCk7CiAJbXQ3NjAxdV93cihkZXYsIE1UX0ZDRV9QU0VfQ1RS
TCwgMCk7CiAKLQltdDc2MDF1X3ZlbmRvcl9yZXNldChkZXYpOwotCW1zbGVlcCg1KTsKKwlpZiAo
dm5kX3Jlc2V0KSB7CisJCW10NzYwMXVfdmVuZG9yX3Jlc2V0KGRldik7CisJCW1zbGVlcCg1KTsK
Kwl9CiAKIAltdDc2MDF1X3dyKGRldiwgMHhhNDQsIDApOwogCW10NzYwMXVfd3IoZGV2LCAweDIz
MCwgMHg4NDIxMCk7Ci0tIAoyLjU1LjAKCg==
--000000000000ebaad9065ad3f1fb--
