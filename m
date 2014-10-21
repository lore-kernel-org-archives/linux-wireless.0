Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45506 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026AbaJUTmp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 15:42:45 -0400
Message-ID: <1413920556.1998.26.camel@jlt4.sipsolutions.net> (sfid-20141021_214247_922341_3B3BE9AE)
Subject: Re: [PATCH v2 6/6] cfg80211: support configuring vdev mac addr on
 create.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Oct 2014 21:42:36 +0200
In-Reply-To: <1413845378-27837-6-git-send-email-greearb@candelatech.com>
References: <1413845378-27837-1-git-send-email-greearb@candelatech.com>
	 <1413845378-27837-6-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Same comment regarding "vdev", here starting from the subject.

Also, this patch isn't purely cfg80211 - should probably split it into
cfg80211 and mac80211 parts?

On Mon, 2014-10-20 at 15:49 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This is useful when creating virtual-stations, and probably
> APs and other devices as well.

It clearly is - imho worth rephrasing as just "when creating virtual
interfaces" :-)

> +++ b/include/net/cfg80211.h
> @@ -319,9 +319,9 @@ struct ieee80211_supported_band {
>  /**
>   * struct vif_params - describes virtual interface parameters
>   * @use_4addr: use 4-address frames
> - * @macaddr: address to use for this virtual interface. This will only
> - * 	be used for non-netdevice interfaces. If this parameter is set
> - * 	to zero address the driver may determine the address as needed.
> + * @macaddr: address to use for this virtual interface.
> + *	If this parameter is set to zero address the driver may
> + *	determine the address as needed.


Maybe point to the feature flag here.

> + * @NL80211_FEATURE_MAC_ON_CREATE: Device supports configuring
> + *	the vdev's MAC address upon creation.

Maybe point to the attribute that's used for that here?

johannes

