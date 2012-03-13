Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44539 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab2CMHyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 03:54:45 -0400
Subject: Re: [PATCH 2/3] cfg80211: Fill Toffset for each station
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com
In-Reply-To: <1331596020-29695-2-git-send-email-ashok@cozybit.com> (sfid-20120313_004712_885361_3D1FA6DB)
References: <1331596020-29695-1-git-send-email-ashok@cozybit.com>
	 <1331596020-29695-2-git-send-email-ashok@cozybit.com>
	 (sfid-20120313_004712_885361_3D1FA6DB)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Mar 2012 08:54:40 +0100
Message-ID: <1331625280.3329.0.camel@jlt3.sipsolutions.net> (sfid-20120313_085449_235245_8C032381)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-12 at 16:46 -0700, Ashok Nagarajan wrote:
>  		sinfo->filled |= STATION_INFO_LLID |
>  				 STATION_INFO_PLID |
> -				 STATION_INFO_PLINK_STATE;
> +				 STATION_INFO_PLINK_STATE |
> +				 STATION_INFO_T_OFFSET;
>  
>  		sinfo->llid = le16_to_cpu(sta->llid);
>  		sinfo->plid = le16_to_cpu(sta->plid);
>  		sinfo->plink_state = sta->plink_state;
> +		sinfo->t_offset = sta->t_offset;

I don't think this is a good idea. sta->t_offset is invalid when
RX_FLAG_MACTIME_MPDU was never set, so I don't think you should report
it to userspace in that case.

johannes

