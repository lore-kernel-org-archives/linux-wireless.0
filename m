Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DBD46C859;
	Tue,  1 Sep 2026 08:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250130; cv=none; b=DHpDRpMOGurDYw7FpFBr8V1FmmX66m8HMFAFsxwrw4iZ0JabxnuMF1nLE3Tw7FEj/4N3JAWDWtOw0+JrUZJrhfLKBqpU0dm6O9IsgUWtV9d8ojTyYad1XwEXUuEYqAPCR41V+nAoS3FXNqKeWyrMK3C6ACAZacnsClp2DpzAJ5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250130; c=relaxed/simple;
	bh=xZixmp/hIu40rQ5K9LjhmakmQkvMqsCx6HmvxiWv9zg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=engrsfCHRkVvDLUDXkfm1WGAroZfyZLfCanv5AV++HRnXEWU1rLXpwyl2NQmhINtqJcu60t4vphnM+ZrheUYcJLUYuzv5yoV2xERcrvWbDeKkwI9D3vl2E6P7EqcPPjget3jRcGfunLVk54/kBcRdXEgKUc9OPn3bScVbVPg9tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kWklQy1L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kWklQy1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7583B1F000E9;
	Tue,  1 Sep 2026 08:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788250129;
	bh=Ohpib62LZWXUeibRpn+IOxerCltjttaZcpi6tQkXmGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kWklQy1LpvHETxUBsg/vGzo+L3C+obYX0PKYmcM6G/9yl6jaG5VV+LLJXQtxrfib6
	 3qo5Eb6fv814iG/12mc3ZXrQGC+L9R87cv04xtLVl0cyW2TEiuZhJy0Q8WaYdx7j1Y
	 IORN/J7Y4IBQJMXpHQEu7bkB4Zj5U9wQmcaRpObCVf+T3sDJ4XzFPjIEAMf+/VnMAi
	 g5lVVDxqzbFFrzaj5+no73rD0uuj97wxAWeeCz3HUikiMI1udf9JxTMwmoH6+hBzY5
	 dE0SttwOhDpDa+U/nhL8KXAs8XsL3ZZbsCXcRdMBgHnPPtjobZYjtaqz06ZU7DJ7Kd
	 LoCDJjOj7kbSQ==
Date: Tue, 1 Sep 2026 10:08:30 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, 
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>, Jingoo Han <jingoohan1@gmail.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Rob Herring <robh@kernel.org>, 
	Jeff Johnson <jjohnson@kernel.org>, Bartosz Golaszewski <brgl@bgdev.pl>, 
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, mhi@lists.linux.dev, linux-wireless@vger.kernel.org, 
	ath11k@lists.infradead.org, qiang.yu@oss.qualcomm.com, 
	Krishna Chaitanya Chundru <krishnac@codeaurora.org>
Subject: Re: [PATCH v5 6/6] PCI: qcom: Enable ASPM disabling during link
 retraining
Message-ID: <jdch2j3vcjsr2f4u7jhiazuotwqu6pon4xlvhzuhrzpzjhmkkb@7zzy2autzbmo>
References: <20260819-bwscale-v5-0-6dea79786b37@oss.qualcomm.com>
 <20260819-bwscale-v5-6-6dea79786b37@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260819-bwscale-v5-6-6dea79786b37@oss.qualcomm.com>

On Wed, Aug 19, 2026 at 06:55:57PM +0530, Krishna Chaitanya Chundru wrote:
> Set the disable_aspm_for_retrain flag in qcom_pcie_host_init() to ensure
> ASPM is disabled during link retraining operations. This prevents potential
> issues with link state transitions during bandwidth scaling on Qualcomm
> PCIe controllers.
> 

Is it really a controller requirement or a device quirk?

> Signed-off-by: Krishna Chaitanya Chundru <krishnac@codeaurora.org>

You need to use OSS email.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
