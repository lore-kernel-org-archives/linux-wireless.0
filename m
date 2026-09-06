Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8B513777E
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 17:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788714629; cv=pass; b=FqSkTlkExUj/IxApnFdNRbmGA5NyttTU5O3uxECdSH0gEDid5fKrEw+U80lhDJG1faIXgfJGHkIgrDTLFIbc0Sxs0GwK3ptSRlh5ewL7hKwnEhF/elgqvHmoAU97VQ9Ac9oMk1R48aWcAUuMwb4UdFbY3gBGzSSCO0PvBiXF3+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788714629; c=relaxed/simple;
	bh=HZEcyytTRfm6SobuhYkTk1dOEKPrzvjkXoMvjjO12rM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=TJvI5P29UyaPIgWW8I+Iw7ANEe1U6CmWXh7rdfTlCSfhJ3szTA/9NHZqbS7oLjDzVB7ciRsgXVWXK7W21wIsy3DUZbFrvMhKbfoiVLelY9sAyrftl95yTF7eIjxgpNGGGMb01mM2TK93j7pei+oebEe4ciGsjV9X6rj5IXtLou0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lcy/k/1k; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lcy/k/1k"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6a0c8283146so4156099a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 10:10:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788714626; cv=none;
        d=google.com; s=arc-20260327;
        b=po+bd2/QzQaOXI/syX2BBPlNeGwIJCF7CaJpcyuCS45rA/TjJ6z5jSXIcgdFnJAOmC
         yuyQglYn156myIPjSdBAl1GdKcIp2s3NxGllkcWnZNt1SZDhW6UvRE7n12BLJMLpp1+q
         2FWHb2dI4oaRnJV/7y24HSFJCSm2g/fH+u0PIY404pvnGWTdMMH0OxxjRL/y6ZH/vsME
         1s7xJLsXI+Q7LuTtBoT+ZnuY1GAM0p4E/lKEaha0SDYrZYa5J23caDYggSYVOLcIXX8h
         LgY2tm8aQKxIXk3dT1sIBQFfC6uGLJctuTW1Atv3eLh4/K8tGE2fl2zkQc0i6Kmf1ECM
         rmLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=fivbRIV9F3sA2+obiII4BuUq9auchksRabMC3bMsek4=;
        fh=69IOGyLbtOiUPuJ47XhFPJSR23ZkGu5xP2z8BrhaNto=;
        b=jfg3ARy1saLKtGtn3EFEfewrVBUoDWpsfBzNwE3jakTOUHinySGhd3d15RQzMmVwy8
         ZOxogtls0V0xJm/xkC7nLcIEcwV34k4nzsCfxivYeQOD1vNvbqDIYdvS1Co6rqhXTtrs
         LMm3Ic6QOUH3KB9uMBOHsDDGFXvKLq7c7A/mWr4/kLzNfo2Qjqw5XhIuedLUJlYd1n7i
         Q71azk5qOqAtVPLkscR1DU+2OBGB31iwLq17kPr6fXw7vC1HWNhR66G4DF/9n3o5sS/3
         HBaAbBDwMSkOfP3hJ1Kv42gIaNHFk517ZBqeqWZSEBAgPdk8abhIoO9N/CFvGK7H6QE/
         WVLA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788714626; x=1789319426; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fivbRIV9F3sA2+obiII4BuUq9auchksRabMC3bMsek4=;
        b=lcy/k/1kJX9BJf9AGGq5piUPpDceGrmPmFBxKUrCUf+zcAy8yVENIZRnPvJEG/n4tb
         rOoQoBYm5qqcXxuy3c1YC7F0K9lqyZS63XGWyMH8xlwOLCoqJ9ashBPT7TYPl/FNrP7W
         R89oKSjR6eP6oVyhqaTQCD3x5qo0hC963/LUmw7FOJF0SgXuMN/2XPY7glJkRzj2wmzI
         ts/hBYzoFFeZHlHylAMBL4iBSBfysAhu2e+8LBiD7qZzNRdejTdRiFfoS9BoRLmsv+Be
         KT/zaw93vWk8S587V+4N7JMt57BInqaFGh29PgLM/LFGbRyYQsiBuQFRo2LFLRvHU1mz
         DMJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788714626; x=1789319426;
        h=content-type:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fivbRIV9F3sA2+obiII4BuUq9auchksRabMC3bMsek4=;
        b=kU6fX2Weyy3Nl9Y8mgNbo46DIyJ3VOLanp4H6tHDPQaawQ761KVU1iVKBobmT+/5bF
         +a9uywBLDh7kAz8cBfprkFXf0bTTdVrSz23dSozRNmDOBS85gjcBIMEXHAl62RL6NzXY
         N23a5L0TlIoa+wS4azuQhTRecIURqizUHl90bYTtBT3NfVOvjAggH+uMTHuNAkS71y+Y
         GxQMWj2GL2ccSVRPpKPNP49VRgOi3IDsa959YUAFPUchpVAg/TPdrDHuDpE6asthydmX
         UbQSepqFkxqw8Dr6z9JKpq5D+TjAtNj7zCEqQg+w/vJxB9THrLO/Z+jxL+DTXqZVG6jB
         1oTQ==
X-Forwarded-Encrypted: i=1; AKwUvBwxMD9KE1f96gGNhAMTMltfAziXwRvoKT8jjlfMzMKtTJ5mukjRUtTFPVuH5g8j4jzxS0Nr8bnLK50Fz/Vx5A==@vger.kernel.org
X-Gm-Message-State: AFuF++mHvfayhIUxa5IlnqQ4FeryrKuj7YflryWhJzl+R9GLR0RgUno3
	xYndWdUvlk72DOG4O0S+Bh28jp43ECX2MqPukcCwus8j4Xf9EHZYfyin4T+GUIB07yMrdNsgcyq
	bLFbdN8tbyGHoyl3P6ScWHoXOSYabpSo=
X-Gm-Gg: AYBFou0IPXc6WZAgg7EmaIxj3YHj3P+5vVPVVyDUqeSPZqp6u/W4UH3lb+VWLocId14
	MVdu+LkAsvyNsksbPmPkY6OItOZ7e9T5rklp63uXVDiOas8qZN7yhMSIg8U2mubtbjP4mX69q0W
	UwruhzlBTmQTkyO1oJpWcCkMoU60KSrNuxfQDDd+U2DWmVgTwBmXPbR+1BxCAEgCF0MNu9ok6nO
	me1w5DmZKR4e/b24P9hv/aLGRlCLjvITSKbpssAGfGHwbYFFXgp7s/GN7mjZTq8HsQP7gjszyQr
	Gkc5Q3IkR+gaDxLDFGapVN2fhUM3eJSPjSIzj71Bmpkqp4nnempjyr0iZsvaIPD4DoWbJtHzATO
	l0MTXr5wBpm0Poc00SXx+
X-Received: by 2002:a05:6402:538d:b0:6a0:ffb0:273b with SMTP id
 4fb4d7f45d1cf-6a7e8cb1346mr5411057a12.0.1788714625502; Sun, 06 Sep 2026
 10:10:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMnMt5YMA70FJwH+ddo24Ejd8HbpFSgUv73Ybu-fu+F-gcoesQ@mail.gmail.com>
In-Reply-To: <CAMnMt5YMA70FJwH+ddo24Ejd8HbpFSgUv73Ybu-fu+F-gcoesQ@mail.gmail.com>
From: Herman Semenoff <germanaizek0@gmail.com>
Date: Sun, 6 Sep 2026 20:10:17 +0300
X-Gm-Features: AcwNN1VXTtuGEQ84iexSHIE7ObX1CHhpZMgUMkYX_Vj2dvKw3vvUbQHw3wdR13Y
Message-ID: <CAMnMt5Y_fL0cHQ1CjU9+vn0rZVO5eitL6h0dTQ5Wg48c68-yYg@mail.gmail.com>
Subject: [PATCH] wifi: mt7601u: add vnd_reset parameter to fix probe failure
 on Tenda U2
To: kuba@kernel.org, kvalo@kernel.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000dbcb90065ad39355"

--000000000000dbcb90065ad39355
Content-Type: multipart/alternative; boundary="000000000000dbcb8e065ad39353"

--000000000000dbcb8e065ad39353
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
-
https://www.reddit.com/r/archlinux/comments/1d6dfv5/mt7601u_usb_wifi_not_working/

Signed-off-by: Herman Semenoff <GermanAizek@aizekgroup.ru
<GermanAizek@yandex.ru>>
Signed-off-by: Herman Semenoff <GermanAizek@yandex.ru>
Signed-off-by: Herman Semenoff <germanaizek0@gmail.com
<GermanAizek@yandex.ru>>

--000000000000dbcb8e065ad39353
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>On certain MT7601U adapters, such as Tenda U2 and</di=
v><div>other newer hardware revisions, driver initialization consistently f=
ails</div><div>during probe with vendor request timeouts (-110 / -ETIMEDOUT=
):</div><div>=C2=A0 mt7601u 3-14:1.0: ASIC revision: <span>76010001</span> =
MAC revision: <span>76010500</span></div><div>=C2=A0 mt7601u 3-14:1.0: Firm=
ware Version: 0.1.00 Build: 7640 Build time: <span>201302052146</span>____<=
/div><div>=C2=A0 mt7601u 3-14:1.0: Vendor request req:07 off:09a8 failed:-1=
10</div><div>=C2=A0 mt7601u 3-14:1.0: Vendor request req:02 off:09a8 failed=
:-110</div><div>=C2=A0 mt7601u 3-14:1.0: Vendor request req:07 off:0734 fai=
led:-110</div><div>=C2=A0 mt7601u 3-14:1.0: Vendor request req:42 off:0230 =
failed:-110</div><div>=C2=A0 mt7601u 3-14:1.0: probe with driver mt7601u fa=
iled with error -110</div><div>=C2=A0</div><div>The failure occurs because =
mt7601u_load_firmware() unconditionally calls</div><div>mt7601u_vendor_rese=
t() (MT_VEND_DEV_MODE_RESET) before uploading firmware</div><div>chunks. On=
 these devices, issuing this vendor reset leaves the internal</div><div>MCU=
 / FCE DMA engine in an unresponsive state after the first firmware</div><d=
iv>URB is submitted. As a result, reading MT_TX_CPU_FROM_FCE_CPU_DESC_IDX</=
div><div>(0x09a8) immediately times out.</div><div>Introduce a boolean modu=
le parameter &#39;vnd_reset&#39; (default: false) to</div><div>make this ve=
ndor reset optional. When the vendor reset is skipped,</div><div>firmware u=
pload succeeds and the wireless interface initializes normally.</div><div>=
=C2=A0</div><div>Link: <a href=3D"https://bugs.launchpad.net/ubuntu/+source=
/linux/+bug/1716301" rel=3D"noopener noreferrer" target=3D"_blank">https://=
bugs.launchpad.net/ubuntu/+source/linux/+bug/1716301</a></div><div>=C2=A0</=
div><div>More issues with Tenda U2 and Linux:</div><div>- <a href=3D"https:=
//www.opena.tv/viewtopic.php?t=3D63919" rel=3D"noopener noreferrer" target=
=3D"_blank">https://www.opena.tv/viewtopic.php?t=3D63919</a></div><div>- <a=
 href=3D"https://askubuntu.com/questions/1418850/the-problem-with-wi-fi-u2"=
 rel=3D"noopener noreferrer" target=3D"_blank">https://askubuntu.com/questi=
ons/1418850/the-problem-with-wi-fi-u2</a></div><div>- <a href=3D"https://bb=
s.archlinux.org/viewtopic.php?id=3D224859" rel=3D"noopener noreferrer" targ=
et=3D"_blank">https://bbs.archlinux.org/viewtopic.php?id=3D224859</a></div>=
<div>- <a href=3D"https://www.reddit.com/r/archlinux/comments/1d6dfv5/mt760=
1u_usb_wifi_not_working/" rel=3D"noopener noreferrer" target=3D"_blank">htt=
ps://www.reddit.com/r/archlinux/comments/1d6dfv5/mt7601u_usb_wifi_not_worki=
ng/</a></div><div><br>Signed-off-by: Herman Semenoff &lt;<a href=3D"mailto:=
GermanAizek@yandex.ru" rel=3D"noopener noreferrer" target=3D"_blank">German=
Aizek@aizekgroup.ru</a>&gt;</div><div>Signed-off-by: Herman Semenoff &lt;<a=
 href=3D"mailto:GermanAizek@yandex.ru" rel=3D"noopener noreferrer" target=
=3D"_blank">GermanAizek@yandex.ru</a>&gt;<br>Signed-off-by: Herman Semenoff=
 &lt;<a href=3D"mailto:GermanAizek@yandex.ru" rel=3D"noopener noreferrer" t=
arget=3D"_blank">germanaizek0@gmail.com</a>&gt;</div><br></div>

--000000000000dbcb8e065ad39353--
--000000000000dbcb90065ad39355
Content-Type: application/x-patch; 
	name="0001-PATCH-wifi-mt7601u-add-vnd_reset-parameter-to-fix-pr.patch"
Content-Disposition: attachment; 
	filename="0001-PATCH-wifi-mt7601u-add-vnd_reset-parameter-to-fix-pr.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mtq2gtq80>
X-Attachment-Id: f_mtq2gtq80

RnJvbSBjMDNkNzNkMzdkZjQ0MGQwMDQ2ZDY4NDA2ZmRlMmFhMWY2MmZlMGQxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBIZXJtYW4gU2VtZW5vZmYgPEdlcm1hbkFpemVrQGFpemVrZ3Jv
dXAucnU+CkRhdGU6IFRodSwgMyBTZXAgMjAyNiAwNzoxNDozMiArMDMwMApTdWJqZWN0OiBbUEFU
Q0hdIFtQQVRDSF0gd2lmaTogbXQ3NjAxdTogYWRkIHZuZF9yZXNldCBwYXJhbWV0ZXIgdG8gZml4
IHByb2JlCiBmYWlsdXJlIG9uIFRlbmRhIFUyCgp3aWZpOiBtdDc2MDF1OiBhZGQgdm5kX3Jlc2V0
IHBhcmFtZXRlciB0byBmaXggcHJvYmUgZmFpbHVyZSBvbiBUZW5kYSBVMgoKT24gY2VydGFpbiBN
VDc2MDFVIGFkYXB0ZXJzLCBzdWNoIGFzIFRlbmRhIFUyIGFuZApvdGhlciBuZXdlciBoYXJkd2Fy
ZSByZXZpc2lvbnMsIGRyaXZlciBpbml0aWFsaXphdGlvbiBjb25zaXN0ZW50bHkgZmFpbHMKZHVy
aW5nIHByb2JlIHdpdGggdmVuZG9yIHJlcXVlc3QgdGltZW91dHMgKC0xMTAgLyAtRVRJTUVET1VU
KToKICBtdDc2MDF1IDMtMTQ6MS4wOiBBU0lDIHJldmlzaW9uOiA3NjAxMDAwMSBNQUMgcmV2aXNp
b246IDc2MDEwNTAwCiAgbXQ3NjAxdSAzLTE0OjEuMDogRmlybXdhcmUgVmVyc2lvbjogMC4xLjAw
IEJ1aWxkOiA3NjQwIEJ1aWxkIHRpbWU6IDIwMTMwMjA1MjE0Nl9fX18KICBtdDc2MDF1IDMtMTQ6
MS4wOiBWZW5kb3IgcmVxdWVzdCByZXE6MDcgb2ZmOjA5YTggZmFpbGVkOi0xMTAKICBtdDc2MDF1
IDMtMTQ6MS4wOiBWZW5kb3IgcmVxdWVzdCByZXE6MDIgb2ZmOjA5YTggZmFpbGVkOi0xMTAKICBt
dDc2MDF1IDMtMTQ6MS4wOiBWZW5kb3IgcmVxdWVzdCByZXE6MDcgb2ZmOjA3MzQgZmFpbGVkOi0x
MTAKICBtdDc2MDF1IDMtMTQ6MS4wOiBWZW5kb3IgcmVxdWVzdCByZXE6NDIgb2ZmOjAyMzAgZmFp
bGVkOi0xMTAKICBtdDc2MDF1IDMtMTQ6MS4wOiBwcm9iZSB3aXRoIGRyaXZlciBtdDc2MDF1IGZh
aWxlZCB3aXRoIGVycm9yIC0xMTAKClRoZSBmYWlsdXJlIG9jY3VycyBiZWNhdXNlIG10NzYwMXVf
bG9hZF9maXJtd2FyZSgpIHVuY29uZGl0aW9uYWxseSBjYWxscwptdDc2MDF1X3ZlbmRvcl9yZXNl
dCgpIChNVF9WRU5EX0RFVl9NT0RFX1JFU0VUKSBiZWZvcmUgdXBsb2FkaW5nIGZpcm13YXJlCmNo
dW5rcy4gT24gdGhlc2UgZGV2aWNlcywgaXNzdWluZyB0aGlzIHZlbmRvciByZXNldCBsZWF2ZXMg
dGhlIGludGVybmFsCk1DVSAvIEZDRSBETUEgZW5naW5lIGluIGFuIHVucmVzcG9uc2l2ZSBzdGF0
ZSBhZnRlciB0aGUgZmlyc3QgZmlybXdhcmUKVVJCIGlzIHN1Ym1pdHRlZC4gQXMgYSByZXN1bHQs
IHJlYWRpbmcgTVRfVFhfQ1BVX0ZST01fRkNFX0NQVV9ERVNDX0lEWAooMHgwOWE4KSBpbW1lZGlh
dGVseSB0aW1lcyBvdXQuCkludHJvZHVjZSBhIGJvb2xlYW4gbW9kdWxlIHBhcmFtZXRlciAndm5k
X3Jlc2V0JyAoZGVmYXVsdDogZmFsc2UpIHRvCm1ha2UgdGhpcyB2ZW5kb3IgcmVzZXQgb3B0aW9u
YWwuIFdoZW4gdGhlIHZlbmRvciByZXNldCBpcyBza2lwcGVkLApmaXJtd2FyZSB1cGxvYWQgc3Vj
Y2VlZHMgYW5kIHRoZSB3aXJlbGVzcyBpbnRlcmZhY2UgaW5pdGlhbGl6ZXMgbm9ybWFsbHkuCgpM
aW5rOiBodHRwczovL2J1Z3MubGF1bmNocGFkLm5ldC91YnVudHUvK3NvdXJjZS9saW51eC8rYnVn
LzE3MTYzMDEKCk1vcmUgaXNzdWVzIHdpdGggVGVuZGEgVTIgYW5kIExpbnV4OgotIGh0dHBzOi8v
d3d3Lm9wZW5hLnR2L3ZpZXd0b3BpYy5waHA/dD02MzkxOQotIGh0dHBzOi8vYXNrdWJ1bnR1LmNv
bS9xdWVzdGlvbnMvMTQxODg1MC90aGUtcHJvYmxlbS13aXRoLXdpLWZpLXUyCi0gaHR0cHM6Ly9i
YnMuYXJjaGxpbnV4Lm9yZy92aWV3dG9waWMucGhwP2lkPTIyNDg1OQotIGh0dHBzOi8vd3d3LnJl
ZGRpdC5jb20vci9hcmNobGludXgvY29tbWVudHMvMWQ2ZGZ2NS9tdDc2MDF1X3VzYl93aWZpX25v
dF93b3JraW5nLwoKU2lnbmVkLW9mZi1ieTogSGVybWFuIFNlbWVub2ZmIDxHZXJtYW5BaXpla0Bh
aXpla2dyb3VwLnJ1PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL21lZGlhdGVrL210NzYwMXUv
bWN1LmMgfCAxNSArKysrKysrKysrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21l
ZGlhdGVrL210NzYwMXUvbWN1LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2
MDF1L21jdS5jCmluZGV4IGJhZDZjYTgyMS4uYWJmNDc2N2YxIDEwMDY0NAotLS0gYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2MDF1L21jdS5jCisrKyBiL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL21lZGlhdGVrL210NzYwMXUvbWN1LmMKQEAgLTEwLDYgKzEwLDcgQEAKICNpbmNsdWRl
IDxsaW51eC9kZWxheS5oPgogI2luY2x1ZGUgPGxpbnV4L3VzYi5oPgogI2luY2x1ZGUgPGxpbnV4
L3NrYnVmZi5oPgorI2luY2x1ZGUgPGxpbnV4L21vZHVsZXBhcmFtLmg+CiAKICNpbmNsdWRlICJt
dDc2MDF1LmgiCiAjaW5jbHVkZSAiZG1hLmgiCkBAIC0yMSw2ICsyMiwxNCBAQAogI2RlZmluZSBN
Q1VfRldfVVJCX1NJWkUJCQkoTUNVX0ZXX1VSQl9NQVhfUEFZTE9BRCArIDEyKQogI2RlZmluZSBN
Q1VfUkVTUF9VUkJfU0laRQkJMTAyNAogCitzdGF0aWMgYm9vbCB2bmRfcmVzZXQ7Cittb2R1bGVf
cGFyYW0odm5kX3Jlc2V0LCBib29sLCAwNjQ0KTsKK01PRFVMRV9QQVJNX0RFU0Modm5kX3Jlc2V0
LCAiUGVyZm9ybSB2ZW5kb3IgcmVzZXQgZHVyaW5nIGZpcm13YXJlIHVwbG9hZCAoZGVmYXVsdDog
ZmFsc2UpIik7CisKK3N0YXRpYyBib29sIGRpc2FibGVfdXNiX3NnOworbW9kdWxlX3BhcmFtKGRp
c2FibGVfdXNiX3NnLCBib29sLCAwNjQ0KTsKK01PRFVMRV9QQVJNX0RFU0MoZGlzYWJsZV91c2Jf
c2csICJVbnVzZWQgY29tcGF0aWJpbGl0eSBwYXJhbWV0ZXIiKTsKKwogc3RhdGljIGlubGluZSBp
bnQgZmlybXdhcmVfcnVubmluZyhzdHJ1Y3QgbXQ3NjAxdV9kZXYgKmRldikKIHsKIAlyZXR1cm4g
bXQ3NjAxdV9ycihkZXYsIE1UX01DVV9DT01fUkVHMCkgPT0gMTsKQEAgLTQ1OSw4ICs0NjgsMTAg
QEAgc3RhdGljIGludCBtdDc2MDF1X2xvYWRfZmlybXdhcmUoc3RydWN0IG10NzYwMXVfZGV2ICpk
ZXYpCiAJbXQ3NjAxdV93cihkZXYsIDB4OTRjLCAwKTsKIAltdDc2MDF1X3dyKGRldiwgTVRfRkNF
X1BTRV9DVFJMLCAwKTsKIAotCW10NzYwMXVfdmVuZG9yX3Jlc2V0KGRldik7Ci0JbXNsZWVwKDUp
OworCWlmICh2bmRfcmVzZXQpIHsKKwkJbXQ3NjAxdV92ZW5kb3JfcmVzZXQoZGV2KTsKKwkJbXNs
ZWVwKDUpOworCX0KIAogCW10NzYwMXVfd3IoZGV2LCAweGE0NCwgMCk7CiAJbXQ3NjAxdV93cihk
ZXYsIDB4MjMwLCAweDg0MjEwKTsKLS0gCjIuNTUuMAoK
--000000000000dbcb90065ad39355--
