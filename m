Received: from va-2-46.ptr.blmpb.com (va-2-46.ptr.blmpb.com [209.127.231.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F01B449B2B
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 09:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788774240; cv=none; b=nyllOWEOFl2cMRoIb2ELX+jti2tMiDIvM3p8J+lldP/kInbV2NRJrQSw6kGtC+dLpnJfIVCRLBtcwlHMYZfWS4TsfIzywuKhtkUwSC8O4Ub12ge4NNpBB7TkSnR+Cq3HBRPjeagv6k40OtIkub+Em1DE2tMM0kU4rlZZqVJtF8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788774240; c=relaxed/simple;
	bh=W/tjzhit7188afMNdjQeUVFsuHLn/LyB0aJkjmumVkM=;
	h=Subject:Content-Type:Date:Message-Id:To:Cc:From:Mime-Version; b=ra1rRSLwztusEZlEwMlQZllWcMuzPUKudQQ64ULZJ2HS1rBDDkaz5SyFS+o0Zk0EHLiL/AIE+3jK/v3RHoCZwYO4+ceqmTrAow7z1jRSetAPFaXcnBmQOewIoFOUHdiG5ekUFdWQUwOJlXDLduqP9xvWgRWNOoSjcSi/AssEBW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com; spf=none smtp.mailfrom=bedmex.com; dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b=ChJT05aU; arc=none smtp.client-ip=209.127.231.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bedmex.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b="ChJT05aU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=bedmex-com.20200927.dkim.feishu.cn; t=1788774227;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=W/tjzhit7188afMNdjQeUVFsuHLn/LyB0aJkjmumVkM=;
 b=ChJT05aU6mfuOzVD8lvISughvrslUFt7akn9UdLx/rd5JfrgXT0aGCEIqrhPOp8sEscOEE
 xEq3gy1sn8ey8fPUSQh72QL/SPiKBoirH9URgYk5GAdceQzDV/fiZtwVMDXc/6UahYqOmL
 zpX+f0rJ944ZCwhhHbJa0rxAnA8scEq64of12w+6wa6bkU1IJohMMISuwt8Kh3kA6kwoDT
 5d5bWTqJ4euZbZUMMxsC608SocFW/P+4xJ5XjfaCrezKpW8Pt2ngsGGoBK+XU7jri8XbUu
 qt6SL3nW+TCS+aPDXe2I6P/wsS0F4XOISwXsp0LoKQzQVbrNfZM/eY4/dVZgyg==
Subject: Re: [RFC PATCH wireless-next v3 0/4] wifi: aic: add AIC8800D80 SDIO FullMAC driver
X-Lms-Return-Path: <lba+16a9e8751+554bf4+vger.kernel.org+yanli.yang@bedmex.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 17:43:45 +0800
Message-Id: <0c6903be00b92ecb18f2e74fdd9f8cb39e4db47b.c89ac920.6beb.4d20.9ae1.6b2096263672@feishu.cn>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>, 
	"Zhirun Liu" <zhirunliu@aicsemi.com>, "Dijia Xu" <dijiaxu@aicsemi.com>, 
	"Chunqiu Liu" <chunqiuliu@aicsemi.com>, 
	=?utf-8?q?=E5=8D=AB=E7=AB=8B=E7=8F=A9?= <liheng.wei@bedmex.com>
From: =?utf-8?q?=E6=9D=A8=E5=BD=A6=E7=AB=8B?= <yanli.yang@bedmex.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

Hi Johannes,

Thank you for the candid feedback. I hear you, and I clearly
misunderstood the situation.

You are right that I treated your v2 comments as a fix-list and
rushed a v4 without stepping back to actually learn the upstream
process. The "we now have AIC8800_GENL" answer was exactly the
wrong response - I was defending an out-of-tree design choice
(a vendor private genl family) instead of questioning whether it
should exist at all under the upstream framework. I now understand
that upstream is not interested in what we shipped to existing
customers; it is interested in code that fits the kernel's existing
interfaces and conventions.

So I will stop sending revisions for now.

Instead, I want to use this time to actually learn. Could you point
me to what would constitute "demonstrated willingness"? Concretely,
I plan to:

=C2=A0 * Study how existing wireless drivers under drivers/net/wireless/
=C2=A0=C2=A0=C2=A0 interface with nl80211/cfg80211 instead of private netli=
nk
=C2=A0=C2=A0=C2=A0 families, and re-evaluate whether AIC8800_GENL (and simi=
lar
=C2=A0=C2=A0=C2=A0 private ABIs) should exist at all.
=C2=A0 * Read Documentation/process/* and the wireless subsystem's
=C2=A0=C2=A0=C2=A0 contribution guidelines end to end, not skim them.
=C2=A0 * Look at recent driver submissions that were accepted and the
=C2=A0=C2=A0=C2=A0 review threads that shaped them.
=C2=A0 * Run checkpatch, kernel-doc, and the other tooling the
=C2=A0=C2=A0=C2=A0 documentation expects, as a baseline, not as an aftertho=
ught.

I would rather take the time to do this properly than waste your
review cycles on another premature revision. If there is anything
specific you would want to see me demonstrate understanding of
before I come back with a new version, I will prioritize that.

Thanks,
Yanli
