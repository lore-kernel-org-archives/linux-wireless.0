Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08A93D1A81
	for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 08:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789892275; cv=pass; b=PV7++1xxC2qY4bdoSglHU8tymmNqk8IxhaZE5KnLnUjLZvXIm6w8UuxY0Eyh2mqc7DtLKJNd5hKfkMaJrD2xx7z2aq/eA83qNBCITB6fCkhGFYKBGhTkalroKTIahYbNIcBaS/jsrDGAN5Kwx1Wr3r4HctcwgxieROH3IF7Yqfo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789892275; c=relaxed/simple;
	bh=Smp3Y01uPqMlvO9Jd88cM1aFv7HeN5iVUIh4V9cwYIU=;
	h=MIME-Version:From:In-Reply-To:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BmK7FpCchTqY3lyoAKzu79lPLD4pS+VaRAosuQQzD5xXeiF+qHYysRUfcBpNZGT5MTSoWuA8fEm5z2zTOhRniaTOReQo27In4CYGCwXhZqFi4iOhKvpTpWNPhGLocjuOTjEDiVLQ463Cucn5mQgBeJDLYC+ZW+TF9qNGHTz4i0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=M2BAIQkC; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="M2BAIQkC"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f17450so1705888e87.0
        for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 01:17:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789892270; cv=none;
        d=google.com; s=arc-20260327;
        b=jcw2vPJGAYnzVgyaIjeCrshLMCz00mk83SnQHqy0uZLW9lXtRW5h6RDU/3Guq5Pted
         4TwVF6/FWbUVTzXPZsCmw7nilqAYrUY/4lxqV3RT1ddQYphxov+5yE3jLSqs1PoX1AHJ
         jmWhRZcPpjGBu9pj/l/NsqOfU1Eo1dOVu6KSzKDX1Jok2NV+Jn3FgIio1BN2qtmdk+Pu
         gsF9VNSENUAOkgZDMxSV53ogvDINGOgV2cMcaZ4fAzpm2f+8ObW/uR4gpIWkZYsgJdD4
         dIiFTM1jrDEY1A84NnrcuOF9MRB91xFYAOMzq996miY0wQGfGY8T7sVeGaXQVepfywyB
         5OLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=Smp3Y01uPqMlvO9Jd88cM1aFv7HeN5iVUIh4V9cwYIU=;
        fh=n5v73YiJzxMAAE5ZePeLdT+lpUtZ9Qo7rWbrpoNNJIY=;
        b=RBg2picIlqU/faqDvUDvAVaaqdl6YTo0PhazEhwucb1aQ/oknZbilErLk78HjeFg1W
         hlfS5tcfClnmRNN5nGCK/JV+AjmMd48qPzRDykzCgZwgwpAJ9MREIXDNDI7oYUghZG50
         yZa55aw3XBSkzX4eNTYQp/hrm6OltC46Y99mLShRXVcnButD0RGW6XbzMPas8/l1t3Y9
         hh1rGRYCB4yCQnNuXlpsRSapOcyuc0cUd5EZ5HZ+IbvnlbXg1+5hCs6pQv8HbZI4g2Lm
         sgnPf+csB1LJq5zb9SxH+u+YI2Aj0ep+DExQy0njX96lyQF7EyUnps5dcJIogVQRUlW4
         V7Hw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1789892270; x=1790497070; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Smp3Y01uPqMlvO9Jd88cM1aFv7HeN5iVUIh4V9cwYIU=;
        b=M2BAIQkCWEDQ/EjlkvUlfjRbqd8U80cDcx20dW5zi5NlqUBPGT/2LY92/e75ePPq9Z
         SH9wejv7CXrE95t+pBwRJrwsuLO4NsAa0XwfZvu5ltabPEGn/WT+GPvDTwL76zcq5xUD
         laEHse5jdlyV5jD2yvcc0uOjYiV21cRaHiw54=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789892270; x=1790497070;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Smp3Y01uPqMlvO9Jd88cM1aFv7HeN5iVUIh4V9cwYIU=;
        b=mBC8OuyHj1VmW/BiOwr430/18hUbKQpImvAfeDwGVGjlroFSZmOt3PDD8dX+pONAj+
         WmqMvThaCloMCZ0dc8KY57HfXVTNF+v+27Pm1f0tLgt5mBHOP1Vup/tVlLXv6D49X9J1
         yOA7Q6jxMpG1R4ECs5QOSezSqpLdiEl/H1Bg8eY0f9FJr4LQ9Sbe2M17b8LPHqTRRLkX
         MsgvKGEht0B5l+ihj/o8PR8Hmdhnz63j5sCnvG8snNeNMSh7xZjs/wOolt8BL1gRjnEy
         NUUBxntwj1NQpS9SkrtLB3svBBkT6GuBnmhPEP7+4WvVa0h3SM2S+sEQNs26gPoUrtXb
         e4/Q==
X-Gm-Message-State: AFuF++mRQFQ3fy+8nqkWBUYqux3nDL/NMFCH8CzSm9P0SkFy8sJIRgIm
	927aEHAvOO2hn5wxgNS215hn44KyDz1Q8O6RfWtGgon4VeVHs8HAt8/zZB5kY3eUFFFY4IyK+qZ
	m1HofI0DCzhR6oodWWr1bzXjXvj5WDTONvcBYZNdcwA==
X-Gm-Gg: AYBFou2UcY+vnIPaLla44m5PDSccfIo6zPkiYVZm/s3qnutE/H8N38C1JtOovEHDXsq
	xXRgkmmpn/6xPRH0NKbE0EiCTSHEOL1qqrtEiJgeLNYMiEhkTrrZFleHpnjBfTI9Q5RRUmYlpMA
	vShZuJcEePoOU3n3TGkqqYnmzsrCtR8haxVJOBq9HjDsOfeVGrWV2JwuvCX3seZknAKUR12hAxk
	n6OAMNTtJwmubIf5KdCh30rxxuwACZjzZGnO9cm4PPbHHDHuOl8n/6BkcpKzjiZiIeeaQmJSEKj
	xSymzF1LT+O6Mwkl1a3ndHJkO64VE/1X1x9RWvf/VTl0vRA9zyk=
X-Received: by 2002:a05:6512:1389:b0:5b8:99b1:4875 with SMTP id
 2adb3069b0e04-5b8c181ac80mr2299933e87.28.1789892269766; Sun, 20 Sep 2026
 01:17:49 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sun, 20 Sep 2026 01:17:49 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sun, 20 Sep 2026 01:17:05 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Sun, 20 Sep 2026 03:16:58 -0500
From: Kim Wooseok <5mghybrid@khu.ac.kr>
In-Reply-To: <5a81fb985ac2481288d1be7f53c630c0@realtek.com>
References: <20260920-codex-rtl-rx-v3-submit-v3-0-883d11351963@khu.ac.kr>
 <20260920-codex-rtl-rx-v3-submit-v3-2-883d11351963@khu.ac.kr> <5a81fb985ac2481288d1be7f53c630c0@realtek.com>
Date: Sun, 20 Sep 2026 01:17:49 -0700
X-Gm-Features: AcwNN1XxQgRkxcO5wwnrBOWswhretMhzRiv2PX4Aa3gkOjaeu8_isEhGAGpFGIA
Message-ID: <CAH1Bc_z7mGdFKXHjT5x_XX8DqsOVOGfjNFG9H1d11rTuzTxDZA@mail.gmail.com>
Subject: Re: [PATCH rtw-next v3 2/3] wifi: rtl8xxxu: unwind incomplete receive startup
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, Jes Sorensen <Jes.Sorensen@gmail.com>, 
	Kalle Valo <kvalo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Ping-Ke,

> I have a request in v2 that please make sure all error path can
> properly handled by rtl8xxxu_stop(). Can you confirm and ack me?
> Or I missed?

Yes. More precisely, apart from interrupt URB allocation and submission
failures (this adapter does not use that path, so those two cases were
excluded from hardware testing), I exercised all remaining error exits
from rtl8xxxu_start() on the device.

TX and RX URB allocation failures and fatal RX submission failures were
tested at the first, middle and last positions. The same tests were run
both after a successful activation and on the first start after a
fresh probe.

In each case, start returned the expected error and rtl8xxxu_stop()
cleaned up the remaining resources and RX work. Reception resumed
normally on the next start.

I will add the blank line, initialize priv at its declaration, and
carry your Reviewed-by into the next version. Thank you.

Thanks,
Kim Wooseok
