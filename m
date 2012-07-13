Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50978 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab2GMMux (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 08:50:53 -0400
Message-ID: <1342183848.4452.1.camel@jlt3.sipsolutions.net> (sfid-20120713_145120_606796_3C75BDA3)
Subject: Re: [PATCH] cfg80211: fix set_regdom() to cancel requests with same
 alpha2
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 13 Jul 2012 14:50:48 +0200
In-Reply-To: <20120712123358.22054.62538.stgit@localhost6.localdomain6> (sfid-20120712_143407_357227_CA39EE4B)
References: <20120712123358.22054.62538.stgit@localhost6.localdomain6>
	 (sfid-20120712_143407_357227_CA39EE4B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis?

>  		if (!regdom_changes(rd->alpha2))
> -			return -EINVAL;
> +			return -EALREADY;
>  	}
>  
>  	/*
> @@ -2325,6 +2325,9 @@ int set_regdom(const struct ieee80211_regdomain *rd)
>  	/* Note that this doesn't update the wiphys, this is done below */
>  	r = __set_regdom(rd);
>  	if (r) {
> +		if (r == -EALREADY)
> +			reg_set_request_processed();
> +

I'm not really sure I like the reliance on the error code ... would it
make more sense to invent a status enum? Or just return 0 to start with?

johannes

