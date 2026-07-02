Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C730D33F8CA;
	Thu,  2 Jul 2026 08:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782980846; cv=none; b=KYYCnAvx97xxjsqJotOSNS7eTSD3WW9og7wvt+ttGXQ/B8mw1KTHFbjbNpn6qmxMO5aZbAhiyzyDQoUJKdDS7joCYkzVCZ3kjpMhDZjlH9MBIOjnjJzj+CVtTYxwbPDJo9TxZAc5mS5aPGvdCANnYcrxVovasyz2H0cDLEfN9nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782980846; c=relaxed/simple;
	bh=+ngHn6uf+3LIKwi/2+6vVQprALRvSEsMi9V4LTgnpeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLEzGp/L9OweTjRBkB1OKwGDSyBFSQfEv+K0Elcu/U7xrDGwVzAZmtnRjZoNYEs7uxh11i8gBOh6M8UziOkrMdn0wuoWdOnDACRa5a8KQZuJ+njGrLIK0kADS4OlaIuLHcuKmoA/kZnnjxMxPO10VnpXh5sHN79vQ8qyIqQ8NYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hkYJjHhe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hkYJjHhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851061F000E9;
	Thu,  2 Jul 2026 08:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782980845;
	bh=vDQz+NYkTBHSULK0tw+Mm8elpzXTkLrFpJWp8OOPxRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hkYJjHheBiigSCIoxAnmBnm2Bv2li9Wt0V/580iIt97g+Qrcrl/x51jeXGSSBer4N
	 G8ZKzu71v+Ztthqr3JIPrs2YJj9D7qbkxUzhIYzarWZPgQiaBamvYPihvcQtIxaDpa
	 rnh9tbuT81gfZDB+QWm7HZ6b2Fuj1Iqs6AZ2ft+3KAfMwrBosipBQB9reYyIz+THZV
	 YRpOs2QdLr7ugW9crkovYbsPxYd+v1B0mMjw/cdJOcm71xTzmDe2rETZdLIqtOprgQ
	 538oSgv1t2IdpzYrb02oFqE2FPspC5qTTb4RIneR8kbqhk8V8dooW047Fjf+FmWdPW
	 ZbW0tPAXYrQRQ==
Date: Thu, 2 Jul 2026 10:27:22 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Ernest Van Hoecke <ernestvanhoecke@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, 
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>, Andrew LaMarche <andrewjlamarche@gmail.com>, 
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, ath12k@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
Subject: Re: [PATCH] dt-bindings: wireless: ath12k: allow calibration variant
 for WCN7850
Message-ID: <20260702-beneficial-hopeful-binturong-a0bee9@quoll>
References: <20260701-ath12k-calibration-variant-v1-1-d3eddaabf026@toradex.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260701-ath12k-calibration-variant-v1-1-d3eddaabf026@toradex.com>

On Wed, Jul 01, 2026 at 05:42:24PM +0200, Ernest Van Hoecke wrote:
> From: Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
> 
> qcom,calibration-variant selects board-specific calibration data for
> systems where the bus and device IDs are not unique.
> 
> This is not specific to WSI-capable QCN9274 devices. The WSI binding
> already allows the property, so allow it in the WCN7850 PCI binding too.

Why? You need to provide reasons WHY do we want this.

> 
> Signed-off-by: Ernest Van Hoecke <ernest.vanhoecke@toradex.com>

Where is any user of this?

Best regards,
Krzysztof

