Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36212 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbcDFJW1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 05:22:27 -0400
Message-ID: <1459934542.17504.64.camel@sipsolutions.net> (sfid-20160406_112236_438590_EA22D9DF)
Subject: Re: [PATCHv3 RESEND 09/11] mac80211: Implement add_nan_func and
 rm_nan_func
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Wed, 06 Apr 2016 11:22:22 +0200
In-Reply-To: <1459244109-16038-9-git-send-email-emmanuel.grumbach@intel.com>
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1459244109-16038-9-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-03-29 at 12:35 +0300, Emmanuel Grumbach wrote:

> + * @rm_nan_func: Remove a nan function. The driver must call
> + * ieee80211_nan_func_terminated() with
> + * NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST reason code upon
> removal.

bad indentation.

Also here: nan -> NAN.

> +	/* Only set max_nan_de_entries as available to honor the
> device's
> +	 * limitations
> +	 */
> +	bitmap_set(sdata->u.nan.func_ids, 1,
> +		   sdata->local->hw.max_nan_de_entries);

That doesn't make a lot of sense to me. What are you trying to do?

> +	inst_id = find_first_bit(sdata->u.nan.func_ids,
> +				 IEEE80211_MAX_NAN_INSTANCE_ID + 1);
> +	if (inst_id == IEEE80211_MAX_NAN_INSTANCE_ID + 1)
> +		return -ENOBUFS;

Wouldn't you use max_nan_de_entries here instead of
MAX_NAN_INSTANCE_ID, after validating that the former is actually
smaller than or equal to the latter?

Also, the logic says that the variable should be called
"available_func_ids", although I'd prefer "used_func_ids" after
adjusting the logic according to the comments above.

> +	cfg80211_clone_nan_func_members(&func->func, nan_func);

This is quite obviously missing error checking, but see the discussion
in the patch that introduced it.

> +	spin_lock_bh(&sdata->u.nan.func_lock);
> +	clear_bit(inst_id, sdata->u.nan.func_ids);
> +	list_add(&func->list, &sdata->u.nan.functions_list);
> +	spin_unlock_bh(&sdata->u.nan.func_lock);
> +
> +	ret = drv_add_nan_func(sdata->local, sdata, nan_func);
> +	if (ret) {
> +		spin_lock_bh(&sdata->u.nan.func_lock);
> +		set_bit(inst_id, sdata->u.nan.func_ids);
> +		list_del(&func->list);
> +		spin_unlock_bh(&sdata->u.nan.func_lock);
> +
> +		cfg80211_free_nan_func_members(&func->func);
> +		kfree(func);
> +	}
> +
> +	return ret;
> +}

> +static struct ieee80211_nan_func *
> +ieee80211_find_nan_func(struct ieee80211_sub_if_data *sdata, u8
> instance_id)
> +{
> +	struct ieee80211_nan_func *func;
> +
> +	lockdep_assert_held(&sdata->u.nan.func_lock);
> +
> +	list_for_each_entry(func, &sdata->u.nan.functions_list,
> list) {
> +		if (func->func.instance_id == instance_id)
> +			return func;
> +	}
> +
> +	return NULL;
> +}

Arguably though, this whole thing just screams "idr" [1] and then you
don't even need the list_head in the cfg80211 struct.

[1] include/linux/idr.h

> +static struct ieee80211_nan_func *
> +ieee80211_find_nan_func_by_cookie(struct ieee80211_sub_if_data
> *sdata,
> +				  u64 cookie)
> +{
> +	struct ieee80211_nan_func *func;
> +
> +	lockdep_assert_held(&sdata->u.nan.func_lock);
> +
> +	list_for_each_entry(func, &sdata->u.nan.functions_list,
> list) {
> +		if (func->func.cookie == cookie)
> +			return func;
> +	}
> +
> +	return NULL;
> +}

Although this might be more difficult then, but you always
have idr_for_each_entry().

> +	case NL80211_IFTYPE_NAN:
> +		/* clean all the functions */
> +		spin_lock_bh(&sdata->u.nan.func_lock);
> +		list_for_each_entry_safe(func, tmp_func,
> +					 &sdata-
> >u.nan.functions_list, list) {
> +			list_del(&func->list);
> +			cfg80211_free_nan_func_members(&func->func);
> +			kfree(func);
> +		}
> +		spin_unlock_bh(&sdata->u.nan.func_lock);
> +		break;
>  	case NL80211_IFTYPE_P2P_DEVICE:
>  		/* relies on synchronize_rcu() below */
>  		RCU_INIT_POINTER(local->p2p_sdata, NULL);
>  		/* fall through */
> -	case NL80211_IFTYPE_NAN:

any particular reason you're moving the case label?

>  	default:
>  		cancel_work_sync(&sdata->work);
>  		/*
> @@ -1453,9 +1464,15 @@ static void ieee80211_setup_sdata(struct
> ieee80211_sub_if_data *sdata,
>  	case NL80211_IFTYPE_WDS:
>  		sdata->vif.bss_conf.bssid = NULL;
>  		break;
> +	case NL80211_IFTYPE_NAN:
> +		bitmap_zero(sdata->u.nan.func_ids,
> +			    IEEE80211_MAX_NAN_INSTANCE_ID + 1);
> +		INIT_LIST_HEAD(&sdata->u.nan.functions_list);
> +		spin_lock_init(&sdata->u.nan.func_lock);
> +		sdata->vif.bss_conf.bssid = sdata->vif.addr;
> +		break;
>  	case NL80211_IFTYPE_AP_VLAN:
>  	case NL80211_IFTYPE_P2P_DEVICE:
> -	case NL80211_IFTYPE_NAN:

also here?

> +	if (!local->hw.max_nan_de_entries)
> +		local->hw.max_nan_de_entries =
> IEEE80211_MAX_NAN_INSTANCE_ID;

Need a max check also, I guess?

> +/* TODO: record more fields */

...
but isn't cfg80211 recording them anyway?

> +static int ieee80211_reconfig_nan(struct ieee80211_sub_if_data
> *sdata)
> +{
> +	struct ieee80211_nan_func *func, *ftmp;
> +	LIST_HEAD(tmp_list);
> +	int res;
> +
> +	res = drv_start_nan(sdata->local, sdata,
> +			    &sdata->u.nan.nan_conf);
> +	if (WARN_ON(res))
> +		return res;
> +
> +	/* Add all the functions:
> +	 * This is a little bit ugly. We need to call a potentially
> sleeping
> +	 * callback for each entry in the list, so we can't hold the
> spinlock.

Nobody forced you to use a spinlock though??

johannes
