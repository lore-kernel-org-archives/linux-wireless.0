Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:52142 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbZCYIdD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 04:33:03 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LmOXg-0002dQ-NA
	for linux-wireless@vger.kernel.org; Wed, 25 Mar 2009 08:32:56 +0000
Received: from 80-45-51-238.static.dsl.as9105.com ([80.45.51.238])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 08:32:56 +0000
Received: from Quentin by 80-45-51-238.static.dsl.as9105.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 08:32:56 +0000
To: linux-wireless@vger.kernel.org
From: Quentin Armitage <Quentin@Armitage.org.uk>
Subject: Re: [PATCH] cfg80211: fix NULL pointer deference in =?utf-8?b?cmVnX2RldmljZV9yZW1vdmUoKQ==?=
Date: Wed, 25 Mar 2009 08:32:45 +0000 (UTC)
Message-ID: <loom.20090325T082553-834@post.gmane.org> (sfid-20090325_093308_474814_6240A6D4)
References: <1237944068-3682-1-git-send-email-lrodriguez@atheros.com> <1237944068-3682-2-git-send-email-lrodriguez@atheros.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <lrodriguez@...> writes:

>  void reg_device_remove(struct wiphy *wiphy)
>  {
> -	struct wiphy *request_wiphy;
> +	struct wiphy *request_wiphy = NULL;
I think the assignment of NULL to request_wiphy is not necessary here, since
request_wiphy is set below if last_request != NULL and request_wiphy is only
tested if last_request != NULL. But then again, this function isn't called very
often.
> 
>  	assert_cfg80211_lock();
> 
> -	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
> +	if (last_request)
> +		request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
> 
>  	kfree(wiphy->regd);
>  	if (!last_request || !request_wiphy)




