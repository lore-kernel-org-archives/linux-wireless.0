Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC1628371
	for <linux-wireless@vger.kernel.org>; Tue, 21 Apr 2026 10:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776769149; cv=none; b=oixgmeiky4quNWNdeBvkuXkLSdp/Z5e0ojKxz/1eCSzmQY0lRITAzjoSfBKBUo/rYo/YvrrjBSEJDOn6e3y2lfBPd0AGFPNjHkeWb2l0LlY4/tlRslNFnlWsJYH18zcv41+Pz5XMZcu2TtRXhJmJI9uni20ZP1XUsBuoHI2oyeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776769149; c=relaxed/simple;
	bh=D4lf2qjfEqkCSTBrPNWlg4+4w4yT3QUWaTDsHdnL/to=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pKF+SQ8Ma+jzdJy9S4i3yZGRM3XrM2SgLNJV7RQ0bPrt+DsV6TQvtfd6Kd0CykNlMTr91WKJRCTqK09x0dwc8hOmLpcKCncGsiYFSORnvdvVg5Bt5nfA2dQifGRiWeebzbl+NQ31oZmBYgjiX2OitviOg9YhynS1qIcPC1ouNIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Om6FlTrr; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Om6FlTrr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=D4lf2qjfEqkCSTBrPNWlg4+4w4yT3QUWaTDsHdnL/to=;
	t=1776769147; x=1777978747; b=Om6FlTrrJ3BpyvS6yxPiQSnjwGNGu9dQizfNTSVRcynTvAM
	J5IRoPCL4NbGYmoIuZX+/t2sIfhcK9tfsfCIiETQG896sktU02Wr7XzJ3rZnfjVH+y5GDSwpRmDOf
	Stov9sEP4uG8tyiI44GEYz3hgdP+BseMqHS4XWys7WEoV94ZNZbkbA1few+uahoHuHP7f4ngKgHBs
	XvRrSNfqCXStkjG4yRGYr0irtjYdMjsoXJ9yNrXLAWYFv+g4s6X6ngXGlCrlPEVQ7cdNcOW0IPCs+
	CbnizCO9dR40oSC928KCVPLpkw7e4svoMOpGOS8bZx2Lqxb+JfWA8w6nxrYADVnA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wF8oq-00000004wFQ-1wQS;
	Tue, 21 Apr 2026 12:59:04 +0200
Message-ID: <8e437543f696a74e6438040ddb27e2f802de6706.camel@sipsolutions.net>
Subject: Re: [PATCH v3] wifi: rtw88: fix OOB read from firmware RX
 descriptor exceeding DMA buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Tristan Madani <tristmd@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>, 
	linux-wireless@vger.kernel.org
Date: Tue, 21 Apr 2026 12:59:02 +0200
In-Reply-To: <177676770616.2086020.12978814842871576652@gmail.com> (sfid-20260421_123509_288063_115E165B)
References: <177676770616.2086020.12978814842871576652@gmail.com>
	 (sfid-20260421_123509_288063_115E165B)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Tue, 2026-04-21 at 10:35 +0000, Tristan Madani wrote:
> On Mon, 21 Apr 2026, Ping-Ke Shih wrote:
> > Since this is data (hot) path, I'd prefer unlikely(new_len > RTK_PCI_RX=
_BUF_SIZE).
>=20
> Good point. v3 below adds unlikely().
>=20
> Thanks Bitterblue for clarifying -- glad the patches are complementary.
>=20
> ---
>=20
> From: Tristan Madani <tristan@talencesecurity.com>
> Subject: [PATCH v3] wifi: rtw88: fix OOB read from firmware RX descriptor=
 exceeding DMA buffer
>=20

This format doesn't work, you can't have a "preamble" section before a
"---" separator, only a "footer" section _after_ a "---" separator
(which doesn't go into the git history log.)

johannes
