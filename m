Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976Ab1KGP3D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 10:29:03 -0500
Date: Mon, 7 Nov 2011 16:29:00 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Lukasz Jagiello <jagiello.lukasz@gmail.com>
Subject: Re: [PATCH] mac80211: disassociate when direct probe timed out
Message-ID: <20111107152859.GA5990@redhat.com> (sfid-20111107_163043_000375_8E307B8D)
References: <20111107142620.GA5852@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111107142620.GA5852@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 07, 2011 at 03:26:21PM +0100, Stanislaw Gruszka wrote:
>  	if (!skb) {
>  		cfg80211_send_auth_timeout(wk->sdata->dev, wk->filter_ta);
> +
> +		mutex_lock(&ifmgd->mtx);
> +		if (ifmgd->associated)
> +			ieee80211_set_disassoc(wk->sdata, true, false);
> +		mutex_unlock(&ifmgd->mtx);
Patch tested by Lukasz was a bit different, it first did
ieee80211_set_dissasoc() and then cfg80211_send_auth_timeout().
I changed order by accident when forward porting, I think it's better
to apply the orginal order, I'll post v2.

Stanislaw
