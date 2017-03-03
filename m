Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39694 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751757AbdCCNa4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Mar 2017 08:30:56 -0500
Message-ID: <1488544081.25750.5.camel@sipsolutions.net> (sfid-20170303_143234_785561_6143C689)
Subject: Re: [RFC] cfg80211: Add support for FILS shared key authentication
 offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        "Kanchanapally, Vidyullatha" <vkanchan@qti.qualcomm.com>
Date: Fri, 03 Mar 2017 13:28:01 +0100
In-Reply-To: <1488542006-11776-1-git-send-email-jouni@qca.qualcomm.com>
References: <1488542006-11776-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>  struct cfg80211_pmksa {
>  	const u8 *bssid;
>  	const u8 *pmkid;
> +	const u8 *pmk;
> +	size_t pmk_len;
> +	const u8 *ssid;
> +	size_t ssid_len;
> +	u16 cache_id;
>  };

So how does that work - from a flow perspective?

> +void cfg80211_connect_done(struct net_device *dev, const u8 *bssid,
> +			   struct cfg80211_bss *bss, const u8
> *req_ie,
> +			   size_t req_ie_len, const u8 *resp_ie,
> +			   size_t resp_ie_len, const u8 *fils_kek,
> +			   size_t fils_kek_len, bool
> update_erp_seq_num,
> +			   u16 fils_erp_seq_num, const u8 *pmk,
> size_t pmk_len,
> +			   const u8 *pmkid, int status, gfp_t gfp,
> +			   enum nl80211_timeout_reason
> timeout_reason);

Ouch. Please declare most of those (perhaps other than dev) as a
structure and pass a pointer here.

Also, why require the BSSID when BSS is set? Seems you could say one or
the other.

Also, what do you need the PMK for? If you have all of this stuff
offloaded, why does the host need to know the PMK?

> @@ -227,6 +227,13 @@ struct cfg80211_event {
>  			size_t req_ie_len;
>  			size_t resp_ie_len;
>  			struct cfg80211_bss *bss;
> +			const u8 *kek;
> +			size_t kek_len;
> +			bool update_erp_seq_num;
> +			u16 fils_erp_seq_num;
> +			const u8 *pmk;
> +			size_t pmk_len;
> +			const u8 *pmkid;
>  			int status; /* -1 = failed; 0..65535 =
> status code */
>  			enum nl80211_timeout_reason timeout_reason;
>  		} cr;

Could probably use the new struct from cfg80211.h that I asked to add
here then.


Other than that, most of the patch seems mechanical - I think it'd be
good to have a DOC: section or so somewhere (nl80211.h?) that explains
how this is intended to be used? I've already migrated the
documentation to the new rst/sphinx format so we can generate it nicely
and that would be a good addition - I'll probably do some more
additions too.

johannes
