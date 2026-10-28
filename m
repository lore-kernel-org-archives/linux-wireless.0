Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212244;
	b=yRAU5rQb6ky/TFrTcDGHQPx+O7GnhtnO9ZTEXCaSOIf3SYIT79LbS/AY90bxEtuCdyxe
	 BS4GIj6iDpCpkjNnsj9yu8lrVyL4wWkhnuCSu+i7dacv09BjVu6d9lwCnLe+gAsyOdEsf
	 MTvNpQHTGLyDGWF7nfp13JjX2gxxCgDQNW6jxnWhSqUDIahjyiYhiHI+gESl0aCwJT0os
	 nGvreHfc7RD1FtjDzO79nRzT65YFCrnRoV+mrElBBtDTnj5n7Br+MPNipMwdMd4MAyErS
	 eUOAPp/zB+1vusBhSui2HQa4cA0T2r1sW6t3BLBJfKmSQR8dLuuPM8HUTdcFxZmm96Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212244;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=Hitj4QOFcCibSfE+C1n0STRxOoEX+U2w2oL8QRXacMw=;
	b=EYiDBioVsnrYsVW444sdYnIPtPS7D5wfqkHeGg7pe8OsEvZMvnp+IMZ/c6g3CxkwAh1R
	 qtCxN0MmQg/eCwiptVG2xvO8z625O/6Rs08OTteK1sWUOW0YrWJPZLBcC7oaVOOD85Jgv
	 v7donSSpu5DCb87PPbyHVMuONB9HPa0UQ8QRLW1He0mdVL18o0RWD4jsb2VzgZlgNmf2J
	 JflTgA+9P0yxEshrViw5eocSFpNQZTvgq8JCBlTB5G6yEid5DlLn3B3YeG0z3UfATpZDm
	 A0cbTsIQmZ8d+HQ0KJXAvBDT+UdrMquGL+V01QjqarCKeRM0l2G5i7RhGH2+uNFo4xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="UyUllI/O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC91C606A31E;
	Wed, 28 Oct 2026 18:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UyUllI/O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44491F01828;
	Wed, 28 Oct 2026 18:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793212243;
	bh=Hitj4QOFcCibSfE+C1n0STRxOoEX+U2w2oL8QRXacMw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UyUllI/Oq03ut5VAP5DhBp53dKT8ftyCH+6Vcrj+r1MUV89cf1VFLrPXtfndw4QfI
	 mvzb2hn49rwcbAUxq9FOuzDRKo8sVqUibIjXCZC7lBrjD4+HE8fAMVzu0yvyzuBE61
	 /WgMLtWIbwIcz+Y+bIuWXa5po9FaJgQ9Tni52STA+Hv+BzDQvtv0l+PEoVmvB5LcLC
	 xbRsXmm7K1yUmX0Iy5qt17qm33pN1+FwVyboLJH41efeirdNZnuEeAj9hLcBF1sWrO
	 yhhYNdNIHvSQLbygJkmhqvSLWXDMkwE5JWDEjRprFvhJXMa7D8nChgM2XbDWOkHo0E
	 qhxzJ7TWMMXiw==
Message-ID: <7708550c-2cd0-45ba-bfa0-e674b3ec7d38@kernel.org>
Date: Wed, 28 Oct 2026 11:30:41 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] dt-bindings: net: wireless: qcom,ath11k-pci: add
 QCN9074
To: Andrei-Alexandru Bleortu <me@andrei-z.com>,
 Abel Vesa <abelvesa@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
 Johannes Berg <johannes@sipsolutions.net>,
 Konrad Dybcio <konradybcio@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh@kernel.org>
Cc: ath11k@lists.infradead.org, devicetree@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-wireless@vger.kernel.org
References: <cover.1792761470.git.me@andrei-z.com>
 <b12f9b35def027947e5a4b6328c68d1a70d3c97e.1792761470.git.me@andrei-z.com>
From: Jeff Johnson <jjohnson@kernel.org>
Content-Language: en-US
In-Reply-To: <b12f9b35def027947e5a4b6328c68d1a70d3c97e.1792761470.git.me@andrei-z.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/23/2026 6:36 AM, Andrei-Alexandru Bleortu wrote:
> QCN9074 is a PCIe 802.11ax radio that boards such as the IPQ5018-based
> Ubiquiti UniFi U6 Enterprise solder down, two of them on different
> bands. Like the other ath11k PCIe devices, each needs
> qcom,calibration-variant to select its board data. Document its PCI ID.
> 
> No supplies are added: on these boards the radio's rails are fixed and
> not under software control.
> 
> Assisted-by: LLM
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
> ---

Bjorn, please take with 2/4 through your tree.
Acked-by: Jeff Johnson <jjohnson@kernel.org>


>  .../devicetree/bindings/net/wireless/qcom,ath11k-pci.yaml        | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k-pci.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k-pci.yaml
> index 0162e36579..605ac5e01e 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k-pci.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k-pci.yaml
> @@ -18,6 +18,7 @@ properties:
>      enum:
>        - pci17cb,1101  # QCA6390
>        - pci17cb,1103  # WCN6855
> +      - pci17cb,1104  # QCN9074
>  
>    reg:
>      maxItems: 1

