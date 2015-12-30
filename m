Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:38787 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbbL3QrF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 11:47:05 -0500
MIME-Version: 1.0
In-Reply-To: <1450946006-7498-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1450946006-7498-1-git-send-email-bjorn.andersson@sonymobile.com>
Date: Wed, 30 Dec 2015 22:17:04 +0530
Message-ID: <CAFqt6zam7maK4wFrKo=yqWxaBkVDJhZGbKAFAdmcZPQonXTcxA@mail.gmail.com> (sfid-20151230_174754_154966_68168336)
Subject: Re: [PATCH] mac80211: Make addr const in SET_IEEE80211_PERM_ADDR()
From: Souptick Joarder <jrdr.linux@gmail.com>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HI Bjorn,

On Thu, Dec 24, 2015 at 2:03 PM, Bjorn Andersson <bjorn@kryo.se> wrote:
> Make the addr parameter const in SET_IEEE80211_PERM_ADDR() to save
> clients from having to cast away a const qualifier.
>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
>  include/net/mac80211.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 7c30faff245f..a6f3c9c4b7c2 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -2167,7 +2167,7 @@ static inline void SET_IEEE80211_DEV(struct ieee80211_hw *hw, struct device *dev
>   * @hw: the &struct ieee80211_hw to set the MAC address for
>   * @addr: the address to set
>   */
> -static inline void SET_IEEE80211_PERM_ADDR(struct ieee80211_hw *hw, u8 *addr)
> +static inline void SET_IEEE80211_PERM_ADDR(struct ieee80211_hw *hw, const u8 *addr)

I guess without const or with const doesn't make much difference here.
Correct me if I am wrong.
>  {
>         memcpy(hw->wiphy->perm_addr, addr, ETH_ALEN);
>  }
> --
> 2.5.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-Souptick
