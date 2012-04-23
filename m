Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab2DWKzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 06:55:53 -0400
Message-ID: <1335178551.3928.17.camel@jlt3.sipsolutions.net> (sfid-20120423_125559_815317_9C6D0BB4)
Subject: Re: [PATCH] mac80211: call ieee80211_mgd_teardown() on interface
 stop
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 23 Apr 2012 12:55:51 +0200
In-Reply-To: <1335178079-4736-1-git-send-email-eliad@wizery.com> (sfid-20120423_124817_444803_4B65CA6D)
References: <1335178079-4736-1-git-send-email-eliad@wizery.com>
	 (sfid-20120423_124817_444803_4B65CA6D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-23 at 13:47 +0300, Eliad Peller wrote:
> ieee80211_mgd_teardown() is called on netdev removal, which
> occurs after the vif was already removed from the low-level
> driver, resulting in the following warning:

> Fix it by calling ieee80211_mgd_teardown() on ieee80211_do_stop().

Would you rename it to mgd_stop() as well maybe? The "teardown" name is
pretty specific here.

> +++ b/net/mac80211/iface.c
> @@ -649,6 +649,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  		if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
>  			ieee80211_bss_info_change_notify(sdata,
>  				BSS_CHANGED_BEACON_ENABLED);
> +		else if (sdata->vif.type == NL80211_IFTYPE_STATION)
> +			ieee80211_mgd_teardown(sdata);

Could there be a case where the teardown could start a work item? It
might be better to make this part of the switch, and fall through to
flush_work() etc.?

johannes

