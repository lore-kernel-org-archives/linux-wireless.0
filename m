Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6433438BD;
	Wed, 15 Jul 2026 13:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784121776; cv=none; b=sfnSKXSTdVdvS5B5Ntl7ekPLTxRpDYRduPH6XGcIhnkYB2QdRF2WmvSYxK78hM7QEswKBbFxlfyQYKOCUJcrzSy3uuSHH+D+znuahDM/NHpoNX12H7PtT2kepP4OmaH1gO6I3e0N/fbiH20CaY/nMCgb5FyHqcVoF5nnvu3tjJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784121776; c=relaxed/simple;
	bh=MMbHIEN+MKb6ESCBAJk0WKdZs9rfTrbWxqixkvhY/cY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MSetnvismJ2ARJF0F7BwA8xJGDSQg0vJDaTHGORZc3cLCjxoYLj8GtPkDVaPOSvsqPkVqih/dO7QkEbdN7ArD80N7LhmbueIwe1NYmrS9uYN2bEzTQYEM9L5KSrKr09z17zd6l+QTDoQGAXJn2nsPKbMQ27qQ4xPmxvjTrSz3bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=IXZs7Fkh; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="IXZs7Fkh"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id 8DBAA22BE7;
	Wed, 15 Jul 2026 15:22:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1784121763;
	bh=vV+F/Q2g+z1JgERi+3Itnnnx3B2OLvvKCZXJVebmC1I=; h=From:To:Subject;
	b=IXZs7Fkh3JO2pEOchw7bljx9Jv3Zzudtieei/Fmw5S88xfggYTCKrUV2Pl1VIULWg
	 5WX6krKPbqmQ/2odhuWBIhkISQpr28nn72ADHqCNQXz/LFLoRXy52nthPj/VqpH+9y
	 LTgtsn+fJ+uvUvpO1mKcKfiX6h7TuvmvzAxt4fZoVY05NmNY6C61msR+xGoybRGTZe
	 WI91OuJouxDJ7jDEWsQO8/VQ9EW37X9ef+PJl/kW5V6ZdPUMvhkWqMO4GW28gHHxrH
	 uPw2v13XQzaqM1TNRCx2d0/g7AQ67/WZ2RpKd+v3bYN4Q+1oD2J+MN75GQGUsuovY8
	 9P33EW2JYkF7w==
Date: Wed, 15 Jul 2026 15:22:34 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: HE WEI =?utf-8?B?KOOCruOCq+OCryk=?= <skyexpoc@gmail.com>
Cc: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@kernel.org>, Kees Cook <kees@kernel.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: mwifiex: bound uAP association event IEs to the
 event buffer
Message-ID: <20260715132234.GA56330@francesco-nb>
References: <20260629120333.94222-1-skyexpoc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260629120333.94222-1-skyexpoc@gmail.com>

On Mon, Jun 29, 2026 at 09:03:33PM +0900, HE WEI (ギカク) wrote:
> mwifiex_process_uap_event() handles EVENT_UAP_STA_ASSOC by exposing the
> (re)association request IEs that the firmware copies into the event:
> 
> 	sinfo->assoc_req_ies = &event->data[len];
> 	len = (u8 *)sinfo->assoc_req_ies - (u8 *)&event->frame_control;
> 	sinfo->assoc_req_ies_len = le16_to_cpu(event->len) - (u16)len;
> 
> event->len is supplied by the device firmware and is never validated,

Why not validating event->len instead, when we receive an MWIFIEX_TYPE_EVENT
from the firmware? we could just add a new, validated, u16 event_len, in struct
mwifiex_adapter and after that we can just use it in the code.

and we reject invalid events as soon as possible in the software.


> Fixes: e568634ae7ac ("mwifiex: add AP event handling framework")
> Signed-off-by: HE WEI (ギカク) <skyexpoc@gmail.com>
> ---
>  .../net/wireless/marvell/mwifiex/uap_event.c   | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/uap_event.c b/drivers/net/wireless/marvell/mwifiex/uap_event.c
> index 679fdae0f001..adca7da29f0f 100644
> --- a/drivers/net/wireless/marvell/mwifiex/uap_event.c
> +++ b/drivers/net/wireless/marvell/mwifiex/uap_event.c
> @@ -126,6 +126,24 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
>  				sinfo->assoc_req_ies = &event->data[len];
>  				len = (u8 *)sinfo->assoc_req_ies -
>  				      (u8 *)&event->frame_control;
> +
> +				/*
> +				 * event->len is reported by the device firmware and is not
> +				 * otherwise validated.  Reject a length that underflows the
> +				 * header, or that would place the association request IEs
> +				 * outside the fixed-size event_body[] buffer the event was
> +				 * copied into; otherwise the IE walk in
> +				 * mwifiex_set_sta_ht_cap() reads past event_body and out
> +				 * of the adapter slab object.
> +				 */
> +				if (le16_to_cpu(event->len) < len ||
> +				    (u8 *)&event->frame_control + le16_to_cpu(event->len) >
> +				    adapter->event_body + MAX_EVENT_SIZE) {
> +					mwifiex_dbg(adapter, ERROR,
> +						    "invalid STA assoc event length\n");
> +					kfree(sinfo);
> +					return -1;
> +				}

In case we want to keep the change here, I would ask you to make the
code slighly more compact.

just define a

evt_len = le16_to_cpu(event->len)

and use it.

