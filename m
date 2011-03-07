Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1CGOW7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 09:22:59 -0500
Date: Mon, 7 Mar 2011 15:22:42 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Ben Greear <greearb@candelatech.com>
Subject: Re: WARN_ON in ieee80211_scan_completed_finish triggered
Message-ID: <20110307142241.GB9571@redhat.com>
References: <1299443142.1292.6.camel@marge>
 <1299491485.3790.2.camel@jlt3.sipsolutions.net>
 <1299498147.5665.3.camel@marge>
 <1299499400.3790.8.camel@jlt3.sipsolutions.net>
 <1299503693.6739.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1299503693.6739.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 07, 2011 at 02:14:53PM +0100, Johannes Berg wrote:
>  	on_oper_chan = ieee80211_cfg_on_oper_channel(local);
>  
>  	WARN_ON(local->scanning & (SCAN_SW_SCANNING | SCAN_HW_SCANNING));
Not needed, just zeroed local->scanning.

> @@ -332,7 +321,6 @@ static void __ieee80211_scan_completed_f
>  	}
>  
>  	ieee80211_recalc_idle(local);
> -	mutex_unlock(&local->mtx);
>  
>  	ieee80211_mlme_notify_scan_completed(local);
>  	ieee80211_ibss_notify_scan_completed(local);
I'm a bit worried about calling these with mutex.

Stanislaw
