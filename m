Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7253C8737
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 20:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790885572; cv=none; b=Ov5Uehy76EXipQNWAN62/ZrPV4g46SAWBmPK8jVVjau9WYqRh3ZvGI47Zb8lDAXPwmKUM8KodR47Lg0DPXhUk90XXr4HcWpcOjLhDRrHc1O6Ii/E4QGatqNAOThNUSjGlPwEwc2X7pmLbXkDInl7oLttHo9BE1f8UmWqHGM3d2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790885572; c=relaxed/simple;
	bh=aGleTtxqRxGK5SW+aGx82AtwuKvLJwCdYJOoHfRADlc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mLpevLbKjWRwmtidYQGNn+v4wnapAffwIN5OHbRTN9oMp74HtBnC8HBzsKhKDi8b78tNxhe+7bsH2ERr54aqhuF6gXv1Kyo7r1Y3ffuDd+cmiObPL3aq3ZvxGmkMqrScFuwnG1Otki1IjEZb0PZhbBQt+npWA3PLuzwSKRInais=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=i6cHLTk7; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="i6cHLTk7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=aGleTtxqRxGK5SW+aGx82AtwuKvLJwCdYJOoHfRADlc=;
	t=1790885569; x=1792095169; b=i6cHLTk73P5wJfEEqBEW63mv0c4CsPWnMSbJENit1Mcb2TZ
	sJBXV+tdl7Rvtlf6WNRMQcNFKmhwvtissWNy4riszeKwgzi/qh5OYBJUVfp5F39pU3bOl10FTdaty
	h+htMqWxuTj3NnZjiNcAJxt5iAWGr2et+Og3SLfIecMjtah93ne2rTxIVZVGEyU4IMUVnKgoAr4Np
	6mRJi6Jfyn7wGTi7+cfXQztVVuBZwCHpOur3ydDGkPr/8fcWC1nD7YlC5xVhBD9dCU/Q6e2DQm5XA
	DxwY4Dk43GWjpjxxgp7U5pydI6K4uPrw8mDrlbLmunegwJC5N4eW8ccS7zPrtVBg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xCN93-00000000QfD-0cQb;
	Thu, 01 Oct 2026 22:12:45 +0200
Message-ID: <073770dcebd5340126816bd89f9259c0c1dd990a.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2 09/16] wifi: mac80211: Define layouts
 for SMD BSS Transition context
From: Johannes Berg <johannes@sipsolutions.net>
To: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 01 Oct 2026 22:12:44 +0200
In-Reply-To: <fc91329053c0cbedecf51bcccd4a0e74eba850e5.camel@sipsolutions.net>
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
		 <20260924-smd-v2-9-bb40094da1d4@oss.qualcomm.com>
	 <fc91329053c0cbedecf51bcccd4a0e74eba850e5.camel@sipsolutions.net>
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

On Thu, 2026-10-01 at 22:09 +0200, Johannes Berg wrote:
>=20
> I'd also love for you to think about hwsim supporting this - in that
> case mac80211 maintains a lot of this data. Having mac80211 fill in some
> data unconditionally though seems brittle - what if the driver just
> forgot the PN and then mac80211 says "sure the PN is 0" because
> something, so ideally drivers would somehow say "this should be filled
> in from mac80211 software state" or something.

Or maybe the answer here is to offer some kind of helpers to fill in
state before attaching it.

johannes
