Received: from mail.holtmann.org (mail.holtmann.org [81.169.141.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDE652CCD7;
	Thu,  1 Oct 2026 15:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.169.141.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790869207; cv=none; b=i5KIop03KJL6rMXR48ryA16r9vKdoIRQI5wh9oe1iTRqZ/X+2TLuxkRuuDD5GfCXMA90SrYDxnSxHevzoh+iRkUMM8DDXhKKZ6hUMrg6/UY6SmgqkyeDVCy0PG2ljZN4+2Ws55FFLEUA3pWTdgseV44oLt1aM6HNihs6DzVDkD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790869207; c=relaxed/simple;
	bh=vw1rj845XftbG9SUjyzYpshHEzKeJ159aAiFNfiYTUA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Ccug37HfQfL6QfmyZe2rGcxXTDIHvYZCWhp6EoeEF/f0GeQNwQ4+Lbad5ieD6+E8MeIJkAhQWqdh7jiVoUb7JIo49eCCXZz/43b94cUm/Av52efvi0F/DwPcRMhfM6ReOG+dH+UImdga5Hp/whpHsDZ+pSw9kPHcb77caOq6iJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=holtmann.org; spf=pass smtp.mailfrom=holtmann.org; arc=none smtp.client-ip=81.169.141.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=holtmann.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=holtmann.org
Received: from smtpclient.apple (p5b0a9ac0.dip0.t-ipconnect.de [91.10.154.192])
	by mail.holtmann.org (Postfix) with ESMTPSA id A906FFF12A;
	Thu, 01 Oct 2026 17:39:57 +0200 (CEST)
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
In-Reply-To: <19433f85-4cf1-4ec1-a26f-0eab7df062df@app.fastmail.com>
Date: Thu, 1 Oct 2026 17:39:47 +0200
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
Message-Id: <A709172A-40F7-4986-B7D3-02A422F6584A@holtmann.org>
References: <20260922-qrtr-multi-ep-v3-0-c00831e88957@oss.qualcomm.com>
 <20260922-qrtr-multi-ep-v3-2-c00831e88957@oss.qualcomm.com>
 <7aed969d-0868-4c9c-967e-7766dbba427e@oss.qualcomm.com>
 <13BFC5B0-77E6-48F2-B857-37686EA1DB2C@holtmann.org>
 <05e539f8-bb7c-4038-8a83-8ab0d1a5b917@app.fastmail.com>
 <m657dtesuagn7vdajsuzjb4mfysf5xabsu3s6n6lujj7yb3z4p@m2e7e3n4zyev>
 <10091679-7567-42C2-B77E-EFD95CEDD649@holtmann.org>
 <6e0ed085-07d0-46f0-97dd-b8d942842e1f@app.fastmail.com>
 <0A4EB216-06E0-4A7D-A0FD-821DD371773B@holtmann.org>
 <19433f85-4cf1-4ec1-a26f-0eab7df062df@app.fastmail.com>
To: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
X-Mailer: Apple Mail (2.3901.100.1.1.12)

Hi Juha-Matti,

>>> Well, in defense of Manivannan's patchset it currently works for =
PCI+AHB
>>> setups better than the last version of that by Denis/Mihai/me =
(although=20
>>> I could easily fix that), and it may be simpler for userspace to
>>> continue using nid than having to bind to an endpoint, which =
requires
>>> more changes in userspace code.
>>>=20
>>> The userspace just needs to know the nid.
>>=20
>> and existing userspace? You can _NOT_ break existing userspace.
>>=20
>> Don=E2=80=99t you need to re-write all existing QRTRIPC packets to =
actually even make this work?
>=20
> Well, from what I understand this rewriting is the plan.
>=20
> It is true that if someone has a single card, the nid changes, thus
> maybe breaking userspace if the userspace has hardcoded nid.
>=20
> But if someone has multiple cards, the breakage to userspace is less
> with this patch, since userspace can keep on using the same code and
> just change the nid, whereas with the endpoint_id patch, the userspace
> needs code changes to bind to an endpoint.

the general rule for Linux is to _not_ break existing userspace.

Regards

Marcel

