Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511AB351C28;
	Thu, 16 Jul 2026 19:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784230958; cv=none; b=s+Yrx1xfoPvPhUtPSV9sDc6ASosUZyLkyeuieClNN+S7osCeU6P7IIwa/2ZoMwOu1tq9W3Ot5rIUT2fxtah6h38zsrLRJG8ZZr+8/nRB6PxWyQ/lQ6kCwY8v0/I30aZGvJjkXqLQ68l3xxBcFh95ogV2KzuXNnsv3YK97vxvrVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784230958; c=relaxed/simple;
	bh=Ig+GsN0kMZ05cJ4o3ugakK8qv+geJHudqh6YgXHniOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aKup+n8BzicQaKIlFgg3eghOlxjzjXLP704KAC3zIHHdnr9g7Z3R2BrTEILNAml6SFeSwikkIaTi3mkZe9S8egMRzdTVQkjQ53XeCyWVBDpDAJa80UbbgLoJExeqBHsipr/bS0j1EIYWzFf5h3tnHqyhJxjIlEj+Cx64FQWirZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WHHnrgri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WHHnrgri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51D21F000E9;
	Thu, 16 Jul 2026 19:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784230956;
	bh=usR4FsGWwyujnpLuckLUoYL0cDU6hXmHk5b1uovpKno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WHHnrgriO+KrWCsVg+TwAvkOfNWs/YkXkGQ1U3xxZ9mhjMX3Lr0Grm7vAzXVHIJn9
	 ctA9QM3HGp2Ze1NRWtDy+wSs4UuXRVpkGjl53T2V9mNgDburjmXXR24tRt7uTBUPcZ
	 gvfyaboifn0XGp/WKn7chqa5qTHjN/l/ohrNaoCX8v1PPDHA27mbyj3jg0NA9n1W5r
	 V6FqBhqa44TF2LcNoN0AlORsEzAkH2F6DUDbbVsbisfdmubF9TrArc3v/RikOrhMsQ
	 c3OZAX2Pcba9r7LV5Ibx4dxMN7aD1XwfuHYJK2o3rEXm01PWu3oy44quzApuD+uemy
	 elvvQxD+O5t8g==
Date: Thu, 16 Jul 2026 14:42:36 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Bjorn Andersson <andersson@kernel.org>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>, daniel@makrotopia.org,
	linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	Conor Dooley <conor+dt@kernel.org>, netdev@vger.kernel.org,
	Balakrishna Godavarthi <quic_bgodavar@quicinc.com>,
	Simon Horman <horms@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Russell King <linux@armlinux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Jeff Johnson <jjohnson@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Saravana Kannan <saravanak@kernel.org>,
	linux-bluetooth@vger.kernel.org,
	Rocky Liao <quic_rjliao@quicinc.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>, devicetree@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	ath10k@lists.infradead.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v8 1/9] dt-bindings: mmc: Document fixed-layout NVMEM
 provider support
Message-ID: <178423095566.1177840.10999909737617285520.robh@kernel.org>
References: <20260703-block-as-nvmem-v8-0-98ae32bfc49a@oss.qualcomm.com>
 <20260703-block-as-nvmem-v8-1-98ae32bfc49a@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703-block-as-nvmem-v8-1-98ae32bfc49a@oss.qualcomm.com>


On Fri, 03 Jul 2026 15:45:14 +0200, Loic Poulain wrote:
> Allow an eMMC hardware partition node to describe an NVMEM layout so the
> partition can be exposed as an NVMEM provider. This lets a partition
> (e.g. an eMMC boot partition) store device-specific information such as a
> WiFi MAC address or a Bluetooth BD address and reference it through NVMEM
> cells.
> 
> Accept "fixed-layout" as the partition node compatible, in addition to
> "fixed-partitions", so the layout can be described directly on the
> partition node.
> 
> Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
> ---
>  .../devicetree/bindings/mmc/mmc-card.yaml          | 23 +++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

