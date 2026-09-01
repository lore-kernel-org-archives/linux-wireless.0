Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7BD39B975;
	Tue,  1 Sep 2026 07:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788248675; cv=none; b=pYws5u/d2aIgsFj4mINZrbUeoAIDUus9sT1148WXTc8zb5E7WvzX5MVr1D+TeChCjRr7X2bMYJs1kbS7sb17keOps+s5RuswsRqRI9upF6jrTzASUFtM0PjGgNJjBbm5C2iD3zsSYm4w3lH4pOtgJRxVHKdRkJ12/9juro1WvCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788248675; c=relaxed/simple;
	bh=e8VOHgSsxFzI9fgVjJwsg/clc2wKMctz3f2z3JN5Www=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tU7Qw+lEz1WAz/DJ/Ltp3EwFhtabPEd7EAyg6UNNJDCLRz7yzzwpHzYJmA5PdOcye+z6nL4aqjZzTyIqNIBpq0lZwptVd2Fno9PZfdwoAsaImKQT70KpiwiyffQghUxrnq40Ma+AVIY4JusrInJXUY/N/QtP3p3MTHdPuwsi1hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RWtHfyjj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RWtHfyjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA251F000E9;
	Tue,  1 Sep 2026 07:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788248674;
	bh=PMuwU4uDb7rEj6/4JiiTKDPJ13YLZj7n0SxKldQGwJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RWtHfyjjVOYK+ltbUdjcxvqx66SMK8QaTv02Krtz/G+/g3novQpAJgHJ7LZ5rJIxr
	 U7/OWl7XtSv2d6fazO+wgH8UOcJxvZVufzxYOip8bv7gQ1t7ZRQQsBLhYZW/aLMhY1
	 xQzqL12pRxaUozutOeyitjihac27TrgAhsRe3mcrWAnUvDuLDbhGMFTrFXcuEaiqzM
	 fyUCkDXtxA5JvUZrLlKnBA4UjxLj7nE3tkBq+cZqVHDKonvYdQRXx1OUeh6Al+OpD2
	 ojFlhDmrDBkVgTXL2anNj23x6c5oKdcW5sb3Qi6BXmCTXpaesB9e+gWqlHFspFlJlo
	 HUoYiAHZvGP0Q==
Date: Tue, 1 Sep 2026 09:44:20 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, 
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>, Jingoo Han <jingoohan1@gmail.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Rob Herring <robh@kernel.org>, 
	Jeff Johnson <jjohnson@kernel.org>, Bartosz Golaszewski <brgl@bgdev.pl>, 
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, mhi@lists.linux.dev, linux-wireless@vger.kernel.org, 
	ath11k@lists.infradead.org, qiang.yu@oss.qualcomm.com
Subject: Re: [PATCH v5 2/6] PCI: Export pci_set_target_speed()
Message-ID: <hm23ew6au75saw6dtm5rdkf3k4x3sgpf4gnudqmms23rlppuhn@l3pmu3qh4q4s>
References: <20260819-bwscale-v5-0-6dea79786b37@oss.qualcomm.com>
 <20260819-bwscale-v5-2-6dea79786b37@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260819-bwscale-v5-2-6dea79786b37@oss.qualcomm.com>

On Wed, Aug 19, 2026 at 06:55:53PM +0530, Krishna Chaitanya Chundru wrote:
> Export pci_set_target_speed() so that other kernel drivers can use it
> to change the PCIe data rate.
> 
> Signed-off-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>

Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

- Mani

-- 
மணிவண்ணன் சதாசிவம்
