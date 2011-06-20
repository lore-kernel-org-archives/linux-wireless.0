Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51269 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab1FTUBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 16:01:33 -0400
Date: Mon, 20 Jun 2011 15:45:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Mike McCormack <mikem@ring3k.org>
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] rtlwifi: Fix typo in variable name
Message-ID: <20110620194549.GC2251@tuxdriver.com> (sfid-20110620_220144_620117_67FD8CF2)
References: <4DFEA61A.8060805@ring3k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4DFEA61A.8060805@ring3k.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 20, 2011 at 10:44:58AM +0900, Mike McCormack wrote:
> offchan_deley should be offchan_delay
> 
> Signed-off-by: Mike McCormack <mikem@ring3k.org>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> @@ -788,7 +788,6 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
>  {
>  	struct ieee80211_hw *hw = dev_id;
>  	struct rtl_priv *rtlpriv = rtl_priv(hw);
> -	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
>  	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
>  	unsigned long flags;
>  	u32 inta = 0;

How is this hunk related?  It breaks the build...

  CC [M]  drivers/net/wireless/rtlwifi/pci.o
drivers/net/wireless/rtlwifi/pci.c: In function ‘_rtl_pci_interrupt’:
drivers/net/wireless/rtlwifi/pci.c:796:6: error: ‘rtlpci’ undeclared (first use in this function)
drivers/net/wireless/rtlwifi/pci.c:796:6: note: each undeclared identifier is reported only once for each function it appears in
make[2]: *** [drivers/net/wireless/rtlwifi/pci.o] Error 1
make[1]: *** [drivers/net/wireless/rtlwifi] Error 2
make: *** [drivers/net/wireless/] Error 2

I'll fix it up -- please be more careful.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
