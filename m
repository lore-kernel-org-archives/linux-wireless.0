Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:51049 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932505AbbA3Pre (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 10:47:34 -0500
Message-ID: <54CBA794.90508@lwfinger.net> (sfid-20150130_164739_353246_D6AE7DB3)
Date: Fri, 30 Jan 2015 09:47:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: kvalo@codeaurora.org
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH V2 1/6] rtlwifi: Change logging level for key change
References: <1422304934-9239-1-git-send-email-Larry.Finger@lwfinger.net> <1422304934-9239-2-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1422304934-9239-2-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2015 02:42 PM, Larry Finger wrote:
> A recent change in key handling included logging of these changes for
> all debug levels. Such key changes should only be logged when a high
> level of debugging is enabled.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>   drivers/net/wireless/rtlwifi/cam.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/cam.c b/drivers/net/wireless/rtlwifi/cam.c
> index 3ef870d..6e64792 100644
> --- a/drivers/net/wireless/rtlwifi/cam.c
> +++ b/drivers/net/wireless/rtlwifi/cam.c
> @@ -406,7 +406,7 @@ u8 rtl_cam_get_free_entry(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
>   		}
>   	}
>   	if (found) {
> -		RT_TRACE(rtlpriv, COMP_SEC, DBG_EMERG,
> +		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
>   			 "key_index=%d,cam_bitmap: 0x%x entry_idx=%d\n",
>   			  key_index, rtlpriv->sec.cam_bitmap, entry_idx);
>   		return entry_idx;
>

Kalle,

Please include this patch even though the rest of this set should be dropped. 
Once the wifi-BT communications problem is resolved, new versions of those will 
be presented.

I'm sorry that my commit message was not as informative as it could have been. I 
was presented with this material that I did not understand. One saving grace is 
that the RTL8812AE hardware is apparently rare - I certainly do not have any 
samples. I'm not sure of the value of a 1x1 implementation of 802.11ac, but that 
may be another example of my ignorance.

Thanks,

Larry
