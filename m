Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD681372ECE
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 22:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789250990; cv=pass; b=oQcqDTwEXVk48/FTFYW1uJz3Pbm7HT59uWiopsT+ITfNvdmnjY8HAmR/FUFhY4DTNB23TLiPBzhUKTzqqg9EIXF1lh3wbrxf1TRorMfbvAhPCh0Vu0LzWLL3YmISA2mBXjfuZB5LenAIXdgz0mrGXyTUr8ei8wxmqH6RNWCPAFI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789250990; c=relaxed/simple;
	bh=yLbi9CFDyQFO6hIEcuiIvD51I7RbR32ErQwjoEOtFDM=;
	h=MIME-Version:From:In-Reply-To:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GMQqhbv16hbSLEEdb+8SJXv7EuEpWIthjPnCHc3EDSTSjyYbzOJFVQgSPz7Qd2ctbaWftvDzEegVXc86dlklGRYkPlpD67KkK1JlQVGLxtQiux9HmYmPS5AA80YJPXq90+UvGy3m+OrrUd4zmrJ1vgq4b6at7Brey05FUtsf1qk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=VOG1NIyR; arc=pass smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="VOG1NIyR"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b5e4f16f15so1165058e87.3
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 15:09:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789250986; cv=none;
        d=google.com; s=arc-20260327;
        b=gTJhOV1hjwlI9aWCKi3iC1uoUpmsJHPCL5PpJxUUR1FVyYf9aglWmbcWkMc47Ozj8c
         9hHzPJlQ5xx7l8nisoZHKjzT7YKdgEKRw24qgf8l3lciOgkwIivsqdrDX4NYQeVa8e1x
         hzpjIzUdlJyKrAWQIzblQxBKbBZrhq1xszt0sKOgI978t1VaAYhAy7/LkpRyjTF97fOv
         ZR7W00rzTuyhMxOc97ljfVwA/AzhvbW+ZC6a2sTHh1CztHYx83TGMOK6PgWFjfMOWBbj
         izUX0M+i194B6iFIb93dvgT70kyZ5i9Xzke7pB+6/c6FwaqR86wT9NcD8LhYnAwIW9JJ
         fKXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=1vd6Z6B8msynNn1QiswS2w+gBVmPk4ZiKxukPMAKtJY=;
        fh=J7ONFSsaxv15xzVBquNjfdgRvJschiboD5K2mdBH+5M=;
        b=c3P9rQMR+dqTdhB5QJ8hCNySkWurojUGnaRV0J+35wxoR4svCVu0ZJM0xk6l99D/ka
         XllW256irURP47BnaAgSPqOZ+gr6CWQebRGmXriwOB0Wb043dkyWKJ7iNAW6Jc+cENZA
         UNb7n4VtnrYLitTOV6tBj1jukqnE8yXZUVtclCijMBqq4kZZ+OeoEOHKXa8T2dQm3Pzx
         AMhb4FIqqXqs5hs3ACVo7hBqOjyYXZ2u/f4nbowEDDcASXOS9GFTTEUcEAstnIHFQSSB
         ZIM515OFeS2sdQr0MU3EYludxS9DEMgGZdRuAFq7GE27ryr1nP1y5p5GENOt/OxR0ZSS
         zI8w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1789250986; x=1789855786; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1vd6Z6B8msynNn1QiswS2w+gBVmPk4ZiKxukPMAKtJY=;
        b=VOG1NIyRYtMeVaz2qXedBQ9QTXCysuhtDtmMWelDhTeP9ehbC2DaP+HWgzSxapsnON
         yvSM/h/p/SCGejZa90eG18h3Y0uyotgwLxOUIT05G0kmafA4vcgQzT4BOf4o88V9Pr8S
         15GY7T8EOxt3psb5eUAD0HNJPKcxvzjpDlB20=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789250986; x=1789855786;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1vd6Z6B8msynNn1QiswS2w+gBVmPk4ZiKxukPMAKtJY=;
        b=ZFIbiMsbPmm9VZjmQaRDdu565P2stKvG+skrtAbsGRdVzFROh1/uYpX1REGKB0u9Cl
         1TqgoPjTL300IGJ1ViExPrKBhRnn/BQ2sW5RBywBWNEHVNKsU/m6YkOOemUCEJzYWZih
         /eoMQXmHr43yt4RxcxY3XP+ud+778WM1ubgo2Dlb28n4zsXbsPuqEwg6M0FTOm/xkeAf
         mc9skImi0qTqyjzCFW4rWQEF7NmtAhKo1+kFFZ/WIskU/dV+UAI9EtyiI0VQcz7089kU
         R2hEx8VPGleUv8YO4L1jEFhL7Gz6kqZ/3ES93mOt0Zb79UPIQE1f+h0u3lCGuoEADEi9
         DCdQ==
X-Gm-Message-State: AFuF++nc/7MCTGtG+xIjznsnEUrwe+tQ/8Wq59SGU7Px7g1Vr2CawFus
	QubgPW3PZoVEZ8XzyVcDutW2p5PeQrt5bBINONwL0GrCPq+vxWQ66r/WKx4RqnsLMrIAab7l0wu
	r5x+dT+/dS8wlEUw/VBMjB5zS00ZhUDtqTTEAjBwt+n6sCCKEX7He
X-Gm-Gg: AYBFou3wcvnScnLWl1fbkAKqY6KTiynbeeE7mJ0R5THkFSoeLKVmKlojuUYf7coZUVD
	20iRFCm7gdlZTKFcAMe40a4DcdFH8gXkDEWN25p89NozO6TJqyGSYE724MtUg9hrUcHHjCI+R2g
	NVPomlhST3HRcH8mfF2I8P4N6+58Edn6EDbY9+7xsL7P9Z3fFhg8YbfNDtYYlbOAzfHdOxbE+Up
	mdSm+7uhKUiFa15z/Kr9630nhXar+Zg7smTfJe8cjux/4e1GDYIGzD6oYgzq1nE4U5x4CFxJBxo
	CkLvuwgW1zQcZ0gp9YnOWiHMASOJGgJZ1ZvPXiaaROnKKVRx8F0=
X-Received: by 2002:ac2:5694:0:b0:5b6:95e:87ea with SMTP id
 2adb3069b0e04-5b8a02f9c56mr4499960e87.11.1789250985576; Sat, 12 Sep 2026
 15:09:45 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 18:09:44 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 18:09:37 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 18:08:25 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 17:39:37 -0400
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: kimwooseok <5mghybrid@khu.ac.kr>
In-Reply-To: <CAH1Bc_yJ1e_nHk9tP2qP_4D8MHEve1R2EF5cYCEXRwc+1xVAxw@mail.gmail.com>
References: <CAH1Bc_yJ1e_nHk9tP2qP_4D8MHEve1R2EF5cYCEXRwc+1xVAxw@mail.gmail.com>
Date: Sat, 12 Sep 2026 18:09:44 -0400
X-Gm-Features: AcwNN1WnKCplkpZbhbZP8bSlXetbn4A4whVveI9O7a3bq_l5emL7u4CW5DHKtdA
Message-ID: <CAH1Bc_wcSrdf01OOWuZhXduqnd3A50gvxYFSTEcQFpQNU73zXQ@mail.gmail.com>
Subject: [PATCH RESEND wireless 2/4] wifi: rtl8xxxu: unwind incomplete receive startup
To: linux-wireless@vger.kernel.org
Cc: Jes.Sorensen@gmail.com, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000068f01e065b50754d"

--00000000000068f01e065b50754d
Content-Type: text/plain; charset="UTF-8"

rtl8xxxu_start() allocates and submits RX URBs one at a time. If a later
allocation fails, earlier requests may already be active. After a
successful submission, that allocation failure can also leave ret set
to zero. The error path then frees TX resources and disables RX filters
without draining the earlier RX requests, yet reports startup success.

Separate pool allocation from submission so an allocation failure can be
handled before any RX request is active. Introduce rtl8xxxu_alloc_rx_urbs()
to allocate all 32 wrappers, then rtl8xxxu_start_rx() to submit the
completed pool. Return ENOMEM for every RX or TX URB pool allocation
failure so a partial allocation is reported as an error.

Once submission begins, keep ENOMEM/EAGAIN failures queued for retry.
For other submission errors, rtl8xxxu_start_rx() frees the unsubmitted
requests and returns the error. Since earlier submissions may already be
active at that point, route the outer start failure through the existing
rtl8xxxu_stop() path. This drains queued work and active requests and
cleans up RF state and TX resources together. Interrupt URB submission
failure uses the same cleanup path.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Assisted-by: GPT-6 Astra
Signed-off-by: kimwooseok <5mghybrid@khu.ac.kr>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c | 99 ++++++++++++++------
 1 file changed, 71 insertions(+), 28 deletions(-)

--00000000000068f01e065b50754d
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-wifi-rtl8xxxu-unwind-incomplete-receive-startup.patch"
Content-Disposition: attachment; 
	filename="0002-wifi-rtl8xxxu-unwind-incomplete-receive-startup.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: 8a6c92b50cb0e9ee_0.1

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsOHh4eHUvY29yZS5j
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGw4eHh4dS9jb3JlLmMKaW5kZXggNzk1
YTVlYzJmOGNkNC4uMTkzMmE5ZWMxOTcwYyAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcmVhbHRlay9ydGw4eHh4dS9jb3JlLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydGw4eHh4dS9jb3JlLmMKQEAgLTU4LDYgKzU4LDcgQEAgTU9EVUxFX1BBUk1fREVTQyhk
bWFfYWdnX3BhZ2VzLCAiU2V0IERNQSBhZ2dyZWdhdGlvbiBwYWdlcyAocmFuZ2UgMS0xMjcsIDAg
dG8gZGkKICNkZWZpbmUgUlRMOFhYWFVfVFhfVVJCX0xPV19XQVRFUgkyNQogI2RlZmluZSBSVEw4
WFhYVV9UWF9VUkJfSElHSF9XQVRFUgkzMgogCitzdGF0aWMgdm9pZCBydGw4eHh4dV9zdG9wKHN0
cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBib29sIHN1c3BlbmQpOwogc3RhdGljIGludCBydGw4eHh4
dV9zdWJtaXRfcnhfdXJiKHN0cnVjdCBydGw4eHh4dV9wcml2ICpwcml2LAogCQkJCSAgc3RydWN0
IHJ0bDh4eHh1X3J4X3VyYiAqcnhfdXJiKTsKIApAQCAtNTgzMiw2ICs1ODMzLDI3IEBAIHN0YXRp
YyB2b2lkIHJ0bDh4eHh1X2ZyZWVfcnhfcmVzb3VyY2VzKHN0cnVjdCBydGw4eHh4dV9wcml2ICpw
cml2KQogCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnByaXYtPnJ4X3VyYl9sb2NrLCBmbGFncyk7
CiB9CiAKK3N0YXRpYyBpbnQgcnRsOHh4eHVfYWxsb2NfcnhfdXJicyhzdHJ1Y3QgcnRsOHh4eHVf
cHJpdiAqcHJpdikKK3sKKwlzdHJ1Y3QgcnRsOHh4eHVfcnhfdXJiICpyeF91cmI7CisJaW50IGk7
CisKKwkvKiBObyBSWCB3b3JrIGlzIGFjdGl2ZSB1bnRpbCB0aGUgY29tcGxldGUgcG9vbCBoYXMg
YmVlbiBhbGxvY2F0ZWQuICovCisJZm9yIChpID0gMDsgaSA8IFJUTDhYWFhVX1JYX1VSQlM7IGkr
KykgeworCQlyeF91cmIgPSBrbWFsbG9jX29iaihzdHJ1Y3QgcnRsOHh4eHVfcnhfdXJiKTsKKwkJ
aWYgKCFyeF91cmIpCisJCQlyZXR1cm4gLUVOT01FTTsKKworCQl1c2JfaW5pdF91cmIoJnJ4X3Vy
Yi0+dXJiKTsKKwkJSU5JVF9MSVNUX0hFQUQoJnJ4X3VyYi0+bGlzdCk7CisJCXJ4X3VyYi0+aHcg
PSBwcml2LT5odzsKKwkJbGlzdF9hZGRfdGFpbCgmcnhfdXJiLT5saXN0LCAmcHJpdi0+cnhfdXJi
X3BlbmRpbmdfbGlzdCk7CisJCXByaXYtPnJ4X3VyYl9wZW5kaW5nX2NvdW50Kys7CisJfQorCisJ
cmV0dXJuIDA7Cit9CisKIHN0YXRpYyB2b2lkIHJ0bDh4eHh1X3F1ZXVlX3J4X3VyYihzdHJ1Y3Qg
cnRsOHh4eHVfcHJpdiAqcHJpdiwKIAkJCQkgIHN0cnVjdCBydGw4eHh4dV9yeF91cmIgKnJ4X3Vy
YikKIHsKQEAgLTU5MDAsNiArNTkyMiw0NCBAQCBzdGF0aWMgdm9pZCBydGw4eHh4dV9yeF91cmJf
d29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJfQogfQogCitzdGF0aWMgaW50IHJ0bDh4
eHh1X3N0YXJ0X3J4KHN0cnVjdCBydGw4eHh4dV9wcml2ICpwcml2KQoreworCXN0cnVjdCBydGw4
eHh4dV9yeF91cmIgKnJ4X3VyYiwgKnRtcDsKKwl1bnNpZ25lZCBsb25nIGZsYWdzOworCUxJU1Rf
SEVBRChsb2NhbCk7CisJaW50IHJldDsKKworCXNwaW5fbG9ja19pcnFzYXZlKCZwcml2LT5yeF91
cmJfbG9jaywgZmxhZ3MpOworCWxpc3Rfc3BsaWNlX2luaXQoJnByaXYtPnJ4X3VyYl9wZW5kaW5n
X2xpc3QsICZsb2NhbCk7CisJcHJpdi0+cnhfdXJiX3BlbmRpbmdfY291bnQgPSAwOworCXNwaW5f
dW5sb2NrX2lycXJlc3RvcmUoJnByaXYtPnJ4X3VyYl9sb2NrLCBmbGFncyk7CisKKwlsaXN0X2Zv
cl9lYWNoX2VudHJ5X3NhZmUocnhfdXJiLCB0bXAsICZsb2NhbCwgbGlzdCkgeworCQlsaXN0X2Rl
bF9pbml0KCZyeF91cmItPmxpc3QpOworCQlyZXQgPSBydGw4eHh4dV9zdWJtaXRfcnhfdXJiKHBy
aXYsIHJ4X3VyYik7CisJCXN3aXRjaCAocmV0KSB7CisJCWNhc2UgMDoKKwkJCWJyZWFrOworCQlj
YXNlIC1FTk9NRU06CisJCWNhc2UgLUVBR0FJTjoKKwkJCXJ0bDh4eHh1X3F1ZXVlX3J4X3VyYihw
cml2LCByeF91cmIpOworCQkJYnJlYWs7CisJCWRlZmF1bHQ6CisJCQl1c2JfZnJlZV91cmIoJnJ4
X3VyYi0+dXJiKTsKKwkJCWdvdG8gZnJlZV9yZW1haW5pbmc7CisJCX0KKwl9CisKKwlyZXR1cm4g
MDsKKworZnJlZV9yZW1haW5pbmc6CisJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKHJ4X3VyYiwg
dG1wLCAmbG9jYWwsIGxpc3QpIHsKKwkJbGlzdF9kZWwoJnJ4X3VyYi0+bGlzdCk7CisJCXVzYl9m
cmVlX3VyYigmcnhfdXJiLT51cmIpOworCX0KKwlyZXR1cm4gcmV0OworfQorCiAvKgogICogVGhl
IFJUTDg3MjNCVS9SVEw4MTkyRVUgdmVuZG9yIGRyaXZlciB1c2UgY29leGlzdGVuY2UgdGFibGUg
dHlwZQogICogMC03IHRvIHJlcHJlc2VudCB3cml0aW5nIGRpZmZlcmVudCBjb21iaW5hdGlvbnMg
b2YgcmVnaXN0ZXIgdmFsdWVzCkBAIC03NDA4LDcgKzc0NjgsNiBAQCBzdGF0aWMgdm9pZCBydGw4
eHh4dV93YXRjaGRvZ19jYWxsYmFjayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiBzdGF0aWMg
aW50IHJ0bDh4eHh1X3N0YXJ0KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3KQogewogCXN0cnVjdCBy
dGw4eHh4dV9wcml2ICpwcml2ID0gaHctPnByaXY7Ci0Jc3RydWN0IHJ0bDh4eHh1X3J4X3VyYiAq
cnhfdXJiOwogCXN0cnVjdCBydGw4eHh4dV90eF91cmIgKnR4X3VyYjsKIAl1bnNpZ25lZCBsb25n
IGZsYWdzOwogCWludCByZXQsIGk7CkBAIC03NDIzLDE0ICs3NDgyLDEzIEBAIHN0YXRpYyBpbnQg
cnRsOHh4eHVfc3RhcnQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcpCiAJaWYgKHByaXYtPnVzYl9p
bnRlcnJ1cHRzKSB7CiAJCXJldCA9IHJ0bDh4eHh1X3N1Ym1pdF9pbnRfdXJiKGh3KTsKIAkJaWYg
KHJldCkKLQkJCWdvdG8gZXhpdDsKKwkJCWdvdG8gZXJyb3Jfb3V0OwogCX0KIAogCWZvciAoaSA9
IDA7IGkgPCBSVEw4WFhYVV9UWF9VUkJTOyBpKyspIHsKIAkJdHhfdXJiID0ga21hbGxvY19vYmoo
c3RydWN0IHJ0bDh4eHh1X3R4X3VyYik7CiAJCWlmICghdHhfdXJiKSB7Ci0JCQlpZiAoIWkpCi0J
CQkJcmV0ID0gLUVOT01FTTsKKwkJCXJldCA9IC1FTk9NRU07CiAKIAkJCWdvdG8gZXJyb3Jfb3V0
OwogCQl9CkBAIC03NDQxLDMxICs3NDk5LDIxIEBAIHN0YXRpYyBpbnQgcnRsOHh4eHVfc3RhcnQo
c3RydWN0IGllZWU4MDIxMV9odyAqaHcpCiAJCXByaXYtPnR4X3VyYl9mcmVlX2NvdW50Kys7CiAJ
fQogCisJcmV0ID0gcnRsOHh4eHVfYWxsb2NfcnhfdXJicyhwcml2KTsKKwlpZiAocmV0KQorCQln
b3RvIGVycm9yX291dDsKKwogCXByaXYtPnR4X3N0b3BwZWQgPSBmYWxzZTsKIAogCXNwaW5fbG9j
a19pcnFzYXZlKCZwcml2LT5yeF91cmJfbG9jaywgZmxhZ3MpOwogCXByaXYtPnNodXRkb3duID0g
ZmFsc2U7CiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcHJpdi0+cnhfdXJiX2xvY2ssIGZsYWdz
KTsKIAotCWZvciAoaSA9IDA7IGkgPCBSVEw4WFhYVV9SWF9VUkJTOyBpKyspIHsKLQkJcnhfdXJi
ID0ga21hbGxvY19vYmooc3RydWN0IHJ0bDh4eHh1X3J4X3VyYik7Ci0JCWlmICghcnhfdXJiKSB7
Ci0JCQlpZiAoIWkpCi0JCQkJcmV0ID0gLUVOT01FTTsKLQotCQkJZ290byBlcnJvcl9vdXQ7Ci0J
CX0KLQkJdXNiX2luaXRfdXJiKCZyeF91cmItPnVyYik7Ci0JCUlOSVRfTElTVF9IRUFEKCZyeF91
cmItPmxpc3QpOwotCQlyeF91cmItPmh3ID0gaHc7Ci0KLQkJcmV0ID0gcnRsOHh4eHVfc3VibWl0
X3J4X3VyYihwcml2LCByeF91cmIpOwotCQlpZiAocmV0KQotCQkJcnRsOHh4eHVfcXVldWVfcnhf
dXJiKHByaXYsIHJ4X3VyYik7Ci0JfQorCXJldCA9IHJ0bDh4eHh1X3N0YXJ0X3J4KHByaXYpOwor
CWlmIChyZXQpCisJCWdvdG8gZXJyb3Jfb3V0OwogCiAJc2NoZWR1bGVfZGVsYXllZF93b3JrKCZw
cml2LT5yYV93YXRjaGRvZywgMiAqIEhaKTsKLWV4aXQ6CiAJLyoKIAkgKiBBY2NlcHQgYWxsIGRh
dGEgYW5kIG1nbXQgZnJhbWVzCiAJICovCkBAIC03NDc4LDEzICs3NTI2LDcgQEAgZXhpdDoKIAly
ZXR1cm4gcmV0OwogCiBlcnJvcl9vdXQ6Ci0JcnRsOHh4eHVfZnJlZV90eF9yZXNvdXJjZXMocHJp
dik7Ci0JLyoKLQkgKiBEaXNhYmxlIGFsbCBkYXRhIGFuZCBtZ210IGZyYW1lcwotCSAqLwotCXJ0
bDh4eHh1X3dyaXRlMTYocHJpdiwgUkVHX1JYRkxUTUFQMiwgMHgwMDAwKTsKLQlydGw4eHh4dV93
cml0ZTE2KHByaXYsIFJFR19SWEZMVE1BUDAsIDB4MDAwMCk7Ci0KKwlydGw4eHh4dV9zdG9wKGh3
LCBmYWxzZSk7CiAJcmV0dXJuIHJldDsKIH0KIApAQCAtNzgyMCw2ICs3ODYyLDcgQEAgc3RhdGlj
IGludCBydGw4eHh4dV9wcm9iZShzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZXJmYWNlLAogCXNw
aW5fbG9ja19pbml0KCZwcml2LT50eF91cmJfbG9jayk7CiAJSU5JVF9MSVNUX0hFQUQoJnByaXYt
PnJ4X3VyYl9wZW5kaW5nX2xpc3QpOwogCXNwaW5fbG9ja19pbml0KCZwcml2LT5yeF91cmJfbG9j
ayk7CisJcHJpdi0+c2h1dGRvd24gPSB0cnVlOwogCUlOSVRfV09SSygmcHJpdi0+cnhfdXJiX3dx
LCBydGw4eHh4dV9yeF91cmJfd29yayk7CiAJSU5JVF9ERUxBWUVEX1dPUksoJnByaXYtPnJhX3dh
dGNoZG9nLCBydGw4eHh4dV93YXRjaGRvZ19jYWxsYmFjayk7CiAJSU5JVF9ERUxBWUVEX1dPUkso
JnByaXYtPnVwZGF0ZV9iZWFjb25fd29yaywgcnRsOHh4eHVfdXBkYXRlX2JlYWNvbl93b3JrX2Nh
bGxiYWNrKTsKLS0gCjIuNDguMQoK
--00000000000068f01e065b50754d--
