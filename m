Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932831AbcAKMSF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2016 07:18:05 -0500
Date: Mon, 11 Jan 2016 13:16:10 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: kvalo@codeaurora.org, johannes.berg@intel.com,
	emmanuel.grumbach@intel.com, ilw@linux.intel.com,
	linuxwifi@intel.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] iwl4965: Fix a memory leak in error handling code of
 __il4965_up
Message-ID: <20160111121610.GF25015@redhat.com> (sfid-20160111_131821_665405_D5D35BE4)
References: <1452392363-3600-1-git-send-email-baijiaju1990@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1452392363-3600-1-git-send-email-baijiaju1990@163.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 10, 2016 at 10:19:23AM +0800, Jia-Ju Bai wrote:
> diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
> index 6656215..fd7b5c7 100644
> --- a/drivers/net/wireless/iwlegacy/4965-mac.c
> +++ b/drivers/net/wireless/iwlegacy/4965-mac.c
> @@ -5577,6 +5577,7 @@ __il4965_up(struct il_priv *il)
>  	ret = il4965_hw_nic_init(il);
>  	if (ret) {
>  		IL_ERR("Unable to init nic\n");
> +		il_dealloc_bcast_stations(il);
>  		return ret;
>  	}

Please do not repost patches so frequent and if you repost
the unchanged patch mark it so i.e. [PATCH repost].

Stanislaw
