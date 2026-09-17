Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3AD2DC765
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 07:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789630254; cv=pass; b=P5YQ4alt4J7N2FG9vBE01nJw3k//axVOuaWRxDCSK/b7IzkKAJeGk4TmM9lvfkJbFykFT7oEb1I4WsOW5pQYK6PAn92rq/UvY5ZVfs5ZLC/KhXymW5CKPmtemXYvStSTF+fdmHYjcOezHxuLO/2A2D+N98h0kfXQ49guIGbw8H4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789630254; c=relaxed/simple;
	bh=t8ItZmTqSLECprYaxWqsWjLGwssGonbSk9ASbhpQUek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yb9kQaXR+IavajICv363uThpTDwEowPrsTTijPPWCIFc7lFu6zBsMAO+39ijB9XM7XLiPUT4fkybETZ7PuM7M97Y5d3qfHIW82YR1SHSQ7+AcCBDVW3iRGP/23ON6nu15+fu33OXFZ614oEBd0GzWGFlkZpxYvsOuBTlz3iQLcw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=OxSN03mf; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="OxSN03mf"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f1e419so125573e87.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 00:30:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789630251; cv=none;
        d=google.com; s=arc-20260327;
        b=s9+GvZDEcgy393bByjiWXf1/FbLqoF/eJPA7iejR8s0xBvfPFvySjZssTav7day/ww
         cAflbGhUk1028dPX23ah3CoH3zbcQxW3MpjgAJXp89Dpao4MNG+igr2/1Qd4FoliMbqs
         awbLKpiqMMyO9OiVrdHjRMu7ogyTR34wc/1XbWXurkTrMZLODyuGFDkweqRH1TTzk803
         CGUpVltFVIUSgLCH/6q/xPB5AJh4TR5dMxBFoJHFHHtCXqNVyOv6A7+jckyUhLZ9HmJI
         CDvtKAIqG+HtvEQCBIDSnyci1ZzKS9xpb1FK6S48Yx9hwo60FOQaIIAxALYqpmfrFLDG
         g+Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=t8ItZmTqSLECprYaxWqsWjLGwssGonbSk9ASbhpQUek=;
        fh=MhtQkZecYlWmxg3DBRqEiMKK1vmKtO5bFPrMDotOrCs=;
        b=WLIEBp7tsOv+Dh5ABhlZay5kbtxf/J2/ic5CbvK7kdWAlt5VMDZsqJtKKhvGSL1MFL
         jp9x5RldTh6sqWhUISdJElvSI9zwRzFSPcjFZT54DatgZlblKBkgrc+ZhJx9kOXdQIGc
         MP+gXghn7IGc/aQqnLt16MU6vnJ/QIMj30Zq0q6vFFVSM4bVxHeN0d+Xno0YsMPTgCuN
         7o7LoI6sTHQ0BHzJ8lHsTfyb1GG0gNg5tTpLKGHfsfQOUeFSYozXba6ryFZq2dyShZ7p
         FAhXTXG58KYECebmkGtVW7tKk2tnVQu9p7Cds/fP6YuKaVsFyLnNoxXknwLlzFclTW+O
         3hbQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1789630251; x=1790235051; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t8ItZmTqSLECprYaxWqsWjLGwssGonbSk9ASbhpQUek=;
        b=OxSN03mfy+BV+dKcS0K3CeZx/hIXsY2B7LfXaWWRDwS02cXMQLWBe6nMvtUGIzJBAw
         9AZpbIdRELdJw+cmk80USygid4O5K6ONahjsFbafhTRUOIpH2hmk9zaJVFwskYPr8zH+
         a1pJCHAzbhAMAqJPAI1s3FSLl7+nnJWU1DhGc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789630251; x=1790235051;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=t8ItZmTqSLECprYaxWqsWjLGwssGonbSk9ASbhpQUek=;
        b=dFSSATiXNghGl7n/aTvMaeb8PlRUFVpOAe4gp4vYcilhzDQLZY9N88FfBE3fYXRxXj
         aOVI4lH3g4Q5zxcifL1IaCnaOBryfzQFyDLa4e5VsMj8/1CEt6r31XUQGvtN6SOmP6Pv
         /C3D6NfZgWbF1hgcx0w/EA6JlnE4m4lzgrzbnAQSNeU1k6JUheMSP6CMBLlTEQgdlayr
         nh/lmj+q/Y1E9RbHrnuoo/MDRZIGBZuMEniVGctexcqljp4HYXhMbRlw31XY4KUlnzDf
         Rs0jfiXwcv8EPAW2j60MOnKoyhp3mNs1RPgHGFR1c8dz+dcr5v280HTccMM8DkIt0ALb
         1Q/Q==
X-Gm-Message-State: AFuF++kJPEIQGOWeKb3d7IISthXdoAOsZgTWKEXK3m3ekmJUL87LYhq9
	kuM5XvqCyoXcokw2jXpp9SkgGhVIL3WvyaJb+jtXv4FKpVS04fo+/5VC7wWpd6k6uRQtIxaQb1+
	pEthu8leMKnSXM1VtGf9xnA0wEUJnioKIuh/lxbZ9vg==
X-Gm-Gg: AYBFou3OXmzNOO6Lh1D/axNew/7kvxVwPblwv/hDhGaMd1ucZRxDOCiyloddCjEI1k1
	tLLnOHI2sxjmrArA5Xe2gjEQb5Ba7M+tOsdattWNoGU79m2KC62cDJLdx/X3zpV1hJ4BzG4c8Tp
	i6IEY9L6U6AOtaR5m1zI4o+FAPItjz+AyONDEhf1DuIFeM89mMG7S4L+B8esTDU0v9uTnY+HFev
	i6Liptb+LQqCPPlUWLqnJ5OIwVMcvmllBSoVAnvkzAX4d0Y1belDmURvz4DhMfZbejKP+lN8LsB
	ap5yAJ62RqQU7ILUS6k2bu7GCSXdT2zcQqnR/jw4n8kyzC0S3IyzQ0Z89ineEtZ5rA==
X-Received: by 2002:ac2:5282:0:b0:5b8:b419:b89 with SMTP id
 2adb3069b0e04-5b8ba5f11aamr486023e87.16.1789630250975; Thu, 17 Sep 2026
 00:30:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260913-codex-rtw-rx-v2-v2-0-f09c964e0b96@khu.ac.kr>
 <20260913-codex-rtw-rx-v2-v2-4-f09c964e0b96@khu.ac.kr> <0f0a4af91524425982d37b32ac8326d4@realtek.com>
In-Reply-To: <0f0a4af91524425982d37b32ac8326d4@realtek.com>
From: =?UTF-8?B?4oCN6rmA7Jqw7ISdW+2VmeyDnV0o7KCE7J6Q7KCV67O064yA7ZWZIOyghOyekOqzte2VmeqzvA==?=
	=?UTF-8?B?KQ==?= <5mghybrid@khu.ac.kr>
Date: Thu, 17 Sep 2026 16:30:37 +0900
X-Gm-Features: AcwNN1VXCiXPDOFzekvIqwLj-GP089oEzBglJCf8-OL0LXoLtZEOcEn6ywKSXBM
Message-ID: <CAH1Bc_yh5vM5jj-AUQdw5G9afgE0-kBHLr-+Obcj5Am2S_WLhQ@mail.gmail.com>
Subject: Re: [PATCH rtw-next v2 4/4] wifi: rtl8xxxu: test RX ownership and
 recovery across failures
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, Jes Sorensen <Jes.Sorensen@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Ping-Ke,

Thanks for the comments.

For v3, I'll leave the KUnit patch and its test-only hooks out of this
series and keep the driver fixes focused.

I'll validate the revised code with targeted fault injection on hardware,
including startup failures, RX recovery, mixed normal/error traffic and
shutdown. Separating the regression-test infrastructure from the
functional fixes should make the driver changes easier to review while
still directly exercising the affected failure paths.

I'll report the validation coverage and any paths I could not exercise
in the v3 cover letter.

Thanks,
Wooseok
