Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55432 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab0I2SGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 14:06:38 -0400
Subject: Re: [PATCH 2/2] mac80211:  Don't go off-channel in work_work
 unless needed.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1285783383-20822-2-git-send-email-greearb@candelatech.com>
References: <1285783383-20822-1-git-send-email-greearb@candelatech.com>
	 <1285783383-20822-2-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 20:06:38 +0200
Message-ID: <1285783598.3756.31.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-29 at 11:03 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> If the work to be done is on the current active channel, then
> do not call the offchannel and return-to-channel logic.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 ae344d1... 1f2673d... M	net/mac80211/work.c
>  net/mac80211/work.c |   28 ++++++++++++++++++++--------
>  1 files changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/net/mac80211/work.c b/net/mac80211/work.c
> index ae344d1..1f2673d 100644
> --- a/net/mac80211/work.c
> +++ b/net/mac80211/work.c
> @@ -873,6 +873,7 @@ static void ieee80211_work_work(struct work_struct *work)
>  	LIST_HEAD(free_work);
>  	enum work_action rma;
>  	bool remain_off_channel = false;
> +	bool went_off_channel = false;

Heh, this is not going to work ... the return may be done in a separate
invocation of the function. Would have been nice to test this ;-)

johannes

