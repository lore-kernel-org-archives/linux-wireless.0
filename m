Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36273 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752819AbeEYNSt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 09:18:49 -0400
Received: by mail-wr0-f196.google.com with SMTP id k5-v6so9207171wrn.3
        for <linux-wireless@vger.kernel.org>; Fri, 25 May 2018 06:18:48 -0700 (PDT)
Date: Fri, 25 May 2018 15:18:45 +0200
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Move up init of TXQs
Message-ID: <20180525131845.GA9975@localhost.localdomain> (sfid-20180525_151852_563342_647D1643)
References: <152725136177.14483.16708750819293583562.stgit@alrua-kau>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <152725136177.14483.16708750819293583562.stgit@alrua-kau>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested-by: Niklas Cassel <niklas.cassel@linaro.org>

On Fri, May 25, 2018 at 02:29:21PM +0200, Toke Høiland-Jørgensen wrote:
> On init, ieee80211_if_add() dumps the interface. Since that now includes a
> dump of the TXQ state, we need to initialise that before the dump happens.
> So move up the TXQ initialisation to to before the call to
> ieee80211_if_add().
> 
> Fixes: 52539ca89f36 ("cfg80211: Expose TXQ stats and parameters to userspace")
> Reported-by: Niklas Cassel <niklas.cassel@linaro.org>
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
> ---
>  net/mac80211/main.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 4d2e797e3f16..722f3d9fb416 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -1098,6 +1098,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  
>  	ieee80211_led_init(local);
>  
> +	result = ieee80211_txq_setup_flows(local);
> +	if (result)
> +		goto fail_flows;
> +
>  	rtnl_lock();
>  
>  	result = ieee80211_init_rate_ctrl_alg(local,
> @@ -1120,10 +1124,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  
>  	rtnl_unlock();
>  
> -	result = ieee80211_txq_setup_flows(local);
> -	if (result)
> -		goto fail_flows;
> -
>  #ifdef CONFIG_INET
>  	local->ifa_notifier.notifier_call = ieee80211_ifa_changed;
>  	result = register_inetaddr_notifier(&local->ifa_notifier);
> @@ -1149,8 +1149,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  #if defined(CONFIG_INET) || defined(CONFIG_IPV6)
>   fail_ifa:
>  #endif
> -	ieee80211_txq_teardown_flows(local);
> - fail_flows:
>  	rtnl_lock();
>  	rate_control_deinitialize(local);
>  	ieee80211_remove_interfaces(local);
> @@ -1158,6 +1156,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  	rtnl_unlock();
>  	ieee80211_led_exit(local);
>  	ieee80211_wep_free(local);
> +	ieee80211_txq_teardown_flows(local);
> + fail_flows:
>  	destroy_workqueue(local->workqueue);
>   fail_workqueue:
>  	wiphy_unregister(local->hw.wiphy);
> 
