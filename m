Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48270 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab0FONaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 09:30:15 -0400
Date: Tue, 15 Jun 2010 09:26:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Sebastian Smolorz <Sebastian.Smolorz@gmx.de>
Cc: kalle.valo@iki.fi, linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] Changes in mac80211 to make at76c50x-usb working again
Message-ID: <20100615132619.GB12885@tuxdriver.com>
References: <201006151416.36686.Sebastian.Smolorz@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201006151416.36686.Sebastian.Smolorz@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 15, 2010 at 02:16:36PM +0200, Sebastian Smolorz wrote:
> Hi,
> 
> the at76c50x-usb driver fails to authenticate with an AP. The last working 
> major kernel version was 2.6.30. I investigated the problem and found out 
> that the driver needs to send a join command (CMD_JOIN) prior to the actual 
> authentication process. For the join command, the driver needs to know the 
> bssid of the AP. The problem is now that the mac80211 layer does not inform 
> the driver about the bssid prior to the authentication. So we have a 
> chicken-and-egg dilemma.
> 
> The following patch solves the described problem. As it modifies generic 
> mac80211 code and thus has influence on all drivers I'm open for comments on 
> how to make a proper, probably less intrusive patch.
> 
> Sebastian

Hey, thanks for giving attention to this!  See below...

> ---
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index a1bf46c..6c34b4f 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -180,17 +180,9 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
>  	if (!changed)
>  		return;
>  
> -	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
> -		/*
> -		 * While not associated, claim a BSSID of all-zeroes
> -		 * so that drivers don't do any weird things with the
> -		 * BSSID at that time.
> -		 */
> -		if (sdata->vif.bss_conf.assoc)
> -			sdata->vif.bss_conf.bssid = sdata->u.mgd.bssid;
> -		else
> -			sdata->vif.bss_conf.bssid = zero;
> -	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
> +	if (sdata->vif.type == NL80211_IFTYPE_STATION)
> +		sdata->vif.bss_conf.bssid = sdata->u.mgd.bssid;
> +	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
>  		sdata->vif.bss_conf.bssid = sdata->u.ibss.bssid;
>  	else if (sdata->vif.type == NL80211_IFTYPE_AP)
>  		sdata->vif.bss_conf.bssid = sdata->vif.addr;
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 4dad08f..b06b175 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2042,6 +2042,9 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
>  	wk->sdata = sdata;
>  	wk->done = ieee80211_probe_auth_done;
>  
> +	memcpy(sdata->u.mgd.bssid, req->bss->bssid, ETH_ALEN);
> +	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
> +
>  	ieee80211_add_work(wk);
>  	return 0;
>  }

FWIW, the code being removed from ieee80211_bss_info_change_notify
above was introduced by the following commit:

commit 9cef873798dfcdc10ff40b02abf1de935ceeba85
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Thu May 14 13:10:14 2009 +0200

    mac80211: fix managed mode BSSID handling
    
    Currently, we will ask the driver to configure right away
    when somebody changes the desired BSSID. That's totally
    strange because then we will configure the driver without
    even knowing whether the BSS exists. Change this to only
    configure the BSSID when associated, and configure a zero
    BSSID when not associated.
    
    As a side effect, this fixes an issue with the iwlwifi
    driver which doesn't implement sta_notify properly and
    uses the BSSID instead and gets very confused if the
    BSSID is cleared before we disassociate, which results
    in the warning Marcel posted [1] and iwlwifi bug 1995 [2].
    
    [1] http://thread.gmane.org/gmane.linux.kernel.wireless.general/32598
    [2] http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1995
    
    Cc: Marcel Holtmann <marcel@holtmann.org>
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

It would be best to avoid reintroducing the bug mentioned in that
commit.  Perhaps ensuring that iwlwifi's sta_notify is correct would
be worthwhile?

What other issues might be introduced from setting a non-zero BSSID
when not associated?  Will that limit scan results for any devices?
Trigger a premature auth or assoc?  Etc?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
