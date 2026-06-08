Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273E7282F3C
	for <linux-wireless@vger.kernel.org>; Mon,  8 Jun 2026 14:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929044; cv=none; b=QEl17CseYz6S2XwLqT2lzFlQw3g8U3zp3O+48DY0l0rG+W8FtQpTWXKDz6OWc2lWXk3AFULotA58fcqK6a9kKyfk3hh3MW3CR2VQPGYs0dLDHLLvdEJT7ZsndwRvxGt4Hz3pEX27W+t2r/Er9q8I1eBsC0kiIJriVVnf0U93alg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929044; c=relaxed/simple;
	bh=DgevYk+trI9a01XYiR93DkcK4FlvyCsJcciplo5M4a4=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gXtSz7JEaItDsIiNbiQf1pV988naR5FQRvnt/0OmASbhD53Rx+pR2LxjjirtlGIWfK9H1PwZFyp6OidCA9+wo/msfGbJB9kgMJ5Ym19bk4JOKF1uJR6B6CeQAmJEAcpprflA+0oKNEpfduD5IVwTfTHzGq0ZdslNtFAk93Y+I0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yq6+gp7o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yq6+gp7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08321F0089A
	for <linux-wireless@vger.kernel.org>; Mon,  8 Jun 2026 14:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780929042;
	bh=DgevYk+trI9a01XYiR93DkcK4FlvyCsJcciplo5M4a4=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=Yq6+gp7o+t+YQI0mcfmczBWPQRT/vd6mpMnL5zm7lJV5zufTqvuUZFav2lmFFR1zr
	 vU2EVs2llYOb0dtHlYEy9NzYr8JNJOb9R1lU5oyaRfZwTC3rjT9WFZNADXH/tZMrle
	 rQWEi5ICOGsWewXIS0NwPziENp+foPhZM/T9FRSdghgNLaHkUvpi++XUTe79xgkI13
	 mJw1ghKOSb9H72lLnbQC9gNsmjTHJqMFItaCAHvhmMAdMrViPbYjMDv0qYB1s2n2AK
	 kjAgcHKa7c135LL3iv5tW2H8Cj5Lg7JHQ1PfB1H1fFtJmIM6y7uSF6hbjgUcRa/JXR
	 UDwXwOdmoqi8w==
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-137d464c47eso3243194c88.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2026 07:30:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8BZBEATQrRwg6q/e+jbeu0vxulyP2kPyj1bwXP6VXr8KU5ldNlXg5KJV4RD1UF9WEi1Aye633R5MiL5e80kg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh+jnwB2+Vt8XZcB3MnLpoSiAvI6/m6nQn0YycBkhPy6ZMnaO+
	2LSKdcZFXpy0riElOd3/MtbsWwxNfloBEFT3MHx7cA55Xuw1UPsQ3D/8iiZaLtH1r0Xsmyze9O+
	G79YsG5d8/Y9leG5bH6x9vNWNzoQeCPW4huZLKCZjhA==
X-Received: by 2002:a05:701a:c951:b0:12d:b8e5:5e2 with SMTP id
 a92af1059eb24-13807dbc1f2mr6212351c88.23.1780929042235; Mon, 08 Jun 2026
 07:30:42 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 8 Jun 2026 07:30:38 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 8 Jun 2026 07:30:38 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260608-sm8350-wifi-v2-1-efb68f1ff04c@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260608-sm8350-wifi-v2-0-efb68f1ff04c@oss.qualcomm.com> <20260608-sm8350-wifi-v2-1-efb68f1ff04c@oss.qualcomm.com>
Date: Mon, 8 Jun 2026 07:30:38 -0700
X-Gmail-Original-Message-ID: <CAMRc=MctdRxo4WFf6F9A1pFOeTq8us6brdSEzTZsNPFwqrSnNQ@mail.gmail.com>
X-Gm-Features: AVVi8CcaZhXYOpCv2x74C9QF-11-iy12puwZY5pM4Q7NOmmptdOTSpcIOV1fL7E
Message-ID: <CAMRc=MctdRxo4WFf6F9A1pFOeTq8us6brdSEzTZsNPFwqrSnNQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] PCI: qcom: fix parsing of PERST# in the legacy case
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>, Lorenzo Pieralisi <lpieralisi@kernel.org>, 
	=?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Rob Herring <robh@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, Qiang Yu <qiang.yu@oss.qualcomm.com>, 
	Jeff Johnson <jjohnson@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, 
	Mark Brown <broonie@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	Marcel Holtmann <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Balakrishna Godavarthi <quic_bgodavar@quicinc.com>, Rocky Liao <quic_rjliao@quicinc.com>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, 
	ath11k@lists.infradead.org, devicetree@vger.kernel.org, 
	Bartosz Golaszewski <brgl@bgdev.pl>, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 8 Jun 2026 08:59:19 +0200, Dmitry Baryshkov
<dmitry.baryshkov@oss.qualcomm.com> said:
> Commit deed8aec62dc ("PCI: qcom: Handle mixed PERST#/PHY DT
> configuration") fixed support for the "mixed" platforms which declare
> PERST# pin the RC node and the PHY in the RP node, however it also broke
> support for a majority of existing platforms, which declare both PERST#
> and PHY in the RC node, because now PERST# is first acquired in
> qcom_pcie_parse_ports(), which then returns -ENODEV (as there are no
> PHYs in the RP nodes). Later qcom_pcie_parse_legacy_binding() tries to
> acquire the PERST# GPIO again and fails with -EBUSY (as the GPIO has
> already been requested).
>
> Move parsing of RC's perst-gpios to qcom_pcie_probe(), making it obvious
> that it's shared for both cases and skip parsing it in both functions.
>
> Fixes: deed8aec62dc ("PCI: qcom: Handle mixed PERST#/PHY DT configuration")
> Closes: https://lore.kernel.org/r/gieaybsg2ckxpctvqj77nlwu7utama2yeyvebkonmexsxrra3v@v3fobqasxnmy/
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> ---

Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
