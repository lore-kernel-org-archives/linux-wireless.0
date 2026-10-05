Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8A22F7EF4
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 19:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791227854; cv=none; b=auWUshy0YU1Fn2eKZUrasVCTQS9MjVewFBaCi6qz7+pJ8YRFOrUFjRs4uJHQ5Pcwg3im6o5lZuxFcRaEU3iOAfNJc4FRPVpnZgEUYChUx+82TSPTpBxZ0FBt96611wu1142bqQqSXl+m58Ne8oeEphCfygCCFN10TNhKg+Qs2Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791227854; c=relaxed/simple;
	bh=yPFd5Q54lya71DTqdiKILi6itBzQhnEGZp+KDLyxo00=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YMf9kgvvjFXkLb3GF1pVTHtd8R0SSQ6MQN0HWozZgMDK/5o8+EJqRilc7bFagbhONCWLhCNe8thoQVXsvFDBQXt1c6eF7AR1z+D7oOJgIrk/p9B+3IFjItqJSuLHQ3ay2ZJBF/I3PHIgRjQivFRXfPvilrZp3GHcpt9tJqc/hXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=meYeRsLy; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="meYeRsLy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=oxlHXkNNW8bILsg5l/hPGg06wfd29fntYl8VY/wAFwc=;
	t=1791227852; x=1792437452; b=meYeRsLygT0XjasC51l6YH87mMS7RpVAz606CkqmqGL5ks2
	zqT7zGFNqPxZ+qOX9DQj/6duKKBitENHSZETXXmGK6/0ANDv8ZM8OcQPmqLGj8FnAO/OhR+ebX1Ct
	Lq3kkPp4ua/6WRwU6cxhDh/7NcDODDUQG8/3SsDny8WKzv1L8XfuWb5oydQaM6XtJ/PPmug1yheUN
	l8PWcXkim1U+A56nfAoprN+TghOoWc/737AZcwsir1oCezrS+ZbPsq2m2+oxSWT6sgqzeCVBz6xTK
	LuBlGcpcnVHRfglp1iiYPWeoQKxbR2w2fa5ExCcCZ4rTRaPFOLbZkQBZz6jLS1SQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDoBm-00000005ZR4-0VDL;
	Mon, 05 Oct 2026 21:17:30 +0200
Message-ID: <8234429838b276fdf1eaa54da32c4b32347ed361.camel@sipsolutions.net>
Subject: Re: pull-request: nxpwifi-fixes-20261006
From: Johannes Berg <johannes@sipsolutions.net>
To: jeff.chen_1@oss.nxp.com, linux-wireless@vger.kernel.org
Date: Mon, 05 Oct 2026 21:17:29 +0200
In-Reply-To: <20261005171814.2884772-1-jeff.chen_1@oss.nxp.com>
References: <20261005171814.2884772-1-jeff.chen_1@oss.nxp.com>
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

Hi,

You based this on wireless-next, I cannot pull this.

> nxpwifi updates for 7.3-rc7

Ideally -rc6, but I'm not really sure it's worth mentioning what you're
aiming for anyway ;-)

> This update contains fixes for station list synchronization,
> aggregation and reorder buffer cleanup, authentication frame
> handling, and several memory safety issues.
>=20
> Highlights:
> - fix concurrent sta_list add/delete races
> - clean up station entries on uAP deauthentication
> - fix Tx BA stream entry deletion logic
> - avoid deleting Rx reorder entries under RCU
> - improve aggregation buffer cleanup
> - fix authentication frame length validation
> - handle authentication frame allocation failures
> - fix wakeup timer shutdown ordering
>=20
> ----------------------------------------------------------------
> David Carlier (2):
>       wifi: nxpwifi: fix inverted check in Tx BA stream entry deletion
>       wifi: nxpwifi: do not delete Rx reorder entries under RCU
>=20
> Linmao Li (7):
>       wifi: nxpwifi: protect sta_list against concurrent add and delete
>       wifi: nxpwifi: delete the station entry on the uAP deauth event
>       wifi: nxpwifi: wait for the wakeup timer before the adapter is free=
d
>       wifi: nxpwifi: free the aggregation buffer when the RA list disappe=
ars
>       wifi: nxpwifi: zero the channel statistics array
>       wifi: nxpwifi: fix the authentication frame length handling
>       wifi: nxpwifi: handle authentication frame allocation failures

I guess I'll (when you send a new version) pull this and try to convince
net to take it, but Jakub pushed back because Linus pushed back, and you
really can't just send a single pull request late in the cycle this day
and age. You _need_ to send more pull requests and earlier, especially
now that we get so many fixes. Yes it's only seven patches now, but some
have been pending for almost two months, and Felix has *36* patches (if
I pull that). It adds up quickly. Please send things during earlier RCs.

johannes
