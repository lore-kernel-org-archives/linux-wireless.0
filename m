Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from exchange.solarflare.com ([216.237.3.220]:55803 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756765Ab2CPUvB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 16:51:01 -0400
Message-ID: <1331931056.2504.7.camel@bwh-desktop.uk.solarflarecom.com> (sfid-20120316_215110_742333_DEB73BAC)
Subject: Re: [PATCH v2 1/4] cfg80211:  Add framework to support ethtool
 stats.
From: Ben Hutchings <bhutchings@solarflare.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Date: Fri, 16 Mar 2012 20:50:56 +0000
In-Reply-To: <1331927952-8706-1-git-send-email-greearb@candelatech.com>
References: <1331927952-8706-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-16 at 12:59 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> v2:  Fix formatting issues, add kdoc comments
> 
> :100644 100644 9ed8021... f5c8e02... M	include/net/cfg80211.h
> :100644 100644 9bde4d1... 7eecdf4... M	net/wireless/ethtool.c
>  include/net/cfg80211.h |   14 ++++++++++++++
>  net/wireless/ethtool.c |   29 +++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 9ed8021..f5c8e02 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1491,6 +1491,13 @@ struct cfg80211_gtk_rekey_data {
>   *	later passes to cfg80211_probe_status().
>   *
>   * @set_noack_map: Set the NoAck Map for the TIDs.
> + *
> + * @get_et_sset_count:  Ethtool API to get string-set count.
> + *
> + * @get_et_stats:  Ethtool API to get a set of u64 stats.
> + *
> + * @get_et_strings:  Ethtool API to get a set of strings to describe stats
> + *	and perhaps other supported types of ethtool data-sets.
[...]

Please add an explicit reference to struct ethtool_ops, where the
semantics of these operations should be described in more detail.
(There isn't currently as much detail as there should be, but any extra
information is going to be added there and not here.)

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

