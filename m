Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:46239 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbaJBREV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 13:04:21 -0400
Received: by mail-ob0-f176.google.com with SMTP id m8so1626199obr.7
        for <linux-wireless@vger.kernel.org>; Thu, 02 Oct 2014 10:04:20 -0700 (PDT)
Message-ID: <542D8591.5050807@lwfinger.net> (sfid-20141002_190424_776757_74FE7F5E)
Date: Thu, 02 Oct 2014 12:04:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-wireless@vger.kernel.org,
	=?UTF-8?B?InRyb3lfdGFuQHJlYWxzaWwuY29t?=
	 =?UTF-8?B?LmNuID4+IOiwreadreazoiI=?= <troy_tan@realsil.com.cn>
Subject: Re: rtlwifi: rtl8192ee: Move driver from staging to the regular tree
References: <20141002091041.GA10993@mwanda>
In-Reply-To: <20141002091041.GA10993@mwanda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/02/2014 04:10 AM, Dan Carpenter wrote:
> Hello Larry Finger,
>
> There are still some static checker warnings after this driver moved.
>
> drivers/net/wireless/rtlwifi/rtl8192ee/hw.c:533 rtl92ee_set_hw_reg() warn: add curly braces? (if)
> drivers/net/wireless/rtlwifi/rtl8192ee/hw.c:539 rtl92ee_set_hw_reg() warn: add curly braces? (if)
>
> Some unreleased static checker warnings for rtl are:
>
> drivers/net/wireless/rtlwifi/rtl8723be/trx.c:550 rtl8723be_rx_query_desc() warn: 'hdr' can't be NULL.
> drivers/net/wireless/rtlwifi/rtl8188ee/trx.c:621 rtl88ee_rx_query_desc() warn: 'hdr' can't be NULL.
> drivers/net/wireless/rtlwifi/rtl8192ee/trx.c:567 rtl92ee_rx_query_desc() warn: 'hdr' can't be NULL.
> drivers/net/wireless/rtlwifi/rtl8821ae/trx.c:758 rtl8821ae_rx_query_desc() warn: 'hdr' can't be NULL.
> drivers/net/wireless/rtlwifi/rtl8723ae/trx.c:494 rtl8723e_rx_query_desc() warn: 'hdr' can't be NULL.
> drivers/net/wireless/rtlwifi/rtl8192se/trx.c:315 rtl92se_rx_query_desc() warn: 'hdr' can't be NULL.
> drivers/net/wireless/rtlwifi/rtl8192ce/trx.c:392 rtl92ce_rx_query_desc() warn: 'hdr' can't be NULL.
>
> These bogus null checks were added because:
> drivers/net/wireless/rtlwifi/rtl8192se/trx.c says /* during testing, hdr
> was NULL here */.  It is concerning because that means something weird
> is going on when impossible things start happening during testing.
>
> regards,
> dan carpenter

Dan,

Thanks for these warnings. A patch has been submitted.

The first two were due to indenting errors.

As to the bogus checks for null, that same comment was in rtl8192ce. As that was 
the first mac80211 driver that Realtek prepared, I suspect that there once was a 
bug elsewhere in the code that resulted in a corrupted skb, and the hdr test was 
added to keep from crashing. Once that bug was corrected, the hdr test was 
forgotten. I do not remember ever seeing that condition being logged, but if 
there is another bug somewhere, it will now get attention!

Larry

