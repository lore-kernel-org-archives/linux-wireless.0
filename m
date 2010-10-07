Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab0JGGNt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 02:13:49 -0400
Date: Thu, 7 Oct 2010 08:15:16 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: avoid uninitialized var warning in
 ieee80211_scan_cancel
Message-ID: <20101007061515.GA25616@redhat.com>
References: <1286397743-21687-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1286397743-21687-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 06, 2010 at 04:42:23PM -0400, John W. Linville wrote:
> net/mac80211/scan.c: In function ‘ieee80211_scan_cancel’:
> net/mac80211/scan.c:794: warning: ‘finish’ may be used uninitialized in this function
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Hi John

What compiler are you using? I have no warning with gcc 4.4.4 from RHEL6.
That's correct, as "finish" variable can not be uninitialized, because is used
only when abortscan == true;

> +	bool finish = false;
>  
>  	/*
>  	 * We are only canceling software scan, or deferred scan that was not
> @@ -818,7 +819,7 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
>  	if (abortscan) {
>  		/* The scan is canceled, but stop work from being pending */
>  		cancel_delayed_work_sync(&local->scan_work);
> -		if (finish)
> -			__ieee80211_scan_completed_finish(&local->hw, false);
>  	}
> +	if (finish)
> +		__ieee80211_scan_completed_finish(&local->hw, false);
>  }

I have nothing against the patch, but this seems to be compiler problem,
not our code.

Stanislaw
