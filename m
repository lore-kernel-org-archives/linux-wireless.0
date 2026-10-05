Received: from forward101a.mail.yandex.net (forward101a.mail.yandex.net [178.154.239.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFB32931C3
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 08:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791190075; cv=none; b=gCmWs1DBP9TYHPuVY9xV5tq2VxQnz9p2omSr8Z1LJOGU5n2vs32jbfoK7vASrSEim7qnuRH69y68cXbrfe88Dc1sKNvYjVvKKpVX+Kr+/W4TvoHp7YJzZ7SLhbHagPoXcvhegeqAlLcPN4VFIfeOwXvrrCrhTZhKP7ejS5LumM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791190075; c=relaxed/simple;
	bh=y66mAkGFtYumwXbasGAwLTGZ9g9v/epVA9CiizSsOOc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S4SR+cteY7NJhV3ylUa8xK9r/bm10/+P6FhD5dVfa0l8U2TFTOFty6rbUJCeUP/dYva2pR+VwO1giLiqOsD23MdRIh6CJwUyHTD/k7vo8/gdnHmbfot0qBgBbvtVAz2egLtzP2Bh3Bh0k4hOj+TkgMzlLRu5J7fyyjCrCMRAOVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=FQoVvVyg; arc=none smtp.client-ip=178.154.239.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="FQoVvVyg"
Received: from mail-nwsmtp-smtp-production-main-95.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-95.vla.yp-c.yandex.net [IPv6:2a02:6b8:c15:340d:0:640:ad51:0])
	by forward101a.mail.yandex.net (postfix) with ESMTPS id B387681587;
	Mon, 05 Oct 2026 11:47:43 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-95.vla.yp-c.yandex.net (smtp) with ESMTPSA id blGMiWmlcCg0-tMk8ytWj;
	Mon, 05 Oct 2026 11:47:43 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1791190063; bh=y66mAkGFtYumwXbasGAwLTGZ9g9v/epVA9CiizSsOOc=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=FQoVvVygO7oVZXIRScgdhan8tiYf2Hbp/8FfZsm8pt1cI37BsHMCaOecZGfM640KQ
	 FM2jiy5UxwYnuiiosyVEZwpnledl7CWc8L+9PH/zWHtlnGBsjdY5XHRFgIHJalMadR
	 sBRN5JxdVX61OmOyFhgEq4oAzvM1FlVux5mQWXHM=
Authentication-Results: mail-nwsmtp-smtp-production-main-95.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: dolph-in@yandex.ru
To: Michele Dionisio <michele.dionisio@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>, linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH wireless 1/1] wifi: brcmfmac: fix P2P device removal race in brcmf_detach()
Date: Mon, 05 Oct 2026 15:47:27 +0700
Message-ID: <_Omamail_GwNDiHfr-hNonI6e5s0RUw.omamail@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64

SGkgTWljaGVsZSwKCkkgcmFuIGludG8gdGhlIHNhbWUgY3Jhc2ggb24gYSBQQ0llIGNhcmQsIHNv
IGhlcmUgaXMgc29tZSB0ZXN0aW5nIGZyb20KdGhlIGhhcmR3YXJlIHNpZGUuCgpUaGlzIGlzIGEg
TWFjQm9va1BybzE0LDMgKDIwMTcpIHdpdGggYSBCQ000MzYwMiwgeDg2XzY0LCBrZXJuZWwgNy4y
LjUuCkZvciBzbGVlcCBvbiB0aGlzIG1hY2hpbmUgSSB1c2UgYSBob29rIHRoYXQgdW5iaW5kcyB0
aGUgZGV2aWNlIGZyb20KYnJjbWZtYWMgYmVmb3JlIHMyaWRsZSBhbmQgcmViaW5kcyBpdCBvbiBy
ZXN1bWUuIHdwYV9zdXBwbGljYW50ICh1bmRlcgpOZXR3b3JrTWFuYWdlcikgaGFzIGEgUDJQIGRl
dmljZSBvbiBpdC4gV2l0aCB0aGUgc3RvY2sgbW9kdWxlLCB0aGUKc2Vjb25kIHN1c3BlbmQgY3Jh
c2hlZCB3aXRoIHRoZSBzYW1lIEdQRiBhdCAweGRlYWQwMDAwMDAwMDAxMjI6CgogIF9jZmc4MDIx
MV91bnJlZ2lzdGVyX3dkZXYKICBicmNtZl9wMnBfaWZwX3JlbW92ZWQKICBicmNtZl9yZW1vdmVf
aW50ZXJmYWNlCiAgYnJjbWZfZGV0YWNoCiAgYnJjbWZfcGNpZV9yZW1vdmUKCllvdXIgcGF0Y2gg
YXBwbGllcyB0byA3LjIuNSB3aXRoIGEgc21hbGwgb2Zmc2V0LiBJIGJ1aWx0IGJyY21mbWFjIHdp
dGgKaXQgYW5kIGxldCB0aGUgbWFjaGluZSBzdXNwZW5kIGFuZCB3YWtlIHVwIGJ5IGl0c2VsZiAo
cnRjd2FrZSkgMzAKdGltZXMuIEkgYWxzbyBhZGRlZCBhIGNvdXBsZSBvZiB0ZW1wb3JhcnkgcHJp
bnRzIHRvIHRoZSBuZXcgYnJhbmNoIGluCmJyY21mX2RldGFjaCgpLCBiZWNhdXNlIEkgd2FudGVk
IHRvIHNlZSB0aGUgcmFjZSBhY3R1YWxseSBoYXBwZW4sIG5vdApqdXN0IGEgcnVuIG9mIGx1Y2t5
IGN5Y2xlcy4KCkl0IGhhcHBlbmVkIDMgdGltZXMgb3V0IG9mIDMwLiBFYWNoIHRpbWUgYnJjbWZf
ZGV0YWNoKCkgc2F0IG9uIHRoZQpsb2NrcyBmb3IgYWJvdXQgMS41IHMgKHRoYXQncyB0aGUgQlJD
TUZfVklGX0VWRU5UX1RJTUVPVVQgd2FpdCBpbgpicmNtZl9wMnBfZGVsX3ZpZigpKSwgYnJjbWZf
cDJwX2RlbF92aWYoKSByZW1vdmVkIHRoZSBQMlAgaW50ZXJmYWNlLAphbmQgdGhlbiBicmNtZl9k
ZXRhY2goKSBmb3VuZCBpZmxpc3RbaV0gYWxyZWFkeSBOVUxMIGFuZCBza2lwcGVkIGl0LgpJbiA3
IG1vcmUgY3ljbGVzIHRoZXJlIHdhcyBub3RoaW5nIHRvIHdhaXQgZm9yIGFuZCBicmNtZl9kZXRh
Y2goKQpyZW1vdmVkIHRoZSBpbnRlcmZhY2UgaXRzZWxmLiBObyBvb3BzIGFuZCBubyBsaXN0IG9y
IHJlZmNvdW50Cndhcm5pbmdzIGFueXdoZXJlIGluIHRoZSBydW4sIGFuZCBXaS1GaSByZWNvbm5l
Y3RlZCBmaW5lIGFmdGVyd2FyZHMuCgpUZXN0ZWQtYnk6IFNlcmdleSBBcm1vZGluIDxkb2xwaC1p
bkB5YW5kZXgucnU+CgpUaGFua3MgZm9yIGZpeGluZyB0aGlzIQoKU2VyZ2V5
