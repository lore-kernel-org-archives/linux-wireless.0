Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73883BB699;
	Sun,  6 Sep 2026 11:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788695875; cv=none; b=OHLW5DcKjStJRI7b3hGnc8IvOgNyTj2EVqJDunVup+ptxHzSFVvxUiWqt86S2ZtQkpzCcWJ0F0MRdcwoNkRpe0Cf3Je4RKtmxQCMPzKnYafzn9wyXrumXOYvZJhP/g1sKK8wMnSw+QZ9JSQQqbsUU2T0Gi3zLe7lBQ99UqSBkIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788695875; c=relaxed/simple;
	bh=WFG2unOWr2rUL/ff46rpkVyeHhPFd2WZP7rmyHJw14k=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZijuydQ75Y0RD8AKApJ4bMK6qO2LD6QgXwOKiMdDXlr/iJa5LhTvFLNZ8KZUpfDnhTfFQkp7rqWiySn3lr8JI7rl7erM4yRsH5B5qDrZsd6v/h5x416QuLFUGOKl3iZKw09/cwCQFFT9n6LHG9eHbREg2oJQhW062R7CVO5eWKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=bhjUt2Ln; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="bhjUt2Ln"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=oNAKJHgibLFMG/kQIXTl01jK4ijxuqWnXbc1C7lQ+RE=;
	t=1788695873; x=1789905473; b=bhjUt2LnzNKDD5judgtajJlxc6bJYHMuAowyx2CzoooYHIH
	iQHL06Cr2/48+DfhvLd4gMqtm0E7o5RWrFQvFRNoYGPdeVpgtQwHlFcOcmwWSn7Hdb5Ju3qC5ozlO
	qJjGM6NnN+MjQsj+2dd29/ErNY5WQEyGp9cHo+z4PdWMA8d7ptHD+5MmQjBVNW39E1eyitoRPR0CL
	stqexcXvKL/o0TfUoePBo1Vnjf20MuBzaTtWSY+jduspdw42oJJjF9mtClrdBZXpVjI7X2kJZzp7z
	vvbNoAlNuGx4Lilw6NVsNa/RPJARLZkZhiiwc49d+NUcypifJDDW8b9YOwSrQu9w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3BVO-00000003G16-2bKU;
	Sun, 06 Sep 2026 13:57:50 +0200
Message-ID: <8e094e1bd016b04d3ab3bb02be2723aebaf9c9e4.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: cfg80211: avoid holding rtnl_mutex across all
 cfg80211_leave() calls
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?=D6mer?= Mete Kaya <omermetekaya0@gmail.com>, 
	linux-wireless@vger.kernel.org
Cc: kvalo@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	horms@kernel.org, syzbot+adeb8550754921fece20@syzkaller.appspotmail.com, 
	syzbot+101224300649c3eb8af4@syzkaller.appspotmail.com, 
	syzbot+8141dcbd23a8f857798a@syzkaller.appspotmail.com, 
	syzbot+b0ae8f1abf7d891e0426@syzkaller.appspotmail.com, 
	syzbot+d6bbe0f5705cb8a5aa2b@syzkaller.appspotmail.com
Date: Sun, 06 Sep 2026 13:57:49 +0200
In-Reply-To: <20260906002657.620076-2-omermetekaya0@gmail.com> (sfid-20260906_022719_558651_B6EAD15C)
References: <20260903151542.486376-2-omermetekaya0@gmail.com>
	 <20260906002657.620076-1-omermetekaya0@gmail.com>
	 <20260906002657.620076-2-omermetekaya0@gmail.com>
	 (sfid-20260906_022719_558651_B6EAD15C)
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

On Sun, 2026-09-06 at 03:25 +0300, =C3=96mer Mete Kaya wrote:
>=20
> +	/*
> +	 * Snapshot rdev pointers under RCU with a device reference so they
> +	 * cannot be freed between per-device rtnl acquisitions. Using a
> +	 * per-device rtnl_lock() instead of holding it across all devices
> +	 * avoids starving other rtnl waiters when cfg80211_leave() is slow.
> +	 */
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list)
> +		n++;
> +	rcu_read_unlock();
> =20
> -	rtnl_unlock();
> +	if (!n)
> +		return;
> +
> +	snap =3D kmalloc_array(n, sizeof(*snap), GFP_KERNEL);
> +	if (!snap)
> +		return;

I really don't know _what_ you're doing here, or more realistically what
exactly you're asking your LLM to do here, but it's pointless. Please
just stop, you're not helping in any way.

johannes
