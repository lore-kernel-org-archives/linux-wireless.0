Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42101 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbXKAR1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 13:27:54 -0400
Date: Thu, 1 Nov 2007 17:27:46 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 2/7] ath5k: Remove opaque pointers from ath5k_hw_attach()
Message-ID: <20071101172746.GA7033@infradead.org> (sfid-20071101_172758_302517_FAEF7A1B)
References: <20071101043520.GC21987@pogo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071101043520.GC21987@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  struct ath5k_hw {
>  	u32			ah_magic;
>  
> -	void			*ah_sc;
> -	void __iomem		*ah_sh;
> +	struct ath5k_softc	*ah_sc;
> +	void __iomem		*ah_iobase;
>  
>  	enum ath5k_int		ah_imr;

Why do you need separate ath5k_hw and ath5k_softc structures anyway?

