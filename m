Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CBB3B14AC;
	Mon,  8 Jun 2026 10:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780913039; cv=none; b=I5aop/Fh/KQgNte06otuoASIMh2bfK9zYG/CJZ6dqLt2B5MLaicJCE/ubWSBE9BZdKtQmhULBV1Fm1u5jv4ReA+3EJe0w9ltbCH41veXtHTsEJ992kQa056jGovZJtq3A8cCAjAYgr3QNv9ndC1LGMrROZtbMG8b442t0G5RRYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780913039; c=relaxed/simple;
	bh=HlxrOBOCO31Lt3lEbkQvcyDeJ8raUyhSC7+FYG/OGSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A3w5Nh1Nqat6eqbUhPF0B/g3yCjuaL7G4mJnNFlvkZVsIlhWNCCdV58HsALP2119ddM+LqRoSM/0alnO2cK+EwXwx9jIjEGIenyzYEM5cyiUwT7dQGqOB90iDfXyr6I1WCgWpQzaQyCC4nZouNJ4G0q5ZGfgrmmH0Hl0gX+8ggk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lLs6Jzro; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lLs6Jzro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E513A1F00893;
	Mon,  8 Jun 2026 10:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780913037;
	bh=syxAqA1GpHDDzXsNOy0fUEopeINEejRQ7IctKWUkbK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lLs6JzroULacjuDhh+j6BEMxqMvGaSNLLlS+EgKPDn66NrtTLIALRjC352qlREBul
	 M1PeJ/dB297qBslVWaiGKQqja5XXBx7eFCirUyVAe9Ojr8h/I9M/Aw+FMhLY+obZ8H
	 BCqzoWaknh+0GUQymm0YpROl3LGKuCNcn2oHPenLtjJFn7xoWmo7WfV1koaxk4Gvj1
	 n2XlO766dQbpPY+o4sjL7p+1ygWh0laT8GrBGqbgud8s1menxONvPvxBK/1eIbvtoH
	 SNlEbDJC4IYngpX3N+28ZOem+yfTehhzNxKsuOhBt4ztZx21D2HJcpabdIFIsdsxoX
	 uS6Ednx0sKAQg==
Date: Mon, 8 Jun 2026 12:03:54 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Rob Herring <robh@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, Qiang Yu <qiang.yu@oss.qualcomm.com>, 
	Jeff Johnson <jjohnson@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, 
	Mark Brown <broonie@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	Marcel Holtmann <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Balakrishna Godavarthi <quic_bgodavar@quicinc.com>, Rocky Liao <quic_rjliao@quicinc.com>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, devicetree@vger.kernel.org, 
	Bartosz Golaszewski <brgl@bgdev.pl>, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 3/7] regulator: dt-bindings: qcom,qca6390-pmu: document
 WCN6851
Message-ID: <20260608-grateful-armadillo-of-potency-d8aad0@quoll>
References: <20260601-sm8350-wifi-v1-0-242917d88031@oss.qualcomm.com>
 <20260601-sm8350-wifi-v1-3-242917d88031@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260601-sm8350-wifi-v1-3-242917d88031@oss.qualcomm.com>

On Mon, Jun 01, 2026 at 12:46:51PM +0300, Dmitry Baryshkov wrote:
> WCN6851 is an earlier version of WCN6855 WiFi/BT chip, compatible with
> it. Add a device-specific compat string with the fallback to WCN6855
> one.
> 
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/regulator/qcom,qca6390-pmu.yaml | 4 ++++
>  1 file changed, 4 insertions(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

