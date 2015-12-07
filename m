Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:36701 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbbLGCOR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2015 21:14:17 -0500
Subject: Re: [PATCH v2] rtlwifi: fix memory leak for USB device
To: Peter Wu <peter@lekensteyn.nl>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1449446851-2221-1-git-send-email-peter@lekensteyn.nl>
Cc: stable@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <5664EB7D.7010009@lwfinger.net> (sfid-20151207_031434_253863_61CF75EB)
Date: Sun, 6 Dec 2015 20:14:21 -0600
MIME-Version: 1.0
In-Reply-To: <1449446851-2221-1-git-send-email-peter@lekensteyn.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/06/2015 06:07 PM, Peter Wu wrote:
> Free skb for received frames with a wrong checksum. This can happen
> pretty rapidly, exhausting all memory.
>
> This fixes a memleak (detected with kmemleak). Originally found while
> using monitor mode, but it also appears during managed mode (once the
> link is up).
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> ---
>   v2: updated commit message based on Larry's feedback
>   v1: https://lkml.kernel.org/r/1449424677-3140-1-git-send-email-peter@lekensteyn.nl
>
> Tested with v4.3, rebased on v4.4-rc3 (changed paths). The bug goes back
> to its introduction in the v2.6.x kernel.
> ---
>   drivers/net/wireless/realtek/rtlwifi/usb.c | 2 ++
>   1 file changed, 2 insertions(+)

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
> index 2721cf8..aac1ed3 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/usb.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
> @@ -531,6 +531,8 @@ static void _rtl_usb_rx_process_noagg(struct ieee80211_hw *hw,
>   			ieee80211_rx(hw, skb);
>   		else
>   			dev_kfree_skb_any(skb);
> +	} else {
> +		dev_kfree_skb_any(skb);
>   	}
>   }
>
>

