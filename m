Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7453B19B9;
	Sat, 17 Oct 2026 17:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256435; cv=none; b=mvmmB6S6Z6ox45XggjiUTv/m3Vhm2ZFjpb2I0c2yqZ4Tu0HEEIlYEQbbid+EVYzfzjnJrno1wwD8PUeY4mX9MH0yL41wsgokYLyS7aiVoSNG/UcnWNcbAj0SPNlYROOhcSKKpdMMc7UJhFxOJeudgtITceXcgU8OQooixANM9nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256435; c=relaxed/simple;
	bh=2bTA97ILnQsJSGqUwFDR99XvccfbV1wSQj1zK+ZNPHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OAqD38zbssolLhTnlvqPZRDQAfvQjFvaqwgbiKT8dB5eyI16FytTdFOuAbapqo+7FGoCiXbI8BJRzGCzXO1OEL6+o5KRzAoJyE7Cq5JfWOt/5X9Q5Sl499l4Q9xkmSD5O7OhweUuJ8OqNT7uGPHcYbI2p9xtj0iOaEqmlH2gaFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fHl8fu12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fHl8fu12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9FB1F000C4;
	Sat, 17 Oct 2026 17:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792256434;
	bh=YbnWqV/aiXz31EkDcm+H/Bo/C7Kw7PfSJHeX/JxezG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fHl8fu12MEq0ZiRcm8ewBLNR6wUle1ev1Br/rpaZ9WxMTl2UdqdTcPtYsdailFWcf
	 xGepDOTzbHztmstTDezxwyWHKCejEr6haUE+1gDAc/NzpralHcSyIwl4MIGV7jmlQB
	 r1RAdSLjHCHB0cPuxuoHq0nHFn9AQ1zYpTKdk0tk/l5MqUrTJ1qvAerQ1VAyiyvFje
	 Qp63tZQIZsUR7lUmBXCe+FZNVmaJ2CeQR97fCkrdtThPryDxxFNP0BbY5+FYQ4H2Zi
	 u3LenPURx78+aG+UnDvMdbYXOa/unq9L2QkL035ecQfCb4XgaiotoE7EWqNsqlA4ct
	 5x1ITTNkbWR4Q==
Date: Sat, 17 Oct 2026 19:00:31 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, 
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ath12k@lists.infradead.org
Subject: Re: [PATCH ath-next v2 01/17] dt-bindings: net: wireless: Add
 QCN6432 device tree binding documentation
Message-ID: <20261017-little-fanatic-bulldog-e84f9d@quoll>
References: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
 <20261016-mpp-bringup-v2-1-f510c33bfcf5@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261016-mpp-bringup-v2-1-f510c33bfcf5@oss.qualcomm.com>

On Fri, Oct 16, 2026 at 08:51:38AM +0530, Aaradhana Sahu wrote:
> Add Devicetree binding documentation for the Qualcomm QCN6432 IEEE 802.11be
> wireless device.
> 
> QCN6432 is attached to the WCSS Q6 subsystem and is represented as an AHB
> platform device, even though the Wi-Fi hardware interfaces over PCIe.
> Document the compatible string and the resources, including the Q6 remote
> processor phandle, MSI interrupts, SMEM states and memory regions.
> 
> Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>

I missed during previous review - you almost hit combo. If you added
YAML or schema it would be the most redundant information ever. Well,
pity, no combo.

A nit, subject: drop second/last, redundant "device tree binding documentation". The
"dt-bindings" prefix is already stating these.
See also:
https://elixir.bootlin.com/linux/v7.1-rc7/source/Documentation/devicetree/bindings/submitting-patches.rst#L23

With subject fixed:

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

