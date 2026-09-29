Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E4C53B5F2
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 15:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790694893; cv=none; b=u3aqtUPH5YPFKdcHsgJd0rSbd8uCI30bZGOopDyKD9YXcPwIK0eS+KcTED6bMwkTJHa3+kjSDdwTD3/N/aTiQuZOh6od5/XMh0+PEOaXN9rO7BLU2wcWwTxt3UYEnMKXy/PhqdSJ0icsqNlBxy1GiIN5RxGCs9pkdPUVnstYxu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790694893; c=relaxed/simple;
	bh=rPZ/M5iPKuycfBP6lUneUDLNXm8S823vMRwtgvsBTUY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t8HzKaHTPa0uUvBSVj16i2hfmw0v5bOwxpD5SeDP1c6ZpACKsFunmAHgGeYAjAS7mp8zGsjkITTcEdToXuo2ABFj2gisPkF2LiFsdC9ggaV4lKnGoyWN3om6YEnysYfQ0dLqzJMA+17Z1rQM82kkjiAP19p/fFbu+f0zwpKrHa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=LSAH8Zu7; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="LSAH8Zu7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=z0SpTiW24gqodrG6drX+inFH+5+/ODz6dnVzpES9HOY=;
	t=1790694881; x=1791904481; b=LSAH8Zu7OwkvuwlnMPMsEtmMOTPlp3DqWyXhhJ6rabnXczF
	u5Hk5VpnaywfCNl7vzha3ND6OyYiPz0yyROC+g4NHPaye6LY43zQ1VSRIBmiEhg3uwEOenoFfX9rD
	5C35xQYygGw0kqYG5DYtH4EnTTRygyjvbBdGY5Ztik2PJCUlS1asWwrUUbrZqkbpODtT6t2FBjAOG
	LNcIyHOi15mjI6aTe1j+VXa8X0nncI2k7O8P8cEov0raVTPe4I6sdDv57PP62D31Ml753RQFFcxLX
	+J3YNd4Z9+eGhZw2wQ9/YEoApXmV3nrVQ4s/QQ8GfFqWJMuv3vAudDE7AgWoIVlg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xBZXH-0000000F75L-3PQv;
	Tue, 29 Sep 2026 17:14:27 +0200
Message-ID: <126186f5f19d13dcb9ff0618faed010adf1afee4.camel@sipsolutions.net>
Subject: Re: pull-request: ath-current-20260929
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, 
	linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, ath11k@lists.infradead.org, 
	ath12k@lists.infradead.org, jjohnson@kernel.org
Date: Tue, 29 Sep 2026 17:14:27 +0200
In-Reply-To: <2b42b119-4271-4b9d-8a7d-1673c6ef62ee@oss.qualcomm.com>
References: <2b42b119-4271-4b9d-8a7d-1673c6ef62ee@oss.qualcomm.com>
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

On Tue, 2026-09-29 at 07:58 -0700, Jeff Johnson wrote:
>=20
> Baochen Qiang (1):
>       wifi: ath11k: fix unbalanced IRQ enable/disable during suspend/resu=
me
>=20
Hmm, it's complaining that the fixes doesn't exist, and that does seem
to be in wireless-next only? The patch/PR applies anyway, but does it
then cause a problem if the fix lands before the bug?

johannes
