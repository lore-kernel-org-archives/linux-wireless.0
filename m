Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4B33FFD;
	Fri,  4 Sep 2026 08:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788511121; cv=none; b=ejYSUC4LdzyWJKCscnRefzctAW5ZM+YAcVbTxk69emqmGGqWVSH6YJAi70ItlG/9L4PMDilTVM3FFjQ+n+grsIurU7cLB/Hv/zdYLzRgdt2k5mzDYfGRPFKwPrZDG0DpiQk65BmkRHnH+fTtyVaXpMoVTt4ebDU+M41hE1RMsms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788511121; c=relaxed/simple;
	bh=NesheYzcex9EOKZ58GcDfXVuVqCxuU8iAMDt7OkYZX0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RcZxP4rsg71tT5ZaJqeyvF/6IcQtgntUOyWXqHp39W5Pz81OjCTftN1vJTxyiIhp0OFtnLHyngi0rdOWRfYrXTNkSeoDAHeScUtiOWi3KLwdZbBGxwIOD1r667r3V7DarsWR8vPVv613ISlUpD4mClMx9ct7e1ksBqkfoHKCS6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=iOosIz4t; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="iOosIz4t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=SqulXA0ZIVR46ntlAQqW9oJV4Mpl1x9R5gqKUCs4WyE=;
	t=1788511120; x=1789720720; b=iOosIz4ttbXcreJcob6xkuLSwnTPM5kk9Xn6LqjYL1vLqny
	NHqQzse1yxeG3HySMaGeuZ18XzA4mm7rinj51JKD1xmvhPM4wGOBcdzlCv3SYIGhWlth+piaWqB84
	fzMAy32MoZxJvp7skw+2Uaeu26nQCVwDArHl8GtPDisWa6AnPw4SfLUIyL04S8/q4sO7IIn0hFjn6
	E1AHbi9n+4pYYdLF6ZomV9guU2U45AwPidc/O4YOzjHbNXk225MXB3VHWxEVabAPXhImkfUk/Z6hr
	MB8/cMoRAXYtKDtUFj2GxSUeGrfGuJyL3MwXRceC+lK99hioIAtlE//xhNPgBNKw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2PRS-00000001Gte-2w21;
	Fri, 04 Sep 2026 10:38:34 +0200
Message-ID: <94f92252ee873146420ed2a53ac1b86dead1345b.camel@sipsolutions.net>
Subject: Re: [PATCH v5 1/5] wifi: nl80211: add roam offload extended feature
From: Johannes Berg <johannes@sipsolutions.net>
To: Jason Huang <Jason.Huang2@infineon.com>, linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, hsin-hung.li@cypress.com, 
	linux-kernel@vger.kernel.org, brcm80211@lists.linux.dev, 
	brcm80211-dev-list.pdl@broadcom.com, wlan-kernel-dev-list@infineon.com, 
	jeff.johnson@oss.qualcomm.com, Carella Chen <carella.chen@infineon.com>
Date: Fri, 04 Sep 2026 10:38:33 +0200
In-Reply-To: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-1-eeab4fda0f31@infineon.com>
References: 
	<20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
	 <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-1-eeab4fda0f31@infineon.com>
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

On Fri, 2026-08-21 at 15:56 +0800, Jason Huang wrote:

> @@ -18442,8 +18443,10 @@ static int nl80211_set_pmk(struct sk_buff *skb, =
struct genl_info *info)
>  	    wdev->iftype !=3D NL80211_IFTYPE_P2P_CLIENT)
>  		return -EOPNOTSUPP;
> =20
> -	if (!wiphy_ext_feature_isset(&rdev->wiphy,
> -				     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X))
> +	if (!wiphy_ext_feature_isset(wiphy,
> +				     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X) &&
> +	    !wiphy_ext_feature_isset(wiphy,
> +				     NL80211_EXT_FEATURE_ROAM_OFFLOAD))
>  		return -EOPNOTSUPP;

Shouldn't you have a similar change in _del_pmk()?

johannes
