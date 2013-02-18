Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:63898 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3BRQJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 11:09:29 -0500
Received: by mail-ob0-f175.google.com with SMTP id uz6so5808307obc.34
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 08:09:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361021140-19871-1-git-send-email-hauke@hauke-m.de>
References: <1361021140-19871-1-git-send-email-hauke@hauke-m.de>
Date: Mon, 18 Feb 2013 17:09:27 +0100
Message-ID: <CACna6ryaMfZ9x7VWHnRR9RF0wSN0A+H6vr3AC103Sn4G1XZdKQ@mail.gmail.com> (sfid-20130218_170935_098551_B4DBAFEC)
Subject: Re: [PATCH] ssb: fix unaligned access to mac address
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/2/16 Hauke Mehrtens <hauke@hauke-m.de>:
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
>         u8 revision;
> +       u8 country_code;        /* Country Code */
>         u8 il0mac[6];           /* MAC address for 802.11b/g */

It looks a little hacky to me too, it's easy to forget about that
requirement and break that again in the future.

What about not casting il0mac to u16 at all? Maybe we should just fill
it as u8 (which it is)?

-- 
Rafał
