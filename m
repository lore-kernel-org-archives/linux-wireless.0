Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38738 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab3HPKZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 06:25:21 -0400
Message-ID: <1376648716.15299.5.camel@jlt4.sipsolutions.net> (sfid-20130816_122528_762276_DBFB66C7)
Subject: Re: [PATCHv2 2/6] mac80211: split off channel switch parsing
 function
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 16 Aug 2013 12:25:16 +0200
In-Reply-To: <1376058920-17779-3-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1376058920-17779-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1376058920-17779-3-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-09 at 16:35 +0200, Simon Wunderlich wrote:

> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -981,54 +981,35 @@ static void ieee80211_chswitch_timer(unsigned long data)
>  	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.chswitch_work);
>  }
>  
> -static void
> -ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
> -				 u64 timestamp, struct ieee802_11_elems *elems,
> -				 bool beacon)
> +int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,

I think you should also move this function out of mlme.c, maybe the
(almost empty) spectmgmt.c file?

> +				 struct ieee802_11_elems *elems, bool beacon,
> +				 enum ieee80211_band current_band,
> +				 u32 sta_flags,

Passing sta_flags seems a bit odd - I understand the motivation but I
think it would be worthwhile to document (maybe in the kernel-doc in the
header file) which flags are used.

johannes

