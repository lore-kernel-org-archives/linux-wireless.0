Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22975 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0CPWev (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Mar 2010 18:34:51 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 16 Mar 2010 15:34:51 -0700
Date: Tue, 16 Mar 2010 15:33:38 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] wireless: convert reg_regdb_search_lock to mutex
Message-ID: <20100316100337.GA1732@senthil-lnx.users.atheros.com>
References: <4B9F86E9.2030702@gmail.com>
 <1268768940-5654-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1268768940-5654-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 17, 2010 at 01:19:00AM +0530, John W. Linville wrote:
> Stanse discovered that kmalloc can be called with GFP_KERNEL while
This commit log is confusing. It Should be "Stanse discovered kmalloc
was called with GFP_KERNEL". Obviously kmalloc with GFP_KERNEL shouldn't
be used while holding a spinlock.
> holding this spinlock.  It can be a mutex instead.
> 
> Reported-by: Jiri Slaby <jirislaby@gmail.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> Hmmm...I think I can get rid of the unlock of reg_regdb_search_mutex
> before calling set_regdom now as well?
> 
>  net/wireless/reg.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index ed89c59..5f623ed 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -324,7 +324,7 @@ struct reg_regdb_search_request {
>  };
>  
>  static LIST_HEAD(reg_regdb_search_list);
> -static DEFINE_SPINLOCK(reg_regdb_search_lock);
> +static DEFINE_MUTEX(reg_regdb_search_mutex);
>  
>  static void reg_regdb_search(struct work_struct *work)
>  {
> @@ -332,7 +332,7 @@ static void reg_regdb_search(struct work_struct *work)
>  	const struct ieee80211_regdomain *curdom, *regdom;
>  	int i, r;
>  
> -	spin_lock(&reg_regdb_search_lock);
> +	mutex_lock(&reg_regdb_search_mutex);
>  	while (!list_empty(&reg_regdb_search_list)) {
>  		request = list_first_entry(&reg_regdb_search_list,
>  					   struct reg_regdb_search_request,
> @@ -346,18 +346,18 @@ static void reg_regdb_search(struct work_struct *work)
>  				r = reg_copy_regd(&regdom, curdom);
>  				if (r)
>  					break;
> -				spin_unlock(&reg_regdb_search_lock);
> +				mutex_unlock(&reg_regdb_search_mutex);
>  				mutex_lock(&cfg80211_mutex);
>  				set_regdom(regdom);
>  				mutex_unlock(&cfg80211_mutex);
> -				spin_lock(&reg_regdb_search_lock);
> +				mutex_lock(&reg_regdb_search_mutex);
>  				break;
>  			}
>  		}
>  
>  		kfree(request);
>  	}
> -	spin_unlock(&reg_regdb_search_lock);
> +	mutex_unlock(&reg_regdb_search_mutex);
>  }
>  
>  static DECLARE_WORK(reg_regdb_work, reg_regdb_search);
> -- 
> 1.6.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
