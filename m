Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60830 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2FIIpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 04:45:18 -0400
Message-ID: <1339231515.4539.30.camel@jlt3.sipsolutions.net> (sfid-20120609_104523_334524_6C675176)
Subject: Re: [PATCH v2 2/4] mac80211: implement the proactive PREQ generation
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Date: Sat, 09 Jun 2012 10:45:15 +0200
In-Reply-To: <1339043963-2043-3-git-send-email-yeohchunyeow@gmail.com> (sfid-20120607_063951_474534_792C09FB)
References: <1339043963-2043-1-git-send-email-yeohchunyeow@gmail.com>
	 <1339043963-2043-3-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120607_063951_474534_792C09FB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-07 at 12:39 +0800, Chun-Yeow Yeoh wrote:

> + * @IEEE80211_NO_ROOT: the mesh STA is not a root mesh STA (default)
> + * @IEEE80211_PROACTIVE_PREQ_NO_PREP: the mesh STA is a root mesh STA
> + * supports the proactive PREQ with proactive PREP subfield set to 0

please indent to make it readable

>  	mesh_path_tx_root_frame(sdata);
> +	interval = (ifmsh->mshcfg.dot11MeshHWMPRootMode ==
> +	    IEEE80211_PROACTIVE_RANN) ? ifmsh->mshcfg.dot11MeshHWMPRannInterval
> +	    : ifmsh->mshcfg.dot11MeshHWMProotInterval;

that's a horrible way to write this, I suppose an if statement could
actually be readable :-)

> +++ b/net/mac80211/mesh_hwmp.c
> @@ -33,9 +33,11 @@
>  /* Reply and forward */
>  #define MP_F_RF	0x2
>  /* Unknown Sequence Number */
> -#define MP_F_USN    0x01
> +#define MP_F_USN    0x04
>  /* Reason code Present */
>  #define MP_F_RCODE  0x02
> +/* Proactive PREQ with PREP */
> +#define PREQ_F_PREP 0x04

Should all of this really be here rather than in ieee80211.h?

johannes

