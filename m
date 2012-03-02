Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37800 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab2CBHug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 02:50:36 -0500
Subject: Re: [PATCHv2 3/3] mac80211_hwsim: Implement
 ieee80211_ops:tx_last_beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <1330645207-13964-3-git-send-email-javier@cozybit.com> (sfid-20120302_004048_787600_381D3896)
References: <1330645207-13964-1-git-send-email-javier@cozybit.com>
	 <1330645207-13964-3-git-send-email-javier@cozybit.com>
	 (sfid-20120302_004048_787600_381D3896)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 08:50:33 +0100
Message-ID: <1330674633.3367.3.camel@jlt3.sipsolutions.net> (sfid-20120302_085040_049894_8CE1B276)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-01 at 15:40 -0800, Javier Cardona wrote:
> Without this you won't see probe responses in an IBSS/hwsim network,
> which is convenient for testing.
> 
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index deed95f..e4b6ca6 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -47,6 +47,8 @@ static bool fake_hw_scan;
>  module_param(fake_hw_scan, bool, 0444);
>  MODULE_PARM_DESC(fake_hw_scan, "Install fake (no-op) hw-scan handler");
>  
> +static struct ieee80211_hw *txed_last_beacon;

That's definitely not right.

>  /**
>   * enum hwsim_regtest - the type of regulatory tests we offer
>   *
> @@ -821,6 +823,7 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
>  	hdr = (struct ieee80211_hdr_3addr *) skb->data;
>  	tsfpos = (__le64 *) (hdr + 1);
>  	put_unaligned(__mac80211_hwsim_get_tsf(data), tsfpos);
> +	txed_last_beacon = hw;
>  
>  	mac80211_hwsim_monitor_rx(hw, skb);
>  
> @@ -1220,6 +1223,11 @@ static void mac80211_hwsim_sw_scan_complete(struct ieee80211_hw *hw)
>  	mutex_unlock(&hwsim->mutex);
>  }
>  
> +static int mac80211_hwsim_tx_last_beacon(struct ieee80211_hw *hw)
> +{
> +	return (hw == txed_last_beacon);
> +}

And this is mostly a fancy way of saying "return 1" -- there's no beacon
backoff protocol in here, so why not just hardcode "return 1"?

johannes

