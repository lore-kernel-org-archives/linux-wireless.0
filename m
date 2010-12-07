Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37480 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab0LGRcJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 12:32:09 -0500
Subject: Re: [PATCH 5/5] mac80211: fix issuing idle calls when device open
 count is 0
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	"pstew@google.com" <pstew@google.com>,
	"stable@kernel.org" <stable@kernel.org>
In-Reply-To: <20101207155916.GA1855@tux>
References: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
	 <1291690135-4535-6-git-send-email-lrodriguez@atheros.com>
	 <1291714709.3607.2.camel@jlt3.sipsolutions.net>
	 <AANLkTikrLweKeSR-=XziaJ5rqDRf_Ny=mg1OD=jC4nqA@mail.gmail.com>
	 <1291736887.3607.47.camel@jlt3.sipsolutions.net>
	 <AANLkTimiw074uXxe3nPTNZ0j+NtZbHJU1bwiGsFUXMJ4@mail.gmail.com>
	 <1291737298.3607.48.camel@jlt3.sipsolutions.net>
	 <20101207155916.GA1855@tux>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 18:32:01 +0100
Message-ID: <1291743121.3607.50.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-07 at 07:59 -0800, Luis R. Rodriguez wrote:

> @@ -301,7 +301,7 @@ static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
>  	}
>  
>  	mutex_lock(&local->mtx);
> -	ieee80211_recalc_idle(local);
> +	ieee80211_recalc_idle_force(local);
>  	mutex_unlock(&local->mtx);

This is the change that I don't think is necessary.

johannes

