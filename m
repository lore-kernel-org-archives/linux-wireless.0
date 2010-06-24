Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:34106 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206Ab0FXQr7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 12:47:59 -0400
Message-ID: <4C238C3A.6090905@openwrt.org>
Date: Thu, 24 Jun 2010 18:47:54 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] minstrel_ht: mark minstrel_mcs_groups as static
References: <1277392602-10578-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1277392602-10578-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-06-24 5:16 PM, John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  net/mac80211/rc80211_minstrel_ht.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index 7a04951..a8f658c 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -59,7 +59,7 @@
>   * groups, based on the number of streams and flags (HT40, SGI) that they
>   * use.
>   */
> -const struct mcs_group minstrel_mcs_groups[] = {
> +static const struct mcs_group minstrel_mcs_groups[] = {
NACK. minstrel_ht debugfs needs this. The proper fix for the warning is
to add this one to a header file instead.

- Felix
