Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C07C30D413;
	Mon, 10 Aug 2026 17:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786383042; cv=none; b=LAekUAR7tqCn5hvXzkmlGCkIqd+6SjHNIP/MEkJ4X8U9ATXK++nK6yKDvv/vIoKcRacleON/cyWMBQz5Wv0UjC7OdavhjCBLH+bbYGwU1cltev7GbxL/k8jCuaeyVwYRAcA1sIrFdGI6ekG/5E2Q6VpG03VUyxNupW5lF36+6gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786383042; c=relaxed/simple;
	bh=CX85OGSIx/mQNsVqxE3uCXwcmOD0xZ0JfnA0tGXqN/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fwhhuWScFAm0vvU15C8w9aUQTU4ei+Xe6FvPaSkBg+6XjrngVf3wb3o9IaIIF8jfTME4YtRO19ZtpVg5b0s1AhEQnEbk7x5fKgGVT84gBLy3yHA8bzuBIwu8Fak7BaW9j4g/9dIR3vLU3mXPCjAg9IMmWYMQNijvySrpUlp/Z+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LwGEPLYb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LwGEPLYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54961F000E9;
	Mon, 10 Aug 2026 17:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786383040;
	bh=KIVSOjcRfV0FZnsIbdZR9Ns/3ujkvRp97l2ydDdlwmk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LwGEPLYbB3aFmKFprWh+LYbo36vAqQlhy2Z6yj2/6kPALIUKYpv8joVZRMzTlHB0f
	 JSVJ0giJxGqc+ScdKjdYfnV1n9aXV01TBVv/Lsg67qO2JCG7/BHov+Fs9bJ2gt1uAc
	 Hp+jKU9xNjb5ff9Plwo5rmiPOieB7JpOfZuf1iXp59rgDKmPADqN5rgVvvkk5jY28s
	 mOISlZKQgk5aaU+eAZLkIHo5ukdegomqVjz6eSSHe3AzmoLz9vmeYV2RupG3zez1w6
	 e52b9wg+01cOBGLhZ8zznoCBSTlI/Ta2vURj4dfiFTIvPxaUmeHqzxSYBXN+WmN1GW
	 f66K72xnq+AKw==
Date: Mon, 10 Aug 2026 12:30:40 -0500
From: Rob Herring <robh@kernel.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Rosen Penev <rosenp@gmail.com>, devicetree@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: wireless: brcm,bcm4329-fmac: add
 nvmem-consumer reference
Message-ID: <20260810173040.GA2218158-robh@kernel.org>
References: <20260727225311.266596-1-rosenp@gmail.com>
 <20260802083905.3819981-7-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802083905.3819981-7-arend.vanspriel@broadcom.com>

On Sun, Aug 02, 2026 at 10:39:04AM +0200, Arend van Spriel wrote:
> On Mon, 27 Jul 2026 15:53:11 -0700, Rosen Penev <rosenp@gmail.com> wrote:
> > The brcm,bcm4329-fmac binding has unevaluatedProperties set to false
> > but does not allow nvmem-cells or nvmem-cell-names, which are used by
> > DTS files (e.g. bcm4709-linksys-ea9200.dts) to supply MAC addresses.
> >
> > The driver already supports nvmem-based MAC address retrieval via
> > of_get_mac_address(), so add the nvmem-consumer schema reference to
> > document and allow these properties.
> > ---
> >  .../devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml | 1 +
> 
> The problem is real but I think the fix belongs in network-class.yaml rather
> than the brcmfmac binding specifically. ethernet-controller.yaml already
> defines nvmem-cells and nvmem-cell-names for wired NICs, but the wireless
> binding hierarchy (wireless-controller.yaml -> network-class.yaml) is missing
> them. Fixing it in network-class.yaml would cover all network nodes at once
> instead of requiring each wireless driver to add the same reference
> individually.

It is wrong because nvmem-consumer.yaml does not define how many entries 
and what they are. IOW, the valid names in nvmem-cell-names must be 
defined.

However, expecting all network class devices to use the same 
nvmem-cells/nvmem-cell-names will probably not work long term. Some 
device may use it, but not use "mac-address" entry. Unfortunately, 
there's not a way to override a default in json-schema. So we'll 
probably have to just define this in every user rather than centrally. 

So this should just add the definitions to the brcm,bcm4329-fmac 
binding:

nvmem-cells:
  maxItems: 1

nvmem-cell-names:
  const: mac-address

Rob
