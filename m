Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA0A30CD85;
	Tue,  5 May 2026 09:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777972783; cv=none; b=sacYY+Qqm9OXH+pVIGu58XnOM2vjCatkkTfrqh2/VoAJMjPWFOsUbkTvs6ova8mk7AJ210vzovghHuo/jH/OuxoitOptwkyUYsw6FZSk/chuCt0sqxArtwgUOJ18hKzxIGVxlw1oL6DbItGUQ3o7KfDb/drchxHYvP2Vltqdf40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777972783; c=relaxed/simple;
	bh=CPglZ9VeE7ocMLt+W0T6FvtLOr0yuBeE1tDtdf0luXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AlohetxsomP2o1YPHprYaW9nnMBm55HmUJzItnPOag8apKD2UF3YUmdEWiB3tWBg89x6TUqnMLqi2/j3KzskYXLYILej6+hWyvYJyGCd7zmfoRxjR3QwS2zJKUOaMlj9KuSFF37FlLA+YW0WG1mibpSe0bC3MzhMxQEGImNA3Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TSp273iy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TSp273iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E269C2BCB4;
	Tue,  5 May 2026 09:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777972783;
	bh=CPglZ9VeE7ocMLt+W0T6FvtLOr0yuBeE1tDtdf0luXU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TSp273iyNnDHL6irJQvf6PWCKoMgLTRUA7hP9f+yTr+InUAI+Gbp20QdCmT0hmydp
	 ljQnhCunhl2IZoaymvaSZBz7jO4U4LPAv2LfAlDpFx6+cAibG3ydSgTlf3UUrdYRl/
	 mQEiccspeMdQAaIZXWuOQ60KVfBlQEuF7NUWbZXgWazp0Chl/KfZp0cfvGui5AgVxE
	 U3gV4ugDTEOl2d1UEcI2FHs6hTrKtJ8/37TKPv7vyvGahsm0/YUDmpw2X8r0myywrU
	 RbXGTYRA+iAEVv5Ar7VtWWJqULO7Q4zPS+ciWMm4Ph933yUldlA0KEjgNkWUGccbCs
	 1anetaEMIY9NQ==
Date: Tue, 5 May 2026 11:19:40 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Avinash Bhatt <avinash.bhatt@intel.com>
Cc: devicetree@vger.kernel.org, linux-wireless@vger.kernel.org, 
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, 
	johannes@sipsolutions.net, miriam.rachel.korenblit@intel.com, linux-kernel@vger.kernel.org, 
	kobi.guetta@intel.com, emmanuel.grumbach@intel.com
Subject: Re: [PATCH v2 0/3] wifi: iwlwifi: add Device Tree hardware
 integration information
Message-ID: <20260505-crouching-albatross-of-beauty-a5ac6b@quoll>
References: <20260504095327.30892-1-avinash.bhatt@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260504095327.30892-1-avinash.bhatt@intel.com>

On Mon, May 04, 2026 at 12:53:24PM +0300, Avinash Bhatt wrote:
> Add Device Tree support for Intel Wi-Fi hardware integration information
> on platforms that do not provide UEFI variables or ACPI methods.
> 
> Patch 1/3 adds the DT binding schema for the Intel iwlwifi compatible
> node. Patches 2/3 and 3/3 add the driver infrastructure and integrate DT
> as the lowest-priority fallback after UEFI and ACPI.

Please provide link to any upstream DTS user of this binding, either
complete or work in progress.

Best regards,
Krzysztof

