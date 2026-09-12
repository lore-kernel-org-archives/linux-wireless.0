Received: from mail-lr2-f12.google.com (mail-lr2-f12.google.com [74.125.230.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D232F260C
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 22:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789250998; cv=pass; b=u/hh+xkz9mtgs0CXJ64SKKEYt+PLUgoDb2+65sVv/n/qiew28VdVA8xSq0Rm4/AVkpzH0gQA+bx/ezf9p5w1AVVhBvsGGenQzv1+BhtLPtj9lTnx9RJBEU9yHskr9z+YVRye4aI7i9I88pKe311gK6tXYqJ8wublPOMULITatfU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789250998; c=relaxed/simple;
	bh=htNagwqqMzDn9VKiUZ9yziOwEtG+sNlZbdwRPwF4B5U=;
	h=MIME-Version:From:In-Reply-To:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gbj0+jy1ogybFsD7Ieuk1uhWOqTlBA3V6ymAbwih2fwzlZXET0u0kPc17HFHwr2fQz4L00kvwzXCHabI5FSabWTI57b1HmcNDUbyP7hmXelipWkTZ5UeUXPZ3M/xhOm24Lbt8zlcC4F/+A/ocan1P2aQnUG1h+JKm7Bg6Cc2VQ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=NLklWpQ9; arc=pass smtp.client-ip=74.125.230.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="NLklWpQ9"
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a318299b93so5904921fa.0
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 15:09:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789250994; cv=none;
        d=google.com; s=arc-20260327;
        b=An88VrlPCSz9iFUHQzeLINkDq+ZA0YxEYdwARL9VXprUrSnbyJnCY8WcseWGZLA8DO
         6NrUma8PW1gy3w6bragiKadweLDBNJ+YSVwHvP2QgDZCgWBB/HS9oRCpxq2m8DKWBKlI
         A2whebdnZz7kj9z5dexr6GTZLZ6mi5qcQlelO/O6UrLrCYQt47qCVx6iBrgOfZNV3dgE
         FjcbGoOw8VIX4PZi76I7ir1ndVa96fmgEun26rh3JBOqjspBe5znpI43Elm7r+PyeAnX
         3Yx2IcktVIshSV+EWQryiwm+HETpsx9ZU5PwZsIdazjgB73EQi63OTGjEW+TOamrNA/i
         PKbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=w4ajl9UVarVX6gT39AHV5XReGMor+tvBgDReuhSiOhg=;
        fh=J7ONFSsaxv15xzVBquNjfdgRvJschiboD5K2mdBH+5M=;
        b=nVgBCT5HQAVMwuF1AgRXughBAV6de/v0ugctW8uaS7GpLYzY0Cuw/GLopfioL0sjiJ
         NstPCN7J7IOfbYTC2JQAk3jY1kJsXGwIsFMGfZ5o4U4eWzyLZl+OLLTxpZSKcaeLe2j4
         ZBu6+RTGkq0U0zZuf6I4JApBRzLgzY4tfxcM1FYU7+5/3zi7WM6rhEaQipn5Zzx8aoUO
         xAGpBVMZjKpZYCw1bhpHmxsIJh5F/36oBmE+KdBFqwBUCAxlBx34/H34xD7h1QGcz4Z/
         +HSf3ZGxWaI1dwanoU19YN1AmGwl2W0d+zv1AgZMTuEDN1Lb+A+A5C0LZknC0btKELJq
         mQCQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1789250994; x=1789855794; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w4ajl9UVarVX6gT39AHV5XReGMor+tvBgDReuhSiOhg=;
        b=NLklWpQ9EWysvNYwdfvGI4NIeZNGH3RJnz5q59owrzygvgl9sBVoy1m9QChN13wyw7
         SzqEMexuXI+X5M7M35Szb6cGmKkm3pgCfyjLSto7O7Qw43jYvhQrvpH5xBvazGTU1nHN
         gheQeN2agMqUOhkZiYQOZWCgQ8fs8fTCn9Xp0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789250994; x=1789855794;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w4ajl9UVarVX6gT39AHV5XReGMor+tvBgDReuhSiOhg=;
        b=fAJzJ4m8K2q392A9WUPjZG/UAZRxIMILyeMePwrB93ZgBTg6M3Ywb+FVbLD5qSvQ5t
         I3JUqvRf/OuCnUBc/Oq4vKHlwp4VSRS5wQWJHRZFcFPKFfFChp+EtVmutBCjjK/u42CU
         YAmzHn1gZcVJdZjS0gL1cBcK4pazsM6Pq/7INU6mImzgKJs3G+CqMeM54PpwiVHvE2S/
         2LeVIx5h64hBI6SE7sReriwTlkZFhyVFFr/WFBWVvJeWdqh1Iu42mtTHKIGUd30w2Pj9
         3eIzdm6RwvjAWAiOehZ3H/kf3A9jD1+71lOJbHZirOjXkTA9llfb3ZODdJ7PdNtUvBjJ
         rbJQ==
X-Gm-Message-State: AFuF++krfvzmGOm12sVQ/Q6MOxpP8IDahQHji2zMUD1y25SezR5DZGR2
	99sWaIl2ZxW7Wbv36AzDQv+0qnhqD/AsYYngrkv6Lmi0Lh7ehF8cgl7Fx0oYM58OvqLIvyldSBz
	NxfYCm6WZgoK4v0pioT2ZXdPfW7C/JhBlEO4+VZDVwwH5BJFHxZxZ
X-Gm-Gg: AYBFou09+WOQF1qfNVsU9jsQRytO9Z1weXACoM0AlIVtWRR9hrxx1HuJAdZXTT9jb59
	WgtbmkW0VZNAweGMAjQ5xDZAeMyx84Y854cSlR1fXZ0csgNSa1LqMJpCu3YgkE7H/mj1ljyMAgo
	bIyOEjYTPZm2wzb9Qpwr0RqCvNrMTtVkZUl8tkT8ABKgrQSdZXUAhKUOO0rzKcE3dHFOvLEDIDd
	t1TkxU6O2DPHr43h7K3dKyiSc5e19Fwt8S+FXwKPSJH0/vFXjj7SpraJ00nLKlyRt1DLFdHH0pz
	CxKoQSEu0lvZQJfY/bNv5FO5Zs4r3JQoNTR0xGioYywZx+FcXSTvwgs4HeVhhA==
X-Received: by 2002:a05:6512:114a:b0:5b6:1870:268d with SMTP id
 2adb3069b0e04-5b8a8f000bdmr794628e87.62.1789250993982; Sat, 12 Sep 2026
 15:09:53 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 18:09:52 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 15:09:48 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 18:08:28 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 17:39:39 -0400
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: kimwooseok <5mghybrid@khu.ac.kr>
In-Reply-To: <CAH1Bc_yJ1e_nHk9tP2qP_4D8MHEve1R2EF5cYCEXRwc+1xVAxw@mail.gmail.com>
References: <CAH1Bc_yJ1e_nHk9tP2qP_4D8MHEve1R2EF5cYCEXRwc+1xVAxw@mail.gmail.com>
Date: Sat, 12 Sep 2026 18:09:52 -0400
X-Gm-Features: AcwNN1WV5t23V2gPsfZjdcE9mdALjnVzS9ZuB0qjILn8mCxdbIHiHsaZ8e_qxEU
Message-ID: <CAH1Bc_y_HmspszmwOjnB7e8foTAjCH09wevYwzxsWrpQi+2BNA@mail.gmail.com>
Subject: [PATCH RESEND wireless 3/4] wifi: rtl8xxxu: preserve RX requests
 across recoverable transfer errors
To: linux-wireless@vger.kernel.org
Cc: Jes.Sorensen@gmail.com, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000e933f2065b5075a5"

--000000000000e933f2065b5075a5
Content-Type: text/plain; charset="UTF-8"

rtl8xxxu normally reuses 32 RX URBs, scheduling the submission worker when
more than eight completed requests have accumulated on the pending list.
Completion errors free URBs instead. A finite error burst can therefore
leave eight or fewer requests, which cannot reach that threshold after
they all complete. With no request in flight and no worker pending or
running, RX stays stopped even after the errors cease.

To prevent these errors from shrinking the pool below the number
needed for normal resubmission, retain URBs after EPROTO, EILSEQ, ETIME,
EOVERFLOW, ECOMM and ENOSR completions. EHCI can report ENOSR for IN data-buffer
errors, and FHCI maps RX buffer overrun to ECOMM. Free the failed
transfer's skb and keep its URB on a separate retry list.

Keeping the URBs is only part of the fix: the driver must also submit
them again without waiting for nine requests to accumulate. When the
first failed request enters the retry list, schedule delayed work for
100 ms. Further failures join that list while the work is pending.
When it runs, move the collected requests to normal pending and schedule
the submission worker even if only one request is waiting. Keeping
failed requests separate until then prevents normal completions from
triggering an immediate retry; successful RX keeps its existing batching.

A retry can itself fail with ENOMEM/EAGAIN. Returning that request to
normal pending would bring back the same threshold problem, so route
temporary submission failures from both start and the RX worker through
the delayed retry list as well.

Serialize retry insertion and scheduling with shutdown so late
completions cannot schedule fresh retries during stop. Cancel retry work
first, then wait for submission work before killing active URBs, so a
running worker cannot submit a request after the active requests have
been drained.

Cancellation and removal keep their release behavior. EPIPE endpoint-halt
recovery remains outside this change because it requires quiescing
requests and distinguishing recovery cancellation from shutdown.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Assisted-by: GPT-6 Astra
Signed-off-by: kimwooseok <5mghybrid@khu.ac.kr>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c  | 71 +++++++++++++++++--
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |  3 +
 2 files changed, 70 insertions(+), 4 deletions(-)

--000000000000e933f2065b5075a5
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0003-wifi-rtl8xxxu-preserve-RX-requests-across-recoverabl.patch"
Content-Disposition: attachment; 
	filename="0003-wifi-rtl8xxxu-preserve-RX-requests-across-recoverabl.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f0ee61d9ae1349b6_0.1

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsOHh4eHUvY29yZS5j
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGw4eHh4dS9jb3JlLmMKaW5kZXggMTkz
MmE5ZWMxOTcwYy4uODgzYzlhNTZmNTJhNCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcmVhbHRlay9ydGw4eHh4dS9jb3JlLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydGw4eHh4dS9jb3JlLmMKQEAgLTU0LDYgKzU0LDcgQEAgTU9EVUxFX1BBUk1fREVTQyhk
bWFfYWdnX3BhZ2VzLCAiU2V0IERNQSBhZ2dyZWdhdGlvbiBwYWdlcyAocmFuZ2UgMS0xMjcsIDAg
dG8gZGkKICNkZWZpbmUgVVNCX1ZFTkRPUl9JRF9SRUFMVEVLCQkweDBiZGEKICNkZWZpbmUgUlRM
OFhYWFVfUlhfVVJCUwkJMzIKICNkZWZpbmUgUlRMOFhYWFVfUlhfVVJCX1BFTkRJTkdfV0FURVIJ
OAorI2RlZmluZSBSVEw4WFhYVV9SWF9VUkJfUkVUUllfREVMQVlfTVMJMTAwCiAjZGVmaW5lIFJU
TDhYWFhVX1RYX1VSQlMJCTY0CiAjZGVmaW5lIFJUTDhYWFhVX1RYX1VSQl9MT1dfV0FURVIJMjUK
ICNkZWZpbmUgUlRMOFhYWFVfVFhfVVJCX0hJR0hfV0FURVIJMzIKQEAgLTU4MjMsNiArNTgyNCwx
MSBAQCBzdGF0aWMgdm9pZCBydGw4eHh4dV9mcmVlX3J4X3Jlc291cmNlcyhzdHJ1Y3QgcnRsOHh4
eHVfcHJpdiAqcHJpdikKIAogCXNwaW5fbG9ja19pcnFzYXZlKCZwcml2LT5yeF91cmJfbG9jaywg
ZmxhZ3MpOwogCisJbGlzdF9zcGxpY2VfdGFpbF9pbml0KCZwcml2LT5yeF91cmJfcmV0cnlfbGlz
dCwKKwkJCSAgICAgICZwcml2LT5yeF91cmJfcGVuZGluZ19saXN0KTsKKwlwcml2LT5yeF91cmJf
cGVuZGluZ19jb3VudCArPSBwcml2LT5yeF91cmJfcmV0cnlfY291bnQ7CisJcHJpdi0+cnhfdXJi
X3JldHJ5X2NvdW50ID0gMDsKKwogCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShyeF91cmIsIHRt
cCwKIAkJCQkgJnByaXYtPnJ4X3VyYl9wZW5kaW5nX2xpc3QsIGxpc3QpIHsKIAkJbGlzdF9kZWwo
JnJ4X3VyYi0+bGlzdCk7CkBAIC01ODgxLDYgKzU4ODcsNDcgQEAgc3RhdGljIHZvaWQgcnRsOHh4
eHVfcXVldWVfcnhfdXJiKHN0cnVjdCBydGw4eHh4dV9wcml2ICpwcml2LAogCXNwaW5fdW5sb2Nr
X2lycXJlc3RvcmUoJnByaXYtPnJ4X3VyYl9sb2NrLCBmbGFncyk7CiB9CiAKK3N0YXRpYyB2b2lk
IHJ0bDh4eHh1X3J4X3VyYl9yZXRyeV93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKK3sK
KwlzdHJ1Y3QgcnRsOHh4eHVfcHJpdiAqcHJpdiA9IGNvbnRhaW5lcl9vZih0b19kZWxheWVkX3dv
cmsod29yayksCisJCQkJCQlzdHJ1Y3QgcnRsOHh4eHVfcHJpdiwKKwkJCQkJCXJ4X3VyYl9yZXRy
eV93cSk7CisJdW5zaWduZWQgbG9uZyBmbGFnczsKKworCXNwaW5fbG9ja19pcnFzYXZlKCZwcml2
LT5yeF91cmJfbG9jaywgZmxhZ3MpOworCisJaWYgKCFwcml2LT5zaHV0ZG93biAmJiBwcml2LT5y
eF91cmJfcmV0cnlfY291bnQpIHsKKwkJbGlzdF9zcGxpY2VfdGFpbF9pbml0KCZwcml2LT5yeF91
cmJfcmV0cnlfbGlzdCwKKwkJCQkgICAgICAmcHJpdi0+cnhfdXJiX3BlbmRpbmdfbGlzdCk7CisJ
CXByaXYtPnJ4X3VyYl9wZW5kaW5nX2NvdW50ICs9IHByaXYtPnJ4X3VyYl9yZXRyeV9jb3VudDsK
KwkJcHJpdi0+cnhfdXJiX3JldHJ5X2NvdW50ID0gMDsKKwkJLyogQW4gZXJyb3IgbXVzdCBub3Qg
bGVhdmUgYSBzbWFsbCBiYXRjaCB3YWl0aW5nIGluZGVmaW5pdGVseS4gKi8KKwkJc2NoZWR1bGVf
d29yaygmcHJpdi0+cnhfdXJiX3dxKTsKKwl9CisKKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZw
cml2LT5yeF91cmJfbG9jaywgZmxhZ3MpOworfQorCitzdGF0aWMgdm9pZCBydGw4eHh4dV9xdWV1
ZV9yeF91cmJfcmV0cnkoc3RydWN0IHJ0bDh4eHh1X3ByaXYgKnByaXYsCisJCQkJCXN0cnVjdCBy
dGw4eHh4dV9yeF91cmIgKnJ4X3VyYikKK3sKKwl1bnNpZ25lZCBsb25nIGZsYWdzOworCisJc3Bp
bl9sb2NrX2lycXNhdmUoJnByaXYtPnJ4X3VyYl9sb2NrLCBmbGFncyk7CisKKwlpZiAoIXByaXYt
PnNodXRkb3duKSB7CisJCWxpc3RfYWRkX3RhaWwoJnJ4X3VyYi0+bGlzdCwgJnByaXYtPnJ4X3Vy
Yl9yZXRyeV9saXN0KTsKKwkJcHJpdi0+cnhfdXJiX3JldHJ5X2NvdW50Kys7CisJCS8qIEtlZXAg
bm9ybWFsIGNvbXBsZXRpb25zIGZyb20gYnlwYXNzaW5nIHRoZSBlcnJvciBiYWNrb2ZmLiAqLwor
CQlxdWV1ZV9kZWxheWVkX3dvcmsoc3lzdGVtX3dxLCAmcHJpdi0+cnhfdXJiX3JldHJ5X3dxLAor
CQkJCSAgIG1zZWNzX3RvX2ppZmZpZXMoUlRMOFhYWFVfUlhfVVJCX1JFVFJZX0RFTEFZX01TKSk7
CisJfSBlbHNlIHsKKwkJdXNiX2ZyZWVfdXJiKCZyeF91cmItPnVyYik7CisJfQorCisJc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSgmcHJpdi0+cnhfdXJiX2xvY2ssIGZsYWdzKTsKK30KKwogc3RhdGlj
IHZvaWQgcnRsOHh4eHVfcnhfdXJiX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogewog
CXN0cnVjdCBydGw4eHh4dV9wcml2ICpwcml2OwpAQCAtNTkwNCw3ICs1OTUxLDcgQEAgc3RhdGlj
IHZvaWQgcnRsOHh4eHVfcnhfdXJiX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCQly
ZXQgPSBydGw4eHh4dV9zdWJtaXRfcnhfdXJiKHByaXYsIHJ4X3VyYik7CiAJCS8qCiAJCSAqIElm
IG91dCBvZiBtZW1vcnkgb3IgdGVtcG9yYXJ5IGVycm9yLCBwdXQgaXQgYmFjayBvbiB0aGUKLQkJ
ICogcXVldWUgYW5kIHRyeSBhZ2Fpbi4gT3RoZXJ3aXNlIHRoZSBkZXZpY2UgaXMgZGVhZC9nb25l
CisJCSAqIGRlbGF5ZWQgcXVldWUgYW5kIHRyeSBhZ2Fpbi4gT3RoZXJ3aXNlIHRoZSBkZXZpY2Ug
aXMgZGVhZC9nb25lCiAJCSAqIGFuZCB3ZSBzaG91bGQgZHJvcCBpdC4KIAkJICovCiAJCXN3aXRj
aCAocmV0KSB7CkBAIC01OTEyLDcgKzU5NTksNyBAQCBzdGF0aWMgdm9pZCBydGw4eHh4dV9yeF91
cmJfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJCQlicmVhazsKIAkJY2FzZSAtRU5P
TUVNOgogCQljYXNlIC1FQUdBSU46Ci0JCQlydGw4eHh4dV9xdWV1ZV9yeF91cmIocHJpdiwgcnhf
dXJiKTsKKwkJCXJ0bDh4eHh1X3F1ZXVlX3J4X3VyYl9yZXRyeShwcml2LCByeF91cmIpOwogCQkJ
YnJlYWs7CiAJCWRlZmF1bHQ6CiAJCQlkZXZfd2FybigmcHJpdi0+dWRldi0+ZGV2LApAQCAtNTk0
Miw3ICs1OTg5LDcgQEAgc3RhdGljIGludCBydGw4eHh4dV9zdGFydF9yeChzdHJ1Y3QgcnRsOHh4
eHVfcHJpdiAqcHJpdikKIAkJCWJyZWFrOwogCQljYXNlIC1FTk9NRU06CiAJCWNhc2UgLUVBR0FJ
TjoKLQkJCXJ0bDh4eHh1X3F1ZXVlX3J4X3VyYihwcml2LCByeF91cmIpOworCQkJcnRsOHh4eHVf
cXVldWVfcnhfdXJiX3JldHJ5KHByaXYsIHJ4X3VyYik7CiAJCQlicmVhazsKIAkJZGVmYXVsdDoK
IAkJCXVzYl9mcmVlX3VyYigmcnhfdXJiLT51cmIpOwpAQCAtNjYxOCw3ICs2NjY1LDIwIEBAIHN0
YXRpYyB2b2lkIHJ0bDh4eHh1X3J4X2NvbXBsZXRlKHN0cnVjdCB1cmIgKnVyYikKIAkJcnRsOHh4
eHVfcXVldWVfcnhfdXJiKHByaXYsIHJ4X3VyYik7CiAJfSBlbHNlIHsKIAkJZGV2X2RiZyhkZXYs
ICIlczogc3RhdHVzICVpXG4iLAlfX2Z1bmNfXywgdXJiLT5zdGF0dXMpOwotCQlnb3RvIGNsZWFu
dXA7CisJCXN3aXRjaCAodXJiLT5zdGF0dXMpIHsKKwkJY2FzZSAtRVBST1RPOgorCQljYXNlIC1F
SUxTRVE6CisJCWNhc2UgLUVUSU1FOgorCQljYXNlIC1FT1ZFUkZMT1c6CisJCWNhc2UgLUVDT01N
OgorCQljYXNlIC1FTk9TUjoKKwkJCWRldl9rZnJlZV9za2Ioc2tiKTsKKwkJCXVyYi0+Y29udGV4
dCA9IE5VTEw7CisJCQlydGw4eHh4dV9xdWV1ZV9yeF91cmJfcmV0cnkocHJpdiwgcnhfdXJiKTsK
KwkJCXJldHVybjsKKwkJZGVmYXVsdDoKKwkJCWdvdG8gY2xlYW51cDsKKwkJfQogCX0KIAlyZXR1
cm47CiAKQEAgLTc1NDksNiArNzYwOSw3IEBAIHN0YXRpYyB2b2lkIHJ0bDh4eHh1X3N0b3Aoc3Ry
dWN0IGllZWU4MDIxMV9odyAqaHcsIGJvb2wgc3VzcGVuZCkKIAkgKiBpdCBkcmFpbmVkIHZpYSBy
dGw4eHh4dV9zdWJtaXRfcnhfdXJiKCksIHNvIGEgd29ya2VyIHN0aWxsIHJ1bm5pbmcKIAkgKiBh
ZnRlciB0aGUga2lsbCBjb3VsZCBzdWJtaXQgYSBVUkIgdGhhdCBlc2NhcGVzIGl0LgogCSAqLwor
CWNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygmcHJpdi0+cnhfdXJiX3JldHJ5X3dxKTsKIAljYW5j
ZWxfd29ya19zeW5jKCZwcml2LT5yeF91cmJfd3EpOwogCiAJdXNiX2tpbGxfYW5jaG9yZWRfdXJi
cygmcHJpdi0+cnhfYW5jaG9yKTsKQEAgLTc4NjEsOSArNzkyMiwxMSBAQCBzdGF0aWMgaW50IHJ0
bDh4eHh1X3Byb2JlKHN0cnVjdCB1c2JfaW50ZXJmYWNlICppbnRlcmZhY2UsCiAJSU5JVF9MSVNU
X0hFQUQoJnByaXYtPnR4X3VyYl9mcmVlX2xpc3QpOwogCXNwaW5fbG9ja19pbml0KCZwcml2LT50
eF91cmJfbG9jayk7CiAJSU5JVF9MSVNUX0hFQUQoJnByaXYtPnJ4X3VyYl9wZW5kaW5nX2xpc3Qp
OworCUlOSVRfTElTVF9IRUFEKCZwcml2LT5yeF91cmJfcmV0cnlfbGlzdCk7CiAJc3Bpbl9sb2Nr
X2luaXQoJnByaXYtPnJ4X3VyYl9sb2NrKTsKIAlwcml2LT5zaHV0ZG93biA9IHRydWU7CiAJSU5J
VF9XT1JLKCZwcml2LT5yeF91cmJfd3EsIHJ0bDh4eHh1X3J4X3VyYl93b3JrKTsKKwlJTklUX0RF
TEFZRURfV09SSygmcHJpdi0+cnhfdXJiX3JldHJ5X3dxLCBydGw4eHh4dV9yeF91cmJfcmV0cnlf
d29yayk7CiAJSU5JVF9ERUxBWUVEX1dPUksoJnByaXYtPnJhX3dhdGNoZG9nLCBydGw4eHh4dV93
YXRjaGRvZ19jYWxsYmFjayk7CiAJSU5JVF9ERUxBWUVEX1dPUksoJnByaXYtPnVwZGF0ZV9iZWFj
b25fd29yaywgcnRsOHh4eHVfdXBkYXRlX2JlYWNvbl93b3JrX2NhbGxiYWNrKTsKIAlza2JfcXVl
dWVfaGVhZF9pbml0KCZwcml2LT5jMmhjbWRfcXVldWUpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvcmVhbHRlay9ydGw4eHh4dS9ydGw4eHh4dS5oIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvcmVhbHRlay9ydGw4eHh4dS9ydGw4eHh4dS5oCmluZGV4IGVlYjE4ZWIwZTRjMGYuLmVl
NTVmNmNjN2YwMTIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRs
OHh4eHUvcnRsOHh4eHUuaAorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bDh4
eHh1L3J0bDh4eHh1LmgKQEAgLTE4MDgsOCArMTgwOCwxMSBAQCBzdHJ1Y3QgcnRsOHh4eHVfcHJp
diB7CiAJc3BpbmxvY2tfdCByeF91cmJfbG9jazsKIAlzdHJ1Y3QgbGlzdF9oZWFkIHJ4X3VyYl9w
ZW5kaW5nX2xpc3Q7CiAJaW50IHJ4X3VyYl9wZW5kaW5nX2NvdW50OworCXN0cnVjdCBsaXN0X2hl
YWQgcnhfdXJiX3JldHJ5X2xpc3Q7CisJaW50IHJ4X3VyYl9yZXRyeV9jb3VudDsKIAlib29sIHNo
dXRkb3duOwogCXN0cnVjdCB3b3JrX3N0cnVjdCByeF91cmJfd3E7CisJc3RydWN0IGRlbGF5ZWRf
d29yayByeF91cmJfcmV0cnlfd3E7CiAKIAl1OCBtYWNfYWRkcltFVEhfQUxFTl07CiAJY2hhciBj
aGlwX25hbWVbOF07Ci0tIAoyLjQ4LjEKCg==
--000000000000e933f2065b5075a5--
