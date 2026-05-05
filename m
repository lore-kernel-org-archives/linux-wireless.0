Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0C3201004;
	Tue,  5 May 2026 09:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777972700; cv=none; b=sM40kvpn2O96SePAXoGGf+ma1Lw3pNhWC+8JUqecOpofuYIt3UTIIMvu85gagKtEc108CH4Y80U9c1dbW54J1UG/DVJwRfarysxk46ks5vbid2W6pRzuAbpzxLnZxtohReaA51gsZ3/mhjpro3Z0XZeDxcEBJMyu4+EaMoAyZZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777972700; c=relaxed/simple;
	bh=XYLTOou88xcJgyj5ngZphltJcAZ2mOyF1cyM4ekPk+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lhfl/B+u2xOlmdX6GjBQ7oQmsCrEbQmsKE3pSjaQNRjtFlJAXIt8LDgbcKLuN1g3xmdiTI/TtapgmxVrz/20okic4zrK/dVyjS5mNZjPk/ACHqFji9PZKi5yjLRh70JCbYvsI3iKkvQvHAGQkkQ5k/MlQGJKfGFklNioXP01tG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dwml+pO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dwml+pO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77B9C2BCB4;
	Tue,  5 May 2026 09:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777972700;
	bh=XYLTOou88xcJgyj5ngZphltJcAZ2mOyF1cyM4ekPk+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dwml+pO3ofDNjb8XBIbrf15zt3TdWIGK1gPwROuqXvz5fNnnT6w2EWB9nB1Wdgmrc
	 GEArnDGDDzNU9k3qOIUJID8C1XN2Rx9rC08CaVBRgqdo9ObjZCZFPfSpJbsl0/2bCO
	 qzhjvXS89ChXJY/TViR/tsJsgP5Tkqll0XC3+R/6vMetG65YF9X7A/g/BXxWuAVOne
	 pvfwpV3z5XUpZwkhBdnAmbq9paaF2aPbBVv7WmZdKvoxZKPO4NRxravDunU+EZjQe4
	 Y2f+kpaKDOi7tsEl6bZJrVMkBESuKNUGOK3oLOkmMwuESQVoQf9wKAyQPuWuLsa9ev
	 g/Hv83ietzcxg==
Date: Tue, 5 May 2026 11:18:17 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Avinash Bhatt <avinash.bhatt@intel.com>
Cc: devicetree@vger.kernel.org, linux-wireless@vger.kernel.org, 
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, 
	johannes@sipsolutions.net, miriam.rachel.korenblit@intel.com, linux-kernel@vger.kernel.org, 
	kobi.guetta@intel.com, emmanuel.grumbach@intel.com
Subject: Re: [PATCH v2 2/3] wifi: iwlwifi: dt: add Device Tree BIOS
 configuration infrastructure
Message-ID: <20260505-sincere-electric-lobster-2a7bc3@quoll>
References: <20260504095327.30892-1-avinash.bhatt@intel.com>
 <20260504095327.30892-3-avinash.bhatt@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260504095327.30892-3-avinash.bhatt@intel.com>

On Mon, May 04, 2026 at 12:53:26PM +0300, Avinash Bhatt wrote:
> +
> +/*
> + * Mapping from DSM function index to Device Tree property name.
> + * Returns the DT property name for a given DSM function, or NULL if the
> + * function has no Device Tree representation.
> + */
> +static const char *dsm_func_to_prop_name(enum iwl_dsm_funcs func)
> +{
> +	switch (func) {
> +	case DSM_FUNC_DISABLE_SRD:          return IWL_DT_PROP_SRD;
> +	case DSM_FUNC_ENABLE_6E:            return IWL_DT_PROP_6E_UHB;
> +	case DSM_FUNC_REGULATORY_CONFIG:    return IWL_DT_PROP_REG_SPECIAL;
> +	case DSM_FUNC_ACTIVATE_CHANNEL:     return IWL_DT_PROP_ACTIVATE_CH;
> +	case DSM_FUNC_FORCE_DISABLE_CHANNELS:
> +		return IWL_DT_PROP_FORCE_DISABLE_CH;
> +	case DSM_FUNC_ENABLE_11BE:          return IWL_DT_PROP_11BE;
> +	default:                            return NULL;

Pointless function and only making DT ABI checks difficult. Drop.

Don't invent API wrappers or other HAL over simple calls to OF or device
API.

Drop also ALL defines and use OF API like EVERY other driver. This is
not a special place.

Best regards,
Krzysztof

