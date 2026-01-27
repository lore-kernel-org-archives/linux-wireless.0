Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715CF352930
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2026 13:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769518938; cv=none; b=CaBMZtNwkR0uUsiLWxkmiszxo4gXdGDgbnY+WhgNpsn1X/Gx/Pahv0AgGxLZMhC5FdoDOwZYpCL9gxayoJJsk+kDdBvROUYPDClxi5hZCJapEo7X7Jpg3IjFwVoHU51+ftQBauuI+39rRqRslzXdPN6a66KxDECETS7dUpoj/u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769518938; c=relaxed/simple;
	bh=oikarJayW0NZnDO+0QVRIRfoeBtM8zUy8i/lqLIRFBo=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C7LzyUafBWeCprLsPecv0ZqkOKCly5ynA+nzjZ5zvAk2silCSYLNq1Coqr6mOguBNwDogu6YGgAmaDVGhyB1zVv3BK6bGP01QtkJG0X8iN1H69z5XT7WT5idP4o75EEluUN2Q7M9jpfV+POAGZI5t0lZtB3wJg9Fbkq5JcOqHfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=BgLIBqWr; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="BgLIBqWr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=GvG5Vn6NI9pbJ/6/ajv0TWQYACZb84dPyKyKtjL3HBw=;
	t=1769518937; x=1770728537; b=BgLIBqWremieCEge/M5YrB39xIBwUfHLZQ1/DcF2jrk3y8V
	GTr9qxpS3gxKcCOXbDt1qNPSk/yfGE/0/THX2lOfYcq0UfQ0b4DKyd5ZLz0d/w1ljgc11uVqoxBsb
	70FEwpBMNLeTQxRaPjBxnhy7MiN835aYYSge0TLrr+1IJaN4zohmuzfsZT/R2dj9DA6kd4LnprQ1q
	fpY1VnBzKaiK4IrEFn0f2muTSi9CcJ/tblVtNRvfpDScyN+0XQafTThUR+xIVgx+Bp7CBEu+NvNqi
	s0ddHfyvk540eudp8ui1B6nA4h2KiFTDW0lbWGLso+2lC0ap0cLOKhY8H+RoSG9A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vkihz-00000004zyo-1AFv;
	Tue, 27 Jan 2026 14:02:15 +0100
Message-ID: <69c37195aaedd7933bcc307aadbc12d1cdf85b33.camel@sipsolutions.net>
Subject: Re: [RFC v5 wireless-next 2/4] wifi: cfg80211: set and report
 chandef CAC ongoing
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>, 
	linux-wireless@vger.kernel.org
Date: Tue, 27 Jan 2026 14:02:14 +0100
In-Reply-To: <20260125160353.34102-3-janusz.dziedzic@gmail.com> (sfid-20260125_170409_804588_262B2BFE)
References: <20260125160353.34102-1-janusz.dziedzic@gmail.com>
	 <20260125160353.34102-3-janusz.dziedzic@gmail.com>
	 (sfid-20260125_170409_804588_262B2BFE)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Sun, 2026-01-25 at 17:00 +0100, Janusz Dziedzic wrote:
>=20
> + * @cac_ongoing_time: timestamp (CLOCK_BOOTTIME, nanoseconds) when CAC w=
as
> + *	started on this channel. Zero when CAC is not in progress.

Is "ongoing" really a good name? To me something like "CAC start
timestamp" would seem more descriptive?

>   * @psd: power spectral density (in dBm)
>   */
>  struct ieee80211_channel {
> @@ -205,6 +207,7 @@ struct ieee80211_channel {
>  	enum nl80211_dfs_state dfs_state;
>  	unsigned long dfs_state_entered;
>  	unsigned int dfs_cac_ms;
> +	u64 cac_ongoing_time;
>  	s8 psd;
>  };
> =20
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index b0f050e36fa4..7c23fd1b8ce9 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -4452,6 +4452,10 @@ enum nl80211_wmm_rule {
>   * @NL80211_FREQUENCY_ATTR_S1G_NO_PRIMARY: Channel is not permitted for =
use
>   *	as a primary channel. Does not prevent the channel from existing
>   *	as a non-primary subchannel. Only applicable to S1G channels.
> + * @NL80211_FREQUENCY_ATTR_CAC_START_TIME: Channel Availability Check (C=
AC)
> + *	start time (CLOCK_BOOTTIME, nanoseconds). Only present when CAC is
> + *	currently in progress on this channel.

And here it _is_ "CAC start time".


johannes
