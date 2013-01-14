Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44772 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557Ab3ANUAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 15:00:20 -0500
Date: Mon, 14 Jan 2013 14:58:51 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.8 2/2] ath9k_hw: fix RF bank initialization
Message-ID: <20130114195851.GB12018@tuxdriver.com> (sfid-20130114_210029_512380_5F1EE0CC)
References: <1358103298-4017-1-git-send-email-nbd@openwrt.org>
 <1358103298-4017-2-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1358103298-4017-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 13, 2013 at 07:54:58PM +0100, Felix Fietkau wrote:
> ar900*_init_mode_regs needs to be called before RF banks are allocated,
> otherwise the storage size of RF banks isn't known. This patch fixes
> a memory overrun that can show up as a crash on unloading the module.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

<snip>

> @@ -410,7 +411,10 @@ int ar9002_hw_attach_ops(struct ath_hw *ah)
>  	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
>  	int ret;
>  
> -	priv_ops->init_mode_regs = ar9002_hw_init_mode_regs;
> +	ret = ar9002_hw_init_mode_regs(ah);
> +	if (ret)
> +		return ret;
> +
>  	priv_ops->init_mode_gain_regs = ar9002_hw_init_mode_gain_regs;
>  
>  	ops->config_pci_powersave = ar9002_hw_configpcipowersave;

This hunk depends on "ath9k_hw: use the devres API for allocations",
which is queue for 3.9.  Can you revise this for 3.8?  If not, should
I hold just this one for 3.9?  Or the earlier patch in the series
as well?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
