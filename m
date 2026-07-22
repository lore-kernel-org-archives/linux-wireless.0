Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5900361DB5;
	Wed, 22 Jul 2026 14:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784730716; cv=none; b=D46sqV68L/XYeafuvyKKGw1GWWhL+I3o+JnI7l3EAeym+oyVGQsnoVwZSdI0pLCyfNQCaRfsqTivvYBYyMD/K1QEo/fpOi1dWR95FxK9nskPDuligTkogAUPjUXZRTNQ7R9a63JsSPVTz6jikLuT5rEWh9GHhvpmI343CApsQWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784730716; c=relaxed/simple;
	bh=dfr7edx5vWtQEMkwgGVQmp3fiVoB1P4cyZxruqJTiPo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M850hMZu75CyhjkhNdvePkLWc8vJ0GXtvWQKngYtQN7vwd502feeZyd7XAdl5ScW6whRV22WS/XdunitNztrq+ekEBut6NIBvOi6+7svsLqXg8H8/Ql9lm3uJcC/99xFq/LdsoMMrWNArM82VwwzNIL7qooQO3iyuK0GrZVzbGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=BqC8cZtk; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="BqC8cZtk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=CFPvYrnIMj9KwsqUoei53N2CNzjoBBJcfyF8BKqcupo=;
	t=1784730715; x=1785940315; b=BqC8cZtkuDBGCjoST0kus3Qn76V0gIW4tmJyPJOP8KWklig
	KZnIZq+JHhLqQQLUoXkqmkWJsHxfiHoMgPrsGz2bhp6fJSCxzuPq7/4xgvIftoNP436kgu9WAbiwJ
	Ts1KNwYecPmIfK+xv3RblKUiMVBtMdf1a+UMpcrFSq1wRpkyOC/JsD8FInngpYc/Tv7q55+rjQNm1
	dqF4FhvohFQnJgsecquW3sgQdX7qwgrzQXWtcoLPeZKr3hZcyN4S9y/PZimhhBGRJLIEUha+YtI2F
	On/a+LGR3n3NXl3Y+8g2nHpzwHQfetsOGOprcDZ1zQNbK46faAkOyCHuYnDNB+7g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmXzB-00000004oYf-09P8;
	Wed, 22 Jul 2026 16:31:49 +0200
Message-ID: <450be3831c5e0234c309d4c04641a42c6ac4f2b0.camel@sipsolutions.net>
Subject: Re: [PATCH 8/8] wifi: nl80211: clean up color-change beacon data on
 errors
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhao Li <enderaoelyther@gmail.com>, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Miri Korenblit	
 <miriam.rachel.korenblit@intel.com>, Brian Norris
 <briannorris@chromium.org>,  Francesco Dolcini <francesco@dolcini.it>,
 Jaewan Kim <jaewan@google.com>, Daniel Gabay <daniel.gabay@intel.com>, 
 Emmanuel Grumbach <emmanuel.grumbach@intel.com>, Benjamin Berg
 <benjamin.berg@intel.com>, Anjaneyulu	
 <pagadala.yesu.anjaneyulu@intel.com>, Peddolla Harshavardhan Reddy	
 <peddolla.reddy@oss.qualcomm.com>, Lorenzo Bianconi <lorenzo@kernel.org>, 
 John Crispin <john@phrozen.org>, Avinash Patil <patila@marvell.com>, Cathy
 Luo <cluo@marvell.com>, "John W. Linville" <linville@tuxdriver.com>, Aloka
 Dixit <quic_alokad@quicinc.com>
Date: Wed, 22 Jul 2026 16:31:48 +0200
In-Reply-To: <20260708195911.84365-9-enderaoelyther@gmail.com>
References: <20260708195911.84365-1-enderaoelyther@gmail.com>
	 <20260708195911.84365-9-enderaoelyther@gmail.com>
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


> @@ -18754,11 +18754,13 @@ static int nl80211_color_change(struct sk_buff =
*skb, struct genl_info *info)
>  				   wdev->links[params.link_id].ap.chandef.chan,
>  				   info->extack);
>  	if (err)
> -		return err;
> +		goto out;
> =20
>  	tb =3D kzalloc_objs(*tb, NL80211_ATTR_MAX + 1);
> -	if (!tb)
> -		return -ENOMEM;
> +	if (!tb) {
> +		err =3D -ENOMEM;
> +		goto out;
> +	}

It'd be simpler for the cleanup to just change the order.

johannes
