Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43563 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279Ab0IJPz5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 11:55:57 -0400
Subject: Re: [PATCH 11/14] mac80211: wait for scan work complete before
 restarting hw
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1284128807-11436-12-git-send-email-sgruszka@redhat.com>
References: <1284128807-11436-1-git-send-email-sgruszka@redhat.com>
	 <1284128807-11436-12-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Fri, 10 Sep 2010 08:55:10 -0700
Message-Id: <1284134110.6054.23.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-10 at 07:26 -0700, Stanislaw Gruszka wrote:
> This is needed to avoid warning in ieee80211_restart_hw about hardware
> scan in progress.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
> ---
>  net/mac80211/main.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 4935b84..bf0eb6a 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -305,6 +305,9 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw)
>  
>  	trace_api_restart_hw(local);
>  
> +	/* wait for scan work complete */
> +	flush_workqueue(local->workqueue);
> +
>  	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
>  		"%s called with hardware scan in progress\n", __func__);
>  

