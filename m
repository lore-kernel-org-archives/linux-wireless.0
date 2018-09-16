Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60398 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728169AbeIQDwA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Sep 2018 23:52:00 -0400
Subject: Re: [PATCH] fix iwlwifi on old cards in v4.19 was Re: 4.19-rc[23]
 iwlwifi: BUG in swiotlb
To: Pavel Machek <pavel@ucw.cz>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi@intel.com
References: <0c5e53e5-2afa-8d38-0b48-272c670c4bc5@infradead.org>
 <1536651177.3224.106.camel@sipsolutions.net> <20180916093414.GA4299@amd>
 <20180916094142.GB4299@amd> <20180916095535.GA4245@amd>
 <20180916095935.GA4388@amd>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <23940459-3a95-7ccb-6ad0-dfa0790910d1@infradead.org> (sfid-20180917_002741_853998_C34F1E02)
Date: Sun, 16 Sep 2018 15:27:29 -0700
MIME-Version: 1.0
In-Reply-To: <20180916095935.GA4388@amd>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/16/18 2:59 AM, Pavel Machek wrote:
> 
> .max_tfd_queue_size was ommited for old cards, leading to oops in
> swiotlb.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 

Hi,
Thanks.  Works for me.

Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>


PS:  I started the b-word yesterday but my old laptop is slow...


> --- linux/drivers/net/wireless/intel/iwlwifi/cfg/1000.c	2018-09-05 13:12:40.453164067 +0200
> +++ linux-64/drivers/net/wireless/intel/iwlwifi/cfg/1000.c	2018-09-16 11:54:04.010970756 +0200
> @@ -51,6 +51,7 @@
>  
>  static const struct iwl_base_params iwl1000_base_params = {
>  	.num_of_queues = IWLAGN_NUM_QUEUES,
> +	.max_tfd_queue_size = 256,
>  	.eeprom_size = OTP_LOW_IMAGE_SIZE,
>  	.pll_cfg = true,
>  	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
> 
> 


-- 
~Randy
