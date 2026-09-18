Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3557537187E;
	Fri, 18 Sep 2026 06:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789712681; cv=pass; b=Qg9XGsRVSjtb+EMYPMnyJ/FdDPwGzRuGHdJGlfcbNeaAR5dK+d+/ZqYJeO+9m5v2WjAzwAafUzQa4+GJttCshc3PX4D7KAmASPflnaxxu1ABojooeDHldQEEmngTkbHrRk5yQ4zE5RbOPK1CZqfT8Ir5yoTTA+mK+4WWHajE6c4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789712681; c=relaxed/simple;
	bh=MgYRcqrrPR+pmr4ZfrOx8DSOTQ2aU6Q8fwh6LPUstbg=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=huYCPX907C1Mg/NLZb99/QboJrMBHcXTqP9ivGdSEIgSMyZemRVHkwYY2eN3vEiaMdj1+2dR1FrXxdd6GJOkg2dc4Zh35QsKh0Oe5Zgzji/DCJCxW4yhDOe3TuGPnVHYfYtEEaBqnJbkEeIhWss5lOxw8iZJwY4gPq90CKerQck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=DZAmBKx9; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="DZAmBKx9"
Received: from fauth-c1-smtp.messagingengine.com (fauth-c1-smtp.messagingengine.com [204.75.18.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4hmMzM3F23zyPw;
	Fri, 18 Sep 2026 09:24:30 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1789712673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Utn4YPDnwDWDiEHtSEYn9vYIonNp3xKbLi0xHIMoSJw=;
	b=DZAmBKx9a5AYL8v8Rw/xgspyq/9yJtval4otTmfGRTEtsbkSvVoO8PrdLoqJK6p3/8eEmB
	xvZ/NPDubXepn5S8UmBPTlTNcSykLyL2cfqUDd7JkXSqwT6TGsnVHn5ws2wQU8gOJYKo/n
	egikt+rL1G7Z0fOtKM61J+Uifcqctk4=
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=meesny; cv=none; t=1789712673;
	b=DD/yGEYGpCsqIeC12y+RrqAMVQ7CmpX64MsxWDOSqmTOgyvS3plQgvYxBWkY6q/3EjIVCH
	ybZsLaEspvNuyb/ymffeGpe0eiTD376i8q729KlbOvmpyxJ8JgHglddIMyyfTTa2A44Bmp
	VmdsntABKnnaxSs1aUXt2JFvp47Hyr4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1789712673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Utn4YPDnwDWDiEHtSEYn9vYIonNp3xKbLi0xHIMoSJw=;
	b=cGo+/Bi9SjwGvyxoaS4TxMjtwEMmfnbxiv7bB+O0IklxkFpXpcOp56H0Inmip6gNTPj1kT
	NOkPpDeUYhMYbHHM93B3Wk1nY5ZyU2IYKFhAZOYSlIaT9P9FwSg7WBO57PeRJjJ52EuT5+
	10krgdNWRLAg5jXXAXZUEgU+KkJCZzI=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id ECEDB198003A;
	Fri, 18 Sep 2026 02:24:29 -0400 (EDT)
Received: from ams-imap-13 ([10.64.2.33])
  by ams-compute-02.internal (MEProxy); Fri, 18 Sep 2026 02:24:29 -0400
X-ME-Sender: <xms:GtmsasZSldZjBkFz_WJVQZEs5UjywjLFU2n1E4XPlW4cAkZf2LKxNA>
    <xme:GtmsaiP2CGTsUN2CnwzkVB-KDUJM1YNv1W92IFFG9_Eq_yrSd8QJXFnh3v86Vwwni
    CNkPdtLIovqk6M6HpgOYLr_7iAZkx063K6sjfMyDmjb7QA9CTfgt_kC>
X-ME-Proxy-Cause: dmFkZTGSQzkLHL20dI75v5KezdrR4/54n/FI7hF+bC7Q1yK6wOtpVo6TuJQUEPuDh31dsb
    1ffrVC9rw69TEmxHIkji76ul0+KSPvDqPDDlixfmostS9mk/hXKpw9WgeghXAiMxb9iFEI
    6wK0BpZhd/9VrFcYBUf0tiLPFrYEk/e0Kt0Q2/or9cMoOT9ndhwCtauEfcfEdGU7BPXx8A
    Kfr/3Jcso5z7tfdqDqQ1uPpEp3muBglFn8fmUd41iqOXFr+hR6O1NU8YHpFBanA0ZwHhqf
    Qm2UlHYgwBOfDwRJNVQCiIVwgqqLvOXS/eqrKqEJzm+qFrdWJtEOCEV7D5LhNwHCyfPWYd
    LWxQTl5tJYZE0SwZ0LmJefWEgd+7eWTcnKEjrEf1alX99BTOcDzMDvLXJ0gGoQpNmfIMDi
    WIEVg8HZzPFdx8kRudDCnNQcVnR0AlipijaAty0J27ZagaJoDMjBEa8s5++ZU27p9vBWqx
    Y/HYB/moUWPwyh7rIf73gwCHoKTs5x38FEaZKJyApyd2tw0/qEJ6cw2RqPoVmATYF5zRwx
    Y6egJAysP2b4e39DA8rmIsKqikL6IKpDayj+TofjQxtohllnUZxW/dDr6PaJ3n9UmnP5zD
    4Sh8yHaCRd9BGAg+CmiUYFXmPqIN9wh4sx5k0pXkwEfwSDzlzbm0qfF4pPRg
X-ME-Proxy: <xmx:Hdmsarh1TLmd2g4qin5IG6Bb8x7s9IJ0jMQ7jCqKbry52eP7LdUr0g>
    <xmx:HdmsajeBOqx1e5YPWdeP7o-v_kc8s3FI6XiFpc-zsGabUBFxB9WcjA>
    <xmx:HdmsapyUpQUUemavGFRAsE82BNgLQPhZn4ooxQuSXPjS2QEbNPLOCA>
    <xmx:HdmsaladdsvHVav1idVfoZ2Zvfb8UA76u-hR6tvQS_Zj1pLzkVb4IQ>
    <xmx:HdmsavKNbvouncS0j1xMW34rey0AGVqSY4Uu0Oy1Ywr1MopH7FtvHpz8>
Feedback-ID: i02414972:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 6B303F8008E; Fri, 18 Sep 2026 02:24:26 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A0bevnK5BUW7
Date: Fri, 18 Sep 2026 09:22:40 +0300
From: "Juha-Matti Tilli" <juha-matti.tilli@iki.fi>
To: "Jakub Kicinski" <kuba@kernel.org>
Cc: "Manivannan Sadhasivam" <mani@kernel.org>, linux-arm-msm@vger.kernel.org,
 "Jeff Hugo" <jeff.hugo@oss.qualcomm.com>,
 "Jeff Johnson" <jjohnson@kernel.org>,
 "Bjorn Andersson" <andersson@kernel.org>,
 "Konrad Dybcio" <konradybcio@kernel.org>,
 "Eric Dumazet" <edumazet@google.com>,
 "Kuniyuki Iwashima" <kuniyu@google.com>, "Paolo Abeni" <pabeni@redhat.com>,
 "Willem de Bruijn" <willemb@google.com>,
 "David S . Miller" <davem@davemloft.net>, "Simon Horman" <horms@kernel.org>,
 "Mihai Moldovan" <ionic@ionic.de>, "Denis Kenzior" <denkenz@gmail.com>,
 "Marcel Holtmann" <marcel@holtmann.org>, "Andy Gross" <agross@kernel.org>,
 linux-kernel@vger.kernel.org, mhi@lists.linux.dev,
 linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
 ath12k@lists.infradead.org, netdev@vger.kernel.org
Message-Id: <9837273a-c62f-456e-9aa0-567b0d3a6f29@app.fastmail.com>
In-Reply-To: <da6003cf-515b-4d97-8059-3f4553d0251d@app.fastmail.com>
References: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
 <20260915154705.67cfb94f@kernel.org>
 <da6003cf-515b-4d97-8059-3f4553d0251d@app.fastmail.com>
Subject: Re: [PATCH v7 00/15] QRTR Multi-endpoint support
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Sep 16, 2026, at 08:53, Juha-Matti Tilli wrote:
> On Wed, Sep 16, 2026, at 01:47, Jakub Kicinski wrote:
> > On Tue, 15 Sep 2026 08:41:52 +0300 Juha-Matti Tilli wrote:
> > > Subject: [PATCH v7 00/15] QRTR Multi-endpoint support
> > 
> > qrtr usually goes via core networking tree.
> > Please make sure you base your patches on net-next/main
> 
> https://github.com/jmtilli/linux/tree/netnextmain_multi_qrtr_v8_multi_ath11k_ath12k_v5
> 
> That will be the next version. I'll wait for a while to see if other
> review comments pop up for v7, then I'll post v8. At least the
> current v8+v5 QRTR works just fine on my multi-card setup.

Hello,

Some positive news. There will be no next version, as Qualcomm is going
to provide a superior patchset that I tested. It's easier to backport,
cleaner design, fewer lines changed, has 1 author as opposed to 3, and
most importantly, it worked just fine on my 2x card setup. 

Thus, I'm going to abandon this patchset.

BR, Juha-Matti
