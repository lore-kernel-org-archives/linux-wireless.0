Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44846 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab2CPMyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 08:54:14 -0400
Subject: Re: [RFC 2/3] mac80211: protect ->scanning by mutex in
 ieee80211_work_work()
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1331899378-10543-2-git-send-email-sgruszka@redhat.com>
References: <1331899378-10543-1-git-send-email-sgruszka@redhat.com>
	 <1331899378-10543-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Mar 2012 13:54:13 +0100
Message-ID: <1331902453.6753.4.camel@jlt3.sipsolutions.net> (sfid-20120316_135418_570282_ABB801AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't really see the point in this. It seems that this doesn't really
help, you'd actually have to protect all the work stuff here with the
mutex so the scanning can also be excluded or so?

johannes

On Fri, 2012-03-16 at 13:02 +0100, Stanislaw Gruszka wrote:
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  net/mac80211/work.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/work.c b/net/mac80211/work.c
> index 1f74af3..b2650a9 100644
> --- a/net/mac80211/work.c
> +++ b/net/mac80211/work.c
> @@ -122,9 +122,6 @@ static void ieee80211_work_work(struct work_struct *work)
>  	enum work_action rma;
>  	bool remain_off_channel = false;
>  
> -	if (local->scanning)
> -		return;
> -
>  	/*
>  	 * ieee80211_queue_work() should have picked up most cases,
>  	 * here we'll pick the rest.
> @@ -134,6 +131,11 @@ static void ieee80211_work_work(struct work_struct *work)
>  
>  	mutex_lock(&local->mtx);
>  
> +	if (local->scanning) {
> +		mutex_unlock(&local->mtx);
> +		return;
> +	}
> +
>  	ieee80211_recalc_idle(local);
>  
>  	list_for_each_entry_safe(wk, tmp, &local->work_list, list) {


