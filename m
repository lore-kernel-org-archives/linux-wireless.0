Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbaBUOjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 09:39:13 -0500
Message-ID: <1392993530.4346.49.camel@jlt4.sipsolutions.net> (sfid-20140221_153920_772076_3C8392B6)
Subject: Re: [PATCH 1/1] rtlwifi: Convert drivers to use new API for
 ieee80211_is_robust_mgmt_frame()
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Date: Fri, 21 Feb 2014 15:38:50 +0100
In-Reply-To: <1392993211-3848-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140221_153342_109062_89D3C0C6)
References: <1392993211-3848-1-git-send-email-Larry.Finger@lwfinger.net>
	 (sfid-20140221_153342_109062_89D3C0C6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-02-21 at 08:33 -0600, Larry Finger wrote:
> Drivers rtl8188ee, rtl8192ce, rtl8192se, and rtl8723ae all use this routine.
> In addition, all callers of ieee80211_is_robust_mgmt_frame() have access to the
> skb. Thus, it is trivial to use the new API rather than the underscored old version.

Unfortunately, I'm pretty sure this is incorrect. I looked at this code
before, and take for example:

> +++ b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
> @@ -334,8 +334,8 @@ bool rtl8723ae_rx_query_desc(struct ieee80211_hw *hw,
>  			/* during testing, hdr could be NULL here */
>  			return false;
>  		}
> -		if ((_ieee80211_is_robust_mgmt_frame(hdr)) &&
> -			(ieee80211_has_protected(hdr->frame_control)))
> +		if ((ieee80211_is_robust_mgmt_frame(skb)) &&
> +		    (ieee80211_has_protected(hdr->frame_control)))

Here, hdr is set like this:

                hdr = (struct ieee80211_hdr *)(skb->data +
                       status->rx_drvinfo_size + status->rx_bufshift);  

so the skb clearly contains something else before the hdr, and the
conversion is probably not right because it assumes hdr == skb->data,
where here it isn't that but instead (skb->data + something).

johannes

