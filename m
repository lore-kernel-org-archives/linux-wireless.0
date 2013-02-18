Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42149 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409Ab3BRKK3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 05:10:29 -0500
Message-ID: <1361182220.8555.2.camel@jlt4.sipsolutions.net> (sfid-20130218_111033_929360_EF0352EF)
Subject: Re: [PATCH] ssb: fix unaligned access to mac address
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Mon, 18 Feb 2013 11:10:20 +0100
In-Reply-To: <1361021140-19871-1-git-send-email-hauke@hauke-m.de> (sfid-20130216_142600_027602_45FAF12B)
References: <1361021140-19871-1-git-send-email-hauke@hauke-m.de>
	 (sfid-20130216_142600_027602_45FAF12B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-02-16 at 14:25 +0100, Hauke Mehrtens wrote:
> The mac address should be aligned to u16 to prevent an unaligned access
> in drivers/ssb/pci.c where it is casted to __be16.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  include/linux/ssb/ssb.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
> index 22958d6..457e8eb 100644
> --- a/include/linux/ssb/ssb.h
> +++ b/include/linux/ssb/ssb.h
> @@ -26,6 +26,7 @@ struct ssb_sprom_core_pwr_info {
>  
>  struct ssb_sprom {
>  	u8 revision;
> +	u8 country_code;	/* Country Code */
>  	u8 il0mac[6];		/* MAC address for 802.11b/g */

You should probably add __aligned(2) or so to them to avoid relying on
the struct layout only.

johannes

