Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab1BGPHI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 10:07:08 -0500
Date: Mon, 7 Feb 2011 16:05:49 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, george0505@realtek.com,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/6] rtlwifi: Modify core routines
Message-ID: <20110207150549.GB2319@redhat.com>
References: <4d4eebff.7tS1Lx4qGh4/R4P2%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4d4eebff.7tS1Lx4qGh4/R4P2%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  static inline u8 pci_read8_sync(struct rtl_priv *rtlpriv, u32 addr)
>  {
> -	return 0xff & readb((u8 *) rtlpriv->io.pci_mem_start + addr);
> +	return 0xff & readb((u8 __iomem *) rtlpriv->io.pci_mem_start + addr);

Remove 0xff
