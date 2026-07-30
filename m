Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AC33B8135
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785392868; cv=none; b=twzcEKmnDZH7ddq53qiryuZMcZPxy2MSjH9UWsAY2iOcEO2Znw/I2Q/eKagVtLlEohr83W3916kpcc2l3FtoAhAsbX1d4VK9oAZJuCZdKE0wqVubLMan4mwvnxlX8ju4ClTXZIvcZhefiDsqSJRrI7/pWvim1z6pW3I60GfnYmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785392868; c=relaxed/simple;
	bh=hNd1LXMCpC7C7iYMzoOT1zYVDJKD3HfZIBhE6ObuURg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=jFPSjZHVTpdbL69XI51J4a3zQAWq8yNCTGzarmKe/iEGq4R2QxEW4ObxdXCPqP+UfmwJqx4hJ3reLFT+QsAVj/et+eQElTt9Owv96jPFtAhvel2Ohvc6o30xwVMhcDPkJJMFONYTbunD8UrnrwtvEKe5ZAEjiFHh2TofxKjHrwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kbd3bV8Y; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Kbd3bV8Y"
Date: Thu, 30 Jul 2026 08:27:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785392860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hNd1LXMCpC7C7iYMzoOT1zYVDJKD3HfZIBhE6ObuURg=;
	b=Kbd3bV8Yul9weg9tFExlh4+12Z/4ZqUNcg30zllz18Seu2VpFhDCrTQwium257T5VKVnWg
	gYIkRp8+Cf8Vh+66/F9oyuI5zKtCBbjkQ0DoawFrJJTIdrE5djza6jpd1T4sXeRUgqwOpF
	afEqgpffeTLVd9duAUg/EuuWzQm6+u8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael  Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>, johannes.goede@oss.qualcomm.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_01/11=5D_wifi=3A_rtw88=3A_add_?=
 =?US-ASCII?Q?the_RTL8723B_chip_type_and_SDIO_helper?=
In-Reply-To: <2b742bc6c2a247888b3df630183b85e367f8ffbd@linux.dev>
References: <20260725150427.93887-1-luka.gejak@linux.dev> <20260725150427.93887-2-luka.gejak@linux.dev> <774407603bef4fd38290f6b5d4b4a26c@realtek.com> <2b742bc6c2a247888b3df630183b85e367f8ffbd@linux.dev>
Message-ID: <60C071BE-7D15-4AA4-8FC1-D55AD04C7F19@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

>=2E=2E=2E
>
>Hi everyone,
>I apologize for the sudden silence=2E I have run into unexpected offline=
=20
>circumstances and will be completely away from my development setup
>for the next few weeks, due to family reasons=2E
>I see all the review comments coming in and I appreciate the thorough=20
>feedback=2E I will address every single one of them and get v3 out as=20
>soon as I am back online=2E=20
>Thank you for your patience!
>Best regards,
>Luka Gejak

Hi everyone,
Hope this message finds you well=2E
Thankfully the issue was far less serious then I anticipated, therefore
I am back online=2E Thank you for patiently waiting and sorry for the
delay and hopefully there will be no such delays anymore=2E

Best regards,
Luka Gejak
