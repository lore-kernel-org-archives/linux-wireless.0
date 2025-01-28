Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FEF158A09;
	Tue, 28 Jan 2025 19:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738094305; cv=none; b=UENw36sHOZnL1/BK3sH1Oz286lUsGBPYq+uAouoObVZWQ1OB3NfqP0Z5H0MsPtxlronF4PzZWTgmymLXOZYcqoBoL1PZwvQTLPEqp1G2cm3jv/AdGivKF/2GZzbmou4abB4d2X73l5qP1Sd8HNAERum9ffv1dgrkgiFqDrssdMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738094305; c=relaxed/simple;
	bh=r1IQ5VrIiqDXdlSfJTSOs1Fq/Q3uye9YqXJhVfmanPo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JZc8nQblRIcXucQnCsQSaAUM64eyzF7WK7eg4KAFehksUnQDaqGL3KIjkMrgpSiAKwXDGHU+trTLzGkGxhvb448E0dwWEiI4qG5hmLws0vvAtBGBMOeyL81rpGuFTHFcapFsLqIroMdIX0ifgPjSFVWMErxVMzFDRjQguUhiC+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=XLHbKhpM; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="XLHbKhpM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=/UVwCVUckavusFcfIbtuoG7y1CE3wZnBJdeThYkKfqw=;
	t=1738094304; x=1739303904; b=XLHbKhpMdyTadHemOedxO9hmLFGeZxydj/VnJkBm4WZqTdc
	GdS1Q+ykjOGuvCvH2l+i5TgesjKpE3acFhsME4wyGrk1KzM7tCCCtUw1iG9R/4mjkbFvLEA95fGqj
	Omqr1DCgA618HWcXolNxSxeeG0ETESSyspA/oeMwmvd3mW4XY97kVe/hcToZK4CwV8346qe1Qfqw4
	QMM1VSrUEZrgXUmTLc0qSq1TQc5uPXEwXudb8xJZMl289JacFp4XkAIldtloVy5UMVZiM/BtKfxhw
	8IKRTnV6vAji6+pEY3CDGUzUFCkQM5Up8X0xsxRImQvTuVSu9GTyj5FWvlY/Hcyw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98)
	(envelope-from <johannes@sipsolutions.net>)
	id 1tcrKr-0000000D3mR-1nRP;
	Tue, 28 Jan 2025 20:33:21 +0100
Message-ID: <d5ca1cf4593edb1c8ee32f3c2e6fde47dc97cc32.camel@sipsolutions.net>
Subject: Re: [PATCH 0/2] wifi: mac80211: Deadcode cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: "Dr. David Alan Gilbert" <linux@treblig.org>, 
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Tue, 28 Jan 2025 20:33:20 +0100
In-Reply-To: <Z5kkVa0pi9_TRsCl@gallifrey>
References: <20241224013257.185742-1-linux@treblig.org>
	 <Z5kkVa0pi9_TRsCl@gallifrey>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Tue, 2025-01-28 at 18:39 +0000, Dr. David Alan Gilbert wrote:
>=20
> >   wifi: mac80211: Remove unused ieee80211_nan_func_match
>=20
> Hi,
>   I noticed one of these patches (debugfs_key) has landed in 6.14
> but the other one I don't think has - any particular reason?

We were still using NAN internally, and there's a chance that it might
make a comeback, so I was holding off on it for now.

johannes
