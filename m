Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66553C819E;
	Wed, 16 Sep 2026 05:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789538080; cv=pass; b=qLQYRnLZfrm0GVJfhTN6j4w8VvpJgR4grM3VvXF9wsETW1LuBhc1R+td5dl4natkHTCEIe1zbQ/mCJpVLt8G/inw5IvjbkYglBZnj20B+6WoZJ8XZW/2ARD9EifmiZqGZTYIB2b8lrhwB5g7vsUIucMsV0yfBToc/e6YDvIPyQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789538080; c=relaxed/simple;
	bh=7VPxp3B1Gl7oiT9mE1PYkfCbPRVbxVtu5CKXvqFiiEg=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=D7FxULZyVPOXvoIAlaLFGkWreYtq/kXiwf4OjSUJibXYhmTeOgVjEMCssRvlAobrv8pu7XMI28eaQTaH72+/8C8xtj+aMNDpdJF8HsjNjGvcnfujiw2zFU4IMPzZNVJEOOrH5jpplbpcYWisBSzGM6FhgKxFkDHMli1EB9VoBT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=etZUSvqF; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="etZUSvqF"
Received: from fauth-c1-smtp.messagingengine.com (fauth-c1-smtp.messagingengine.com [204.75.18.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hl7PW3tGjz49Q5S;
	Wed, 16 Sep 2026 08:54:23 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1789538065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qDqC/HPIfNfvuSsx83zdPTK1F3wWfSW0i1ycVhcmCBM=;
	b=etZUSvqFedUWuQoIKehKlMEDzQAg2aA9rKos3oZ5YJ+vf8DXQaFF9O2p1nysuUE45SYmph
	YxK3hFEQSPk620OYKQDNQQ9hSWGytv87Vc9JWLeKbgaRLQh6NO8LgfVx0lbcrfBe1wMx39
	KiMjnPnRlB4YYskpwKFZTZA2DE2tu5W7o6ET3+mZB0XVX1J1NpvB+ZJFUYD/SzKxDNpgfF
	vMtbgvQMy2M6DphDvhgxMcwSTvp3vf0tVezkAjodzUoCvISaOuNegOll/urLHckBmY8Ig3
	xMU0n9anNz2ZGNisYiUsVUQejm3aiZhDt5iNznajuvfTkfSDcR9gK6gfADmznw==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1789538065;
	b=Fkrz0PjEWWkiaXYVEllk9Zumo2f2grkmL0OsjlHawaH5cKb9jHS7bb+ILoRGDF2Ejle+3s
	Be6pqawK3YgJMAQk21uYWhtEYhicKOJb5pqfVJ5LCrKwAW1t9MYA5GPpMn5MQ0AsKOL7+i
	6yqXQHSyaxvhklaLzsllIrwnumpKNH41u90xfLeqz53UMtFNPLn5UYXb0gVHIK2iRnGKA4
	qGv424ZxxTbGKVgPJtSYDQpeTws7lBptsoNfjw+q7R48ILW66psRUA3oJXqLHnKlP622rp
	Jd/F70GNN4eDl05zDdbpBnsJXHd7M+cq99y0K6QprkqIWSnePUsKa8n9BsmK2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1789538065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qDqC/HPIfNfvuSsx83zdPTK1F3wWfSW0i1ycVhcmCBM=;
	b=ggQoE1hJjO1bIWz3b7plcizJC571s5KJ+w0aYjoYuzLCx9eDUwuWF3xPpA/GfBpUePmkQm
	21zrZ+ZcNhviOaW7u2UmZOyP696szakP4bzMlAdsxK3PyulSnolBrUTb4N87g9koAFScYv
	pANLUrx/8ttlnsCuy+F9s0fpMb0I94PBICOTeO+mArxKHjrbxkez8VMiuGJmEPjC8hJZUg
	bnUh8TMw1HfFKYrTvhNgcHK+r+aESpMmx+Nw36YBrYdVo0THPHy6aTtweTE+aNBicBfNkQ
	rWXc8DdEglRKr5WV8jkeR0AVuG6mxImKfC6fLVQsrdFqOkJZUdIq78CuYC1CGw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id AFA631980052;
	Wed, 16 Sep 2026 01:54:22 -0400 (EDT)
Received: from ams-imap-13 ([10.64.2.33])
  by ams-compute-02.internal (MEProxy); Wed, 16 Sep 2026 01:54:22 -0400
X-ME-Sender: <xms:Ci-qaiVMZFrwdhS6C9HxvFDOVM1z7iEPVeRkndxuakxpeiJivwQj1w>
    <xme:Ci-qapZ9yLxHQ17k9xfIEjOdRk2zoiWaI8XbFeuvGxn-cbBVeTpn4vCMBqUji-znW
    CGYEhlYZEPz9L65fL_Tk6fEwJf4d6a5PfEfxn-SmuPClQOLCOUR3tM>
X-ME-Proxy-Cause: dmFkZTFURl2j0nXvDHDFYLB7Kc+qfRb/Fq1qdvpzuJNk/3e2E1JHui3UrZE2VVvNddZf0L
    AV+TGoBl78YpaIVHnJMdDQ8JVuQRdwMk0ewqpfwEVJpON9+YKqDH46FGTGp61wWV9FUYo2
    tq0G1TVu87vq6gu7WcV8CB4hgF664wxci3tFrqEpBBUMG5WXorW2TBjPn7BbZdxr5xUG7C
    VGJpJKBuATFkQ8KsQSW66ZneIGPc/PPlCM2g0XToXhlSEKvDrRVQwodzgxylrwEY/y6igV
    wbxdvsH7P2/gjvN+sa4VkEKZDNsdDMBhkXnq753Mw4f5Rc6MJgLMLRy2Q4G6r6pHj1rYgr
    eE9tSoRaQUX4PdPnsQfVu2TZWA6r8y5LQNgn7lo/oYeoyrYYDjeovh1ZwXulgY2sEQ9iR9
    2CBFaoEUlG0IsaOZ3POI6GNbqFs60exacJTRvCu/Of1zSQ27QEZ5xREUGufsA5j1RTslOG
    jtSCiNQszBaNYBL+qTI8/H+mRwmnnS5hGUoucWdw5iMfBBB4FuMuE1W2SV4sN6uT8B/Vv3
    kBWFvsNBo9ghedWk4NVGo8cysHntLdXoKXDMjZlRm9+OVPVHu3E969U0QHq5idi1R3KVkQ
    9bu4yut1tEIRC+LNrpKcNznJPjANnuAJffWPPk2l267rGz7fr/TMOzTt/npw
X-ME-Proxy: <xmx:Di-qaqeYe2x73OWTcAcE491AYG93_x69Z7OpMpdf-ocooh8qhKHosA>
    <xmx:Di-qavoaA8fBPZN0i8hK9fCidfw_4DX4GKTupUahuJNF1-4xrxWs5Q>
    <xmx:Di-qaqM--IBv2Nx_o4CEo_nVHw6-hmJ2Pu6QKGCbivBSEgU7Y1vpvQ>
    <xmx:Di-qalFM32JGM2h9BDCVcFQWRXgl7eD23GD8pUW8fMzuS8S8i20dMQ>
    <xmx:Di-qatGQmngdPE7_ClIkJL7y96JNuN8MQuDKDH2EZ96u8SXRu4gedR_O>
Feedback-ID: i02414972:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id CA2CFF80089; Wed, 16 Sep 2026 01:54:18 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A0bevnK5BUW7
Date: Wed, 16 Sep 2026 08:53:26 +0300
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
Message-Id: <da6003cf-515b-4d97-8059-3f4553d0251d@app.fastmail.com>
In-Reply-To: <20260915154705.67cfb94f@kernel.org>
References: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
 <20260915154705.67cfb94f@kernel.org>
Subject: Re: [PATCH v7 00/15] QRTR Multi-endpoint support
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Sep 16, 2026, at 01:47, Jakub Kicinski wrote:
> On Tue, 15 Sep 2026 08:41:52 +0300 Juha-Matti Tilli wrote:
> > Subject: [PATCH v7 00/15] QRTR Multi-endpoint support
> 
> qrtr usually goes via core networking tree.
> Please make sure you base your patches on net-next/main

https://github.com/jmtilli/linux/tree/netnextmain_multi_qrtr_v8_multi_ath11k_ath12k_v5

That will be the next version. I'll wait for a while to see if other
review comments pop up for v7, then I'll post v8. At least the
current v8+v5 QRTR works just fine on my multi-card setup.

BR, Juha-Matti
