Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE36A3446C6;
	Thu, 16 Jul 2026 19:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784230141; cv=none; b=mD8QaeLCXsn66Ncptr/LToE4NvNyN+uyoTOcBbTrjZjJMYNPG5tupMYRLhqQr2+sSz8p4Ttr8y0MpGRH1ijmhbP2bsBCMy9Enhs9Zj4go8JbmRsR6MggQzVMkXt0FFnKTfiLRCgJ6xwgHQ61U/G9tzyfdvuKBrtKXl1t8ORxsxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784230141; c=relaxed/simple;
	bh=5nOPvtDOltYfSZ2BtVykY6aHPENLZTFw4iky50GQSiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uXu9lcjjM2qH+IeJmzDkpmLXkoCBE8PK5ocS0RnU1ScP78O7uqtKyETv+b+QmE7jB94AoW1WDl9QkAJkRLtVYeu6AJRlcUQcgq1FW+SBcnqQUBR4KceUVmDGpJX6KYY4fzPRFxufdgaFSeWYA1/iqS9srAXzAJBOp1FC+aFMnbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=bukHaJIn; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="bukHaJIn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=gi06cjup0mnCESgMnGu56CGRNQ7Q6fgCPxGPMm5qKPw=; b=bukHaJInPjQgB0Oo2KZUUlebHx
	mQKsz5JkyZejIO7a394uIpEMQGo+xwn5hEVnGM80csZ2NVtf8MCOGfYpfO1paN1BGAz1FIrFGlT7Q
	Ii693ExnvVbOVngBDb1n7dsvE6h9Ak4eJ7t2ZMnpxG7vBkxxg8TAwgI6Ki7AAROHVZLg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1wkRlK-00CckZ-3b; Thu, 16 Jul 2026 21:28:50 +0200
Date: Thu, 16 Jul 2026 21:28:50 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Simon Dietz <dietz23838@hs-ansbach.de>
Cc: simon.dietz@plantwatch.de, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, johannes@sipsolutions.net, kuniyu@google.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next v0 2/6] net: fix GeoNetworking
Message-ID: <3ee0f1ce-cba2-43b2-9f6e-9fb7021f92db@lunn.ch>
References: <20260716135902.2895237-2-simon.dietz@plantwatch.de>
 <20260716153917.3399255-1-dietz23838@hs-ansbach.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716153917.3399255-1-dietz23838@hs-ansbach.de>

>  drop:
> -	pr_info("Packet was dropped.");
> +	//pr_info("Packet was dropped.");
>  	kfree_skb(skb);

Don't comment it out, remove it.

And maybe think about incriminating a counter.

> @@ -1003,21 +1031,41 @@ static int gn_rcv(struct sk_buff *skb, struct net_device *dev,
>  
>  	switch (gh->gc_h.ht) {
>  	case CH_HT_GUC:
> +		if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE + sizeof(struct gn_guc_header) + sizeof(struct btp_header)))
> +			goto drop;

The netdev coding style asks for lines to be < 80 characters long.

We also have quite a lot of #defines for lengths of various
headers. So maybe add some _HLEN macros.

	 Andrew
