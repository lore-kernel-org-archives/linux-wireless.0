Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B84F51815D;
	Fri, 18 Sep 2026 16:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789749584; cv=pass; b=kxILnmgvqpawalEawahE3EiHXyGiIRmZNFE5nKexrMzPyUHwzOdQ691a3sb48THBpOyemgoB1djBreHpdjubFhzHTlu45UQO5w2vThbHR51kxm0tcZD2ferVbqAF6VOkWAq87tFcXPeq494edx/vf7y2lliNeW8u+fhFiRKnJIw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789749584; c=relaxed/simple;
	bh=OaTupvPSXjV4tcDSKwkLoCMZSghlDqaDma0/VaD1crE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=TuY6sZOS9PVHVk0ju8nXWqBniaY/5ITlRdfuJDXOIg5H4Snv9wUoYi3AUB7kbzicGy6BIyn3OE5OQVZ4BLTB45nAyAMUPCOKnYHoBzfiXFvtwiQCGmSbxd1Gk32zpQcfL+0UB0SciDgr0T3sWVF5mZeK+NYC6F1bqTVvKQmTHio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=iAEFtWQN; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="iAEFtWQN"
Received: from fauth-c2-smtp.messagingengine.com (fauth-c2-smtp.messagingengine.com [204.75.18.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hmdd20yJjz4BKJ0;
	Fri, 18 Sep 2026 19:39:34 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1789749575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2bX1EKHp0Quhk+gq7adxCGKb0B+LghpMlLP0cmw2Iew=;
	b=iAEFtWQNRz7ZhG0NW3u+R5nf2yCYlC6GZiGfIQSHWWikVd3BZEqvKiRqhkh8xqUAfeQQ8y
	vmYlo7mGFhy8yItjoLXC/GEaimZBLEVl62C7j4SZtkru0inNfCNZEtCEOX9sYmFnlrQrxe
	MyfzN8/hkhCvuZnI3ClS3aASNu1UDw4zgoAByyeQoimHj0wNfZk1s4t7sXAndb9ozQikEo
	TgHdb5T6t4Ml8sdO1U0Z0tfO+UAL1qPeSk1hwdyhrbCZ3pOEsB3ygaFpfFJGCvI2WcS2hM
	W/LrWXTcoTDxGsn/sPRcZm8y5OTRZXfhqqyOxVXKMLT3e+Z86zCPXs6KKakxFw==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1789749575;
	b=ow1e5bWZPlMwdxa3zBgMYZhowt0Jx9TW5u/7uukf+bC0uJWdfPMtRJq+lxs9jUiU2/L5mv
	QeuEps9tcxD6cLxQdMvnsPgbK9AxsGhWiI6FDR5cOFvSAsCiRD/rY7VIn0rBfOs3dBGvd/
	IlZu7atuc3GOeh9KRyla6aUnKjuzcOvVWEYUoP9uy8lOacjAgy9+c3LDhSDfxjaS7wR/Hm
	IrZxTsl8uYmPudTl+AkB4lxAX/iBY/LYpS/otik+fY0zwGm4R/D9AON4K05f2BCPqet+ph
	Re3xfOrCNNXjqC1ORaMsrcP/oOiTmjD5TRHMKihcAgSDA7hvxtslYvMt81NXPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1789749575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2bX1EKHp0Quhk+gq7adxCGKb0B+LghpMlLP0cmw2Iew=;
	b=WZyOtIptY4USOulG5yJ42VHC0cu4JnzGVlYmpfvh4ikc52IMOTDDo0gpZfwpgAGbitKg2/
	qLm4InJeHJ7c72H8ipq2Gt69rZpbUJdWyHU/XbWs0wjSm3g4FSrzzjDUHGHeCfLDPxikID
	GggWBmom+ZcKK4PSpabH3eV7UdTDB4IGbLmrJh53npLgrWK8rRIU6LxFUfCx9p2pV2rq8R
	GLbXsjJ8mN1YZttRYT6z45B0Ef31TerdQP1ueVW6MsS/X4umaL5YKCyMNt+cJ9v/rQaJW4
	Rl6PJRd6W9pEkQjc/85nq03QdB9XgmqX2vk7e4W5G7VZb8SON1F6pcx36yGBCw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 3F094198005C;
	Fri, 18 Sep 2026 12:39:33 -0400 (EDT)
Received: from ams-imap-13 ([10.64.2.33])
  by ams-compute-02.internal (MEProxy); Fri, 18 Sep 2026 12:39:33 -0400
X-ME-Sender: <xms:QmmtaqeMMcYIM05pprdBHW9q_Dsel74suD6rURye1JW5lr8UZ7Icfw>
    <xme:QmmtavDA-T64SwNcJBHTzegN1wUuft2p04NrdSjTH2Td-COBf2tNbcCPW0wO7cy0_
    UvUUQfwIMd4W9XgByOhx8sOjRsMJ9QtOpMQ8_iL-HDUJLRWdTjGgavI>
X-ME-Proxy-Cause: dmFkZTGgrfBZdGn7M8WQTKUJaj1D8vr0/YFLGS6Y6O+RkC9rVsC5GJqpFn3Fe27jJ2IIue
    BBwj5693w5e8/4dplpgmEgLTfKlZju/Afuw2j/G5cDlzUYKQ3m1oRScdb9OKSPnEhdLAQv
    vpSNDMP7t/mrrwfZsInHg6rHRdnv38WFBMZlvGNP27WkU/7TxW+HNM/1bFvB+hF9h7pjSo
    u9rYWBkuhh6evLdJzeJEoEvusgi4E+MZxzPs6D0ZOp8TjeawU0BAKo4Z3c1e7tL+bjgkmi
    XHW2GyJCOw/5cUEGDbOFwxooi7CDeA4mLH2M8Lk3GHU3YaoYR3qIFwQpN55RY3qksOyaYj
    nJw8H0/I9oejv3/Wi8kTthvEAA7X0iz5qV/jphCnaX5S18R4bOouTM6MF6o4ElUX0VeCle
    bGIFVWYuNkXCM8jOrOuL3CII5M4mksxH0+XcHGcxAy09OzKH0dO8DqIeabpCij9QyJ9UfM
    DvbyRLw2ehOK+viHPEazsWsS5HG7t3EIZDQOGRVF2mJT0YsJlKABGbK4xmKYOBEIyjh9oo
    ZtBT+VVvspCLCNZEhdLGi7BAM4CEomN5EX06KpCw9vTfJCASjgZxru+3FwZOfn9TaP4npj
    4LDBn0mqjcWQ8pigmvosMMS68S+gTztclQigXTr6Ez6Bc1WIx1ZWRxeNOEHg
X-ME-Proxy: <xmx:RWmtarOH03taGg0WXK9V0sd3CNzZ_fFd4j_VjgWortLKjD3xiDhqOA>
    <xmx:RWmtagdBu8KwNJc95xcn6wihEDHA_xfRXCVPxKAPLfJdgcRsIHUPtw>
    <xmx:RWmtanOXwHDGhX4MDbwUJmp2meJgvjutV7YIhbK_py5ANs81odKH2A>
    <xmx:RWmtaiaVgn3sM9-jss19ME0I9SOYvYH2D9oecZCuVehoSAsZzGjsLw>
    <xmx:RWmtarvoXwp5XTmR_ukN9c5jTfCAquAaPFysOWg11WiUVMfRdIP420h8>
Feedback-ID: i02414972:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 7CDCEF80089; Fri, 18 Sep 2026 12:39:30 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AbqzItSRZteg
Date: Fri, 18 Sep 2026 19:39:09 +0300
From: "Juha-Matti Tilli" <juha-matti.tilli@iki.fi>
To: "Manivannan Sadhasivam" <manivannan.sadhasivam@oss.qualcomm.com>,
 "Manivannan Sadhasivam" <mani@kernel.org>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>,
 "Jeff Johnson" <jjohnson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org, ath12k@lists.infradead.org,
 "Bjorn Andersson" <andersson@kernel.org>,
 "Chris Lew" <christopher.lew@oss.qualcomm.com>,
 "Deepak Kumar Singh" <deepak.singh@oss.qualcomm.com>,
 "Raj Kumar Bhagat" <raj.bhagat@oss.qualcomm.com>,
 "Jeff Hugo" <jeff.hugo@oss.qualcomm.com>
Message-Id: <da0421b8-bf31-43d1-8d71-520753c8344c@app.fastmail.com>
In-Reply-To: <20260918-qrtr-multi-ep-v1-3-8a06caa368d3@oss.qualcomm.com>
References: <20260918-qrtr-multi-ep-v1-0-8a06caa368d3@oss.qualcomm.com>
 <20260918-qrtr-multi-ep-v1-3-8a06caa368d3@oss.qualcomm.com>
Subject: Re: [PATCH 3/4] wifi: ath11k: Connect to the QMI server belonging to the
 device owned by this driver
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Sep 18, 2026, at 19:28, Manivannan Sadhasivam via B4 Relay wrote:
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> When two identical ath11k PCIe devices are connected to the same host, both
> advertise the WLFW service with the same service and instance id. The QMI
> lookup reports both servers to each device, so a device may connect to the
> firmware running on the other device.
> 
> But now, QRTR provides each MHI endpoint a unique node id which is
> different from the node id announced by the device. So use the same id to
> pick the correct server. Add a get_qrtr_node_id() HIF callback that returns
> the node id derived from the MHI controller index and zero for transports
> that do not assign one. In the new_server callback, skip any service whose
> node id does not match. A node id of zero disables the check, so transports
> that do not assign one keep their current behavior.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

Tested-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
Tested-on: 2x WCN6855 hw2.1 PCI WLAN.HSP.1.1-04685-QCAHSPSWPL_V1_V2_SILICONZ_IOE-1

(assuming the patch is the same and hasn't been updated since 17.9:
https://github.com/Mani-Sadhasivam/linux/commits/qrtr-multi-ep/ )

BR, Juha-Matti
