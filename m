Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934205Ab0GSOd3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 10:33:29 -0400
Date: Mon, 19 Jul 2010 18:33:10 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: move QoS-enable to BSS info
Message-ID: <20100719183310.28949b46@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <1279280060.3938.23.camel@jlt3.sipsolutions.net>
References: <1279280060.3938.23.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 16 Jul 2010 13:34:20 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> Stanislaw, can you please test this? I have no legacy APs that really
> don't understand QoS frames. I suppose I could use a sniffer but maybe
> it's easier for you to just test with the AP you have?

Patch works with my legacy AP.

Tested-by: Stanislaw Gruszka <sgruszka@redhat.com>

>  	/* after reinitialize QoS TX queues setting to default,
>  	 * disable QoS at all */
on station mode.
> -	local->hw.conf.flags &=	~IEEE80211_CONF_QOS;
> -	drv_config(local, IEEE80211_CONF_CHANGE_QOS);
> +	sdata->vif.bss_conf.qos = sdata->vif.type != NL80211_IFTYPE_STATION;
> +	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_QOS);
