Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from civicrm.laptop.org ([18.85.44.157]:60472 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750972AbdISDBU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 23:01:20 -0400
Date: Tue, 19 Sep 2017 13:01:13 +1000
From: James Cameron <quozl@laptop.org>
To: yintang@qti.qualcomm.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [TDLS PATCH V2 1/5] mac80211: Enable TDLS peer buffer STA feature
Message-ID: <20170919030113.GO26927@us.netrek.org> (sfid-20170919_050123_610626_95F1B2AA)
References: <1505789468-25330-1-git-send-email-yintang@qti.qualcomm.com>
 <1505789468-25330-2-git-send-email-yintang@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1505789468-25330-2-git-send-email-yintang@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 19, 2017 at 10:51:04AM +0800, yintang@qti.qualcomm.com wrote:
> From: Yingying Tang <yintang@qti.qualcomm.com>
> 
> Enable TDLS peer buffer STA feature.
> Set extended capability bit to enable buffer STA when driver
> support it.
> 
> Signed-off-by: Yingying Tang <yintang@qti.qualcomm.com>
> ---
>  include/net/cfg80211.h |    3 +++
>  net/mac80211/tdls.c    |    5 ++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index f12fa52..edefc25 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -3249,6 +3249,8 @@ struct cfg80211_ops {
>   *	beaconing mode (AP, IBSS, Mesh, ...).
>   * @WIPHY_FLAG_HAS_STATIC_WEP: The device supports static WEP key installation
>   *	before connection.
> + * @WIPHY_FLAG_SUPPORT_TDLS_BUFFER_ST: Device support buffer STA when TDLS is

"_ST:" should be "_STA:"

> + *	established.
>   */
>  enum wiphy_flags {
>  	/* use hole at 0 */
> @@ -3275,6 +3277,7 @@ enum wiphy_flags {
>  	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
>  	WIPHY_FLAG_HAS_CHANNEL_SWITCH		= BIT(23),
>  	WIPHY_FLAG_HAS_STATIC_WEP		= BIT(24),
> +	WIPHY_FLAG_SUPPORT_TDLS_BUFFER_STA      = BIT(25),
>  };
>  
>  /**
> [...]

-- 
James Cameron
http://quozl.netrek.org/
