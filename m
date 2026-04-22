Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960D03C1969;
	Wed, 22 Apr 2026 09:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776849602; cv=none; b=WyNpMy504uiK3+Le6KnCIqS5uHNKVruvSxUSqffE3uMnYScu28aFm3AlqBDarkD6NmW+rk15YEw3aQTBOsq7AMSwfRarfFcdTCGl/ZtdTL/6He+SlHkH1Pncu91KNbzPAEPyaH9+hzck3QpvrUzFaDHXbkNlkoUJ2de5rayVmRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776849602; c=relaxed/simple;
	bh=DpOEJWEbgy2EUIdAGmq2P4VnzdGsa4AlW6mJFjN6PwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dzBenPZvoa5nLard1Eyep2XtEbzl2/gzLblJv8G113VSr84Nthny73V9RoWjVrtV5q0xlbrqIS61nEKvugll52Mz9pl7Zcz2G2kScRGHAGPIaFE0oj/AJy98L/9jJH68Fm9dGF6ZHacfYu0Q+plkMWlp5FzsI4yk+Y+GGT6mSN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UuyrWoo/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UuyrWoo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7EDC19425;
	Wed, 22 Apr 2026 09:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776849602;
	bh=DpOEJWEbgy2EUIdAGmq2P4VnzdGsa4AlW6mJFjN6PwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UuyrWoo/xf5nGazq35hR0q2RXtNpo6PANgA5dj5aWydhM6d4MmJNPyu0pUxwQbwgT
	 +5ghBBHRsFi4BEGsP0unkz75GUvQQl7VVh4rsxyLO+9uu5J9+AkoX07iAWXyRu0vGw
	 7zrU/imsnECPWBVYwYOM7vf4xXvQxduqIGOdPDPM2BcYUb6mA4PkQmJyRni8LWNaJF
	 ApkZaCEQaauIQaxFdfDLF3zx4OhX+SDgN8fplrR2xs5bVBYc0EwmagTVSThAkS3ypr
	 K7ty1GBMArtRgQROxzYgMHbhsvMHInLf+OCq5Hjg+Y/qYSAPlFuzX58VOcka23aD6q
	 zfKZLUg1Qw/uQ==
Date: Wed, 22 Apr 2026 11:19:59 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, 
	Stephan Gerhold <stephan@gerhold.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Jeff Johnson <jjohnson@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, 
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Sylwester Nawrocki <s.nawrocki@samsung.com>, Mark Brown <broonie@kernel.org>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Yang Xiwen <forbidden405@outlook.com>, Alex Elder <elder@kernel.org>, 
	Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>, Sibi Sankar <sibi.sankar@oss.qualcomm.com>, 
	Rao Mandadapu <quic_srivasam@quicinc.com>, Patrice Chotard <patrice.chotard@foss.st.com>, 
	Xu Yang <xu.yang_2@nxp.com>, Peng Fan <peng.fan@nxp.com>, 
	Thomas Zimmermann <tzimmermann@suse.de>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, ath11k@lists.infradead.org, 
	linux-pci@vger.kernel.org, linux-remoteproc@vger.kernel.org, linux-sound@vger.kernel.org, 
	linux-spi@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix phandle-array constraints, again
Message-ID: <20260422-proud-quartz-mastodon-fafb9e@quoll>
References: <20260421195836.1547469-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260421195836.1547469-1-robh@kernel.org>

On Tue, Apr 21, 2026 at 02:55:25PM -0500, Rob Herring (Arm) wrote:
> The unfortunately named 'phandle-array' property type is really a matrix
> with phandle and fixed arg cells entries. A matrix property should have 2
> levels of items constraints.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
> Can someone from QCom provide some descriptions for 'qcom,smem-states'
> properties.

Working on it...

Best regards,
Krzysztof

