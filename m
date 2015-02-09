Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49591 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbbBIUpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 15:45:12 -0500
Date: Mon, 9 Feb 2015 15:37:42 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2015-02-07
Message-ID: <20150209203741.GG3566@tuxdriver.com> (sfid-20150209_214524_872102_22FAAA81)
References: <87a90qosos.fsf@kamboji.qca.qualcomm.com>
 <20150209.121342.1535841700027616341.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20150209.121342.1535841700027616341.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 09, 2015 at 12:13:42PM -0800, David Miller wrote:
> From: Kalle Valo <kvalo@codeaurora.org>
> Date: Sat, 07 Feb 2015 13:40:51 +0200
> 
> > There's a small conflict in drivers/net/wireless/rtlwifi/pci.c, the fix
> > is to leave the two labels like this:
> > 
> > 			schedule_work(&rtlpriv->works.lps_change_work);
> > 		}
> > end:
> > 		skb = new_skb;
> > no_new:
> > 		if (rtlpriv->use_new_trx_flow) {
> > 
> > 
> 
> That can't be the correct resolution:
> 
> drivers/net/wireless/rtlwifi/pci.c: In function ‘_rtl_pci_rx_interrupt’:
> drivers/net/wireless/rtlwifi/pci.c:934:1: warning: label ‘end’ defined but not used [-Wunused-label]
> 
> So I've removed that label in the merge commit.

FWIW, that's the way I have it in wireless-testing as well...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
