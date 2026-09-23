Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DA730ACEE;
	Wed, 23 Sep 2026 06:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790145805; cv=pass; b=IF6Oa+9YG5L/RJNiFxKFNfGjecVwYKNQFPESXmL47rp+1qhvKtCKfZAhqw2c190QhJhb/GhXVXdikY0ujbHwo8ZIJ5fXuRL2apZmulao0q2Acy5FWOaaFVQPg5XfFsuvwQ2xkCaQHu5v8k88cXyimsc/SvwlRbUM/hfJnLIYaqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790145805; c=relaxed/simple;
	bh=rYNUtYVo/DE4BajXfdVfAGUQ1KL8Prik0dfzkqOMPgg=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=QjdIwiwEJKvXjiOdYqV0xv6Fh7GSuw/vLfycM+AUB8VONrLp6rqSopgNGW0Gqzcb9LCreo4davxlLG8rau7ej81n5ADIa1xviV/BTudK6wUYUBxN+VsbHe/2l9wSvQIE2QxvNKs4okmJgrXaS24Rp6Doa4F6EiT439ACEatE3NA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=L2J86SbM; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="L2J86SbM"
Received: from fauth-c2-smtp.messagingengine.com (fauth-c2-smtp.messagingengine.com [204.75.18.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hqS8b0Gh5z49Q7P;
	Wed, 23 Sep 2026 09:43:10 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1790145791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7wOWxYY4eY9XU25OMHVx3sfwNw2fYVAY+jnGCl+7xTA=;
	b=L2J86SbMjEGywVetJbAFl10zJowdDWQM07D3vE1cwVZkYPyJWIqJfDNKv3jQgY+IVSD/RO
	+iJP90HJFNiC5aHlBhfOefGRnCY54oQs6AL5AKoYU79V9iYSZsm9gY1vGWkUkM4OS1nz2I
	XMG1OfZSbcJlki4EPKroRJ4n5Z1/F4ymhKmJGpHc9JVVuqwG0ZLbeVdYp4LxHGy5YcsMSa
	zqOZUNPqwH3ooRAqyRmZANqWmxB1J4FPJ8GHHEiChAOMUg7uNKG9dNoZkdnmQ4x5dNzWuO
	FLv3srBQxPf7Tup4E0qr1n9WkfUDgYszoTT1CMJuNDu3Vdznozd9S8GpxyG46w==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1790145791;
	b=X3JZL2SuTJ9/lESUDZV8bqVUsqxTkRL/F7XS+ZgXAqoXzJDayZfkB6z8FLdUhihoErC7pQ
	PJhxAvraTvXrFn0OhU3d/dep8GJax5UE+ybqTthzoU9ef1ROTCWEeBygCf7CX96KYjlAXw
	y5aZS21pg50MhtyTILUMFwIttUILUatYELk/ft9Dv+qAQFd2+JPNC8dnNc5XMoqxSGm727
	HVFNHbUghp3dGYh+QIIURoscOkD7Rajjv76lIppyN/Wafq0tQHUYidDODmBNGI7bBHWDhz
	lzi7C4XRDUyFjWgvfH0gDQninCOsptaek1I5D2GG4I++juTDK1kNNbn0N/rSzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1790145791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7wOWxYY4eY9XU25OMHVx3sfwNw2fYVAY+jnGCl+7xTA=;
	b=tccHAp6omQj8HSZMFOMZAiBvDg/Isjj4Drl75SRdZeoEH0eQTX5v0a5bOd8E8fHOUIy8Ez
	MvOwEaPNdJkIVhgUM8QwhTZE7p9CHg4P/j0URJt3zZHj6nlaEWWDpBlXUJaV7OqzVkJcyr
	Ak5ldbd0ACyW+IffvJpIH9RxFzkSNL1XbZWw/81OJVHF1ZieYWTfRhRtBXw3sFc1wf1XX0
	0pw/0qGD+3LSbCAQofVi0hQ5Nis9Jp0HUJRFiAnRxZHsdVnsmhq2Rs4NdbgoZvmFGFoAeO
	CJ6IRY5E3WWtn3Gy94NuXNizstndWwXzuB2rgHM1OxgA3Mvovw/1VbFCSmt2AA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 47C9C198004A;
	Wed, 23 Sep 2026 02:43:10 -0400 (EDT)
Received: from ams-imap-13 ([10.64.2.33])
  by ams-compute-02.internal (MEProxy); Wed, 23 Sep 2026 02:43:10 -0400
X-ME-Sender: <xms:-3SzakVwe1VxyDXHb413WQaKDq6_3zS5KetTsI54C_mSAwQH0mt_sA>
    <xme:-3Szajafl31YUfXA6zZn9bh6EicH2OMotgMoN4ROKMs4jH_N-D7ceHqCbHsjzolOu
    sDl_DA72TNnX6OjN3J1xer5Ma-yJC6sXTf3IB8fogpEbNvdVw_yRvM>
X-ME-Proxy-Cause: dmFkZTFZGTj3GjzbP5lYRKQxP+eSpNJWuoi9GAhHtMOeLYfiHKA0AKIj1Kd2GGDDkxTBLQ
    4MDet04aCmyUWslVn60gIvcdy66Uw/Kl9xZ4fbg5csse8A1LyE3KT+sl+WNTnWti4S34vi
    K3VAMHoqN0HOf7wqh2GI7+SjgeXMDlXjJSADQctWRxmn28w9PzX6kZFYR+BkQoKkIXXri4
    DxYtKkj90b18TYFd2Y+VPF3EYEpE+NhRRtWYRkHrpclSqpVjwDFI/hjvCrZN97Wr/OrU9o
    HRvNsq+S+iEsP+6E8AEjSgtkw+nmJ/A5ZhtfcHVDlPmeTCkRMMNLbNEgiFeNWnLihnXTOj
    u+Z4YjcR7unRGpzGBPc15f1rg0udjNxofqmGerLDYFu1uTWwVjN76Z1Q6/Aixb6poAxTO5
    vY1QNdSzmFNIuu29EHc6qFe6ZFPiFDwpIs2BjrB+vWrPbg9dchmr4vxgYCnvFtXUvyLkf5
    64jzDe6/rnpD/DO9oTypgquLbQApXc+GF1dmAcZSLeppr//4+S7Vma+EXXsyExj77GEHmL
    DpcfNh8DDKGX7vU9m6d6XVqYk8sqOIsX5buSn3UfGZRuHVq3bYX0Qe0Neca+PwRKZh2vZd
    xCXvBqu6UlKeUniQNtLDNsRaKdZf976LYb5BHQNxCUb8SUB6zvxCxEcgrvew
X-ME-Proxy: <xmx:_nSzas1dJCHZrnRNJjNGhY-P-tN9iTd28AuGv2pcygktRRX2JZi2HQ>
    <xmx:_nSzarW6uNVDeY5Ma5O7pAZiV2v5NtMrGWWiYJNuXB3GrrWiOu2iYQ>
    <xmx:_nSzaocQkw6MFOLUVjXGq-H3U2BIb3LIOGChOniranpEf1pta-u_eQ>
    <xmx:_nSzak9kF_xpDo5CtpZP9WJtwp3JHcWPWbi5ZveYyqvRRRG9B37BPg>
    <xmx:_nSzaoZ_i2H8ufpkLRt4jBZSPqE0pmWboi2feJDFtcKu7x6eS2f8YheB>
Feedback-ID: i02414972:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 15044F8008B; Wed, 23 Sep 2026 02:43:07 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ArNQnYYOpCrZ
Date: Wed, 23 Sep 2026 09:42:46 +0300
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
 "Jeff Hugo" <jeff.hugo@oss.qualcomm.com>,
 "Vasanthakumar Thiagarajan" <vasanthakumar.thiagarajan@oss.qualcomm.com>
Message-Id: <f4cba44d-d566-45d7-8772-c08af41dfdbf@app.fastmail.com>
In-Reply-To: <20260922-qrtr-multi-ep-v3-4-c00831e88957@oss.qualcomm.com>
References: <20260922-qrtr-multi-ep-v3-0-c00831e88957@oss.qualcomm.com>
 <20260922-qrtr-multi-ep-v3-4-c00831e88957@oss.qualcomm.com>
Subject: Re: [PATCH v3 4/4] wifi: ath12k: Connect to the QMI server belonging to the
 device owned by this driver
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, Sep 22, 2026, at 16:41, Manivannan Sadhasivam via B4 Relay wrote:
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> When two identical ath12k PCIe devices are connected to the same host, both
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
> Tested-on: 2x WCN7850 hw2.0 WLAN.IOE_HMT.1.1-00018-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1
> Tested-on: 1x WCN6855 ath11k + 1x WCN7850 ath12k
> 
> Tested-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
> Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

Ok, you can retain my Tested-by tag despite the changes to v3.

Backported to kernel 6.18.53, all regdb issues are gone, and when I
attached antennas to the secondary WiFi card, the statistics fetching
dmesg issues are gone now.

I have two cards, both of them work simultaneously, on the v3 patchset.

The only remaining issue I have is this on the access point card:

ath12k_pci 0001:01:00.0: dp_tx: failed to find the peer with peer_id 2

Google's AI (Gemini) tells me it's not worrying if the connection works
(like it does for me).

Thank you for the effort! I'll take the 6.18.53 LTS version into use
with these patches.

BR, Juha-Matti
