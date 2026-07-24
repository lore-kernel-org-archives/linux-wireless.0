Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C964E2931FF;
	Fri, 24 Jul 2026 13:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784898685; cv=none; b=IsJoK7iVxs36yW8TULdFye/ssh1PwUMW1ywznYkew3IoMcxCNxFMnL3zHPsLuWlUPi/nhN4/16TM8yOFLnd9COgarab5ca6p5eNonIAXpviU8iyA9RcQ3L61rFP2Pe7dH5A0SIntRWZgtfKUuq7D3GesHN6P1VrQRaVyheinoxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784898685; c=relaxed/simple;
	bh=NUna20UvecMvvldvWQK7l6dRgL5Kg++Jc2/WPoM8vog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CmE6i2H6wfDw/dT3+vA8CzUYWybGPYCP/gIQCwOltLK0oftErJQXCv82YgsBc8r8b1UM0J+s1KXIvQKnPrtr7oIDSL6mRm9xQRFaRM4e6v9zwSUApeU4Gc07fH5krZ7ezR59T1sI6Z+Ps5WXemVtYSNNJjm1I6RpSXK9WZRqJZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eVQW4YyH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eVQW4YyH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tIGeMUsaNb0y93vr8pcc7knEo2f51EGekAs0IIpo/eY=; b=eVQW4YyHf2n+7nUYlm9j9OoqmW
	93jEEsn1tgghZPGu21TlFvfxft/ALHG/mcJ4p2P/W/aubzHwD5nZtVcahmZaQw6D3DVgoEHKXTTrQ
	NTVlYkiTW41de23zdPu1kvTfNTe8DuxdK4P0Uq4beMSHQ22WvPeuvI0drpbOvsZt4C8PJgXi6m/4A
	jhZLQ13UK8c6cUqXfoFqsaW/24ALutRbfEWvhyrM4Gi3ngVRbOdVBRYP1+ZTqC7A6cYQ/KjSw7y5u
	LfrmaxaUtxKbK5ASxHwjBB/eX2I41fzVQwewAD4AgLl/JDI6lPDDchhWsILYnKSegrrYGZtkoSzCD
	gd+/Lzzw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnFfz-0000000GSAN-1qmn;
	Fri, 24 Jul 2026 13:10:55 +0000
Date: Fri, 24 Jul 2026 06:10:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ulf Hansson <ulfh@kernel.org>,
	Rob Herring <robh@kernel.org>,
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
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Saravana Kannan <saravanak@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>, linux-mmc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-block@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
	daniel@makrotopia.org,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: Re: [PATCH v8 5/9] block: implement NVMEM provider
Message-ID: <amNkX6HV7c_8jRUa@infradead.org>
References: <20260703-block-as-nvmem-v8-0-98ae32bfc49a@oss.qualcomm.com>
 <20260703-block-as-nvmem-v8-5-98ae32bfc49a@oss.qualcomm.com>
 <amLwz6WuHYUwKKJo@infradead.org>
 <CAFEp6-1_iariDyqWj0KezHAtULSO+piPHX0F=Z46Rx4KDNLmXw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEp6-1_iariDyqWj0KezHAtULSO+piPHX0F=Z46Rx4KDNLmXw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jul 24, 2026 at 11:10:58AM +0200, Loic Poulain wrote:
> Right, I was planning to add partition support in a follow-up series.
> But since this is really supposed to be a block-agnostic feature,
> whether it's a disk or a partition, I'll include partition in v8.

Please include the partitions, as including them or not matters for
the interfaces.  What is holding that support back now?  fwnode
magic?

> > Also once you register the whole devices as nvmem provider, we really
> > should keep it from being used a block device, shouldn't we?
> 
> 
> I'm not sure, the whole concept is block backed NVMEM, so we still
> need to add that block as base layer, though we could discuss
> suppressing uevent for it. Preventing block usage would make the
> feature much more intrusive than other NVMEM providers like MTD, where
> the underlying device stays accessible. And we may genuinely still
> want to write the disk (e.g. for factory provisioning), updating the
> very data the cells point to, etc. There's also the layering aspect,
> if a disk (e.g. mmcblk0) has logical partitions on top (mmcblk0pX), we
> still register/expose the whole disk mmcblk0 as a block device
> regardless. So if a disk contains NVMEM cells, I think it should still
> be exposed as a block device as well.

So we now get two unsynchronized ways to access the same device?
At least we need to prevent exclusive openers on the block device
side.  And document the side channel very well.

