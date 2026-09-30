Received: from mail.holtmann.org (mail.holtmann.org [81.169.141.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AE2503BC8;
	Wed, 30 Sep 2026 14:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.169.141.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790778828; cv=none; b=i2/vWr8v0bVvA7AL3Q3d5ni/74bPK/0IUsKnI8N6Y9A03EX31JhPq96g+Vcm48CYfbVD7bC5lXrT3kGaa5YvN50ZbOUxqaq6p2lKghm+bUPM43Mtw9nODrHv7mXaAJxnPT8RjjMzwKZp0HzzOGCO1/P2lh9yZdb/7TjmFcLhTh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790778828; c=relaxed/simple;
	bh=1iIJSTnMOWRTOmbXm6u7wig5eFrazUxV6Fl/xrS/ZMY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=nPyHLvzVNETq4ecvX3g5Pym3p7QG2LHy08EqgJV1jTT9/32zZl8sq5haU/Mox3AF4rwclfFl5ZxedBSlnarUH5CInXG6s5eR61LV0xqgvcT3QS0BvlXf+9Py4mzsdODM6ObX4x8+xcpBDNGbY5Q+na04g8PnfE1eM/CzEKPiEE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=holtmann.org; spf=pass smtp.mailfrom=holtmann.org; arc=none smtp.client-ip=81.169.141.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=holtmann.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=holtmann.org
Received: from smtpclient.apple (p5b0a9ac0.dip0.t-ipconnect.de [91.10.154.192])
	by mail.holtmann.org (Postfix) with ESMTPSA id 85DF3FF100;
	Wed, 30 Sep 2026 16:33:33 +0200 (CEST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v3 2/4] net: qrtr: Assign unique node id for MHI endpoints
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <6e0ed085-07d0-46f0-97dd-b8d942842e1f@app.fastmail.com>
Date: Wed, 30 Sep 2026 16:33:22 +0200
Cc: Manivannan Sadhasivam <mani@kernel.org>,
 Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
 "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>,
 Jeff Johnson <jjohnson@kernel.org>,
 linux-arm-msm@vger.kernel.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org,
 ath12k@lists.infradead.org,
 Bjorn Andersson <andersson@kernel.org>,
 Chris Lew <christopher.lew@oss.qualcomm.com>,
 Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>,
 Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0A4EB216-06E0-4A7D-A0FD-821DD371773B@holtmann.org>
References: <20260922-qrtr-multi-ep-v3-0-c00831e88957@oss.qualcomm.com>
 <20260922-qrtr-multi-ep-v3-2-c00831e88957@oss.qualcomm.com>
 <7aed969d-0868-4c9c-967e-7766dbba427e@oss.qualcomm.com>
 <13BFC5B0-77E6-48F2-B857-37686EA1DB2C@holtmann.org>
 <05e539f8-bb7c-4038-8a83-8ab0d1a5b917@app.fastmail.com>
 <m657dtesuagn7vdajsuzjb4mfysf5xabsu3s6n6lujj7yb3z4p@m2e7e3n4zyev>
 <10091679-7567-42C2-B77E-EFD95CEDD649@holtmann.org>
 <6e0ed085-07d0-46f0-97dd-b8d942842e1f@app.fastmail.com>
To: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
X-Mailer: Apple Mail (2.3901.100.1.1.12)

Hi Juha-Matti,

>>>> I'm still willing to submit a new version of that patchset =
originally by
>>>> Denis, if the kernel devs so decide that it's the way. For example, =
the
>>>> "radix tree of radix trees" approach could be replaced with a hash
>>>> table.
>>>>=20
>>>> There was also some criticism about a layering violation in storing =
the
>>>> endpoint id to mhi controller. However, maybe that could be reduced =
by
>>>> providing a correct abstraction around it, so that other code =
doesn't
>>>> touch the mhi controller structure directly.
>>>>=20
>>>> Other criticism for that patchset by Denis was its overt =
complexity.
>>>> Yes, it has more lines of code changed.
>>>>=20
>>>> This dual-card setup needs to be handled somehow, either by Denis's
>>>> patchset or by Manivannan's patchset.
>>>>=20
>>>=20
>>> I wish to go ahead with my series as it is simple and tested across =
the
>>> multi-WLAN setups. For concern around exposing the nid to userspace, =
I'll
>>> implement it in next version, thanks!
>>=20
>> actually no. Seems you have no plan on how to address the userspace =
problem.
>>=20
>> It would be useful to actually review the endpoint_id concept =
introduced by Denis since it has a userspace facing API. What is your =
plan? Are you planning to break all existing userspace code?
>=20
> Well, in defense of Manivannan's patchset it currently works for =
PCI+AHB
> setups better than the last version of that by Denis/Mihai/me =
(although=20
> I could easily fix that), and it may be simpler for userspace to
> continue using nid than having to bind to an endpoint, which requires
> more changes in userspace code.
>=20
> The userspace just needs to know the nid.

and existing userspace? You can _NOT_ break existing userspace.

Don=E2=80=99t you need to re-write all existing QRTRIPC packets to =
actually even make this work?

Regards

Marcel


