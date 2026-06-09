Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A781A3EEAD6;
	Tue,  9 Jun 2026 09:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780996930; cv=none; b=DqIOvHUX1KMwG83MB3yXYNfIyPqkl5fMEai8FKETTgvoVaDTSLxrSHVewQdxazhzh+cEujAX8akOCH89dMiJa6jOY0UJYemQ3CtNmQEDWC14OkNuCpkBPL2TRe59D1alzPq0+AToWn/2Nmpg5mf8bogXENJ5IVHKax9UVsImur0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780996930; c=relaxed/simple;
	bh=rNgJjkqUXvclOxqjax98QCBO7bm8YhheqVkY6FYq9pQ=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=QjC5V9xlN+ZB98jaaOKMyuo8VBoMI1uwywfTzlBJQuABx6+5NAxjI/bZ8yyX2z6nXfG6CERjLY9w1rIfjMlBSgh4LUBS0cAISo12Ed6oS3x0nTWhXBHB8y1ihiNWkC8OTJ6YiFJbRuJHxa5GJINmam+crD+/eHGYfc/eTLv3zp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com; spf=pass smtp.mailfrom=fastmail.com; dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b=fSigl2WY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ceJgdNo1; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="fSigl2WY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ceJgdNo1"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 8C2F21400164;
	Tue,  9 Jun 2026 05:22:06 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-10.internal (MEProxy); Tue, 09 Jun 2026 05:22:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1780996926;
	 x=1781083326; bh=rNgJjkqUXvclOxqjax98QCBO7bm8YhheqVkY6FYq9pQ=; b=
	fSigl2WYgmYCinux0ObyMZ/DXlvaXvw8WNFRa3iUIDx6w/aSylLOgdKKB3PKGBS5
	w99zaFfNbXPQ4EvMkj0F2fXyQ6ctjAvqXY5IsTpIKtLqjIUPwXjV7V7+CIzsRcNo
	Dqr24kWOhj+c8nppsWw77er9R0wSm2bxFlXT5eeKZcS13kPgEtFCaLLt+nm8Dsbm
	WDNVv0flgInePBD7WvWaoBtes5jw4z69IxqTxBDUX9QOW6JjR9tF5l9MNspSoYbL
	T3lCL8BP54V7jkkikzeuEB+j+hsC87TmtYFrUkUFlNd9XggBvtufQoXdjUxoXda8
	AIqQJ66m6mCDLt89LEwBLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1780996926; x=
	1781083326; bh=rNgJjkqUXvclOxqjax98QCBO7bm8YhheqVkY6FYq9pQ=; b=c
	eJgdNo1aYvPicssE6rT7CZI2em8ah94sIfti0epPUyPC+g1qeuuYAT+Aveihu6cp
	JO0krJANwQBuF56CSXDtQ22HhSa55MT/SxwlVayDv2F19BAgc1iI/x3ZwaO8aDWe
	rW37NINUVx5w87kkm2FR8ZluKJriX8gRpsoPefljZPlkEx7XYK/oulGYhV4pGSfG
	QiozBEgWdNVi+wAbqzkHo4ksl3A1MyRklCJrq1bdaAJIQNozNPLKDZJvEc/dKSLE
	EjOBxBGwNA/bjp0ZY35GWJLj1XW21WfwI14ZLCp2/s2q8yohyYDvYcaYJQhQyUgs
	/ySW0+3Px37X+LI4whBXQ==
X-ME-Sender: <xms:PtsnariwnPev3mVJfxSQ3iKKmk8glj3BeUo_yUmbwg5g5C26dgiK1A>
    <xme:Ptsnai1iq4kpGQDXaz9_WtRj9aZPgEYEf3eeijT31B40lX1xRgxVnUprULyYMxHks
    vRTZcexgQjD8ZcHvXSbY3JCbKCUJgXQJ1oWnsRuMUkKHiNnVuw3>
X-ME-Proxy-Cause: dmFkZTEnJvZd+qEemXOkQl+NioykKeo+ibtLrN/x3ze24JlTD45PsYrzfna/LbkhUq3ILn
    OdnN8S63QahBTXjvN3+uGASlxRP+IiU5rrQga0+JPkv8EIwEkMUh8onEFguAT/S4M71Qhe
    LMSlVwuoenYyEw28UEuyJnRH7Ny8FdpwkHCcL2XDBPWODUTvAJO2Qy2pGb3uit5SAOq12v
    FK3SzxqdYZJzMDpVelNavpGsRkgKLw+UJjZFxfrDLhp0XMheGeZF9vMK1z6r8sy949Abq2
    ByU1W/1X1aRSfaaFaTH866aTpO1Qj4YWDR5fPXZIZJldqPSpacd5bWRbx1Qg3OC/UhmXZT
    BiEnIA5YJw/0+SBuQmzer7UG39GnUuvvxmYWjdj3AudiXQ6CxeRG5agsJ/GjJiETqMwIbB
    SXL81fAqLxiYDce0jcFud1wqdVKF45cfir11w+dr0kCdN327/XtiMLzpwHkcYMsHn0WPpo
    MVasFeZSqI+SZL9oetdum5pK5XDIwX6peg+MHRfF5juW5f1TBqdXzRcERH7JBfxwYko3TH
    2yulz+OnmSXZtZiHuXx5uNMZ/5gzmsxfulObu+jSQBYYzT/wBCwHi6iEGwBuuLP17+ycG9
    b05dFWkH1rEXsldwjSRe0HasdldQC/L+OD/0MS8uKQiL3Pm7vIB/B5xQP8tQ
X-ME-Proxy: <xmx:PtsnapKyDN9aUPGFhcyxg505eWH0C0sLI3Mz-gxJleXJEUIYNbPzCg>
    <xmx:PtsnagmCBerkweAvn8tIJSEN0wkjrnC6uWtUN2hsAT3gxQftFRaRtA>
    <xmx:PtsnalOHY81gv1aPqX_bjVDSO836U3YE-JA-ZDLnfNL6qmXIg6FumA>
    <xmx:Ptsnau0WprRJjR_CJ8nyJdw5RamHsKhLtGdn-xOuMZAK3EeqvIEhUQ>
    <xmx:PtsnaqbtQ1DBWDaKMKof57ikXkm0yyRiHBMgX1_EaZp2qBDpqFH-_mm5>
Feedback-ID: ifade4b72:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 56B24182008A; Tue,  9 Jun 2026 05:22:06 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 09 Jun 2026 11:21:45 +0200
From: "William Hansen-Baird" <williamhb+k@fastmail.com>
To: "Ping-Ke Shih" <pkshih@realtek.com>,
 "William Hansen-Baird" <william.hansen.baird@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-Id: <5cf53e3e-001a-45ea-aead-3f9b8d9a1a0d@app.fastmail.com>
In-Reply-To: <8b562a921c7944819e4eea862b1b53b3@realtek.com>
References: <20260608135345.2526325-3-williamhb+k@fastmail.com>
 <8b562a921c7944819e4eea862b1b53b3@realtek.com>
Subject: Re: [PATCH] wifi: rtlwifi: rtl8723be: Remove unnecessary irq save/restore in
 hw_init()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Thanks for the review. I'll fix the commit message and send a v2 with your ack included.
