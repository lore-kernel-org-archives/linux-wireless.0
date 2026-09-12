Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFD5372ECE
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 22:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789250978; cv=pass; b=JmFXEFmR2Evl0zF2bCMcXVVqBF+A2hHi6ylN0/St8zK1j1f4at+6CKY9cLiVEEw67s5OnOdhZqGFaehSMinQEOwWjgd1vsQ8GW9XdhVb6LYISoP0ewV8Rx0702oCUkdmtHe3MrDfqRrdcYvfiTqaQ7VwuHWYdsCdQ0l0WtB01JE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789250978; c=relaxed/simple;
	bh=euNMuiJihVbGssVFL3EzLBt/V0FkgWJXXjT61R3oxVY=;
	h=MIME-Version:From:In-Reply-To:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rqVJsI0VN5wo+UxPDgKfjKeJRGbuyuzJkbuoPo4BwzptldHlq86ZT22HcdGMb7eqA9PcmMdy4FhRoQBl61ow53rVBeEW0pbH40sc9xufVcxtlMtbvNIsJaYap4evyShndz/kXoyrNy7CoHJbbYleW56FUtOy4rRMnJaHr86vdTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=F8kIfYeb; arc=pass smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="F8kIfYeb"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3a20f06cce6so17760081fa.1
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 15:09:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789250973; cv=none;
        d=google.com; s=arc-20260327;
        b=ZTIR9OBm8x87FxKLuG2LO3GCY8bgoHm5Ik0jV4UkALiPM41nLNCuNPhFBlOTuz9wXi
         MdfGVmH3bWYJMlJk7BrKj6jMniKLRDOfzs8IO0wa15VChXRZILGVFsbxILrzEQ2Bi/mE
         VpkN3+tDtek9Tha0mIRNZE7Uu0RQciMmmn5Ech0Qq2bviVeLkHPnzwNCrhb3Nv8n1dRr
         g6KUyyqP+L/zVpXPRp1bg6hrhKw80kI7UG5NiQmpgRYXjq/kOaA154e9TQXIjLQv8MRx
         R42T7krPK5g8/lmCg/5YZw/i0qIfVUUhOcf5UTsXXXIjliP4PS5LVLraOnIXTSaiMte5
         WSVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=RZbmvP+qAHLIy4TizlwHYTL6WfRhtQ5q2w+eUJNpL84=;
        fh=J7ONFSsaxv15xzVBquNjfdgRvJschiboD5K2mdBH+5M=;
        b=Rf9C+4Q9sPH71iioyDwrQjz1ItZCITdmxprA4Alqfib2DWWFZT02IPzE1adZCgpnUw
         fCVYTmX2Fk4TDAmP4UuwofZpRlvWw5XHKzh8LNeGz6Wm75A/fxBE1z+buJYhUroQt1HE
         mfDSyU4XxROeNLqJkjcNaBjtmb1hybeKdjpAjhyRJG90aox1FD4TsoVs6imXZA2hTGWM
         D1v9LdjQaUSmnuKF1OyeYh4hPAIW5JkrKMhM5Oq44loj/PuUoO/21Z4yDR440LQo3D+2
         1u7l69p7WjkWTGztf+xyDGooGgacRs0xEAm+A7OtFSmp+5svcuB2SYyu43aEfJvMtTKD
         XqPQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1789250973; x=1789855773; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RZbmvP+qAHLIy4TizlwHYTL6WfRhtQ5q2w+eUJNpL84=;
        b=F8kIfYeblelWcpQOoSYXpviOUDXV0jtAEvEcJb0OoB5END3bFaCVyHQGllSAxjMRtR
         P7AU6/oVJzs/0BflQXhl1Rp3Jf4YyJXY8vXYCwvRxblva+cSSI/pMPcut22OkPMLxcIY
         D13yROjxN1vhoEZtdiw24aKQvwhgf296p3NI0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789250973; x=1789855773;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RZbmvP+qAHLIy4TizlwHYTL6WfRhtQ5q2w+eUJNpL84=;
        b=IZuSI2x0bk7CNrLDUV+qIG/WEaAFhWAsPkSkHvWpkxsQPZiM3FL5ZDnfSEyhCXQXcV
         o/Dzl51qWI1cReuKpEwkuNg/uKo8KTC/dWQXwNN7aBtumxb8Tuy9KI6lHjmITM/H9LBQ
         EODrfrvAMa6epaBvYTOGtoNhHtrlSE2JwKada5hackQEz6c5zXYNPYz684PMKBWOS5HC
         szjrT3I/ewbjPrApbb+b9SAlBz4rVYwd94jLKHSNxuLIYA39Sr+9mZZv73l04mqXZB++
         rJt8U/Vbn/zUNAwYaL6nx5Wx368wnDDQ+zoLKX8tG4iAHRg6M4JpwSe6nJ6SSqP+85eQ
         5xWw==
X-Gm-Message-State: AFuF++moKYEV0UklomcEv7GSJcLRxFngZ9x8jhtV66UoZn7I1Htyi1OQ
	eaj+crjopSDfpjaawK2uvMIbFrPvvBzX7C6dnaOiSGxBD1HRwnkGAFQolNoH0ZChctwEgLHm56C
	jF/KNcM1MCXqrkyYkyisJFmPZjnahVumW5AAYtwiwu8afLGlEe88t
X-Gm-Gg: AYBFou0JdY+YOzPYW/RmzhH3zgPpOKe3O3oSdperXvwMKXyx/uinqHXDmoK/3K2AsGV
	63MOTARnh12jpkmJMR0muwcUhHQwRiDqwbzR4LuXDRClG9aW5WBOhgK0CJEI6FVkI7WOPYwxMsO
	1F9EbaLNVJ9K2Apu4BOSbp1UHU0VeXoeNy2ALn1VJh7qX993/kdrNdIlNj79PbNAmqrjqlr6fXP
	rVyjJkY76E4PXEvJIkIQ9QTMoB1b+CS4PVWwXW9beCq0JU/knsT0GWQ7Yf98ZGP999ElKiWExc/
	QMsCNEG29eHH1cIUqlrIzQGski9aBcCPWifzv36GkV8LlnOAnkzu
X-Received: by 2002:a05:651c:1507:b0:3a4:82b7:bfcf with SMTP id
 38308e7fff4ca-3a5be03fbe1mr44171fa.0.1789250973557; Sat, 12 Sep 2026 15:09:33
 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 18:09:32 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 15:09:28 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 15:08:21 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 14:39:35 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: kimwooseok <5mghybrid@khu.ac.kr>
In-Reply-To: <CAH1Bc_yJ1e_nHk9tP2qP_4D8MHEve1R2EF5cYCEXRwc+1xVAxw@mail.gmail.com>
References: <CAH1Bc_yJ1e_nHk9tP2qP_4D8MHEve1R2EF5cYCEXRwc+1xVAxw@mail.gmail.com>
Date: Sat, 12 Sep 2026 18:09:32 -0400
X-Gm-Features: AcwNN1VkoWc6yOIu-iP_4EECwaDJOmBbluOYtYWHQpuN-MgHe2ykg9w1FFygbkM
Message-ID: <CAH1Bc_zqe_a93WcmksWBfmBkW2JGdhuRHcLECpLtznXA_dTWEA@mail.gmail.com>
Subject: [PATCH RESEND wireless 1/4] wifi: rtl8xxxu: free RX skb when URB
 submission fails
To: linux-wireless@vger.kernel.org
Cc: Jes.Sorensen@gmail.com, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000b18dc1065b5074df"

--000000000000b18dc1065b5074df
Content-Type: text/plain; charset="UTF-8"

A failed RX URB submission can leak the skb allocated for that attempt.
rtl8xxxu_submit_rx_urb() allocates the buffer and stores it in urb.context,
but if usb_submit_urb() fails, it only unanchors the URB. The RX worker
queues ENOMEM/EAGAIN failures for retry with that buffer still attached.

On the next attempt, rtl8xxxu_submit_rx_urb() allocates another skb and
overwrites urb.context, losing the reference to the previous buffer.
Stopping before the retry also leaks the buffer because pending-request
cleanup frees only the URB.

Fix the leak at the submission failure by making rtl8xxxu_submit_rx_urb()
responsible for both allocating the skb and releasing it when submission
fails. Free the newly allocated skb and clear urb.context before returning
the error, so neither retry nor stop receives a pending URB that still
owns a buffer. Remove the caller-side skb cleanup from start and the RX
worker; those callers now handle only whether to retry or release the URB.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Assisted-by: GPT-6 Astra
Signed-off-by: kimwooseok <5mghybrid@khu.ac.kr>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--000000000000b18dc1065b5074df
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-wifi-rtl8xxxu-free-RX-skb-when-URB-submission-fails.patch"
Content-Disposition: attachment; 
	filename="0001-wifi-rtl8xxxu-free-RX-skb-when-URB-submission-fails.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: a064dd4dfd1042e1_0.1

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsOHh4eHUvY29yZS5j
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGw4eHh4dS9jb3JlLmMKaW5kZXggYmRk
YmQwOTkwZGU3Mi4uNzk1YTVlYzJmOGNkNCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcmVhbHRlay9ydGw4eHh4dS9jb3JlLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydGw4eHh4dS9jb3JlLmMKQEAgLTU4NjQsNyArNTg2NCw2IEBAIHN0YXRpYyB2b2lkIHJ0
bDh4eHh1X3J4X3VyYl93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAlzdHJ1Y3QgcnRs
OHh4eHVfcHJpdiAqcHJpdjsKIAlzdHJ1Y3QgcnRsOHh4eHVfcnhfdXJiICpyeF91cmIsICp0bXA7
CiAJc3RydWN0IGxpc3RfaGVhZCBsb2NhbDsKLQlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOwogCXVuc2ln
bmVkIGxvbmcgZmxhZ3M7CiAJaW50IHJldDsKIApAQCAtNTg5Niw4ICs1ODk1LDYgQEAgc3RhdGlj
IHZvaWQgcnRsOHh4eHVfcnhfdXJiX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCQlk
ZWZhdWx0OgogCQkJZGV2X3dhcm4oJnByaXYtPnVkZXYtPmRldiwKIAkJCQkgImZhaWxlZCB0byBy
ZXF1ZXVlIHVyYiB3aXRoIGVycm9yICVpXG4iLCByZXQpOwotCQkJc2tiID0gKHN0cnVjdCBza19i
dWZmICopcnhfdXJiLT51cmIuY29udGV4dDsKLQkJCWRldl9rZnJlZV9za2Ioc2tiKTsKIAkJCXVz
Yl9mcmVlX3VyYigmcnhfdXJiLT51cmIpOwogCQl9CiAJfQpAQCAtNjU5Niw4ICs2NTkzLDExIEBA
IHN0YXRpYyBpbnQgcnRsOHh4eHVfc3VibWl0X3J4X3VyYihzdHJ1Y3QgcnRsOHh4eHVfcHJpdiAq
cHJpdiwKIAkJCSAgc2tiX3NpemUsIHJ0bDh4eHh1X3J4X2NvbXBsZXRlLCBza2IpOwogCXVzYl9h
bmNob3JfdXJiKCZyeF91cmItPnVyYiwgJnByaXYtPnJ4X2FuY2hvcik7CiAJcmV0ID0gdXNiX3N1
Ym1pdF91cmIoJnJ4X3VyYi0+dXJiLCBHRlBfQVRPTUlDKTsKLQlpZiAocmV0KQorCWlmIChyZXQp
IHsKIAkJdXNiX3VuYW5jaG9yX3VyYigmcnhfdXJiLT51cmIpOworCQlkZXZfa2ZyZWVfc2tiKHNr
Yik7CisJCXJ4X3VyYi0+dXJiLmNvbnRleHQgPSBOVUxMOworCX0KIAlyZXR1cm4gcmV0OwogfQog
CkBAIC03NDEwLDcgKzc0MTAsNiBAQCBzdGF0aWMgaW50IHJ0bDh4eHh1X3N0YXJ0KHN0cnVjdCBp
ZWVlODAyMTFfaHcgKmh3KQogCXN0cnVjdCBydGw4eHh4dV9wcml2ICpwcml2ID0gaHctPnByaXY7
CiAJc3RydWN0IHJ0bDh4eHh1X3J4X3VyYiAqcnhfdXJiOwogCXN0cnVjdCBydGw4eHh4dV90eF91
cmIgKnR4X3VyYjsKLQlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOwogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7
CiAJaW50IHJldCwgaTsKIApAQCAtNzQ2MSwxMyArNzQ2MCw4IEBAIHN0YXRpYyBpbnQgcnRsOHh4
eHVfc3RhcnQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcpCiAJCXJ4X3VyYi0+aHcgPSBodzsKIAog
CQlyZXQgPSBydGw4eHh4dV9zdWJtaXRfcnhfdXJiKHByaXYsIHJ4X3VyYik7Ci0JCWlmIChyZXQp
IHsKLQkJCWlmIChyZXQgIT0gLUVOT01FTSkgewotCQkJCXNrYiA9IChzdHJ1Y3Qgc2tfYnVmZiAq
KXJ4X3VyYi0+dXJiLmNvbnRleHQ7Ci0JCQkJZGV2X2tmcmVlX3NrYihza2IpOwotCQkJfQorCQlp
ZiAocmV0KQogCQkJcnRsOHh4eHVfcXVldWVfcnhfdXJiKHByaXYsIHJ4X3VyYik7Ci0JCX0KIAl9
CiAKIAlzY2hlZHVsZV9kZWxheWVkX3dvcmsoJnByaXYtPnJhX3dhdGNoZG9nLCAyICogSFopOwot
LSAKMi40OC4xCgo=
--000000000000b18dc1065b5074df--
