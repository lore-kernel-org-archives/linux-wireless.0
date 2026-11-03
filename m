Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793699780;
	b=ITn+23vo0J7Z0UHjIWUz+NU8L939U8Mpe8FQGTTg81Lwj6bTCHRdObX0W1qVmBtBa5Ic
	 qjkg3mEuaJhwXWtl+1XWIHLuJGsvLHMn+MWoau2X4JPhRNhQJX52e2g3D5MwQ+lP5OPLO
	 Gz1dliyDH4Rt/hb6Y/dW5y3aDyNQv6v4h/3kjM6bVl02+RHZKWUpoihMKAkpLZF1mHRcH
	 ZZ2vi3Bfa++OKIpNVznoh7j2/Nh1C00hL3ycPNgmvlo/xGSfBD9EJaUAXm/TS9Fo6v7bb
	 k7h7y4mN08/qcqcCzM5B70mVa7PVqsAccfKZPWeTQY1ZDNcgWr7bieQCFLp32IGbyxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793699780;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=hLTiI1kP/AbllMQDMrdD3GMXjYT58HAHPodk/BwxYu7On02P4bHffsKdo8NqayV/gry6
	 5NiobhL6q+FY2WUja2Iza1t1LZ/AvgbeHfF/eC2QYRyiVlpYYKz6olIaXWxm5p2RsoKRw
	 KNjU7PqmfHS9l3Tb5Kq+Q/ydQb65FvPdyZI+tM/gwGWyqj6AafstjekDCtH9bM9GEjubj
	 BsXvXRBQmfsz/ddhcvJSxbdBHMCRQSHkKs24BUJnPgWYkgheRx5RQqhDA7VLt/IpMq6z3
	 4L+QBDO+8z2ekOx1duEqJbHnHGdZydjm+eUUOxEGCrPj0nXPi/TWP03uzmyopOZWTvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=dlR0BLvh;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C64606B374;
	Tue,  3 Nov 2026 09:56:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4C64606B374
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=dlR0BLvh
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dlR0BLvhBt/X5Kvkd76yjGaG+H
	UKtgSW0ZhfO5lKc1nXji+L/Wk3egM54eZJSYTTyKnR75GFat/q/56L9d/GS36hoLmni6St/BM+ua+
	zXg6MTpa9lbi+tiC7AOX2Mr9lrDkTVc4mMe7eWR45rkFV9aKXf2NLM8z3O31SGSy+wuLZ0fUdek6K
	d0MHFp2jOQaXsxX8p+LYP/sa9pLzg5zFuAxK4jihpbmqcNdo9fpbSv8uMmFdXXmg8tcmY9SbPzo2R
	Cm3TS7FSS3ecJlJ5XI1E9pZGP2ZGh+wADsvugxv9e67sCCFRe9MPaFoYbblwLXf4IKTWG+ZZrr6MO
	4j2n3/9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOBFX-00000001qzv-41Uy;
	Tue, 03 Nov 2026 09:56:15 +0000
Date: Tue, 3 Nov 2026 01:56:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Ulf Hansson <ulfh@kernel.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jeff Johnson <jjohnson@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Balakrishna Godavarthi <quic_bgodavar@quicinc.com>,
	Rocky Liao <quic_rjliao@quicinc.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Saravana Kannan <saravanak@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Eric Dumazet <edumazet@kernel.org>, Abel Vesa <abelvesa@kernel.org>,
	linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-block@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, daniel@makrotopia.org,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: Re: [PATCH v12 2/2] block: implement NVMEM provider
Message-ID: <aumvv31Xm0K6ypgP@infradead.org>
References: <20261102-block-as-nvmem-v12-0-f4a2a681087d@oss.qualcomm.com>
 <20261102-block-as-nvmem-v12-2-f4a2a681087d@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-block-as-nvmem-v12-2-f4a2a681087d@oss.qualcomm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

