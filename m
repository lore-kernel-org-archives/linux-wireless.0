Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:32850 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754493AbcBZS1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 13:27:10 -0500
Date: Fri, 26 Feb 2016 20:27:06 +0200
From: Jouni Malinen <j@w1.fi>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] cfg80211: Allow a scan request for a specific BSSID
Message-ID: <20160226182706.GA22680@w1.fi> (sfid-20160226_192714_573944_7A4EA135)
References: <1456495566-14272-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456495566-14272-1-git-send-email-jouni@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 26, 2016 at 04:06:04PM +0200, Jouni Malinen wrote:
> This allows scans for a specific BSSID to be optimized by the user space
> application by requesting the driver to set the Probe Request frame
> BSSID field (Address 3) to the specified BSSID instead of the wildcard
> BSSID. This prevents other APs from replying which reduces airtime need
> and latency in getting the response from the target AP through.
> 
> This is an optimization and as such, it is acceptable for some of the
> drivers not to support the mechanism. If not supported, the wildcard
> BSSID will be used and more responses may be received.

>  include/net/cfg80211.h       | 2 ++
>  include/uapi/linux/nl80211.h | 4 +++-
>  net/wireless/nl80211.c       | 6 ++++++

> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> @@ -1471,6 +1472,7 @@ struct cfg80211_scan_request {
> +	u8 bssid[ETH_ALEN] __aligned(2);


You should know better to run all hwsim test cases before sending
patches out.. nl80211 one is not enough when we have WEXT. :)

Johannes, please drop this. I'll need to talk to myself to get a fixed
version with the two other rdev_scan() callers updated to fill in the
bssid field.

-- 
Jouni Malinen                                            PGP id EFC895FA
