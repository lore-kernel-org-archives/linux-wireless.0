Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7571A368958
	for <linux-wireless@vger.kernel.org>; Thu, 26 Feb 2026 16:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772124660; cv=none; b=HNagtu4+2kLb+dCZ6L1e/4StpWfCkT+70BoQUGfsMOlKoIGVBRga/Ur9MxRghjrH+8CAX8Ej/gBKvBJMdo5Tnub6ZfR2+tNNhkoEvzz6Kd8P1HeoLvlEFGtJ/ty2t34gBAsQEaDhYiuuLCvO6KtjbJZQMFAlXBQiRxSKc6kU3cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772124660; c=relaxed/simple;
	bh=BPGOsqx3oLjycf/jwsxZozyvFu2DFGN06DeSyrr/PPE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cO1dTyJjWlIixioB6/Eoz88K1uP7edrqm1foXBL355IrAxxzPbhYTxn0MqTa9ETa4Jr1LkfKm8vNwGz1sezkhR0hmKigGKtAP6oUXS7TRfO2UPUFTNT75sd7h4tjt6smyH4zmz5exEywMwHLK/8wck3NmHlVLrt6tvy72pYXbgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=I9AwCeet; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="I9AwCeet"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=BPGOsqx3oLjycf/jwsxZozyvFu2DFGN06DeSyrr/PPE=;
	t=1772124659; x=1773334259; b=I9AwCeetbaCnlByZvzwrUskvIVm/0dM018re7plfRqjhgrR
	kI82rT5BiCtbc1tXN1cVqxkNQEaDTZGlnai1BbaIrzVGzSsijSMqinP5XcZjJSTK4xEh3KEju+X6i
	Ta78RHlslja+raq8sHeobALMFhRQU8kt+lhTjF7f0wxFMCH9vSRs/TWkoLJ7EVCKBbQ8LxwY8kz0a
	yRITqeJhK8MqJQE5LIfjynIU9ao0mChFFN3iBMp0uLOKmwc+6SVRZCLmBtztdv4MzFfeV/qqUKQX+
	EoAVCnYaKx4WffFlc+ZDJ/EXxVDLH2FSiU3Y4XEco4oVjUad86/VjgNnwij3hY1g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vveZk-00000002Uqx-2LtO;
	Thu, 26 Feb 2026 17:50:56 +0100
Message-ID: <916b0969c559f1faeba94bdef792da646b9b0c21.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 3/3] wifi: mac80211_hwsim: Advertise
 support for IEEE 802.1X authentication protocol
From: Johannes Berg <johannes@sipsolutions.net>
To: Kavita Kavita <kavita.kavita@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Feb 2026 17:50:55 +0100
In-Reply-To: <15cd54d4-a663-423b-b4c5-9a058f5bc73d@oss.qualcomm.com>
References: <20260226065442.4182232-1-kavita.kavita@oss.qualcomm.com>
	 <20260226065442.4182232-4-kavita.kavita@oss.qualcomm.com>
	 <3ecb3d440ed3ab4fe4cd3765e0c8457ef58fd6b6.camel@sipsolutions.net>
	 <af15a01f-93eb-4c0f-b13d-8cea41f82703@oss.qualcomm.com>
	 <e96a1d08ab71bb75bd7a65278b04d29c609904bf.camel@sipsolutions.net>
	 <15cd54d4-a663-423b-b4c5-9a058f5bc73d@oss.qualcomm.com>
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

On Thu, 2026-02-26 at 22:19 +0530, Kavita Kavita wrote:
>=20
> Sorry, I missed one case earlier. EPPKE mandates (Re)Association frame
> encryption support, so we should only advertise EPPKE when the driver ind=
icates
> support for (Re)Association frame encryption in mac80211.

Oh, OK, but we could also check that in mac80211, in register_hw(), I
think?


johannes
