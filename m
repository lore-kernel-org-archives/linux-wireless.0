Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB09B503BE1
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 17:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788802514; cv=none; b=YFPoPGwqtk+JIl88kBF3HLlTNp0jpf2gpQ++AxdzXFWkN2ZNVd82lVwCz7OR1wa6m7Ca/Pq3BInTKdg6JWfN803G+IhPA/FrKd7YZYjbhutzMQsaYnWza43Y6zOsIC/Ccg5mmKWC2fsIp1l1n5shJUkkkSl8C3o5cFvf2z6GrG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788802514; c=relaxed/simple;
	bh=uFwMwQUmfSyN8MkklpTLqIS0+8gt174wQ2LH581bNa0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pz2qfiepO2qZa6VmOLkOCS2FTG8xjkFN5bNgl4eK8lm4LPwspWPyE3nawA3fMqs7XXRsgNMIUb4QVA7yhtTbhn+0TCNM00eSfJlY0Mq948i8bDgYqo+hT4Mi3zjIEq0z4yye6jTIqj02EAhvYbp98LerzWL72Nyqeu0V7b2TNKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=J+E6fgE1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="J+E6fgE1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=uFwMwQUmfSyN8MkklpTLqIS0+8gt174wQ2LH581bNa0=;
	t=1788802512; x=1790012112; b=J+E6fgE1pM/ZDOZGX6f0XCPP325R5L9y5Trpwc3qL2DWOr5
	LowXuAEnCNmMPWw+s4KR/DkMM48mT45T+ZLK/m/JcqrJkbbgcJL6BZQN7cjDTZRwj158Ykf7IeyjE
	5Vb4x7rPhzjTDit63m7hM39H2OcFyJCvxd3Zlt8GCZtFiETDANLTrxChHB+85a2oKqvFde2/Zr05Y
	5+nlxT+m0wOBJJmNwAnicgaszT3VdAyZmpbbno/6hpQBq+esObpoGyfLxT68Mm/icR1w4YYItTynR
	fKaz5Oldtdwn2EJ5sNejzmfXTkOmOq25kCGg5zMsapYyNzZQzS2G3mSdkfWzeDjA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3dFN-00000004lxm-1Ikx;
	Mon, 07 Sep 2026 19:35:09 +0200
Message-ID: <497398008538f1be822d348bb80c726ebb0184be.camel@sipsolutions.net>
Subject: Re: [PATCH wireless 1/2] wifi: cfg80211: add
 NL80211_CMD_NAN_SET_NON_EVAC_CHANNELS
From: Johannes Berg <johannes@sipsolutions.net>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org, Andrei Otcheretianski
	 <andrei.otcheretianski@intel.com>
Date: Mon, 07 Sep 2026 19:35:08 +0200
In-Reply-To: <20260907203545.2185380c2557.Ice8839058e114f6f9783079807df446388187dda@changeid>
References: 
	<20260907203545.2185380c2557.Ice8839058e114f6f9783079807df446388187dda@changeid>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2026-09-07 at 20:35 +0300, Miri Korenblit wrote:
> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
>=20
> Add a new NL80211_CMD_NAN_SET_NON_EVAC_CHANNELS command that lets user

I'm not taking a whole new API to wireless, that's not what it's for.

johannes
