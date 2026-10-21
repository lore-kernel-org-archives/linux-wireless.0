Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792591160;
	b=iZclAQpSvBL2UfkIfY6nSA6WKFQVeWjSPQ4nHToBAgwnU+FJ3a/OMuvyGRzycxttfX32
	 JsGDXTpFxXqSEO0V/dW2aYcKFWWJwWf4diwwUssN8XZQ8mZ3X/RNcI8ATgT3SNylFWIUQ
	 ozc4Z8XIf9O+YrjH8naOmxHJf/vhJKRATI5glki0HjkiUH/W2sCLJ16ixv3DnbsHz985X
	 WGdHSsjN/9t+Cuut3Sp95eYqyAVqB5tp3YVvj72CxfdDHQPiHUmA3XE7vyrb0efijE0fo
	 qpeHT0JNs9J+EPfohivJPQZqfj8j+NiXQP/U4ajHcUB3HOexf8ugc+5KgmyUQCb1jfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792591160;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=rvZRFpgW4mcXFVz0LqNiDYyuovhD6IbGYSgNDeZHiok=;
	b=nU0rPH7y8UOi/lshAfu7FGjsHdnbdEMUuyi/AujxrDmfaPXHnoVRsZZK31Yn2cRYoXtW
	 TMx25phzpYlKE8QshY6Yx3wC69cu1TvdKuRMg6VCbu9kX6bLiTsGwJ38yUNK4JzMIEJE+
	 Nek+XTHPENmcrQZJdyAOROHzd5xATaFjWGJVVDMZBCSk+8bHf63UD7B2AizEUtDXEOPpi
	 74ZLJRBJw1pPCfG+z95+oj7fieLttiSZOKA84gaLJyFMspotXDmthDHsuj3o+OiRE5U8V
	 uc+/7SXUBG2vNv4dLg/5bBUCfnhj+ogKOQkwggd3knbmfXqZN4x3pp4BeBQ3zGAq7ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=F5GpOs5c;
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2DD606A327
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 13:59:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC2DD606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=F5GpOs5c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=rv
	ZRFpgW4mcXFVz0LqNiDYyuovhD6IbGYSgNDeZHiok=; b=F5GpOs5ck4fKnc60OZ
	FzpF7CTyZWyrYoZGc3EdLmyHR/z7+9D52AnJKmrH8g8MN28nCc3XMZlE8ulEgNYs
	iIxW4TkMt9a28Yoeh+Z08t6ce98HoJNf9nomndYDLtGgFl2VNEAUm6wQuiEx9bVF
	G18Ie+VwUKa4aK5+H5lR+fFfY=
Received: from LAPTOP-137NTCJO (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3fxUvxdhq2hgEBw--.42856S2;
	Wed, 21 Oct 2026 21:59:13 +0800 (CST)
From: Jiaxin Li <18135327133@163.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v3 0/1] wifi: rtl8180: reject RX frames longer than MAX_RX_SIZE
Date: Wed, 21 Oct 2026 21:59:05 +0800
Message-ID: <20261021135906.1493-1-18135327133@163.com>
X-Mailer: git-send-email 2.56.0.windows.2
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3fxUvxdhq2hgEBw--.42856S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4RAEfrUUUUU
X-CM-SenderInfo: zpryijyvtsliitt6il2tof0z/xtbC6RFOD2rYxTHzFwAA3b

Hi,

Thanks for the review and the suggestion on the variable ordering.
This v3 orders the new local variables in reverse Christmas tree style.

Regards,
Jiaxin Li 
School of Software
Taiyuan University of Technology

Jiaxin Li (1):
  wifi: rtl8180: reject RX frames longer than MAX_RX_SIZE

 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)
--
2.34.1

