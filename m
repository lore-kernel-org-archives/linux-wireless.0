Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46759530DF7
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790074271; cv=none; b=Z7JzoG/k5IVNtSjcEEsUG+kZB21wW0fW1q5c1MhLVlXGW80eUT1G0HQ6PsBKhguSzjSTns2Z7XQl7rQyxS3anFngXGlGa5SZEugYS6FI98JWquSLgJqLPwJ12prcqrdDHeLgxSP5apJ8PqQyNCy6UMjNtpEl5wqRXCbEofiyIvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790074271; c=relaxed/simple;
	bh=JCxQ4KNjfukY/T/evl93jcXFaaRTB82E1iGacrS+oP4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mmrI1vX6vaPGZp1pV512KHPxALownGKo82WL73Bjnge3RSPUegLlG3D/2L093sEv3K/62OwdAmzXIpoR07IrpHDs9FRPcIkoTcepWOAzgAeKnrPo3NDMLtRx4PWjneU6LF6ErFntDCHjAmleb6ikMOLYzO/DcgtsW+nkCPdUtrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=bVZ9N2E/; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="bVZ9N2E/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=JCxQ4KNjfukY/T/evl93jcXFaaRTB82E1iGacrS+oP4=;
	t=1790074267; x=1791283867; b=bVZ9N2E/Qr7DgorbFCZmf4WjYepSDMOheF0DCv3mUNtK98R
	VzXxv9nsaxoPNrW8TmZ93qL2qQdbpzQwlUvRzJJIviTZ5hkrpi/qf+zd+tj44dtcbgIVXYsvLNvhe
	rys75mdg8mewb9QvtD7e0odwLoRAF8+CGlDqpOEE6W0UbZmo7udtywXhGiud2qzYNCQsqYQ648OOt
	G2mETXVUIHFA/VpZGK9lnoFcayJ4+Wf0LC3bLsa5kZVOFvFBIM+WCoGBfCBRJ3tqK6X9ueJ1OIJGV
	bUpdJdlCd2reRLCwiKxgwUsj3EWxTdKQvVsAU2Aa9tszQG5ah/izJJfw18UkLi3A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x8y5V-00000006qEw-09J8;
	Tue, 22 Sep 2026 12:51:01 +0200
Message-ID: <ee25d1c927d4a618384eb05a210b0f9b2147d055.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2] wifi: mac80211: Report parent AP BSS
 parameters for AP_VLAN
From: Johannes Berg <johannes@sipsolutions.net>
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>, 
	ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Ganesh Kariganuru Mahabalesh
	 <quic_gkarigan@quicinc.com>
Date: Tue, 22 Sep 2026 12:51:00 +0200
In-Reply-To: <ddaf2702-b33e-459c-9efd-098feba33243@oss.qualcomm.com>
References: <20260915052923.3300269-1-aaradhana.sahu@oss.qualcomm.com>
	 <48ebf25d157b8c12dff724fb1f6a97a0b45849e0.camel@sipsolutions.net>
	 <ddaf2702-b33e-459c-9efd-098feba33243@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Tue, 2026-09-22 at 16:12 +0530, Aaradhana Sahu wrote:
>=20
> Since all these parameters (beacon interval, DTIM period, CTS protection,
> short preamble, and short slot time) are already populated in sta_info an=
d
> are visible through the iw station dump command, I only made changes for =
the
> AP_VLAN case, where these values are currently reported incorrectly.

Fair, but I suspect that they were really only there for 'iw link'?

> I am not sure whether any third-party userspace application relies on the=
se values
> apart from iw. If we remove these parameters from the AP-side station inf=
ormation,
> the iw station dump output will also change. Would that be acceptable?

I don't see why not, if nothing relies on it.

johannes
