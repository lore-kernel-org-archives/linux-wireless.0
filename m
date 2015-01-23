Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:38239 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbbAWQnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 11:43:08 -0500
Received: by mail-oi0-f43.google.com with SMTP id z81so7354733oif.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2015 08:43:07 -0800 (PST)
Message-ID: <54C27A19.80102@lwfinger.net> (sfid-20150123_174312_217337_05D22401)
Date: Fri, 23 Jan 2015 10:43:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com
Subject: Re: [PATCH] rtl8192cu: fix the mesh beaconing
References: <1422003564-22414-1-git-send-email-yeohchunyeow@gmail.com>
In-Reply-To: <1422003564-22414-1-git-send-email-yeohchunyeow@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2015 02:59 AM, Chun-Yeow Yeoh wrote:
> Patch "rtlwifi: add support to send beacon frame" allows
> the beaconing of rtl8192cu. But mesh beaconing is not
> working. Fix this.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 1 +
>   1 file changed, 1 insertion(+)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> index 5513217..e5a7c4f 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> @@ -1509,6 +1509,7 @@ void rtl92cu_set_beacon_related_registers(struct ieee80211_hw *hw)
>   	/* TODO: Modify later (Find the right parameters)
>   	 * NOTE: Fix test chip's bug (about contention windows's randomness) */
>   	if ((mac->opmode == NL80211_IFTYPE_ADHOC) ||
> +	    (mac->opmode == NL80211_IFTYPE_MESH_POINT) ||
>   	    (mac->opmode == NL80211_IFTYPE_AP)) {
>   		rtl_write_byte(rtlpriv, REG_RXTSF_OFFSET_CCK, 0x50);
>   		rtl_write_byte(rtlpriv, REG_RXTSF_OFFSET_OFDM, 0x50);
>

