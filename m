Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49937 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab3GKI7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 04:59:47 -0400
Message-ID: <1373533184.8201.8.camel@jlt4.sipsolutions.net> (sfid-20130711_105950_335715_D229D5F0)
Subject: Re: [WT PATCH 6/6] mac80211: Tell user why beacons fail to parse.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Jul 2013 10:59:44 +0200
In-Reply-To: <1372546738-25827-6-git-send-email-greearb@candelatech.com> (sfid-20130630_005952_096446_C7F6AD26)
References: <1372546738-25827-1-git-send-email-greearb@candelatech.com>
	 <1372546738-25827-6-git-send-email-greearb@candelatech.com>
	 (sfid-20130630_005952_096446_C7F6AD26)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-06-29 at 15:58 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Should help better debug dodgy APs and such.

This isn't a bad idea, but I think instead of storing the message:

> @@ -110,6 +110,7 @@ struct ieee80211_bss {
>  
>  	/* Keep track of what bits of information we have valid info for. */
>  	u8 valid_data;
> +	char corrupt_elems_msg[80];

you should store a "what's bad" type field and the broken IE number or
so, to reduce memory usage

> @@ -4341,8 +4341,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
>  				corrupt_type = "beacon";
>  		} else if (bss->corrupt_data & IEEE80211_BSS_CORRUPT_PROBE_RESP)
>  			corrupt_type = "probe response";
> -		sdata_info(sdata, "associating with AP with corrupt %s\n",
> -			   corrupt_type);
> +		sdata_info(sdata, "associating with AP with corrupt %s, reason: %s\n",
> +			   corrupt_type, bss->corrupt_elems_msg);

and only actually format the message here. That also reduces overhead
during beacon/probe response processing.
 
> +				snprintf(elems->parse_err_msg,
> +					 sizeof(elems->parse_err_msg),
> +					 "seen id: %i already", id);

Your snprintf() usage is also unsafe.

johannes

