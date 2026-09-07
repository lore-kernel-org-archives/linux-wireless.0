Received: from va-2-43.ptr.blmpb.com (va-2-43.ptr.blmpb.com [209.127.231.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410D83B8921
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 10:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788775350; cv=none; b=NItT0GtRtP2O+vxo2ugNGgQPD+o9Yz2YcFBVu0fP0xAuQvMdXmLjHT4sfeaE2CaV2OQldjw2Zntg0PBtpPbhRFU5uJj+rcd/y2MJeosKK/zfAa+WKmiMRieGSjxZP+weLIgnH6e6mcF7B9vAGjLXgrp0JE7CLb6TFtRh2OI9nZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788775350; c=relaxed/simple;
	bh=HczVLTtxVajXFngPcXvq/Ip+QgRs8fxNXtfUWq/pR4E=;
	h=To:From:Mime-Version:Content-Type:Date:Message-Id:Cc:Subject; b=MUnEzfB9HJZxjO2+LF3B3S2U4RaaeXYSl5MsPry68gKVn42xHEYOuJBas+Ghs8kQrHLE85lifSN53V4NR/aG1iOAvPXrtBt9hZqfz/dcvwXNCs2M9PhYQMl1yVxviOX8oxpMJiZq+whx4nNao8dbvewM3I1w8dz9aqx1dY2z9wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com; spf=none smtp.mailfrom=bedmex.com; dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b=mpSqoeHt; arc=none smtp.client-ip=209.127.231.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bedmex.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b="mpSqoeHt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=bedmex-com.20200927.dkim.feishu.cn; t=1788775336;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=HczVLTtxVajXFngPcXvq/Ip+QgRs8fxNXtfUWq/pR4E=;
 b=mpSqoeHtZMsmoApYADsZZH2G/s6MIRYVs+8BfZlXe1MuuEDfx1+2D5HKAJcnsl81JA+a5j
 RKgnNX/NMox9EFpiB6onlokJRi5IIojAp4tO6eYgUe7ObJlYotURgZ4uhVm/GpyuwPL6g0
 MB2PCacdNZBWmgr7x/XTLJSveNK1gIrBvVNR1achiFE/0vmmutzWiGU5AHarFPaERmdLF1
 fZofwxXz5TegYaGC15AnudgwoHf/8yT8ZuxBLqIv/knyJH6mqmLc8qhHb32xn3P1uFWo15
 JcPKwyvvDFIr5QMj0DjrPd/429QzxYTZPP9AyLM4P03jvpttWtVs8zqGkQqFNg==
To: "christianshewitt@gmail.com" <christianshewitt@gmail.com>
X-Lms-Return-Path: <lba+16a9e8ba6+d26148+vger.kernel.org+yanli.yang@bedmex.com>
From: =?utf-8?q?=E6=9D=A8=E5=BD=A6=E7=AB=8B?= <yanli.yang@bedmex.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 18:02:14 +0800
Message-Id: <0c6903be00b92ecb18f2e74fdd9f8cb39e4db47b.5ac6183e.ac36.4b69.a75c.17bfd7917817@feishu.cn>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>, 
	"Zhirun Liu" <zhirunliu@aicsemi.com>, "Dijia Xu" <dijiaxu@aicsemi.com>, 
	"Chunqiu Liu" <chunqiuliu@aicsemi.com>, 
	=?utf-8?q?=E5=8D=AB=E7=AB=8B=E7=8F=A9?= <liheng.wei@bedmex.com>
Subject: Re: [RFC PATCH wireless-next v4 0/4] wifi: aic: add AIC8800D80 SDIO FullMAC driver

Hi Christian,

Thank you very much for testing the patch set in your rockchip=E2=80=917.2.=
y branch and sharing the compile failure finding, I appreciate you taking t=
he time to try this out.
We are aware that there are compilation issues against some kernel branches=
. Those build problems will be addressed in our next revision.
Just to clarify, the current v4 series targets only the SDIO variant of AIC=
8800D80. USB hardware support is not implemented in this version. We will c=
onsider adding USB support at a later stage if there is need.

Best regards,
Yanli
