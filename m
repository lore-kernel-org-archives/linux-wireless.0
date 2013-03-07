Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53094 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab3CGK37 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 05:29:59 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UDY5B-0006MG-LG
	for linux-wireless@vger.kernel.org; Thu, 07 Mar 2013 11:29:54 +0100
Message-ID: <1362652189.8694.29.camel@jlt4.sipsolutions.net> (sfid-20130307_113009_312298_59BC8076)
Subject: Re: [PATCH 3/3] mac80211: batch key free synchronize_net()
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 07 Mar 2013 11:29:49 +0100
In-Reply-To: <1362652067-14903-3-git-send-email-johannes@sipsolutions.net> (sfid-20130307_112756_625579_02BAA0CA)
References: <1362652067-14903-1-git-send-email-johannes@sipsolutions.net>
	 <1362652067-14903-3-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130307_112756_625579_02BAA0CA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-03-07 at 11:27 +0100, Johannes Berg wrote:

>  void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
>  {
>  	struct ieee80211_key *key, *tmp;
> +	LIST_HEAD(keys);
>  
>  	cancel_delayed_work_sync(&sdata->dec_tailroom_needed_wk);
>  
> @@ -571,17 +578,61 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
>  
>  	ieee80211_debugfs_key_remove_mgmt_default(sdata);
>  
> -	list_for_each_entry_safe(key, tmp, &sdata->key_list, list)
> -		ieee80211_key_free(key, false);
> +	list_for_each_entry_safe(key, tmp, &sdata->key_list, list) {
> +		ieee80211_key_replace(key->sdata, key->sta,
> +				key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
> +				key, NULL);
> +		list_add_tail(&key->list, &keys);
> +	}
>  
>  	ieee80211_debugfs_key_update_default(sdata);
>  
> +	synchronize_net();
> +	list_for_each_entry_safe(key, tmp, &keys, list)
> +		__ieee80211_key_destroy(key, false);

Since it's likely that there are no keys, I'll change this:

 	ieee80211_debugfs_key_update_default(sdata);
 
-	synchronize_net();
-	list_for_each_entry_safe(key, tmp, &keys, list)
-		__ieee80211_key_destroy(key, false);
+	if (!list_empty(&keys)) {
+		synchronize_net();
+		list_for_each_entry_safe(key, tmp, &keys, list)
+			__ieee80211_key_destroy(key, false);
+	}
 
 	WARN_ON_ONCE(sdata->crypto_tx_tailroom_needed_cnt ||
 		     sdata->crypto_tx_tailroom_pending_dec);


johannes

