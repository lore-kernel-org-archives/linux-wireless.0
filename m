Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814883E638D;
	Fri,  2 Oct 2026 06:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790923273; cv=none; b=svOkPR1joq1DipqGY78dz4HA9Dgl+0UgsxeoIOfLZTGF8mHv9mW15YfsTSoMSZBYyfGHxbPoFbyMdBxbmPjgOhK5Kby5O2f8L4aP5NMuvqvEqc9movNGq6XiZLs7YEbI8urFc7E7dA9fOE2omAUWuOznlq3qgj4sH1VvuYG10gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790923273; c=relaxed/simple;
	bh=XGBTX2H/a9BvgiRkHTWqTFYaugyI2SwmfZEi4SZnl1I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G3T0LiWGVt4F9gaASRMjcGDD0nMq0+OYPROe6874XBb7E1ojvJXZSPpkkhij0r4Tv/dEnXdAmq4LktrYSmM2POu2Rn1kLmThXPNxNq9IiRAg+TnN94Mbqs+tMaAIBGY9oFuONCWEw0Bl77kkpgiIrYmKoIJ412Jswf/Pjx4bNkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=KcKpNhvK; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="KcKpNhvK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=XGBTX2H/a9BvgiRkHTWqTFYaugyI2SwmfZEi4SZnl1I=;
	t=1790923270; x=1792132870; b=KcKpNhvK7vn6v52vHC08Gkn0HILj3cC26fHWJ1vWsiwM0l3
	wa0r4+wD3ndLQ1RFcwCCBusnOCcFOXooHm2LlGxVCXddwDE3zycxij1RnrIUjo/Zd1pepQ9qO3Jro
	fHaUKvEQYvG25yLnVCTDqiH162Jk/35CFfyfqnlyY960CRifooTWY8H+2YV++S0GdNgTXii19gPPm
	yEFyllOo/X6yQGf4+rB9gbaFnAIypMchPKC8yOBQtixE0/0yvPmNAj3BHvER6RNoBtjbViX9c7ELQ
	MLA7/FH2fOagvWag1/okwub+wWXr5izDZ/qjHNk2/5/sx0uJLGrkOMuaI/8+r1ng==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xCWx8-00000001ELd-3Hb2;
	Fri, 02 Oct 2026 08:41:06 +0200
Message-ID: <ceb7d07781c6aac1ad3e26a47f688a36659cceb4.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2 01/16] wifi: nl80211: Define Seamless
 Mobility Domain (SMD) device capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>, Kees Cook
	 <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Date: Fri, 02 Oct 2026 08:41:06 +0200
In-Reply-To: <20260924-smd-v2-1-bb40094da1d4@oss.qualcomm.com>
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
	 <20260924-smd-v2-1-bb40094da1d4@oss.qualcomm.com>
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

On Thu, 2026-09-24 at 08:10 +0530, Pooventhiran G wrote:
>=20
> Subclause 37.16.11 defines an optional capability for the current AP
> MLD to forward buffered downlink (DL) data frames for the non-AP MLD to
> the target AP MLD.

I ... don't see how you would implement that by defining just a feature
bit?! And you have no documentation for how it'd be implemented, nor any
additional code in mac80211, though that would seem to be necessary
given that it also queues frames?

IOW, "driver supports forwarding" doesn't make much sense without other
mechanisms _somewhere_, and then those should be described (perhaps in a
new nl80211.h DOC: section, which is probably a good idea for the whole
SMD AP-side anyway).

johannes
