Received: from mail97.out.titan.email (mail97.out.titan.email [3.219.11.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02B12D24B7
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2026 05:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.219.11.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491266; cv=none; b=RtqQEyx6LTLMPIDrMmWiqIlzUt8jsgzlQOmGrti1DP0pjXMAkw3CvLUnfHN0YiCnH9XH+KYnnRb6KDFlywy3RzR1WQtH1XyLeEY9FyY/F4cwUu/gAcF2IrN/bTpG4K+jFKjJ1Fby/a+ZTc735fZN0rGJ29BVcJqfP4F4oBp9StE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491266; c=relaxed/simple;
	bh=hLxS2C67eKGhzv3MzXFdsWhc8o0OmDYPHsYvosiOx60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTPn05NZCjIwNZ5EhJw06UtM73kIvlUEsjt1YiWvctSziHXtOzFWI1lK+lHsBieQLW3IobBG108fq2Wkn7CNe9d/wFY113bfb1vVuzkrEyUEonDWWfyVxTGjUjtErZFp/V48KXHNrGgw4dViYLr0oKnPpSA3g1Ey6X0qwrJD3B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (1024-bit key) header.d=t32smtp-sign002.email header.i=@t32smtp-sign002.email header.b=FGAPAg2L; arc=none smtp.client-ip=3.219.11.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t32smtp-sign002.email header.i=@t32smtp-sign002.email header.b="FGAPAg2L"
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id 4f0YCH1tDMz9rxN;
	Tue, 27 Jan 2026 05:01:15 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=hLxS2C67eKGhzv3MzXFdsWhc8o0OmDYPHsYvosiOx60=;
	c=relaxed/relaxed; d=t32smtp-sign002.email;
	h=from:subject:cc:message-id:in-reply-to:references:mime-version:to:date:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1769490075; v=1;
	b=FGAPAg2LKRasxMIyo89aTABR9s0RQx6YXRuoASqFAwWHliwekwacigHNLEdtk34ZEJmiNTa7
	pMewR0roNkTcW0wVMnHNQYnD0Qzi1HXcxjQh55MWDIi/2J/L4GNvSvsyqZMMnluYQTJGDZJEezx
	EERAwsUh2rKwVbPI/Q03eCqs=
Received: from SkinnyD (unknown [176.100.43.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp-out.flockmail.com (Postfix) with ESMTPSA id 4f0YCG3Ngxz9s0F;
	Tue, 27 Jan 2026 05:01:14 +0000 (UTC)
Feedback-ID: :lucid_duck@justthetip.ca:justthetip.ca:flockmailId
From: Lucid Duck <lucid_duck@justthetip.ca>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	mh_chen@realtek.com,
	rtl8821cerfe2@gmail.com,
	Lucid Duck <lucid_duck@justthetip.ca>
Subject: Re: [PATCH] wifi: rtw89: usb: fix TX flow control by tracking in-flight URBs
Date: Mon, 26 Jan 2026 21:00:27 -0800
Message-ID: <20260127050028.478-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.50.0.windows.2
In-Reply-To: <290226f1d7144477a668f045cbd8eb56@realtek.com>
References: <20260125221943.36001-1-lucid_duck@justthetip.ca> <290226f1d7144477a668f045cbd8eb56@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1769490075066389503.13754.1469075588457555659@prod-use1-smtp-out1003.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=WtDRMcfv c=1 sm=1 tr=0 ts=6978469b
	a=6cvM5N0Q1CppT8/Q7vqPfQ==:117 a=6cvM5N0Q1CppT8/Q7vqPfQ==:17
	a=CEWIc4RMnpUA:10 a=9RjlThnDEmPendmGZr0A:9

On Mon, 26 Jan 2026, Ping-Ke Shih wrote:=0D
> Then URB becomes exhausted?=0D
=0D
Yes. Without proper flow control, mac80211 continuously queues frames=0D
since we always report resources available. URBs accumulate until=0D
submission fails, causing TX stalls or instability under load.=0D
=0D
> Curiously. How did you decide this value? Have you tested USB2 and USB3=0D
> devices? How about their throughput before/after this patch?=0D
=0D
The value of 32 was based on similar USB wireless drivers (mt76, ath9k_htc)=
=0D
as a reasonable starting point. I'm open to tuning this if testing reveals=
=0D
a better value, and it may need adjustment for optimal USB2 vs USB3=0D
performance at different bands.=0D
=0D
I have both USB2 and USB3 test capability and will be running more=0D
rigorous throughput testing on both configurations shortly. Initial=0D
testing showed the patch stable under sustained load, but I want to=0D
collect proper iperf3 measurements before providing specific numbers.=0D
=0D
I'll follow up with detailed test results and a v2 addressing your=0D
comments.=0D
=0D
> I feel we don't need repeatedly adding this comment. If you like it,=0D
> just keep one.=0D
=0D
Understood. Will clean this up in v2.=0D
=0D
Thanks for the review.=0D
=0D
--=0D
Lucid Duck=0D
