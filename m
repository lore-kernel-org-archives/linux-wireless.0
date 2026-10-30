Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793372042;
	b=MKXSRZJKUle7LXaIba2P8IxsKAR4HiWyGkn3BX1AiSjIJPwByexdBiX9+875dKub178r
	 3hnL+C7gI0+BXBhkPYc3WlvrI9+40yQ81Jd8N2IjlV4tlKOlptWhoeu28UTnUTbb77Jpm
	 HzzWZz4ZTztMhFytPa074v9fYPDUSJHFKhR9d0byETUt/mwjoRvQZLMj1yjiQIW5tanJC
	 QOkS7s1gq+yqyPZ/OQcKUPiqK+Jd8JuvIOHRvR84pZuTZq1rrvQWQSA8YlBfY5fKfMR59
	 9IiuLp8ATE2lfDsqBY3rhidIuZFI1pe8ysR+mmOcQU6qrJkBwdX+l4SE7yDXqasGz9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793372042;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Jau+PZuEPRdnI6rZvYHlpRwrBnMws6uBKUU9f9SsPHc=;
	b=a7CZYv2jGjx8kyZUlDAq3HDD1Vtpxla/XRnkRsT5raZoPSSnPww7EPwF7pHE/Wy2h1iN
	 EFsqwozkjB0fY2TRcwb6JmlqeKrauKfa2lCJvVu2PET2i1c9desPUOZm0rrAp75+eXGBW
	 FqsEmK1A/4W5mjzJhwoG6LYojLABSptIMlM3uZimVT/A2sk0WHQru/kf4zzzKBW/mvPxX
	 5XXCE4tZRy1lNHWpNIVLE1ul7Z+WdSZErAxrqARUxqiBk36SYWNMXKeDedxmDuttT+p3J
	 Pw3ft24OerHANV1Xk+q22jx0PaBXbZURxbYzoRI9eg7ZwNOs9eeNjan0Is7Ec/vxLIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BLpYs2cb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF10606A325;
	Fri, 30 Oct 2026 14:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BLpYs2cb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D3D1F00A18;
	Fri, 30 Oct 2026 14:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793372042;
	bh=Jau+PZuEPRdnI6rZvYHlpRwrBnMws6uBKUU9f9SsPHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BLpYs2cbXAHOdyOfNBb1ztSow/pDm1JHqoEBGyS08uofb79chz6YmYz0s5/b6fK8H
	 m0YYKS7nZZsXbYJ4Qu1fb/J0YJhOAMQFXvGArlTF0C1F8rxE9ohgAck2pbYjk1gHTo
	 76SC4wCY8ZRFsAa17Ekn7+IzQ4HgOcXJUcDWiJ6TRn95oBHQa0C3pyL9uVcBzSwZWA
	 rrPOvyJmdUoFAIX4havbXGS0QaNIxAJOMOliJ7wqCh68m4piundA2PJXEmGhnR+H0w
	 OzCyOHwoRg13NWv99jjUVYvJntQgd3nHDGTOrOQRByQUav3SQtX4TVqiJ7QKsITfCZ
	 71Ga/cKCxWnAw==
Date: Fri, 30 Oct 2026 09:53:58 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Ernest Van Hoecke <ernestvanhoecke@gmail.com>
Cc: linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
	Conor Dooley <conor+dt@kernel.org>, linux-wireless@vger.kernel.org,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Andrew LaMarche <andrewjlamarche@gmail.com>,
	devicetree@vger.kernel.org,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Jeff Johnson <jjohnson@kernel.org>,
	Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
Subject: Re: [PATCH v2] dt-bindings: wireless: ath12k: allow calibration
 variant for WCN7850
Message-ID: <179337193753.3936464.10436179036151297295.robh@kernel.org>
References: <20260907-ath12k-calibration-variant-v2-1-1a9d6c47dade@toradex.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907-ath12k-calibration-variant-v2-1-1a9d6c47dade@toradex.com>


On Mon, 07 Sep 2026 16:17:20 +0200, Ernest Van Hoecke wrote:
> From: Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
> 
> qcom,calibration-variant is the generic Qualcomm Wi-Fi DT property for
> selecting board-specific calibration data when the device identity alone
> is ambiguous.
> 
> Commit 06cca100ad08 ("wifi: ath12k: support calibration-variant from
> device tree") implemented support for this property in the ath12k
> driver.
> 
> WCN7850 can be used in systems where the PCI device ID and machine
> compatible are identical across product variants, or across regions with
> different regulations. For regulatory changes, the hardware description
> does not change, but the vendor-provided calibration data can differ. In
> that case neither the PCI identity nor the machine compatible can
> identify the required data, so DT needs an explicit calibration variant.
> 
> The ath10k, ath11k and ath12k WSI bindings already allow this generic
> property for the same class of board-data selection. Allow it for
> WCN7850 PCIe devices as well.
> 
> Signed-off-by: Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
> ---
> Changes in v2:
> - Rebased
> - Updated commit message
> - Link to v1: https://lore.kernel.org/r/20260701-ath12k-calibration-variant-v1-1-d3eddaabf026@toradex.com
> ---
>  Documentation/devicetree/bindings/net/wireless/qcom,ath12k.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

Sorry, not sure why this wasn't showing up for me. You may want to 
resend it in case it is not in wireless queue.

Rob
