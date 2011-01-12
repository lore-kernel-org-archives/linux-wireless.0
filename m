Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45153 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab1ALIrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 03:47:21 -0500
Subject: Re: [PATCH 1/2] ieee80211: correct
 IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK macro
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <1294791265-24020-1-git-send-email-bzhao@marvell.com>
References: <1294791265-24020-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 09:47:59 +0100
Message-ID: <1294822079.3639.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-11 at 16:14 -0800, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> It is defined in include/linux/ieee80211.h. As per IEEE spec.
> bit6 to bit15 in block ack parameter represents buffer size.
> So the bitmask should be 0xFFC0.

Good catch, thanks.

John, can you pick this up?

Cc: stable@kernel.org
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
>  include/linux/ieee80211.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 6042228..294169e 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -959,7 +959,7 @@ struct ieee80211_ht_info {
>  /* block-ack parameters */
>  #define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
>  #define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
> -#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
> +#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFC0
>  #define IEEE80211_DELBA_PARAM_TID_MASK 0xF000
>  #define IEEE80211_DELBA_PARAM_INITIATOR_MASK 0x0800
>  


