Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52114 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753012Ab3LNCo7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 21:44:59 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "j@w1.fi" <j@w1.fi>, Johannes Berg <johannes.berg@intel.com>
Date: Fri, 13 Dec 2013 18:44:49 -0800
Subject: RE: [RFC] mac80211: implement HS2.0 gratuitous ARP/unsolicited NA
 dropping
Message-ID: <477F20668A386D41ADCC57781B1F70430F532572E0@SC-VEXCH1.marvell.com> (sfid-20131214_034504_662716_B1E238AF)
References: <1386010602-3916-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1386010602-3916-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Taking the gratuitous ARP/unsolicited NA detection code from
> mwifiex (but fixing it up to not have read-after-skb-end bugs),
> implement the ability for userspace to request the behaviour
> required by HS2.0 to drop gratuitous ARP and unsolicited NA
> frames when proxy ARP service is enabled on the AP. Since this
> behaviour is only mandatory for HS2.0 and may not always be
> desired, make it optional - modify cfg80211/nl80211 for that.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

[...]

> diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
> index 5c85d78..1887629 100644
> --- a/drivers/net/wireless/mwifiex/decl.h
> +++ b/drivers/net/wireless/mwifiex/decl.h
> @@ -153,12 +153,4 @@ struct mwifiex_types_wmm_info {
>  	u8 reserved;
>  	struct ieee_types_wmm_ac_parameters ac_params[IEEE80211_NUM_ACS];
>  } __packed;
> -
> -struct mwifiex_arp_eth_header {
> -	struct arphdr hdr;
> -	u8 ar_sha[ETH_ALEN];
> -	u8 ar_sip[4];
> -	u8 ar_tha[ETH_ALEN];
> -	u8 ar_tip[4];
> -} __packed;

"#include <uapi/linux/if_arp.h" in this file can be removed too.

@@ -26,7 +26,6 @@
 #include <linux/wait.h>
 #include <linux/timer.h>
 #include <linux/ieee80211.h>
-#include <uapi/linux/if_arp.h>
 #include <net/mac80211.h>


Acked-by: Bing Zhao <bzhao@marvell.com> [mwifiex]

Thanks,
Bing

