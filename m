Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069A32566F7;
	Thu,  5 Feb 2026 17:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770312844; cv=none; b=rd0k+oSOoZKTtJ5KTP4deHnuduPITbkQ+jX1ShCfrUA7vabwqlIOTVf6fxRP24X6SSfgi7zLPAmy5O8R/dKGwDrY+RL9liSAVsldV0XNJHVYZt6wHgIrkODgXPU+uvE3a2hSn4Le6U+s3yEs0YxYjlKZDw2kJgn+ZDpqbfnluSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770312844; c=relaxed/simple;
	bh=YmAZPLraaYyAH8QEMoajkTgspFcmml8cxhuWo8X6dQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qTrlJyI3VmBTbp4rTVxilG3VJP4ftIzZeWko4/xYspwfIrpB7oATLDBWpJQfYTs87nyRFigMDEaR18JbmXMDosQtq2a9ywCvLXLD+0Z/vAoP9N/cfeWmrjv/XXMOxt1pAJHkzpYpzyWyEbXeVWYng553tFZd+lwREEUjnqIXFbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=Am7bi8fW; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=er8bfm37; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="Am7bi8fW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="er8bfm37"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id 0B7361D0007E;
	Thu,  5 Feb 2026 12:34:03 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Thu, 05 Feb 2026 12:34:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1770312842; x=1770399242; bh=Bdr3a4RsfY
	7loaV4EGK1omAkpqA0BNuHOWy3YIZ/14E=; b=Am7bi8fWs/fTDVULBUBy7522mC
	2QBtGyYfLxObp28fQSEPQNP8V3mJ599FGipR05dd5da6xYNqeU/v1NhkxzXkn9ye
	ymWLvdA3kCIqkHNAPO7ROTvfO4Q6/lTT0rwW9e0nB1Mn5Hudl2IKCxIgak+mnDOZ
	AcYyB2qusJ8cKZiKQ84YBQdNMWifd7Q4h0DYBVlFQpPq9rp2gUUCBCwFv7/a6/Hl
	R8kbaeRH/3xuWLgcaVERfLJZUxhYq0Rjrr/PtmMkc4eCyQam3rbYiG9bYUOeP5Ik
	NXzD4at4K2Ckromx5JliuvzB3MPsna59yTj4S7/WTvl4B7yFKfyOoRGB1QkQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1770312842; x=1770399242; bh=Bdr3a4RsfY7loaV4EGK1omAkpqA0BNuHOWy
	3YIZ/14E=; b=er8bfm372OpLa4w1LWK9KzYiVq7EX5BcrmbjXCBeJp2asQtJg8D
	0u80Cnjjy94tcYr1ocSE5jKPKngfhoDBBDxbgN0noWLhhCrXYH5JX5rEqrC/sDSr
	1hGLkjUvbhEoECi+PfQvDq+joBbDGo1OZXw9Jo98kQt/3qUpqKzIAfYqCqIwIF/t
	FufwyVnrEbMFfTu1a5FHXD662WwqRaGLSbCMoArpfdsqD2EsD7DmBIu1hbKutymS
	ZyJNXRYwDUGGbkC3PKEzU57sTNZslQWzM9HWHaqqONGZLQZDldJUy6gpVXL9k/vF
	bFLkcna8JnNyDFIWZXuJ88nFYlMkk/yALuw==
X-ME-Sender: <xms:itSEaRnnGHqIXgZCLBjyZCJBM76MC8ITR-o-z2KuKh_TOWhNis6Whg>
    <xme:itSEaZgn8SJu34GqdbWLzWlC2jbFbjEb0gnd9RQSgvUaq4cGAoOCcHrilrWnq1Azs
    JQm_G-Ou0eOaerntG0QIopgSXoekX8CqbxLLwS2tzJI46MCLaw>
X-ME-Received: <xmr:itSEabhOTlQdY4XVmXRaSdUyAGA9kgO175BJZ9brOlKkYwpCXD95VkXwos0eHKNCGxkgp05u9vGaHy984zW9KZ-Os-C6Ebnlx4vLxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukeehleduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehueehgf
    dtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhdpnhgspghrtghpthhtohepuddv
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopeguhhihrghnudeltddvvddttdelse
    hgmhgrihhlrdgtohhmpdhrtghpthhtohepjhhohhgrnhhnvghsrdgsvghrghesihhnthgv
    lhdrtghomhdprhgtphhtthhopehlihhnuhigqdifihhrvghlvghsshesvhhgvghrrdhkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehsthgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrghdprh
    gtphhtthhopeguhhihrggrnhduledtvddvtddtleesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:itSEabvHdv-QuczPnE2QA4G8MpdznTOHqGo0bvdGx1vRTUPqQHMlMA>
    <xmx:itSEaTta4I6gPbUGRmN8oIMmPHYGdzTfVuxiQcPtczdhuW2tC_iJUw>
    <xmx:itSEaZq0e-8W1G3HECEyviJ2M-eXlDV_-hO4TFxqwaX-iq7dl-pf6w>
    <xmx:itSEaaLJUEWpdXgd7lWhyWgS6Lu0j2aougop0JcrHrrB9yATnipcXw>
    <xmx:itSEafAMeimhLYb66njjsEqp58ItFnOxqzBqJ2WsdyRJQYMeZrvRzVvx>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Feb 2026 12:34:02 -0500 (EST)
Date: Thu, 5 Feb 2026 18:34:00 +0100
From: Greg KH <greg@kroah.com>
To: Dhyan K Prajapati <dhyan19022009@gmail.com>
Cc: Johannes Berg <johannes.berg@intel.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, stable@vger.kernel.org,
	dhyaan19022009-hue <dhyaan19022009@gmail.com>
Subject: Re: [PATCH v3 wireless] mac80211: fix NULL pointer dereference in
 monitor mode
Message-ID: <2026020553-consult-widow-3d06@gregkh>
References: <20260205172313.16652-1-dhyaan19022009@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205172313.16652-1-dhyaan19022009@gmail.com>

On Thu, Feb 05, 2026 at 10:53:12PM +0530, Dhyan K Prajapati wrote:
> From: dhyaan19022009-hue <dhyaan19022009@gmail.com>
> 
> Signed-off-by: dhyaan19022009-hue <dhyaan19022009@gmail.com>
> ---
>  net/mac80211/main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index b05e313c7..190222c26 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -416,6 +416,8 @@ void ieee80211_link_info_change_notify(struct ieee80211_sub_if_data *sdata,
>  	case NL80211_IFTYPE_MONITOR:
>  		if (!ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF))
>  			return;
> +		if (!link->conf->bss)
> +			return;
>  		break;
>  	default:
>  		break;
> -- 
> 2.43.0
> 
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
