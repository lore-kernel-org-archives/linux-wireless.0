Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F812C0261
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 17:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790702249; cv=pass; b=st61iquc+pcEJIxCpsBiJijkt9U3asNBS8aBm8pdETl5U3HeTZh/59ZkGKy6dEC5ptq27GJ5sML32PxsHWrS6+hxcwRNuLjiskRcJJnbdDC0DkS/pSYDXxEFzBhUT7RDdx/8Sur5T11GtSpQNlRWMeclMkSPAscUPsl5pgf6vUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790702249; c=relaxed/simple;
	bh=g/mX2HQtfr8KSlsHnS+2JZG6F4wFlWRzGJ4LmZSxx44=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=V3PNpVTkZg5kcovPy04hbORWEaoZWXm4Kwcqh3Cte/oGm6ysvsuG08N0uefl7ac+yIw9sNIB0kEK7lGtUmOMC9Fbiu7pvgUXTbsO6U8KH8QRmzv086v0uGYlzxqVfPbzNvA6zo9JMgOv1VCkdHZF1PLd3ic8FNpdISrwZJuduPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=ZlnsT0NN; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="ZlnsT0NN"
Received: from fauth-c2-smtp.messagingengine.com (fauth-c2-smtp.messagingengine.com [204.75.18.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hvPxQ27d1z49Q6b;
	Tue, 29 Sep 2026 20:17:13 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1790702234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g/mX2HQtfr8KSlsHnS+2JZG6F4wFlWRzGJ4LmZSxx44=;
	b=ZlnsT0NNO711I8R54hRavq+GbzJ79v5PH8xgQ6cEbGhOO0Fm0AnXH+k2RK3hxRvzuoX/RR
	CFKSPquYwevhXYOuHBtxTAyldgz4bfFUPSqLVJWTOJ71gkAk7tv8qDOKXlF44hgJRIWie6
	HXJUq0nLES+k1aHvQJMgjwAaFldn4EH7UTxIQohGoMU3dl1aAeUrs3aaIbpRkLOZMeOMbX
	3demr4G7Go03Irk05hL1VQg7E+VztNmknYkTYerwBIbx52kuQ2JpXVB0nlXWZVY5xq64hz
	MroB9rnqJqdGgIR7DKw4puYwJ5VqJqhYNuvX7/PpIz2Y5pO5M5IGbe6YtGz5xQ==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1790702234;
	b=DDMHzPpPsJOwcMvCtnzyOHJJgIUZd8coKqb9lYGFLiWoTd5hMpVtVYq8ABD3/mhZSj+QFh
	nFZkJE4dOnpXSbuv1Q/CPJS31Rq1kCsDe97r7UffL3DriEKpi9iPmqAFSBINIWb0yX68AF
	O7nEp1dhuuCV6PPowMA4UWNIYaktKE8TObCj20T+DPTgaN8cV+yDZHAV2dsreAsb60yy18
	/x+BbXRbPGO89zDphqX8GJilUfF5FKMAIzadwy4h92HgPYAPdrGuHSIXoY2H/b7s3JFIGB
	vlzXQ3trw7tuivHf56v4mgqQVDhn1h0bzBUrmEJuoyNk6TCn5KOviCkiPrnzGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1790702234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g/mX2HQtfr8KSlsHnS+2JZG6F4wFlWRzGJ4LmZSxx44=;
	b=RSo4i3VsyqM7Q22B9yVvmXVu37Ao9XgctRkuRI+veoMkQVcluAKXGCCBpi+mxejYAXh3J9
	Ww4O3SzPe35L5Dv3EHfOyxKI+3Cfjg7Ju5LfbXhdXTV8rOOdck3mx77usWEY+cIrli7GZD
	Wojmutwu+i5GslagE0t1/QDt2WHRvhOOFF0gTQuMxHha1wF/jmhHGPDxt7b0tBsgZN8Cqc
	7H2rZj60Y9cD6GNp91dSCKCEzvNZfDuK3TYn+Qg5EO/oT2+m0QCZe8HEce8ro891WO5qKt
	3QVpBnuOh9YNDJdP2GkP/J5Gby/d4SQTrmwWtxiGAzC/LwCPIGaIjdPSPLJo/w==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 34A3F198003A;
	Tue, 29 Sep 2026 13:17:13 -0400 (EDT)
Received: from ams-imap-13 ([10.64.2.33])
  by ams-compute-02.internal (MEProxy); Tue, 29 Sep 2026 13:17:13 -0400
X-ME-Sender: <xms:lvK7ajXDeZU-X1nmGnonOQFGrtuOTBUtkNQ2oaz2jmoj5kLPvkb0oA>
    <xme:lvK7amaPpNCwR3kNmAWfG0Yoe7nC6oeFPMObGzjvAfWvvftbBXzYXtzUitxbmpdAl
    9ttfjhv45czl306FrgV6AptACa6yXdMrmscVW_OhIVwWz5k01zYgLQ>
X-ME-Proxy-Cause: dmFkZTF7vlONJhVBF2Qik9ZfiMF1TReLucmRClIJecd9pJHDGdECRkjwvH6pGdM/Z08zDE
    qSMwvbZPDUL5f2TaN1o6wknWrotb3N3xofMCP1XLI86bX43TDsklb0P/zrgXJxsfQ59fwV
    YUV6JSjK1BIobOPIG8IyqDs9k3SrGc4YQRslX/L7Z60t+T+NvUUxMynaUnfo3bIvG+ABOS
    q8hbcj2y6NAqdGUqUX+c3p9Y7TJtWubXM0c9JD6zI5AO6FjWe+dSSTO0zvw7T2P91mpItY
    RDbiN08Dod24hMoz55EhDxAv8YpfcE6oSn+3I9nYr0FdRwz5OYwEXqWDK32fZI3a0jXtAK
    wbJ1xfx8vaRH5PPFFpXlOy1calKFjzmf1WP8z2G5RPOv1pTDQg2SAxTlmIQJPrKtwJozLB
    SXYfS6kXNezJrkFjDDmg49oyLy2DIplox9Q5zJAHlC+EatceucXAQ1+VCxtkl2IK7kHske
    9fKjj6Zgz4fHKS4O3Eg5jHocGxgBnIq8Hi6x0Ic1aNUCxr8NFz398zTeIMF36LYBtgMBjd
    GTTTggHgjw/mWaBNrhaSOUp5+GD8NqDm5/WRFt6p+hbSTe/ymVEjB90cFxllMSKZkRUl2W
    aC51Y+bR7E5cEAlIufpwiFtVDJNGzXUdcmPYO/EHHmTm1s0NgWfQXxB3jw3w
X-ME-Proxy: <xmx:mfK7akI4dC7UoWV7iXtBgZgD2b2bq9Q5jvPrqCC8SJDj_PnKRJetwA>
    <xmx:mfK7alxHqGABN_U3Up2H84LkMEEGnYhsGJQF5HS6WVMhAEfO3LcnjA>
    <xmx:mfK7aozvVE9YO6dyI1UPd_nzHoyjLjqmSxZLwg61K34udbofDi687A>
    <xmx:mfK7an1tgxkGIyoW1-ig2YtGvA9qEG3Rt78ylQNJ3YSInBcvSp8QQA>
    <xmx:mfK7aqWIihSRYnyG65D2LO4cNc-nso0UWZPrKuIC_7SWVyB9MivRp3rT>
Feedback-ID: i02414972:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 34538F8008B; Tue, 29 Sep 2026 13:17:10 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A0G5p0OZ_htJ
Date: Tue, 29 Sep 2026 20:16:50 +0300
From: "Juha-Matti Tilli" <juha-matti.tilli@iki.fi>
To: "Marcel Holtmann" <marcel@holtmann.org>,
 "Deepak Kumar Singh" <deepak.singh@oss.qualcomm.com>
Cc: "Manivannan Sadhasivam" <manivannan.sadhasivam@oss.qualcomm.com>,
 "Manivannan Sadhasivam" <mani@kernel.org>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>,
 "Jeff Johnson" <jjohnson@kernel.org>, linux-arm-msm@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
 ath12k@lists.infradead.org, "Bjorn Andersson" <andersson@kernel.org>,
 "Chris Lew" <christopher.lew@oss.qualcomm.com>,
 "Raj Kumar Bhagat" <raj.bhagat@oss.qualcomm.com>,
 "Jeff Hugo" <jeff.hugo@oss.qualcomm.com>
Message-Id: <05e539f8-bb7c-4038-8a83-8ab0d1a5b917@app.fastmail.com>
In-Reply-To: <13BFC5B0-77E6-48F2-B857-37686EA1DB2C@holtmann.org>
References: <20260922-qrtr-multi-ep-v3-0-c00831e88957@oss.qualcomm.com>
 <20260922-qrtr-multi-ep-v3-2-c00831e88957@oss.qualcomm.com>
 <7aed969d-0868-4c9c-967e-7766dbba427e@oss.qualcomm.com>
 <13BFC5B0-77E6-48F2-B857-37686EA1DB2C@holtmann.org>
Subject: Re: [PATCH v3 2/4] net: qrtr: Assign unique node id for MHI endpoints
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2026, at 20:05, Marcel Holtmann wrote:
> >> +#define QRTR_NODE_HOST_BASE 0x10000u
> >=20
> > Can it be exposed with include/uapi/linux/qrtr.h also. There are use=
r space clients like modem manager
> > which need to calculate modified node id to distinguish same service=
 from multi modem over mhi.
> > This is same as wlan use case.
>=20
> did anybody actually looked at the proposal that Denis and I came up w=
ith. It was exactly addressing this properly.
>=20
> It seems you guys came up with some hot fix and want to run with it. A=
fter month and month of silence and not bothering to review the proposal=
, you are trying to push your thing?
>=20
> If you don=E2=80=99t support userspace, your proposal is broken. Plain=
 and simple.

I'm still willing to submit a new version of that patchset originally by
Denis, if the kernel devs so decide that it's the way. For example, the
"radix tree of radix trees" approach could be replaced with a hash
table.

There was also some criticism about a layering violation in storing the
endpoint id to mhi controller. However, maybe that could be reduced by
providing a correct abstraction around it, so that other code doesn't
touch the mhi controller structure directly.

Other criticism for that patchset by Denis was its overt complexity.
Yes, it has more lines of code changed.

This dual-card setup needs to be handled somehow, either by Denis's
patchset or by Manivannan's patchset.

BR, Juha-Matti
