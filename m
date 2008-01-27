Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:35640 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752846AbYA0RB4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 12:01:56 -0500
Message-ID: <479CB7A0.6090000@lwfinger.net> (sfid-20080127_170201_038386_F5D30487)
Date: Sun, 27 Jan 2008 09:56:00 -0700
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Stefano Brivio <stefano.brivio@polimi.it>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: [PATCH 2/2] rc80211-pid: add sanity check
References: <20080126040534.005e6736@morte>
In-Reply-To: <20080126040534.005e6736@morte>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefano Brivio wrote:
> From: Larry Finger <larry.finger@lwfinger.net>
> 
> Add a sanity check in rate_control_pid_adjust_rate(). Thanks to Larry Finger
> for suggesting this and reporting a related bug.
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> NOT-Signed-off-by: Larry Finger <larry.finger@lwfinger.net>
> ---
> Index: wireless-2.6/net/mac80211/rc80211_pid_algo.c
> ===================================================================
> --- wireless-2.6.orig/net/mac80211/rc80211_pid_algo.c
> +++ wireless-2.6/net/mac80211/rc80211_pid_algo.c
> @@ -128,6 +128,11 @@ static void rate_control_pid_adjust_rate
>  		}
>  
>  		newidx += back;
> +
> +		if (newidx < 0 || newidx >= sband->n_bitrates) {
> +			WARN_ON(1);
> +			break;
> +		}
>  	}
>  
>  #ifdef CONFIG_MAC80211_DEBUGFS

The bug is triggered when the following conditions are true: (1) an 802.11g device is being used on
an 802.11b network, (2) "newidx" from rate_control_pid_shift_adjust is higher than the index of 
rates used by the AP, and (3) the value of "back" is 1. The loop keeps increasing "newidx" but 
sta->supp_rates & BIT(newidx) can never be true.

Although the real cause of the bug is due to selecting a trial value for the new rate that can never 
be satisfied, I think that this sanity check is a reasonable way to detect and stop the runaway. As 
this condition is likely to affect a lot of systems, I think the WARN_ON(1) should be removed from 
the final version of the patch. With it in, a lot of logs will get spammed.

Larry



