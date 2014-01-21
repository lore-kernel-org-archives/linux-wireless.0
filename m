Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:33553 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754712AbaAUN7x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 08:59:53 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [RFC 0/5] Export Minstrel best API information via get_station()
From: =?iso-8859-1?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>
Date: Tue, 21 Jan 2014 14:52:53 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <28926A5E-E0FA-4677-BC0C-68E5E11C188F@net.t-labs.tu-berlin.de> (sfid-20140121_145956_492623_8EC07EDE)
References: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>
To: Antonio Quartulli <antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Antonio,

I like you idea of making use of information from different layers to try to enhance wireless communication. 
It seems reasonable for me to start exporting and further using/experimenting with that rate, where minstrel estimates the maximum throughput.
But on closer inspection, it might also be of certain interest (maybe not batman in particular) to use the most robust rate, which both Minstrels version do also have an estimate.
So what do you think about exporting the whole sorted rate table structure (struct ieee80211_sta_rates) instead of extracting the single max thr. rate ?

Greetings Thomas


On 21.01.2014, at 12:09, Antonio Quartulli <antonio@meshcoding.com> wrote:

> Hello list,
> 
> we (as batman-adv developers) are currently working on a new version of the
> our routing protocol which is going to use some Minstrel internal information
> to compute the metric.
> In particular I am interested in the currently selected bitrate (which Minstrel
> selected because it "maximises the throughput") and it's probability of success.
> 
> To achieve so I am proposing here a change to the get_station API.
> This change is supposed to export the needed information only if the current
> driver is using the Minstrel (or Minstrel HT) RC algorithm.
> 
> Patch 1 introduced the change in get_station()
> Patch 2 add a new rate_control API used to query the RC algorithm and retrieve
>        the information. Then it fills the sinfo object.
> Patch 3 and 4 are implementing this rate_control API in minstrel and minstrel_ht
> Patch 5 exports the get_station API in order to allow other modules to use it.
> 
> 
> I already had a discussion with Johannes about this patch being not generic
> enough and really focussed on Minstrel only.
> 
> However this change will just
> introduce a new exported capability in the station_info object: if the driver
> does not support it (e.g. it does not use Minstrel) then we simply won't have
> this information (like we already do with other capabilities).
> 
> 
> Cheers,
> 
> p.s. I may need to add some more kerneldoc
> 
> 
> Antonio Quartulli (5):
>  cfg80211: export minstrel best rate information through get_station()
>  mac80211: export minstrel best rate information in set_sta_info()
>  mac80211: minstrel - implement get_minstrel_best_rate() API
>  mac80211: minstrel_ht - implement get_minstrel_best_rate() API
>  cfg80211: implement cfg80211_get_station
> 
> include/net/cfg80211.h             | 28 ++++++++++++++++++++++++++++
> include/net/mac80211.h             | 15 +++++++++++++++
> net/mac80211/cfg.c                 | 15 +++++++++++++++
> net/mac80211/rc80211_minstrel.c    | 12 ++++++++++++
> net/mac80211/rc80211_minstrel_ht.c | 30 ++++++++++++++++++++++++++++++
> net/wireless/nl80211.c             | 22 ++++++++++++++++++++++
> 6 files changed, 122 insertions(+)
> 
> -- 
> 1.8.5.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

