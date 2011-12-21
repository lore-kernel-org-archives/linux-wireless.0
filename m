Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11510 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab1LUOyR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 09:54:17 -0500
Message-ID: <4EF1F313.1090304@qca.qualcomm.com> (sfid-20111221_155420_237729_D0D49061)
Date: Wed, 21 Dec 2011 20:24:11 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: fix scan state machine
References: <1324479072-8242-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1324479072-8242-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 December 2011 08:21 PM, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>
> when we run high bandwidth UDP traffic and we trigger a scan, the scan
> state machine seems to be looping in SUSPEND->RESUME->DECISION->SUSPEND
> and SET_CHANNEL seems to be never called as 'tx_empty' is never true
> while running UDP traffic. fix this by settting SET_CHANNEL state when
> we get into RESUME state.

Hi johannes,

i am not completely familiar with the scan state machine. used some 
previous before some of your latest changes in scan state machine and
found this might help. please let me know if this does not helps 
something. thank you!

>
> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
> ---
>   net/mac80211/scan.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index 2c5041c..2908e56 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -625,7 +625,7 @@ static void ieee80211_scan_state_resume(struct ieee80211_local *local,
>   	local->leave_oper_channel_time = jiffies;
>
>   	/* advance to the next channel to be scanned */
> -	local->next_scan_state = SCAN_DECISION;
> +	local->next_scan_state = SCAN_SET_CHANNEL;
>   }
>
>   void ieee80211_scan_work(struct work_struct *work)


-- 
thanks,
shafi
