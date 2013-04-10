Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:32645 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3DJHuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 03:50:00 -0400
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v4 1/2] cfg80211: P2P find phase offload
Date: Wed, 10 Apr 2013 10:49:37 +0300
Message-ID: <4688331.yiSjqMZEZk@lx-vladimir> (sfid-20130410_095009_179718_09371582)
In-Reply-To: <1363863994-32510-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1363863994-32510-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, March 21, 2013 01:06:34 PM Vladimir Kondratiev wrote:
> Allow to implement P2P find phase in the driver/firmware.
> 
> Offload scheme designed as follows:
> 
> - Driver provide methods start_p2p_find and stop_p2p_find in the cfg80211_ops;
> - Driver indicate firmware or driver responds to the probe requests by setting
>   feature NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD
> - wpa_supplicant analyses methods supported to discover p2p offload support;
> - wpa_supplicant analyses feature flags to discover p2p probe response
>   offload support;
> to perform p2p scan, wpa_supplicant:
> - perform legacy scan, through driver's cfg80211_ops 'scan' method
> - configure rx management filter to get probe-request and probe-response frames
> - start p2p find via driver's cfg80211_ops start_p2p_find method
> - driver start p2p find with hardware and notify wpa_supplicant with
>   cfg80211_p2p_find_notify_start()
> - driver/firmware toggle search/listen states. Received probe-request and
>   probe-response frames passed to the wpa_supplicant via cfg80211_rx_mgmt
> - when wpa_supplicant wants to stop p2p find, it calls driver's
>   cfg80211_ops stop_p2p_find method. Alternatively, driver/firmware may decide
>   to stop p2p find. In all cases, driver notifies wpa_supplicant using
>   cfg80211_p2p_find_notify_end()
> 
> All driver to user space communication done through nl80211 layer.
> 
> Offloaded P2P find does not support variations like progressive scan.
> 
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> ---
>  include/net/cfg80211.h       |   60 +++++++++++++++
>  include/uapi/linux/nl80211.h |   13 ++++
>  net/wireless/nl80211.c       |  167 ++++++++++++++++++++++++++++++++++++++++++
>  net/wireless/rdev-ops.h      |   19 +++++
>  net/wireless/trace.h         |   34 +++++++++
>  5 files changed, 293 insertions(+)
> 

Hi Johannes,

Could you please comment on this patch status? I was under impression
I did all as we discussed and it is going to be merged, but maybe I
missed something. I was on long vacation.

Do you want me to rebase and resend?

Thanks, Vladimir


