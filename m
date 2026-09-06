Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1C82765DF
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 20:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788725880; cv=pass; b=g7wpp++4M2GvdSwanZjwOYrxHaKubi1KujpgaWrGLZwj6Vqv9ibOagNh3FPQkPK7jJ5FooStvTy9BI3qhZSX0BoU7oa8cwK52cMvHJkzvptWYKIzY6V0XQm18Rfc9EKCSle3Qyf3JdXVv1tzQVd5ALEjCAMyHPtankE7fwkYGHc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788725880; c=relaxed/simple;
	bh=lyXZlgCF7BVVftsLxxxPxTCVdlePvzDal2dJg3r7ohA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=P4ww9q0as9sc1XGt0tSooCYxMTXADBPfgxfItNMbPD6AwhjjRNUE1y90tTXqtrtov/tPhj2Z2Zgg0x4EyRsKYHoSyeykr/1nikpQNcB+PXsa/FWOfVahqmLFSbnLzLPloZvfuDcBHuyfXqbmQ7EhwRt/59zDLn1kZo++4dG7Qv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZuTZV0Vf; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZuTZV0Vf"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a68aaf4840so5756648a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 13:17:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788725877; cv=none;
        d=google.com; s=arc-20260327;
        b=ljyTdWs2dHMGouLhC+6qGZ330oUcp79NqZR/ANqLs8ttpvlk5SrdJZM7h1VeGGi/fP
         FwGQ/0jQGwwWMhBTlF+G6BYZcoizoZjZIW2lBCkJIxfBDPfqevvI63oEKhaH3lSfHwPV
         0VxNbL+J/wUZDF59ESsgH3nt7O1J+gRQi5XB2IWiJYJkpYG+ErHWDI2BveDI90QfVu7F
         E8rN3VepinfDT5VaPuGD5eT3SZoRYyRgV3uMhBU9VB6qzIAclH+WF1h0ADb5WYnHKxcm
         UEy1vS4D42scva3P+9rvkKthLsOD2B/vKaoMn89cOJhheuZdyQKgqTO0Yx27shsRg9gR
         mH4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=jAjjI82aHAkhJLWmgT8McMk47izfFq2ietX96dnVZrs=;
        fh=Ayi9llIzWiSEioA3S6uDFjG86nUBIAWAKzE4kQSsHqM=;
        b=h3xE0T/MI72sdaX1oot1KHv+ADeiPjKcn3JW3qLd1QrTulYl6Cwc1Res0Ew6HoDGyg
         c9wFvKAOikXZELMs1dfEmcF59ARfhF9mdcdO1jhXvlb013gzUBGBXP85131KBPW0dhh8
         677wGzZlWg6HqUGMSMeWa1nTwhOiCQt/hT8unbUfvp9BRFznnVCZsa1ko3KI6Qpw7VpS
         hsNrjmowDElGH3RuHTN3JW2EmbjnTBqcDZHeoXmoKiZNDgzV4trGwTVl0cMpYuiSK7ad
         67fEZ/B/sQVzyGXSf6Hd3g7ziTMdpP7TiS7zdEcB9d7ZSi1rksyJP13oy///67A1Zbzi
         tNEA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788725877; x=1789330677; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=jAjjI82aHAkhJLWmgT8McMk47izfFq2ietX96dnVZrs=;
        b=ZuTZV0VfNnpoDbMTSLCwdxY7CSnsbkMH7Hy7t8NPiZMIxI320ZGS/EmfZegkARsaeX
         Wr9kvmxG7hY0QdLnX2PThhAkCNHtvDMWleFyWSHUvvkxzT+Vp6kn0f0FPh01toPAQZ00
         4Mps6kDHnjE5CbLavzPp4ZhNQvtji4OnydCWKpojWlNwY0T3W1tBnboYWku6p1e0ZFPb
         HSTwkrkScFeUl4pTKFXNVLLXGfV5rpU6c/hlKG5VFAgOwadOlhqmZBGwpfyCsocOcGSC
         vbgjt8djm/sVfjK087WRtpLc9BNWDqoje8RqH4GS63HcXqpCT1DAjssfgfU/aE4ausu1
         Zziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788725877; x=1789330677;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jAjjI82aHAkhJLWmgT8McMk47izfFq2ietX96dnVZrs=;
        b=pfhdKS4j6JWovf8CFWfG/Ey4d3hr0nM5uOY4+eLZ38AJirAL/i/bzg3aC5FJqlqUd9
         We+c5KPFKRIW927IZcJVkvfUki6BiMLovWNo4tKJwBxVNSmmt+GGF3YF7ENvrAm60dKR
         SabDYTWc9f+6oQl7pU1hw7EPnDQBQnMotg1h8xhK4JknWPcXJ1ebJaS7CdP/EcvOiL6Z
         OveLWCx84vkvD0DUm6ugIaXr+xbHUWVivPDpJ0fv74fqHO9b7ffSc+qnFkmhWp5gt/uC
         S5ai4ctK4B2vQnHQEmleIV5pNlgnwQ2I0dE3ZlZi99VwrELBIN3DUPW9K4JUoIowNI9p
         J2wg==
X-Forwarded-Encrypted: i=1; AKwUvBwXg1mSg+Db1TPhPIXkBFkLvKZxlNpEbJxXgAiwBiV3SiHD3Fj1iJ+GUUASQ9raZJ+C25jWeDfWCSKVJLbYrA==@vger.kernel.org
X-Gm-Message-State: AFuF++loWtOhUxc5rLwZH8bbjM9MphEv60agZ0mHWcq1TtBEq5w6KAxH
	QzbjAjeTeNliQSAYUvAi58opzqh2O0hsrUVBRwj2cs/wAjXkEnBLacHq27QVjxrlMv39UDmSOXA
	0s3AzHicPBE2QRDrLWzOfdNqkfx/ZWYQ=
X-Gm-Gg: AYBFou295h/IExDXc+ovvNzyS7SaxsW/GY6JC0NK0JIEvqrGTxZ9/Fslegbf/xFdwNk
	fNhUKUQ4dMA46Y8UM7DW7zvNaRsStrnap0cws8tseRQqiDtoK/FAq+oTnVtKlE/4WkE+IW8LEL2
	MMBJDch0rBy823uorzcABfptl2XGkClfs2UjZ1l/nzavxsbzWcYefQ3UP7ftyacU/RDRKb6zI2a
	h0ut4u2ORsbZ//MvtP1YEmwRVWTgclfZvYJxlfuxOkRUoTIQL3zctFIyNpxbv39ca7zi2GTPBir
	2t59PvkhLMZcRxP8DhhG5fhb9/KWnfDwbNMnKq2Zn2XKycDdKWGz4BoWF12W6Su5VtyBvfvphA/
	sk1Quyt2DywZyX0BeUKsniCekjWwydS8=
X-Received: by 2002:a05:6402:270c:b0:6a6:b2b9:61f9 with SMTP id
 4fb4d7f45d1cf-6a7e9520211mr5863212a12.13.1788725876598; Sun, 06 Sep 2026
 13:17:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Herman Semenoff <germanaizek0@gmail.com>
Date: Sun, 6 Sep 2026 23:17:49 +0300
X-Gm-Features: AcwNN1XfTsYgOA2Z4O3BMhk2THXD-qKeJZKhwUVDjUFQUKn_MheadpRHqWnnvq0
Message-ID: <CAMnMt5bJr68_YMH5nA6Z7TvsjpHF674U8CBTCwME4vtgaVJ9cA@mail.gmail.com>
Subject: [PATCH wireless-next] wifi: mt7601u: add vnd_reset parameter to fix
 probe failure on Tenda U2
To: kuba@kernel.org, kvalo@kernel.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000079f912065ad632a1"

--00000000000079f912065ad632a1
Content-Type: text/plain; charset="UTF-8"



--00000000000079f912065ad632a1
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-PATCH-wifi-mt7601u-add-vnd_reset-parameter-to-fix-pr.patch"
Content-Disposition: attachment; 
	filename="0001-PATCH-wifi-mt7601u-add-vnd_reset-parameter-to-fix-pr.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mtq970e40>
X-Attachment-Id: f_mtq970e40

RnJvbSBjMDNkNzNkMzdkZjQ0MGQwMDQ2ZDY4NDA2ZmRlMmFhMWY2MmZlMGQxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBIZXJtYW4gU2VtZW5vZmYgPEdlcm1hbkFpemVrQGFpemVrZ3Jv
dXAucnU+CkRhdGU6IFRodSwgMyBTZXAgMjAyNiAwNzoxNDozMiArMDMwMApTdWJqZWN0OiBbUEFU
Q0ggd2lyZWxlc3MtbmV4dF0gd2lmaTogbXQ3NjAxdTogYWRkIHZuZF9yZXNldCBwYXJhbWV0ZXIg
dG8gZml4IHByb2JlIGZhaWx1cmUgb24gVGVuZGEgVTIKCk9uIGNlcnRhaW4gTVQ3NjAxVSBhZGFw
dGVycywgc3VjaCBhcyBUZW5kYSBVMiBhbmQgb3RoZXIgbmV3ZXIgaGFyZHdhcmUKcmV2aXNpb25z
LCBkcml2ZXIgaW5pdGlhbGl6YXRpb24gY29uc2lzdGVudGx5IGZhaWxzIGR1cmluZyBwcm9iZSB3
aXRoCnZlbmRvciByZXF1ZXN0IHRpbWVvdXRzICgtMTEwIC8gLUVUSU1FRE9VVCk6CgogICAgbXQ3
NjAxdSAzLTE0OjEuMDogQVNJQyByZXZpc2lvbjogNzYwMTAwMDEgTUFDIHJldmlzaW9uOiA3NjAx
MDUwMAogICAgbXQ3NjAxdSAzLTE0OjEuMDogRmlybXdhcmUgVmVyc2lvbjogMC4xLjAwIEJ1aWxk
OiA3NjQwCiAgICBtdDc2MDF1IDMtMTQ6MS4wOiBWZW5kb3IgcmVxdWVzdCByZXE6MDcgb2ZmOjA5
YTggZmFpbGVkOi0xMTAKICAgIG10NzYwMXUgMy0xNDoxLjA6IFZlbmRvciByZXF1ZXN0IHJlcTow
MiBvZmY6MDlhOCBmYWlsZWQ6LTExMAogICAgbXQ3NjAxdSAzLTE0OjEuMDogVmVuZG9yIHJlcXVl
c3QgcmVxOjA3IG9mZjowNzM0IGZhaWxlZDotMTEwCiAgICBtdDc2MDF1IDMtMTQ6MS4wOiBWZW5k
b3IgcmVxdWVzdCByZXE6NDIgb2ZmOjAyMzAgZmFpbGVkOi0xMTAKICAgIG10NzYwMXUgMy0xNDox
LjA6IHByb2JlIHdpdGggZHJpdmVyIG10NzYwMXUgZmFpbGVkIHdpdGggZXJyb3IgLTExMAoKVGhl
IGZhaWx1cmUgb2NjdXJzIGJlY2F1c2UgbXQ3NjAxdV9sb2FkX2Zpcm13YXJlKCkgdW5jb25kaXRp
b25hbGx5IGNhbGxzCm10NzYwMXVfdmVuZG9yX3Jlc2V0KCkgKE1UX1ZFTkRfREVWX01PREVfUkVT
RVQpIGJlZm9yZSB1cGxvYWRpbmcgZmlybXdhcmUKY2h1bmtzLiBPbiB0aGVzZSBkZXZpY2VzLCBp
c3N1aW5nIHRoaXMgdmVuZG9yIHJlc2V0IGxlYXZlcyB0aGUgaW50ZXJuYWwKTUNVIC8gRkNFIERN
QSBlbmdpbmUgaW4gYW4gdW5yZXNwb25zaXZlIHN0YXRlIGFmdGVyIHRoZSBmaXJzdCBmaXJtd2Fy
ZQpVUkIgaXMgc3VibWl0dGVkLiBBcyBhIHJlc3VsdCwgcmVhZGluZyBNVF9UWF9DUFVfRlJPTV9G
Q0VfQ1BVX0RFU0NfSURYCigweDA5YTgpIGltbWVkaWF0ZWx5IHRpbWVzIG91dC4KCkludHJvZHVj
ZSBhIGJvb2xlYW4gbW9kdWxlIHBhcmFtZXRlciAndm5kX3Jlc2V0JyAoZGVmYXVsdDogZmFsc2Up
IHRvCm1ha2UgdGhpcyB2ZW5kb3IgcmVzZXQgb3B0aW9uYWwuIFdoZW4gdGhlIHZlbmRvciByZXNl
dCBpcyBza2lwcGVkLApmaXJtd2FyZSB1cGxvYWQgc3VjY2VlZHMgYW5kIHRoZSB3aXJlbGVzcyBp
bnRlcmZhY2UgaW5pdGlhbGl6ZXMgbm9ybWFsbHkuCgpMaW5rOiBodHRwczovL2J1Z3MubGF1bmNo
cGFkLm5ldC91YnVudHUvK3NvdXJjZS9saW51eC8rYnVnLzE3MTYzMDEKTGluazogaHR0cHM6Ly93
d3cub3BlbmEudHYvdmlld3RvcGljLnBocD90PTYzOTE5Ckxpbms6IGh0dHBzOi8vYXNrdWJ1bnR1
LmNvbS9xdWVzdGlvbnMvMTQxODg1MC90aGUtcHJvYmxlbS13aXRoLXdpLWZpLXUyCkxpbms6IGh0
dHBzOi8vYmJzLmFyY2hsaW51eC5vcmcvdmlld3RvcGljLnBocD9pZD0yMjQ4NTkKTGluazogaHR0
cHM6Ly9yZWRkaXQuY29tL3IvYXJjaGxpbnV4L2NvbW1lbnRzLzFkNmRmdjUvbXQ3NjAxdV91c2Jf
d2lmaV9ub3Rfd29ya2luZy8KU2lnbmVkLW9mZi1ieTogSGVybWFuIFNlbWVub2ZmIDxHZXJtYW5B
aXpla0BhaXpla2dyb3VwLnJ1PgotLS0KVGhpcyBwYXRjaCBpcyBiYXNlZCBvbiBsaW51eC1uZXh0
ICh0YWc6IG5leHQtMjAyNjA5MDQsIGNvbW1pdCBhZjVmMTI4MDVlNWMpCmFuZCB0YXJnZXRzIHRo
ZSB3aXJlbGVzcy1uZXh0IHRyZWUuCgpOb3RlOiBBbHRlcm5hdGl2ZWx5LCBpZiBtYWludGFpbmVy
cyBwcmVmZXIgdG8gYXZvaWQgYWRkaW5nIGEgbW9kdWxlCnBhcmFtZXRlciBhbmQgY2FuIGNvbmZp
cm0gdGhhdCBtdDc2MDF1X3ZlbmRvcl9yZXNldCgpIGlzIG5vdCByZXF1aXJlZApvbiBhbnkgc3Vw
cG9ydGVkIGhhcmR3YXJlLCB0aGUgdmVuZG9yIHJlc2V0IGNhbGwgY291bGQgaW5zdGVhZCBiZSBk
cm9wcGVkCmVudGlyZWx5LgoKIGRyaXZlcnMvbmV0L3dpcmVsZXNzL21lZGlhdGVrL210NzYwMXUv
bWN1LmMgfCAxMSArKysrKysrKystLQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9tZWRpYXRl
ay9tdDc2MDF1L21jdS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3NjAxdS9t
Y3UuYwppbmRleCBiYWQ2Y2E4MjE0MDAuLmM3YzViZDliYjlkZiAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3NjAxdS9tY3UuYworKysgYi9kcml2ZXJzL25ldC93
aXJlbGVzcy9tZWRpYXRlay9tdDc2MDF1L21jdS5jCkBAIC0xMCw2ICsxMCw3IEBACiAjaW5jbHVk
ZSA8bGludXgvZGVsYXkuaD4KICNpbmNsdWRlIDxsaW51eC91c2IuaD4KICNpbmNsdWRlIDxsaW51
eC9za2J1ZmYuaD4KKyNpbmNsdWRlIDxsaW51eC9tb2R1bGVwYXJhbS5oPgogCiAjaW5jbHVkZSAi
bXQ3NjAxdS5oIgogI2luY2x1ZGUgImRtYS5oIgpAQCAtMjEsNiArMjIsMTAgQEAKICNkZWZpbmUg
TUNVX0ZXX1VSQl9TSVpFCQkJKE1DVV9GV19VUkJfTUFYX1BBWUxPQUQgKyAxMikKICNkZWZpbmUg
TUNVX1JFU1BfVVJCX1NJWkUJCTEwMjQKIAorc3RhdGljIGJvb2wgdm5kX3Jlc2V0OworbW9kdWxl
X3BhcmFtKHZuZF9yZXNldCwgYm9vbCwgMDY0NCk7CitNT0RVTEVfUEFSTV9ERVNDKHZuZF9yZXNl
dCwgIlBlcmZvcm0gdmVuZG9yIHJlc2V0IGR1cmluZyBmaXJtd2FyZSB1cGxvYWQgKGRlZmF1bHQ6
IGZhbHNlKSIpOworCiBzdGF0aWMgaW5saW5lIGludCBmaXJtd2FyZV9ydW5uaW5nKHN0cnVjdCBt
dDc2MDF1X2RldiAqZGV2KQogewogCXJldHVybiBtdDc2MDF1X3JyKGRldiwgTVRfTUNVX0NPTV9S
RUcwKSA9PSAxOwpAQCAtNDU5LDggKzQ2NCwxMCBAQCBzdGF0aWMgaW50IG10NzYwMXVfbG9hZF9m
aXJtd2FyZShzdHJ1Y3QgbXQ3NjAxdV9kZXYgKmRldikKIAltdDc2MDF1X3dyKGRldiwgMHg5NGMs
IDApOwogCW10NzYwMXVfd3IoZGV2LCBNVF9GQ0VfUFNFX0NUUkwsIDApOwogCi0JbXQ3NjAxdV92
ZW5kb3JfcmVzZXQoZGV2KTsKLQltc2xlZXAoNSk7CisJaWYgKHZuZF9yZXNldCkgeworCQltdDc2
MDF1X3ZlbmRvcl9yZXNldChkZXYpOworCQl1c2xlZXBfcmFuZ2UoNTAwMCwgMTAwMDApOworCX0K
IAogCW10NzYwMXVfd3IoZGV2LCAweGE0NCwgMCk7CiAJbXQ3NjAxdV93cihkZXYsIDB4MjMwLCAw
eDg0MjEwKTsKLS0gCjIuNTUuMAoKYmFzZS1jb21taXQ6IGFmNWYxMjgwNWU1Y2VmYTRmZTY4ZDYx
MjdjN2UxZmI3OGNkNTUzNWMK
--00000000000079f912065ad632a1--
