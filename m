Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5145F2D063E;
	Wed, 10 Jun 2026 07:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781077292; cv=none; b=pjAiy97C7xLxI5hP0S7/El/I00y0xo29cEQ+RoJ0cFkmKYDiB1Q4UkIwFpateyrGR+5VhNmAqdu5laMxG48Oj5986tRalOINoJRlBvwWGCFzyppjGFHZeSLBCAm2/tWym4ZrKW465OO7EDPY5bW8Udn48S8NUeSH55ryGb/sZEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781077292; c=relaxed/simple;
	bh=NtOTToasxCE2jc40iWisPgV2xK93NZ0NraMiA5sg/Rk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SzIHchE3mvZvr8Z6Uj7X8y49/Unma8/VStQ8irooWY75vOfewj+S+pPz2hRGpCG07+CHUZ4cUKBp3AyOZOJ7PBBSd62Ux7rCaO8HC3YP5cXGYUtib3MKDRjNIwwxCrwswAWVNkn5osxYDu+StYHlhTeWlSWOI/JFXtbeSqbI1kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N3yauVZS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N3yauVZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBC11F00893;
	Wed, 10 Jun 2026 07:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781077291;
	bh=EgV/NjGFw2TBnGNu1grd25blD1KwYsPIRIqEutCfpzc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N3yauVZSBrf47qf05zumLqq/Yg56bWYcjmWs3qicj1JFe4cQx7KkFLZPodz/lycsr
	 aaihNpg+Vq43zVq9abn/EkBkSOeY3BhN+4R/JyLPYnTCAXRRSrzc7GlCb/bmOA7IfK
	 qyzerJOFwCiszfXk4wEbGDQSN6abHyem5iag0vy1PPECpR8Ca5aZeoiP456d50WmXn
	 2tTdFGkVLD/lFEZKqu5b28jYpNGpKdzy35aB1qQxAn8OsOtI0jOBUK938yHgyoFvvT
	 VacH128cjlgDJz6a765Ae/xyrfrmsCtj2rJ11InHyeZCjsQ3XJbdv50WWFjoGujyv6
	 mxUHxrjjhwdvw==
Date: Wed, 10 Jun 2026 09:41:27 +0200
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
	Bartosz Golaszewski <brgl@bgdev.pl>, linux-bluetooth@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: Re: [PATCH v2 4/7] dt-bindings: bluetooth: qcom,wcn6855-bt: document
 WCN6851
Message-ID: <20260610-lush-mellow-dragon-3ed9fd@quoll>
References: <20260608-sm8350-wifi-v2-0-efb68f1ff04c@oss.qualcomm.com>
 <20260608-sm8350-wifi-v2-4-efb68f1ff04c@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260608-sm8350-wifi-v2-4-efb68f1ff04c@oss.qualcomm.com>

On Mon, Jun 08, 2026 at 09:59:22AM +0300, Dmitry Baryshkov wrote:
> WCN6851 is an earlier version of WCN6855 WiFi/BT chip, compatible with
> it. Add a device-specific compat string with the fallback to WCN6855
> one.
> 
> Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> ---
>  .../devicetree/bindings/net/bluetooth/qcom,wcn6855-bt.yaml        | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

