Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B1B392825;
	Mon,  9 Mar 2026 10:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773052818; cv=none; b=Jwnjmztfr6oK/EqODT8tgYb8UCXlQk9zu5FNHK2muVl9IjtJ977/usccGzPIImq9U3Vnq2KnHo22cxRvQN3PaOLZVKcZYhW1nrI+xPHj3I3v8s+hNlXJp6h89wBPj1Pag8jifG9+LQOWqUVAKtWAJqidD65zqTCpeoVT0oTv1cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773052818; c=relaxed/simple;
	bh=/LL+cA0ozCUmuZKStymI49YWY0tx1XTIy6wWyZmgijE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bIH9MvIIyb+Q1doBozBG/1A4aEsY7t1RnmfUaG17LZRcjbUtxc7ogr1MG0c9VA/j2j8vlOVXbUK9jAZGgyRe4dzJF00D9zTSpZRhuzmOR1nNEdBp66UkMhSdHT2hK+y5cv7BfCYetHJNxB5IZw0EcLPmqFd9txk3KEQpMIAOvPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=m5AMYpdK; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="m5AMYpdK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Bq11JOk5ibB9ZzMxjd+tfcs5njSiFxk1DziCZBKvMxY=;
	t=1773052817; x=1774262417; b=m5AMYpdKkWKu4vSUn7zEmbgjrPN1ieRXviayO2BA+/8pnuF
	679eokLeO9ksEeCfO2gBxAGxacXHytuKt/VMpnAKr56Soxj8wit7dOhLN9JCwGKOyUJDyxYfxyF9c
	bmtVoCqTIc8M5qdKUI5mLi9qxDQE7VmZAuU2dhU23kWPUzju7sdkdxpBdy4GipZg+zI603/fYZCJf
	H09mhELhMQx0esNUjeWJbrqO3Sxjg5mwT92eLwdv6dR833vgczZX81WYJ1D6/pBb/v5VDGajwQu4u
	4gQPbp8SIOqUO301j6N+V8ii7UIAseEqc5Bh/t30HCCRp+T91PDXZQ6dNarqolUA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vzY22-0000000CsGZ-1Zfj;
	Mon, 09 Mar 2026 11:40:14 +0100
Message-ID: <f09f527c49c8f8998786674a8abd60fcd059f95e.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next] wifi: brcmsmac: use FAM for debug code
From: Johannes Berg <johannes@sipsolutions.net>
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>, "open list:BROADCOM
 BRCM80211 IEEE802.11 WIRELESS DRIVERS"	 <brcm80211@lists.linux.dev>, "open
 list:BROADCOM BRCM80211 IEEE802.11 WIRELESS DRIVERS"
 <brcm80211-dev-list.pdl@broadcom.com>, open list
 <linux-kernel@vger.kernel.org>
Date: Mon, 09 Mar 2026 11:40:12 +0100
In-Reply-To: <20260223030539.19307-1-rosenp@gmail.com>
References: <20260223030539.19307-1-rosenp@gmail.com>
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

On Sun, 2026-02-22 at 19:05 -0800, Rosen Penev wrote:
>=20
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.h
> @@ -43,7 +43,7 @@ struct brcms_timer {
>  	bool set;		/* indicates if timer is active */
>  	struct brcms_timer *next;	/* for freeing on unload */
>  #ifdef DEBUG
> -	char *name;		/* Description of the timer */
> +	char name[];		/* Description of the timer */
>  #endif
>=20

Might be better to remove that ifdef too, if only to have cleaner code
and get errors when someone tries to add something after it in non-debug
builds?

johannes
