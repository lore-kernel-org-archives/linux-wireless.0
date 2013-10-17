Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab3JQNo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 09:44:59 -0400
Message-ID: <1382017495.14410.4.camel@jlt4.sipsolutions.net> (sfid-20131017_154502_148628_93FD44DC)
Subject: Re: [PATCH] mac80211_hwsim: Add iface comb for DFS
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 17 Oct 2013 15:44:55 +0200
In-Reply-To: <1381773079-2678-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131014_195135_973970_61B866A6)
References: <1381773079-2678-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131014_195135_973970_61B866A6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-14 at 19:51 +0200, Janusz Dziedzic wrote:
> Add iface combination that allow DFS support.
> Add also debugfs dfs_simulate_radar file that
> can be used to simulate radar event.
> This could be usefull for mac80211/cfg80211/

typo: useful

> @@ -1714,6 +1716,7 @@ static void mac80211_hwsim_free(void)
>  
>  	list_for_each_entry_safe(data, tmpdata, &tmplist, list) {
>  		debugfs_remove(data->debugfs_group);
> +		debugfs_remove(data->debugfs_radar);

I think it would be good to convert to debugfs_remove_recursive first -
that avoids the need for the new dentry pointer as well as the remove
here. Can you do that (as a separate patch)?

> +static int hwsim_write_simulate_radar(void *dat, u64 val)
> +{
> +	struct mac80211_hwsim_data *data = dat;
> +
> +	ieee80211_radar_detected(data->hw);
> +
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(hwsim_simulate_radar, NULL,
> +			hwsim_write_simulate_radar, "%llu\n");

Does the u64 make sense? Probably doesn't matter much, but seems weird
to be so specific for a file that really doesn't care about the value?
 
johannes

