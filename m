Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24787 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab3IQMZj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 08:25:39 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] cfg80211: don't start p2p device while in RFKILL
Date: Tue, 17 Sep 2013 12:25:21 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301DB0C3D@HASMSX103.ger.corp.intel.com> (sfid-20130917_142542_884279_456C8A21)
References: <1379420619-6123-1-git-send-email-emmanuel.grumbach@intel.com>
In-Reply-To: <1379420619-6123-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Grumbach, Emmanuel
> Sent: Tuesday, September 17, 2013 3:24 PM
> To: linux-wireless@vger.kernel.org
> Cc: Grumbach, Emmanuel
> Subject: [PATCH] cfg80211: don't start p2p device while in RFKILL
> 
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  net/wireless/nl80211.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c index
> 316503f..6bb03b5 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -8666,6 +8666,9 @@ static int nl80211_start_p2p_device(struct sk_buff
> *skb, struct genl_info *info)
>  	if (err)
>  		return err;
> 
> +	if (rfkill_blocked(rdev->rfkill))
> +		return -ERFKILL;
> +
>  	err = rdev_start_p2p_device(rdev, wdev);
>  	if (err)
>  		return err;

This is bad... obviously I need to test that before I add the interface... v2 on the way
