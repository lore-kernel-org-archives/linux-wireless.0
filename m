Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793001375;
	b=HkznKSqTDWP9qTN84MELE8CeDHJKZYVb8Bvs04+R/SHtdPMV3R1Pl7tvXn+/zlC+OkYg
	 GUCCTTZ3iVVDg1JBVm8oPY/a2jGF6cOOHGUDbRc8WIBI9LXcx1YmoHt/+7EeBjMD5fM9I
	 jopxtdXqOdtSGvpWNds3AzZuFrNuorzeZq385mj8/XCHczTzy6luH9kqNw8kBfRArygMw
	 XqONaOLq9e+q+sqSFD/MaHFjzHn4XpKjb8U4yNJjXRDop+rHm+CZEwP2/Qo/uNHwGG64b
	 mkQCOoNw9Rjr/yjbcZOG5HLJ7v8vNpXJfFHnB636qKuP3pW4ddH0GJEfmUx+w55PECw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793001375;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=u3tZOGX5uvrdqoC7dUccuRlWsX5EhE7NoULiLf5ru0A=;
	b=vozBjswFdxahyOsBeMDGu+nH5GoIF0C7gFnOE46QEMTqq1evxVnNVxbLXAeO6hhV/uFm
	 oxOAlUzA7g+knlJBDmHV+PCAgszm+gayw79cAyAXZeo6pY+aPdxzneQ0b46Ze7fUb2s5V
	 GBKOh/3Hlc/NkZfFMf9J6AbcZz5xQMZjqFTNxLP6ZvaVMRESrPuZTE8JpfHeyPdq3CxHc
	 3gi9Rn/8/R1HfIvmPLXjzo8KS+UXLZTUtyxbmyD1Jky47ElOgZoMGVmF/Q3IY9axPemyU
	 4lZvuxA9n21j+davTrXQLbmZW/hC6lyTzYkYuB4L9sAuZ+e5fetk5yFi9z0irugA9hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VQUVWDd5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C012606A31A;
	Mon, 26 Oct 2026 07:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VQUVWDd5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AC01F01825;
	Mon, 26 Oct 2026 07:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793001375;
	bh=u3tZOGX5uvrdqoC7dUccuRlWsX5EhE7NoULiLf5ru0A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VQUVWDd59s5jjtL5p8mDbx1VUrYzprC/+uUjUstAhihGr55nocJ5j/zXgNlkf5gph
	 fw5jWPzzIzUsf4qwQ/NCVugz0wVGoIo54jtUlItn7D2Nf2KyDHYPbNBAFf4tbzNhiG
	 Fs5SUL69wN6PzRJIbtFyEgcSga75LrJvbF1K14PMVwHY85jW6LBigo1K5myaxp9afw
	 3hg1GI5fLeit4iBdO9OtWLSwagdq4dCb3463OFu3B7jDVfpoKSSPdokIQxqKq+CsWD
	 AwtGJKyj/5IJpr/qvOJ9BMXRK8Vrjn11/igaQildOkLc9w5pYOJFr2HVqFCE9twhdG
	 axU1I2Ngn0G/w==
Date: Mon, 26 Oct 2026 08:56:11 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, 
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ath12k@lists.infradead.org
Subject: Re: [PATCH ath-next v3 01/17] dt-bindings: net: wireless: Add QCN6432
Message-ID: <20261026-sticky-bumblebee-of-beauty-2e5ff9@quoll>
References: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
 <20261023-mpp-bringup-v3-1-19f3fcbf7b5f@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261023-mpp-bringup-v3-1-19f3fcbf7b5f@oss.qualcomm.com>

On Fri, Oct 23, 2026 at 12:31:04PM +0530, Aaradhana Sahu wrote:
> Add Devicetree binding documentation for the Qualcomm QCN6432 IEEE 802.11be
> wireless device.
> 
> QCN6432 is attached to the WCSS Q6 subsystem and is represented as an AHB
> platform device, even though the Wi-Fi hardware interfaces over PCIe.
> Document the compatible string and the resources, including the Q6 remote
> processor phandle, MSI interrupts, SMEM states and memory regions.
> 
> Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
> ---
>  .../bindings/net/wireless/qcom,qcn6432.yaml        | 149 +++++++++++++++++++++
>  1 file changed, 149 insertions(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

