Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D8B1419A4;
	Mon,  8 Jun 2026 10:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780913162; cv=none; b=qbeAKAdMogJkRIr8lnCbNETxq4ev2inJlG7KIR6ic11k40YKkuWfPYy0WF3sfaPi7TRL1/NZgStFKv3zTtGoyW7eUg9xCqgtrnefSMTzKzVvRNc4QSo1OkohKXn1TmGnFXpKXyHByMltISUgZufOTUHqp2JLK/5IQHKkTYo7FFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780913162; c=relaxed/simple;
	bh=DtUctrJnalFiNpO6pNf5UJhrtB12L1KZ3pnTMR9p/4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sxlblmR+dDfcF8BZtNLlyOXPVZ8ODWmN/SpOywkEyQ+SdbnmAzBhonkytqlZu3rQZkX1mfdQWnqVolXWaPn0136eVinEjw+InQW7dJ+/c7mRA7vSCPLJDG1dwUUejaogTX3YjLqpN8+RZxzMl+wtpvVc4Nk1k7oKaIbaG6iWnj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WjZA/1yF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WjZA/1yF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF5B1F00893;
	Mon,  8 Jun 2026 10:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780913161;
	bh=987+ZkDZJxNuFnm2MmcF2sfXZO6A3YzQGr1a0DWPqhE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WjZA/1yFpnWI5gu9okoF7ljichwl5GJx8v58SXaOA7svy6lfCG4P+BQyc1MDtzJkv
	 E9Tx9VzimZsN9NlMBWTlom0SDBhUDUJXYSg9neGYr3JKD8mVgoyDoNEWzdopRBXFx0
	 oSW4UY6Lhio6akwHEolIh/fZrbztHA60ccRTGNgcGZkEEDhVoeUeChHT5vD+3qxlZ0
	 6vEI81rk4gDdcEwByiFM+ir2gyYcySsP4uacN1fY41UWHESE3T6EL4qhizsYuJvpho
	 viZko6JkuoqC/3YIrRws3h744SybNGcH0osiUH+AflKw72p9/kVham3jMI3Ox3ZNVa
	 vYK0Ly3Ch/dJA==
Date: Mon, 8 Jun 2026 12:05:58 +0200
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
Subject: Re: [PATCH 4/7] dt-bindings: bluetooth: qcom,wcn6855-bt: document
 WCN6851
Message-ID: <20260608-robust-ringtail-of-atheism-5f2ece@quoll>
References: <20260601-sm8350-wifi-v1-0-242917d88031@oss.qualcomm.com>
 <20260601-sm8350-wifi-v1-4-242917d88031@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260601-sm8350-wifi-v1-4-242917d88031@oss.qualcomm.com>

On Mon, Jun 01, 2026 at 12:46:52PM +0300, Dmitry Baryshkov wrote:
> WCN6851 is an earlier version of WCN6855 WiFi/BT chip, compatible with
> it. Add a device-specific compat string with the fallback to WCN6855
> one.
> 
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> ---
>  .../devicetree/bindings/net/bluetooth/qcom,wcn6855-bt.yaml        | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

