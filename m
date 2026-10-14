Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB863A6EE6;
	Wed, 14 Oct 2026 02:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791946373; cv=none; b=RZQ5UdOcSGbIySI2kG3Vh25Lt784bMmjHMJA8rH4Fw3xkdmWqtorWDkqsOAzlR80yjww+qRJqS3Ih/h619vR1dmPqC3mWWK5GR+/6UZ0hMNx02UwZ8l9XHVx/90qcEMEQxQOTkzH7KJLez19DkGXlb0q6RJAKD98BL6K3FEYiyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791946373; c=relaxed/simple;
	bh=Rsk9iYPk8yZ9Q3MyrwHccU/MgYVIT/oBogzsblRor8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5+Hi8WxUgrExC1kCc9lfZPueRvfQbW4osQeoq8jzw1ztevWyD3tfL7pei5LsRI/Tr9Qp1k/Zeag/P39vcgbHcmkZ7NP/rpkJwvxiFyKGXGmRt/6jewOuS+q/WfZ6pbBwOSboK/H66mi51R+UPzY2bK7iAFiGU94OBxW2Kk2904=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=fQcj/Yeq; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="fQcj/Yeq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Rs
	k9iYPk8yZ9Q3MyrwHccU/MgYVIT/oBogzsblRor8I=; b=fQcj/YeqB4aJLAMEqJ
	pWVO9RFiohIa5blm+WdWURWr5Mu94+UQ7IASwk3fdbEWwYoPNUmhh7r8++ARbeF8
	v+x/SZ8kPZBHgkdY0rMdaV4R/0jCQCyGzkkh5rGmgyuCRIv7oIbijbVV/6Ux1TIV
	alsWZJwWw2xljMcQezJernpp8=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3n8Zj7s5qRjA2Eg--.53721S2;
	Wed, 14 Oct 2026 10:52:20 +0800 (CST)
From: Pengpeng Hou <hppiscas@163.com>
To: johannes@sipsolutions.net
Cc: briannorris@chromium.org,
	chunfan.chen@gmail.com,
	jeff.chen_1@nxp.com,
	francesco@dolcini.it,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	francesco.dolcini@toradex.com,
	hppiscas@163.com
Subject: Re: [PATCH v4] wifi: mwifiex: validate event lengths before copying bodies
Date: Wed, 14 Oct 2026 10:52:17 +0800
Message-ID: <20261014025217.82975-1-hppiscas@163.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <97fdc1b8cff6477217100beb9b242ede810a7dc2.camel@sipsolutions.net>
References: <20260731141600.2-mwifiex-v4-pengpeng@iscas.ac.cn> <97fdc1b8cff6477217100beb9b242ede810a7dc2.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3n8Zj7s5qRjA2Eg--.53721S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFW8Xr47WFWrKrW5Kw1kAFb_yoWxKFg_uF
	yvvr97Gw1vqr93JFW3KF4UZFsrurW2kw1kZrWqvw1Syry5tF4fAr1kKFnYvFyfKa13Gr9x
	Krn3Ca45ur1fWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUj-tx7UUUUU==
X-CM-SenderInfo: 5kssx2xfdvqiywtou0bp/xtbC7gQj62rO7mTIYgAA3m

Hi Johannes,

Yes. PCIe sets event_received even when its size condition skips the copy
into event_body. USB and SDIO rejection alone would leave inconsistent
handling and could leave PCIe consumers using an unchanged event body.

The PCIe length also includes the transport header. A revision needs to
validate that extent before trimming/pulling the skb, copy only the body
after both headers, and return a rejected event buffer to its DMA ring
without publishing the event. Dropping the buffer without that ring
completion is not sufficient.

I will hold v4 until that common rejection policy and PCIe buffer-return
path are covered together, rather than resend the USB/SDIO-only change.

Thanks,
Pengpeng

