Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57228 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYAZLVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 06:21:11 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH 2/2] rc80211-pid: add sanity check
Date: Sat, 26 Jan 2008 12:19:32 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Mattias Nissler <mattias.nissler@gmx.de>
References: <20080126040534.005e6736@morte>
In-Reply-To: <20080126040534.005e6736@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801261219.34805.mb@bu3sch.de> (sfid-20080126_112116_693541_9538EAE7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 26 January 2008 04:05:34 Stefano Brivio wrote:
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

Just you know, you can also do this kind of check this way:

	if (WARN_ON(newidx < 0 || newidx >= sband->n_bitrates))
		break;

This way you have an implicite unlikely() and less lines. :)
But you don't need to respin the patch. I'm also OK with the above.
This is just informational. ;)

-- 
Greetings Michael.
