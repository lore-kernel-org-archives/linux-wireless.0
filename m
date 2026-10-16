Received: from 4do.net (4do.net [51.68.154.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE081FE451;
	Fri, 16 Oct 2026 06:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.68.154.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792133170; cv=none; b=XkuI0cCDz/nkrdiGsg7uzbuSSHte6kiwk5Rz804MCoW1yjTDyW0RDul2h1QZ2BroUaZm7gnXXOMwkhwARmY6NeQDplRuXv5L9QaC+A1StfCYIbWdcQzwJXh6M7faZGdkLpjq8k1c44YPW+qqZUmv7+odm+TIhlzrZzv/pFkAhbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792133170; c=relaxed/simple;
	bh=TgDyxgu8IDR41V90BIj5qe9X5y5frV/UovMkQLzWCYY=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=AtmGP9QGUel17skJNCQa067+tUv1Q8zocWsVdJAi4vndu8xRwB5xjzfXb+DlZawiRGebXssXB1XdOS9j0CrUEWFmueIj2ghD6q9nmb9BqDZf/oN7Ka4Z+Bju0FZv4Neh0s/u7+xU27IS4yY6uWDfL1Z3AOVkA8PmDpYR71CGFEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fromdisposition.org; spf=pass smtp.mailfrom=fromdisposition.org; arc=none smtp.client-ip=51.68.154.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fromdisposition.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromdisposition.org
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 16 Oct 2026 06:39:31 +0000
From: Demeter Barna <me@fromdisposition.org>
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>, Lorenzo Pieralisi
 <lpieralisi@kernel.org>, =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?=
 <kwilczynski@kernel.org>, Rob Herring <robh@kernel.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, Qiang
 Yu <qiang.yu@oss.qualcomm.com>, Jeff Johnson <jjohnson@kernel.org>, Liam
 Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Bartosz
 Golaszewski <brgl@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, Luiz
 Augusto von Dentz <luiz.dentz@gmail.com>, Balakrishna Godavarthi
 <quic_bgodavar@quicinc.com>, Rocky Liao <quic_rjliao@quicinc.com>, Bjorn
 Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>,
 linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org, devicetree@vger.kernel.org, Bartosz Golaszewski
 <brgl@bgdev.pl>, linux-bluetooth@vger.kernel.org, Bartosz Golaszewski
 <bartosz.golaszewski@oss.qualcomm.com>
Subject: Re: [PATCH v2 2/7] wifi: ath11k: enable support for WCN6851
In-Reply-To: <fiuuh6rwohtlmwdiy7cwqee62e7jrtdgii7fklfy7jkgh25yul@mzlefhqgzo55>
References: <20260608-sm8350-wifi-v2-0-efb68f1ff04c@oss.qualcomm.com>
 <20260608-sm8350-wifi-v2-2-efb68f1ff04c@oss.qualcomm.com>
 <fiuuh6rwohtlmwdiy7cwqee62e7jrtdgii7fklfy7jkgh25yul@mzlefhqgzo55>
Message-ID: <850ada71460dc62152218e42e78079c6@fromdisposition.org>
X-Sender: me@fromdisposition.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2026-06-11 20:05, Dmitry Baryshkov wrote:
> This crashes with the firmware that came with the board,
> WLAN.HSP.1.1.c3-00200-QCAHSPSWPL_V1_V2_SILICONZ. I will revert to 3
> vdevs for v3.

Same here with a newer firmware, WLAN.HSP.1.1-02922 (2021-11-04),
on a Razer Edge 5G (SM8350, WCN6855 hw1.1; next-20261012 plus a
board DTS that is not upstream yet). With 4 vdevs the firmware
crashes (MHI_CB_EE_RDDM, no WMI ready event). With 2 + 1, as in
v1, Wi-Fi works.

Happy to test v3.
