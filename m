Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vserver.eikelenboom.it ([84.200.39.61]:40555 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaDQMHp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 08:07:45 -0400
Date: Thu, 17 Apr 2014 14:07:40 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Message-ID: <19510493295.20140417140740@eikelenboom.it> (sfid-20140417_140750_823488_0F069CEE)
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	<colleen@cozybit.com>, <mcgrof@do-not-panic.com>
Subject: Re: [PATCH] cfg80211: avoid freeing last_request while in flight
In-Reply-To: <1397646587-11078-1-git-send-email-arik@wizery.com>
References: <1397646587-11078-1-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Could you put whatever (combination of) patches you see fit into you -next 
tree .. so i can retest what will hopefully go upstream in the next mergewindow.
I think that will also increase further testcoverage (and if something else 
arise it gives time to fix it before the next mergewindow). It would be nice
if it would make it this time around ...

--
Sander


Wednesday, April 16, 2014, 1:09:47 PM, you wrote:

> Avoid freeing the last request while it is being processed. This can
> happen in some cases if reg_work is kicked for some reason while the
> currently pending request is in flight.

> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
> This is to be applied on top of
> "cfg80211: fix processing world regdomain when non modular"

>  net/wireless/reg.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)

> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index f59aaac..5ec04dc 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -240,8 +240,16 @@ static char user_alpha2[2];
>  module_param(ieee80211_regdom, charp, 0444);
>  MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
>  
> -static void reg_free_request(struct regulatory_request *lr)
> +static void reg_free_request(struct regulatory_request *request)
>  {
> +       if (request != get_last_request())
> +               kfree(request);
> +}
> +
> +static void reg_free_last_request(void)
> +{
> +       struct regulatory_request *lr = get_last_request();
> +
>         if (lr != &core_request_world && lr)
>                 kfree_rcu(lr, rcu_head);
>  }
> @@ -254,7 +262,7 @@ static void reg_update_last_request(struct regulatory_request *request)
>         if (lr == request)
>                 return;
>  
> -       reg_free_request(lr);
> +       reg_free_last_request();
>         rcu_assign_pointer(last_request, request);
>  }
>  
> @@ -1616,7 +1624,7 @@ reg_process_hint_user(struct regulatory_request *user_request)
>         treatment = __reg_process_hint_user(user_request);
>         if (treatment == REG_REQ_IGNORE ||
>             treatment == REG_REQ_ALREADY_SET) {
> -               kfree(user_request);
> +               reg_free_request(user_request);
>                 return treatment;
>         }
>  
> @@ -1676,14 +1684,14 @@ reg_process_hint_driver(struct wiphy *wiphy,
>         case REG_REQ_OK:
>                 break;
>         case REG_REQ_IGNORE:
> -               kfree(driver_request);
> +               reg_free_request(driver_request);
>                 return treatment;
>         case REG_REQ_INTERSECT:
>                 /* fall through */
>         case REG_REQ_ALREADY_SET:
>                 regd = reg_copy_regd(get_cfg80211_regdom());
>                 if (IS_ERR(regd)) {
> -                       kfree(driver_request);
> +                       reg_free_request(driver_request);
>                         return REG_REQ_IGNORE;
>                 }
>                 rcu_assign_pointer(wiphy->regd, regd);
> @@ -1777,10 +1785,10 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
>         case REG_REQ_IGNORE:
>                 /* fall through */
>         case REG_REQ_ALREADY_SET:
> -               kfree(country_ie_request);
> +               reg_free_request(country_ie_request);
>                 return treatment;
>         case REG_REQ_INTERSECT:
> -               kfree(country_ie_request);
> +               reg_free_request(country_ie_request);
>                 /*
>                  * This doesn't happen yet, not sure we
>                  * ever want to support it for this case.
> @@ -1841,7 +1849,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
>         return;
>  
>  out_free:
> -       kfree(reg_request);
> +       reg_free_request(reg_request);
>  }
>  
>  /*

