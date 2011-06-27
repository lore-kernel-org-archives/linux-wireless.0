Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58191 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab1F0SHI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 14:07:08 -0400
Received: by pvg12 with SMTP id 12so3003730pvg.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 11:07:07 -0700 (PDT)
Date: Mon, 27 Jun 2011 21:06:09 +0300
From: Dan Carpenter <error27@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath6kl: implement testmode rx command
Message-ID: <20110627180609.GZ14591@shale.localdomain> (sfid-20110627_200906_139045_99C80489)
References: <20110627153610.16774.65919.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110627153610.16774.65919.stgit@localhost6.localdomain6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 27, 2011 at 06:36:10PM +0300, Kalle Valo wrote:
>  #define AR6K_TM_DATA_MAX_LEN 5000
> @@ -1482,11 +1483,83 @@ static const struct nla_policy ar6k_testmode_policy[AR6K_TM_ATTR_MAX + 1] = {
>  				.len = AR6K_TM_DATA_MAX_LEN },
>  };
>  
> +void ar6000_testmode_rx_report_event(struct ar6_softc *ar, void *buf,
> +				     int buf_len)
> +{
> +	kfree(ar->tcmd_rx_report);
> +
> +	ar->tcmd_rx_report = kmemdup(buf, buf_len, GFP_KERNEL);
> +	ar->tcmd_rx_report_len = buf_len;
> +

Can this race?  When we use tcmd_rx_report_len we are under lock,
but it seems like when we set it here, we're not under lock.

regards,
dan carpenter

> +	wake_up(&arEvent);
> +}
> +
