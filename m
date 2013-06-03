Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:42078 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759104Ab3FCQyq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 12:54:46 -0400
Message-ID: <1370278476.2025.41.camel@joe-AO722> (sfid-20130603_185449_257949_27BB81CC)
Subject: Re: [PATCH] brcmsmac: Reduce log spam in heavy tx, make err print
 in debug
From: Joe Perches <joe@perches.com>
To: John Greene <jogreene@redhat.com>
Cc: linville@tuxdriver.com, arend@broadcom.com,
	linux-wireless@vger.kernel.org
Date: Mon, 03 Jun 2013 09:54:36 -0700
In-Reply-To: <1370267259-19712-1-git-send-email-jogreene@redhat.com>
References: <1370267259-19712-1-git-send-email-jogreene@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-06-03 at 09:47 -0400, John Greene wrote:
> Move message to debug mode to reduce log spam under heavy tx (iperf) load.
[]
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
[]
> @@ -900,7 +900,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
>  		if (supr_status) {
>  			update_rate = false;
>  			if (supr_status == TX_STATUS_SUPR_BADCH) {
> -				brcms_err(wlc->hw->d11core,
> +				brcms_dbg_ht(wlc->hw->d11core,
>  					  "%s: Pkt tx suppressed, illegal channel possibly %d\n",
>  					  __func__, CHSPEC_CHANNEL(
>  					  wlc->default_bss->chanspec));

net_ratelimited instead?


