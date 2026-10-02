Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDF2418371
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 07:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790925050; cv=none; b=B+QPGgI+llmwWLgkjfloCxmvEoXl1J6PXwR2ZdjTaLt1Yik7Wt7PcLeDJz+1DJI7yf7QAIMoNvXx9GhnmM3WX9XfhOk+wONLuDQVkahOmvbbhnMCIiMOzVd3+pCf/bBfomVYdEvq6JzFKDSix3IzWomaQ5MJLh7vLKOYUC0FyLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790925050; c=relaxed/simple;
	bh=GJbMoRlPpSRS/85Fs6bI0PpltDp0kaQpGeIDMLz74bY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=D9qnTF5R1YdaOx9ct+nSCj6u1x0xmZ+LOwthXYSMY8Nn4TnFJIwEmWML9+akql/ccQ2oZsWlPXKP0Kk0PvDzlmRGduKVfJ+f+5mKutMsy61zhE+fwjJMKLdoNhmOC4Y3XLhpUQDNKmlar/F1h0Hee+Jyo9i31ilCynjsxLs0Th0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=vUmZdjiV; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="vUmZdjiV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=0iCSnZBf94iSU8qX5YSFoey6y9BUtEAsjdm8I4FRRa0=;
	t=1790925047; x=1792134647; b=vUmZdjiVzE07uOgrqiA611cL9/1h5mP1xhuDQL/J06TP+7B
	HP6yT1D1Tnoz7bEZmYeDx59mcPDrYGsoz6OEAjBWuLQRMjcqTY5hQVYS6Y0AMtPkvj7SwXtrOjh+c
	E96eDFaCKM3hNPqaX+0uAN+rbFXWYKk2zqjgZWEcW04sj8I/96uW3z9SIPrIr7z8N1CQHSDRGLBLU
	kruRqur/SL2scLhoFK0vx2Lw9pp/DF/NQbQFKkCJ5rB20lAhEiKF1pmSAqkE8km+OcyMCcSadpVTL
	SbSHhxKHHMuyJI/1w7PvEMXV0Ed6PAeP1dfNG4qwM3SWhcQQszGEacYQWO2tWz/w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xCXPn-00000001FYt-41ms;
	Fri, 02 Oct 2026 09:10:44 +0200
Message-ID: <1327040865acb1ef04142b28b7aa6c878c692123.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 4/7] wifi: mac80211: nan: allow Rx
 registration for NAN beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>
Date: Fri, 02 Oct 2026 09:10:42 +0200
In-Reply-To: <20261001162941.42c8f2a8e1b2.Ibb92f6652a447acbf47f5b8d654fe34a0fd845e0@changeid>
References: <20261001133311.3367683-1-miriam.rachel.korenblit@intel.com>
	 <20261001162941.42c8f2a8e1b2.Ibb92f6652a447acbf47f5b8d654fe34a0fd845e0@changeid>
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

On Thu, 2026-10-01 at 16:33 +0300, Miri Korenblit wrote:
> From: Ilan Peer <ilan.peer@intel.com>
>=20
> Instant Communication requires user space to track the NAN beacons, so
> let it register for Rx of beacons on a NAN interface. Add support for
> passing beacon on NAN Device interface when instant communication is
> enabled.
>=20
> Add a helper function to identify NAN beacons, based on the BSSID
> and the beacon frame content. Skip NAN beacons so they would not
> be used to update the BSS table.

This does two things, please split it.


> +++ b/net/mac80211/rx.c
> @@ -4536,7 +4536,10 @@ static bool ieee80211_accept_frame(struct ieee8021=
1_rx_data *rx)
>  	struct ieee80211_hdr *hdr =3D (void *)skb->data;
>  	struct ieee80211_rx_status *status =3D IEEE80211_SKB_RXCB(skb);
>  	u8 *bssid =3D ieee80211_get_bssid(hdr, skb->len, sdata->vif.type);
> +	bool nan_beacon =3D ieee80211_is_nan_beacon((struct ieee80211_mgmt *)hd=
r,
> +						  skb->len);

Doing that fairly long inline here for every single frame seems like a
bad idea. It's also really not necessary at this spot, we accept just
about every beacon frame here and today even every NAN beacon if it
bubbles up. Also, BSSID filter will reject it anyway in most cases, so
is it even needed at all?

We can always be attacked in some way with this, so that's not an excuse
either, could even trivially just put a non-vendor-element into what
otherwise looks like a NAN beacon and then it'd be rejected by
"is_nan_beacon()" but parse exactly the same way as one.

> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -353,6 +353,10 @@ void ieee80211_scan_rx(struct ieee80211_local *local=
, struct sk_buff *skb)
>  		if (!ieee80211_is_s1g_beacon(mgmt->frame_control) &&
>  		    !is_broadcast_ether_addr(mgmt->da))
>  			return;
> +
> +		/* NAN beacons are not a BSS, don't add to the BSS table */
> +		if (ieee80211_is_nan_beacon(mgmt, skb->len))
> +			return;

If that's such a hard general rule, why in mac80211?

johannes
