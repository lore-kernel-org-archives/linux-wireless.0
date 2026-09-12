Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD71489875
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 20:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789244869; cv=pass; b=tkplFCOB5+7Bm3OPSDon3eYPvJS21KruIquIhnJgobPCGJfHROiwZU7htcRF+4wsPi0kYmNTyd/Sl4aF7KInRoX2tmJ3/zlemW8fMW/lhmSkGqwJSeo3+HuVZLMA5x38dvLpnXQbeyCtQOZVke9Rq7bd5HRPHwiSwyre80SC150=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789244869; c=relaxed/simple;
	bh=mdQ2/RSBa5kkx4EoM2gRmAu0I4MaI/d5EfpBHtMqvYk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=IpypaCafsQEhSg4mVZ31trEYDxw7tCCOouFKXrfvxULB9yBnM/J1G3F56sdY6PJsTbgEkeOdZxMNNHuD8/TYJQ3/5DJj/Zsej51e481RyeDXAjLLv7CDmKQwqkRoLKmsFyQmUbuNu3qC/Btfpgc14BsSbUahhr4/OAq7WQhY/Sg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=mKAjp5vN; arc=pass smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="mKAjp5vN"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b4afc8465eso2961505e87.2
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 13:27:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789244857; cv=none;
        d=google.com; s=arc-20260327;
        b=HUuSQx6IXJq7i9bX52dF3cEwShilsuQMYbP+TTQ1YNju0cdc132PJTefjngTxFz/Wr
         K8wx+I/akmQjfSCP7pcVyNFxT8ZtNvUvNTAuRCQ/egSfBgHW8ZKjaqGlpOZY4g5zFjWk
         T3OY0Sl9YY2fMVbQI8fiPyg1v/PyOjzd5hUAxdMfu2CKXvuSpmVBJFcLm1bEambXM37N
         RKK2lsTQd/uTYJJYODjcODFbB9qsfbw8VH1t6Vv67UA4DaXAKGO4GBSdCplJnXKINAhM
         DEWKcWZ40pGyJDrgg2UhFcZ/AI+i2T+3E/GPzwToGe35kb/JlKwerSLRreySTzaMf1ON
         n5mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=QusD7oKO91C2KV0ZFIkt5N0wahUFTPr7WHmYLgncsbQ=;
        fh=TFULXDBgHlLqMQdfUyAurUJgwNjfZoZpfLyj5gKGrno=;
        b=WQrrGduyi8iAnjxqLyvr9ecoyurDwI91JlKR+uvxDRTW/6A7FeA01iUS9oDbP9lsbY
         NK6VS/htjGyjb+CR2xB7j9Pk4fz93Mv8Qw7mEPB2VYpVuAPyMGvul5BUEHj/J+LRGEvs
         6RZI0n+xay13E/sQIS5Ad9fVFJag8FImzMrTHIeZokLiFaDiqWfUUX0nyI2+AKam1AeM
         nI04fVmaNQ/CF8FJVmQ/d5YmIxCCKHgwK/MzvlAh8egWw6cTxZGG+lhB6P2jwgqoNMbe
         n0U2HgCDQx8iaHo9MGZ6wF/LIoqQTsBQC1goDb7VF6UCOmj6wz5gClrxHsQCwAUYOjdV
         0W9A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1789244857; x=1789849657; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QusD7oKO91C2KV0ZFIkt5N0wahUFTPr7WHmYLgncsbQ=;
        b=mKAjp5vNjmKVy4As+yPyVkaSWnVJBbKMP/sUd6ziTxC0wHxHUfBqZe5sTLUT5Wbcye
         4e2GxisTOjbpCbltXEY6yHqAXLHyWDewQiolCJv+OyYXxa7dBbw/1y5q/EK7IQSrxZ8e
         g0IIT/ykx+jjPZroKPh6r5aPK5Dc7tqQWNidU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789244857; x=1789849657;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QusD7oKO91C2KV0ZFIkt5N0wahUFTPr7WHmYLgncsbQ=;
        b=BSPlNc4+0PKIjpt43igwLxJ+gr1317jAkwSJ3Nb23XyhR6xwg91yNWVguw7tm3Y7tA
         yP8zpDdkz65tItfoX/xjT96Gpfg4uWyZBhWfBHP3Tmnb/g7AOVg8i0scHPk0IN9y5zcA
         cfXDZB0rzN4nd78TDYiUPueCxI5mwuLJduZJI0wk/V6iykEN7AsXZPIurYYmhpd9eIJR
         CHbCqbEOlNHsRbOHSZMt99eEM6E4o5LPVCJrHn8uOZzLDJyGm3rw5qi7CZz606nUzX5t
         bsGUiBYZLNL5H6XG+cwVkkYKWLRESdi1z19x7JvPT82lePeiSSNJ+7ekWtP/9PqqcXwL
         2wHg==
X-Gm-Message-State: AFuF++mD3pz93dBs3TMSkfFdVkW5fTtGPKM3I//VShtKuk/Ju3C3qlTf
	5iZwMsChO1UDl9WIpYeC319pPIFglYWzUKr2/RTZovfatbAXaRDwl/pWSrsNXsWUQGsAQVnRNVw
	8F87ueFovHNlKyj6xv+NTZlw8WdzOND7aBf3vdw/DaA==
X-Gm-Gg: AYBFou21Aek22yFNDVZG2/KTRTvIkBL6ui9lWNgd4pI42o/dsGA7JLVSsTDQigeM/IB
	zJDbnXUFnQ0ioqOT0csE/PF5+FCLaLj+3XCRKbMLFYlxzP4dq1tra9YbDaUJxfBNB/WBeXKWf4N
	RjZb0nNAYoqvCG8EQiCKtr2fIriAorS5/oqB/mHE7qhfoykTWQz1FIAXXZVaJjP+I1nxJbBaN/T
	YLTjZvivcqx2+LKa7pSG4AZV9W/TsKP6X2jQE0PlvX7PzCMI7FIRgeXhSPYBJJf74ajx2d2AT37
	lHY8Fm5OzdfUL+7dOxGu4SuoWBPa6Gbj7CgXT8MGwOZNTKsn+Zk=
X-Received: by 2002:a05:6512:3b13:b0:5b6:1a7c:fd84 with SMTP id
 2adb3069b0e04-5b8a033055amr2293019e87.42.1789244856795; Sat, 12 Sep 2026
 13:27:36 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 13:27:36 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 13:09:32 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Sat, 12 Sep 2026 13:08:47 -0700
From: kimwooseok <5mghybrid@khu.ac.kr>
Date: Sat, 12 Sep 2026 13:27:36 -0700
X-Gm-Features: AcwNN1U1b0vod9cTp2CAPwS7-ksB7fvx9duh70j0iRAn55UF18yCCn1pT85r_9E
Message-ID: <CAH1Bc_wBUmmNyzF3c2H1aFBRBbAPSw0hR=1MnPOAcCXypVL_Dg@mail.gmail.com>
Subject: [PATCH wireless 0/4] wifi: rtl8xxxu: keep RX requests available
 across transient errors
To: Jes Sorensen <Jes.Sorensen@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

rtl8xxxu maintains a pool of 32 RX URBs. Successful completions return
their URBs to a pending list and schedule the RX worker when more than
eight URBs are waiting. The worker allocates fresh receive buffers and
resubmits the queued URBs in a batch.

Completion errors free the affected URBs, reducing the pool. Once eight
or fewer survive, their completions can leave all remaining requests on
the pending list without reaching the worker scheduling threshold. If no
request is in flight and no worker is pending or running, nothing triggers
further submissions, so RX remains stalled after the errors stop.

Temporary submission failures can leave requests in the same state, while
retaining an skb that the next submission attempt overwrites.

This series fixes buffer ownership on failed submission, unwinds
incomplete startup, and preserves requests through one delayed retry path.
The retry worker schedules submission even for a single request. A
separate error list provides a 100 ms batch delay from the first error
while preserving normal successful RX batching. Shutdown drains retry
work, submission work and active requests in that order.

Completion retries cover EPROTO, EILSEQ, ETIME, EOVERFLOW, ECOMM and ENOSR;
ENOMEM/EAGAIN from startup or worker submission uses the same retry path.
Cancellation and removal keep their release behavior. EPIPE endpoint-halt
recovery is outside this series.

With 24 injected EPROTO completions, the original driver stopped at eight
pending requests and zero in flight for about 30 seconds. Under the same
error budget, the patched driver retained all 32 requests and resumed RX
without restarting the interface.

Validation:
- ARM64 QEMU KUnit: 11/11 cases passed, covering the actual RX helpers,
  worker, buffer ownership, startup failures and shutdown.
- RTL8192EU on Raspberry Pi, kernel 6.18.46-thesis-test-rt+: 13/13 cases
  passed using a compatibility backport. The lab fixture substitutes
  completion statuses and injects submission and allocation failures.
  Each of the six completion statuses recovered after 32 completion
  errors followed by 96 submission failures. Error-window, pending-retry
  stop, startup failure and clean RX/down-up cases also passed.
- W=1 ARM64 allmodconfig and allyesconfig builds passed with incremental
  caches; the changed driver and KUnit objects rebuilt in both.
  Sparse added no diagnostics relative to baseline.
- Each intermediate production commit compiled, and sequential patch
  application reproduced the corresponding source trees.

kimwooseok (4):
  wifi: rtl8xxxu: free RX skb when URB submission fails
  wifi: rtl8xxxu: unwind incomplete receive startup
  wifi: rtl8xxxu: preserve RX requests across recoverable transfer
    errors
  wifi: rtl8xxxu: test RX ownership and recovery across failures

 .../wireless/realtek/rtl8xxxu/.kunitconfig    |  16 +
 drivers/net/wireless/realtek/rtl8xxxu/Kconfig |  11 +
 .../net/wireless/realtek/rtl8xxxu/Makefile    |   3 +
 drivers/net/wireless/realtek/rtl8xxxu/core.c  | 236 +++++++--
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |   3 +
 .../net/wireless/realtek/rtl8xxxu/rx-test.c   | 461 ++++++++++++++++++
 .../net/wireless/realtek/rtl8xxxu/rx-test.h   |  27 +
 7 files changed, 707 insertions(+), 50 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/.kunitconfig
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rx-test.c
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rx-test.h


base-commit: f71dd599a98182d6bc34dce39977f928068ecd64
-- 
2.48.1
