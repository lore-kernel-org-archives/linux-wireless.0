Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390D33AF65F;
	Wed, 16 Sep 2026 02:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789526392; cv=none; b=jlX8a19gWJ039ZJiy1toeniYkXkBZb1M7fSJSWL/lxhQUmd5KqXp/4YWNm0jyJKOsNsBJGit+eIGDDUlJOtl//g+SPs5NyE86AdSr/rCHcpbpnSfpSZ3X+bEu0zJs07N196OaWO13aNOeah/HFXUvSwFGqEo9he1QgClLX9m/Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789526392; c=relaxed/simple;
	bh=byz0RftANdJsZWunUZ3RoGkdhup+wIg2DIt19ZtuUY4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qdrPyvBrWG2Tm1UNAnWSJRZXCYtppk/RwRcQkhZtoOKARpfhcYnwDo75P3mJQ2Q0/GENqcQARGfmIqqqDjJqyeYsxzHdL74IxMo2G3VrYatuGsjMcr0EWXZxFp0032pXP+GP0fN8WNEUw1HVBNTD4wWmyiKeAm2iWqh+/+/+Vv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=IRTLHpzE; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="IRTLHpzE"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G2dgqP72039227, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789526383; bh=y/mEuf7boR1N1neJM/CV7P2cSOVy3en6jz4fpycJ3Sg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version;
	b=IRTLHpzEoqslxPmEKcsBlt/0xMkhA5UV9bcY6dYSJ5ClfqQ0Cdn0l9PGrSyf2yFh5
	 a1D1gKpaSSsspM/Ojb4QFkQrjMs9PT7236oEbmANSVkbLt4Plf7XQ3q2ybIfUnqHZs
	 ntChdYpev7cN+aJmEC1tHPHeSUk2XHNwm/2pBrMHmDS7ORz23vyDBLVDHX/eYLNM/V
	 FUGLDdsxrpYseyKXK6NR7We6GwcsBG1G0OtSHRR+09aVBFinN5THCFmgjKUmVBSaFI
	 1qAO/HqzXmnbc/YZOZl+J4sucYDw6Wt+IukdH8/We9Wqg9RMKRfJnX3opEE8gAWUPq
	 MQEOzi4lhHtOw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G2dgqP72039227
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 10:39:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 10:39:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 16 Sep 2026 10:39:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Maxim Skokov <skokovmaksimevg@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: rtw89: BT connect state differs between scoreboard and bt_info on
 RTL8851B
Thread-Topic: rtw89: BT connect state differs between scoreboard and bt_info
 on RTL8851B
Thread-Index: AQHdRQ2CnV7TRht53kG/awfFcwERqbbPDZQAgAFwrJA=
Date: Wed, 16 Sep 2026 02:39:42 +0000
Message-ID: <25270f2066784a02806daa352643be53@realtek.com>
References: <20260915122625.6341-1-skokovmaksimevg@gmail.com>
 <20260915123718.7239-1-skokovmaksimevg@gmail.com>
In-Reply-To: <20260915123718.7239-1-skokovmaksimevg@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: yes
Content-Type: multipart/mixed;
	boundary="_002_25270f2066784a02806daa352643be53realtekcom_"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

--_002_25270f2066784a02806daa352643be53realtekcom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Maxim Skokov <skokovmaksimevg@gmail.com> wrote:
> Same on WL_FW 0.29.41.5, the newest in linux-firmware, with the sink
> connected and playing:
>=20
>   [status]     : enable:Y, btg:N, connect:N, mailbox_avl:Y
>   [profile]    : profile: , A2DP_active:Y, PAN_active:N
>   [bt_info]    : raw_data[49 00 d0 00 04 00] (type:auto/cnt:82/same:3)
>   [scoreboard] : BT0->WL:0x40000003(total:0, bt_update:26)
>=20
> BTC_BSCB_BT_CONNECT is not set here either.

We found the problem recently, and ongoing to send out the patch.=20
Please try the attachment.


--_002_25270f2066784a02806daa352643be53realtekcom_
Content-Type: application/octet-stream;
	name="20260916_00_patch_for_scoreboard.patch"
Content-Description: 20260916_00_patch_for_scoreboard.patch
Content-Disposition: attachment;
	filename="20260916_00_patch_for_scoreboard.patch"; size=2817;
	creation-date="Wed, 16 Sep 2026 02:38:12 GMT";
	modification-date="Wed, 16 Sep 2026 02:35:44 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvY29leC5jIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OS9jb2V4LmMKaW5kZXggNWE5ZGM0ZDhh
MDBiLi5kZjQ5ZjYyZjU2NmIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0
ZWsvcnR3ODkvY29leC5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkv
Y29leC5jCkBAIC0xMDAwLDcgKzEwMDAsNyBAQCBzdGF0aWMgdm9pZCBfcnVuX2NvZXgoc3RydWN0
IHJ0dzg5X2RldiAqcnR3ZGV2LAogCQkgICAgICBlbnVtIGJ0Y19yZWFzb25fYW5kX2FjdGlvbiBy
ZWFzb24pOwogc3RhdGljIHZvaWQgX3dyaXRlX3NjYmQoc3RydWN0IHJ0dzg5X2RldiAqcnR3ZGV2
LCB1OCBiaWQsIHUzMiB2YWwsIGJvb2wgc3RhdGUpOwogc3RhdGljIHU4IF9zbmVkX2gyY193MmJz
Y2JkKHN0cnVjdCBydHc4OV9kZXYgKnJ0d2RldiwgYm9vbCBmb3JjZV9leGVjLCB1OCBiaWQpOwot
c3RhdGljIHZvaWQgX3VwZGF0ZV9idF9zY2JkKHN0cnVjdCBydHc4OV9kZXYgKnJ0d2RldiwgdTgg
YmlkKTsKK3N0YXRpYyB2b2lkIF91cGRhdGVfYnRfc2NiZChzdHJ1Y3QgcnR3ODlfZGV2ICpydHdk
ZXYsIHU4IGJpZCwgYm9vbCBpc19jMmgpOwogc3RhdGljIGNvbnN0IGNoYXIgKmlkX3RvX2gyYyh1
MzIgaWQpOwogCiBzdGF0aWMgdm9pZCBfcmVzZXRfaDJjX21hY3JvKHN0cnVjdCBydHc4OV9idGMg
KmJ0YykKQEAgLTM2MDIsNyArMzYwMiw3IEBAIHZvaWQgYnRjX2Z3X2V2ZW50KHN0cnVjdCBydHc4
OV9kZXYgKnJ0d2RldiwgdTggZXZ0X2lkLCB2b2lkICpkYXRhLCB1MzIgbGVuKQogCQkJCSAgICAi
W0JUQ10sICVzKCkgYnQlZDpjMmgtPjB4JTA4eCwgcmItPjB4JTA4eFxuIiwKIAkJCQkgICAgX19m
dW5jX18sIGksIGJ0LT5zY2JkX2MyaCwgYnQtPnNjYmRfcmIpOwogCQkJYnQtPnNjYmRfYzJoID0g
YnQtPnNjYmRfcmI7Ci0JCQlfdXBkYXRlX2J0X3NjYmQocnR3ZGV2LCBpKTsKKwkJCV91cGRhdGVf
YnRfc2NiZChydHdkZXYsIGksIHRydWUpOwogCQkJYnRjLT5kbS5zY2JkX2Iyd191cGRhdGUgPSBm
YWxzZTsKIAkJfQogCX0KQEAgLTc4MDUsNyArNzgwNSwyMSBAQCBzdGF0aWMgdm9pZCBfdXBkYXRl
X2J0X2N0cmxfbHBzKHN0cnVjdCBydHc4OV9kZXYgKnJ0d2RldikKIAl9CiB9CiAKLXN0YXRpYyB2
b2lkIF91cGRhdGVfYnRfc2NiZChzdHJ1Y3QgcnR3ODlfZGV2ICpydHdkZXYsIHU4IGJpZCkKK3N0
YXRpYyB1MzIgX3JlYWRfc2NiZChzdHJ1Y3QgcnR3ODlfZGV2ICpydHdkZXYsIHU4IGlkKQorewor
CWNvbnN0IHN0cnVjdCBydHc4OV9jaGlwX2luZm8gKmNoaXAgPSBydHdkZXYtPmNoaXA7CisJdTMy
IHZhbDsKKworCWlmICghY2hpcC0+c2NiZCkKKwkJcmV0dXJuIDA7CisKKwl2YWwgPSBydHc4OV9y
ZWFkMzIocnR3ZGV2LCBjaGlwLT5idGNfc2IubltpZF0uZ2V0KTsKKwlydHc4OV9kZWJ1ZyhydHdk
ZXYsIFJUVzg5X0RCR19CVEMsCisJCSAgICAiW0JUQ10sIHJlYWQgc2NiZCBidCVkOiAweCUwOHhc
biIsIGlkLCB2YWwpOworCXJldHVybiB2YWw7Cit9CisKK3N0YXRpYyB2b2lkIF91cGRhdGVfYnRf
c2NiZChzdHJ1Y3QgcnR3ODlfZGV2ICpydHdkZXYsIHU4IGJpZCwgYm9vbCBpc19jMmgpCiB7CiAJ
c3RydWN0IHJ0dzg5X2J0Y19idF9saW5rX2luZm8gKmJ0XzJnLCAqYnRfNTZnOwogCXN0cnVjdCBy
dHc4OV9idGMgKmJ0YyA9ICZydHdkZXYtPmJ0YzsKQEAgLTc4MzgsNyArNzg1Miw3IEBAIHN0YXRp
YyB2b2lkIF91cGRhdGVfYnRfc2NiZChzdHJ1Y3QgcnR3ODlfZGV2ICpydHdkZXYsIHU4IGJpZCkK
IAkJaWYgKCEocnR3ZGV2LT5jaGlwLT5wYXJhX3ZlciAmIEJUQ19GRUFUX0RVQUxfQlQpICYmIGlk
ID09IEJUQ19CVF8yTkQpCiAJCQlicmVhazsKIAotCQl2YWwgPSBidC0+c2NiZF9jMmg7CisJCXZh
bCA9IGlzX2MyaCA/IGJ0LT5zY2JkX2MyaCA6IF9yZWFkX3NjYmQocnR3ZGV2LCBpZCk7CiAKIAkJ
aWYgKHZhbCA9PSAweGZmZmZmZmZmKSB7CiAJCQlydHc4OV9kZWJ1ZyhydHdkZXYsIFJUVzg5X0RC
R19CVEMsCkBAIC04NDczLDggKzg0ODcsOCBAQCB2b2lkIF9ydW5fY29leChzdHJ1Y3QgcnR3ODlf
ZGV2ICpydHdkZXYsIGVudW0gYnRjX3JlYXNvbl9hbmRfYWN0aW9uIHJlYXNvbikKIAogCV91cGRh
dGVfcnVuX2N0cmxfaW5mbyhydHdkZXYpOwogCi0JaWYgKHJlYXNvbiA9PSBCVENfUlNOX05URllf
SU5JVCB8fCByZWFzb24gPT0gQlRDX1JTTl9OVEZZX1JBRElPX1NUQVRFKQotCQlfdXBkYXRlX2J0
X3NjYmQocnR3ZGV2LCBmYWxzZSk7CisJaWYgKHJlYXNvbiA9PSBCVENfUlNOX05URllfUkFESU9f
U1RBVEUpCisJCV91cGRhdGVfYnRfc2NiZChydHdkZXYsIEJUQ19BTExfQlQsIGZhbHNlKTsKIAog
CWRtLT5mcmVlcnVuID0gZmFsc2U7CiAJZG0tPmNudF9kbVtCVENfRENOVF9SVU5dKys7CkBAIC05
ODE0LDcgKzk4MjgsNyBAQCB2b2lkIHJ0dzg5X2J0Y19jMmhfaGFuZGxlKHN0cnVjdCBydHc4OV9k
ZXYgKnJ0d2Rldiwgc3RydWN0IHNrX2J1ZmYgKnNrYiwKIAkJcnR3ODlfZGVidWcocnR3ZGV2LCBS
VFc4OV9EQkdfQlRDLAogCQkJICAgICJbQlRDXSwgaGFuZGxlIEMySCBCVCVkIFNDQkQgd2l0aCBk
YXRhIDB4JTA4eFxuIiwKIAkJCSAgICBiaWQsIGJ0LT5zY2JkX2MyaCk7Ci0JCV91cGRhdGVfYnRf
c2NiZChydHdkZXYsIGJpZCk7CisJCV91cGRhdGVfYnRfc2NiZChydHdkZXYsIGJpZCwgdHJ1ZSk7
CiAJCV9ydW5fY29leChydHdkZXYsIEJUQ19SU05fVVBEQVRFX0JUX1NDQkQpOwogCQlicmVhazsK
IAljYXNlIEJURl9FVk5UX0JUX1BTRDoK

--_002_25270f2066784a02806daa352643be53realtekcom_--
