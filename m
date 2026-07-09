Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9364331EAD
	for <linux-wireless@vger.kernel.org>; Thu,  9 Jul 2026 13:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783604640; cv=pass; b=NJqNmRMgusVdiFiprTEOTcVkSJfll5A1QIONm6OYZym0HGNKRhTw8oPwt2DNWFvtngcXMdVXANzGxUwkVWd/n+X5BMuYYWc3Cd9wiU3+V1gOHKlURO9L6HY9jJ4x9iXvXleh9jvfjcASBs6M41vW8td+CthTn73a2TgCQU1+ds4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783604640; c=relaxed/simple;
	bh=9KMXbwrUitUgT7b1ibd8ZVqYBr0HN+FQnXm3Jhryfes=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=X9SSWA8zwJb1MeSaIgzxArVDMgN6jwJjUvBNREfPA6tidzNtFACJeRFhvJXm5hogQzxocxZHRea90H2RLoo5PqFueS66Gyyz8m3beF06e+RYybqWKGCUH44BVKR4XbEsdSV5inmUYd6iDjM+pGlHpYTLWCBUOvXbznNu6a+B8Qk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aurora.tech; spf=pass smtp.mailfrom=aurora.tech; dkim=pass (2048-bit key) header.d=aurora.tech header.i=@aurora.tech header.b=kn+uMbYE; arc=pass smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aurora.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aurora.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aurora.tech header.i=@aurora.tech header.b="kn+uMbYE"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-ca00f126b7eso1097309a12.2
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2026 06:43:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783604638; cv=none;
        d=google.com; s=arc-20260327;
        b=HCyLPer7DqHtmJBP1+96maGCbpOkSwQrkNL7Sk+JOjbhAkQcyW9izMp5WwpqgulxfN
         gKXeatTd21gzoDMq96hlRJG9YnxKU1qYypLEBqZwTd50vF4dGMeaDOvauZs3Hjc3ENY+
         PR1kGdr6Wrvd8YYHWRpyQ+9BIwAiP+Jxss28KQOMmoOdNaXLN9noZtVzcXJYZEtpgn2D
         UMybSub5dkJRXnAZlIIh2b9Zei/AFfR+XSMQNGw+oZn6aVbvL7i8XwPfcP2QByN6itIf
         PCfdtN2OJd4SCTgzmVtZos0g9Auf8AxBn2Qb7f3cbkyCEqYDuYFgTlccvz6HqwdtKF/h
         9csQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=E4lslf+9nyxKJLQMGZQQVOR9X6zmmYU3kFQcQgDDQz4=;
        fh=qW0phhq3fb3oiohK/Mu9j1KY1zyRNiiioKFc5anvatM=;
        b=Y+dUs7UihoIklpZj2j2YlsTvc3jqzzw1wPWzGDRHSivmdJbCjgtl3H12g41U6kh6VV
         rAS4kTTClbAVyeR5k4Xwch9qJP63prQcUQrvZm3XZvWlf4ZpaaHS/xMJEZljwQELhSDv
         SDGU/vcPkPpqVmI3Fk9qLj3sdaI3S6c28/e+Sm883MA6aEAAXpfvaEUiQ7sCbrRrj4QG
         ABf7re05hwjgCizUoVHX+JzvnBt7M79jjh1nSFaAVtMl3R59Kui0vSAM9EqcWau2Am82
         2eNGcRos+59BmxxwHBtP0tXHnnLLNCbiXH0XrVymJpTGuKvC/wGCNvBzcOy7faSfsUMl
         Al/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aurora.tech; s=google; t=1783604638; x=1784209438; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=E4lslf+9nyxKJLQMGZQQVOR9X6zmmYU3kFQcQgDDQz4=;
        b=kn+uMbYEjDPfSWiA8AZ/DpFFSueZue0Kb5lP/3Kcd70tyIygnQWne6KnRNRL58d4Kw
         h0wyhjDi9KeDKiYPYgKnG6bxcgnIQy931Cj6MrBTaeNCo01Gw+f9SnspNCwq+Hm3gMvv
         cVZ69Pxx9exRDX/b5ceRlAogPDSQvI7U2Bum4O3WyHWUZgEtA5DVYou1zW84uYCuXZQQ
         S0AtX8u/Gcwrvb0fZ0pEpkbrbzdzAL0tw67Ve4DvBQQ0MNhTz3zwco5qnuThRhUvb7ln
         TZz/SMf/scKGjL/myalbFh6EakjFVXXlZSNJJajvM6yLxBTzK6pfOUYhmd5lAtuiWj3G
         aQ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783604638; x=1784209438;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E4lslf+9nyxKJLQMGZQQVOR9X6zmmYU3kFQcQgDDQz4=;
        b=UwV7/by5c3fVVZc2uwhJcro8YhaF+g7oAEXIlAKY/LJ16ntUvh8jamUhnQNFaiXZyE
         3nko5Uc3v02pwZgkT2j4olzkmNuV4UnkpLt9ovkw8zjOJr31ZIKqhhLU9RCtq07CrtyR
         8cXtGS7jc4owtM1Z7Qd203HXKzD+RM7xrYhAce0RWto0UjRlageyO06C6fP2aU8x06y7
         KqBt0rQguLLImAtAazXpSgYWzVKWBX89Q0VriUmkg4wAPc0e36ffiIAuvQteDprsLLbB
         VI2hF5We+G6KX2G/s//BDNEUo3ng4QVXZvxumz2sfSNoR9dzryppOIdIgd/dGwSnEsVr
         NSAg==
X-Gm-Message-State: AOJu0YwcFLZIKpmEgiGpAyTN4AAtQyPG+ZwwgtNY4xsklOxwtx+BZ/h4
	o4jPL2oh6gwqMYNBU2KaB/lzf/5xIQ8iLhew1YjdrD7EJmsQ6+ed3jso9CAA8bjb/EbjnqV97Kj
	shxwQCO+gxeo7Wg9mLDQU35ftBsIQ2lVRoxH0VM76Ynp6ntrypYSdrmo=
X-Gm-Gg: AfdE7cn0O0hZY5RBy/vvhC+OCOdCRreR/+60/+x7jjXwbTT00Ou41YTyGUlJYr4zKV0
	7TIJ/r8Yi5q2IvoBSNKhiy8tLqjq945thtmj93UL3KiXBNw5Pae7484fdF4wFZ9lHnJtLyyL634
	3x65R85PtMx1jTcMIJk8wO17nSOYLMEsGfBSFDga6eZAZ/GV45uwJFCGpsJTRSfh3moC7Zo0Pxa
	4YpFRBbR7U88bKU6XO3pvhPxJL5MbzfaLZ0eq4hQjwKawMGJLXCLqUfYQX0FaCUPBYqpTqMbUvk
	QmGStnjDXTJOzEu8gylINrh7m5pThM/C9qqw/wA=
X-Received: by 2002:a05:6a21:6e43:b0:3bf:6c04:a817 with SMTP id
 adf61e73a8af0-3c0bd1696bbmr8776569637.56.1783604637875; Thu, 09 Jul 2026
 06:43:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Gerrit Renker <grenker@aurora.tech>
Date: Thu, 9 Jul 2026 09:43:21 -0400
X-Gm-Features: AVVi8CcBNn4eKDQL_Bmq77d5hgzLcuWZAXq9Z5Lj5WdoPY1Hd25UG7FijdURswQ
Message-ID: <CAFPSX+MvOHs63anaY=uMLW73-2ZitMP0EstwuP1McLx_9_zTcA@mail.gmail.com>
Subject: [PATCH] nl80211.h: fix compiler warning
To: linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000dc81e506562dd019"

--000000000000dc81e506562dd019
Content-Type: multipart/alternative; boundary="000000000000dc81e406562dd017"

--000000000000dc81e406562dd017
Content-Type: text/plain; charset="UTF-8"

Happens with -Wpedantic.

--000000000000dc81e406562dd017
Content-Type: text/html; charset="UTF-8"

<div dir="ltr">Happens with -Wpedantic.</div>

--000000000000dc81e406562dd017--
--000000000000dc81e506562dd019
Content-Type: text/x-patch; charset="UTF-8"; 
	name="0001-nl80211.h-fix-compiler-warning.patch"
Content-Disposition: attachment; 
	filename="0001-nl80211.h-fix-compiler-warning.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mrdk48xf0>
X-Attachment-Id: f_mrdk48xf0

RnJvbSA3MzMzMGZjYjFiNDNkY2M1ZTU1OWI1NGQ2MWY1YWQ5NmY2YzQ5MzdkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBHZXJyaXQgUmVua2VyIDxncmVua2VyQGF1cm9yYS50ZWNoPgpE
YXRlOiBUaHUsIDkgSnVsIDIwMjYgMDk6MzY6MTggLTA0MDAKU3ViamVjdDogW1BBVENIXSBubDgw
MjExLmg6IGZpeCBjb21waWxlciB3YXJuaW5nCk1JTUUtVmVyc2lvbjogMS4wCkNvbnRlbnQtVHlw
ZTogdGV4dC9wbGFpbjsgY2hhcnNldD1VVEYtOApDb250ZW50LVRyYW5zZmVyLUVuY29kaW5nOiA4
Yml0CgpUaGlzIGFkZHJlc3NlcyB0aGUgZm9sbG93aW5nIGNvbXBpbGVyIHdhcm5pbmcgb2NjdXJy
aW5nIHVuZGVyIGAtV3BlZGFudGljYDoKYGBgY29uc29sZQpubDgwMjExLmg6NjYwMTo1OTogd2Fy
bmluZzogSVNPIEMgcmVzdHJpY3RzIGVudW1lcmF0b3IgdmFsdWVzIHRvIHJhbmdlIG9mIOKAmGlu
dOKAmSBbLVdwZWRhbnRpY10KNjYwMSB8ICAgICAgICAgTkw4MDIxMV9GRUFUVVJFX05EX1JBTkRP
TV9NQUNfQUREUiAgICAgICAgICAgICAgPSAxVSA8PCAzMSwKICAgICB8CmBgYApUaGUgcHJvYmxl
bSBpcyB0aGF0IGAxIDw8IDMxYCBlcXVhbHMgdGhlIHZhbHVlIG9mIGBJTlRfTUlOYCAoYC1JTlRf
TUFYIC0gMSlgLCB3aGljaCBpcyBvbmUKdmFsdWUgaGlnaGVyIHRoYW4gdGhlIG1heGltdW0gcG9z
aXRpdmUgdmFsdWUgYElOVF9NQVhgLgpUaGlzIGlzIG5vdCBzdXBwb3J0ZWQgYnkgSVNPIEMgYmVm
b3JlIEMyMy4KClNpZ25lZC1vZmYtYnk6IEdlcnJpdCBSZW5rZXIgPGdyZW5rZXJAYXVyb3JhLnRl
Y2g+CgpkaWZmIC0tZ2l0IGEvbmw4MDIxMS5oIGIvbmw4MDIxMS5oCmluZGV4IDY3ZDc2NDAuLjZm
YzNkOTkgMTAwNjQ0Ci0tLSBhL25sODAyMTEuaAorKysgYi9ubDgwMjExLmgKQEAgLTY1OTgsNyAr
NjU5OCw3IEBAIGVudW0gbmw4MDIxMV9mZWF0dXJlX2ZsYWdzIHsKIAlOTDgwMjExX0ZFQVRVUkVf
VERMU19DSEFOTkVMX1NXSVRDSAkJPSAxIDw8IDI4LAogCU5MODAyMTFfRkVBVFVSRV9TQ0FOX1JB
TkRPTV9NQUNfQUREUgkJPSAxIDw8IDI5LAogCU5MODAyMTFfRkVBVFVSRV9TQ0hFRF9TQ0FOX1JB
TkRPTV9NQUNfQUREUgk9IDEgPDwgMzAsCi0JTkw4MDIxMV9GRUFUVVJFX05EX1JBTkRPTV9NQUNf
QUREUgkJPSAxVSA8PCAzMSwKKwlOTDgwMjExX0ZFQVRVUkVfTkRfUkFORE9NX01BQ19BRERSCQk9
IChpbnQpKDFVIDw8IDMxKSwKIH07CiAKIC8qKgotLSAKMi41Mi4wCgo=
--000000000000dc81e506562dd019--
