Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45466 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752780AbdEOIlJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 May 2017 04:41:09 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlegacy: warn when enabling power save
References: <1494835148-12945-1-git-send-email-sgruszka@redhat.com>
Date: Mon, 15 May 2017 11:41:05 +0300
In-Reply-To: <1494835148-12945-1-git-send-email-sgruszka@redhat.com>
        (Stanislaw Gruszka's message of "Mon, 15 May 2017 09:59:08 +0200")
Message-ID: <87ziee5x7i.fsf@purkki.adurom.net> (sfid-20170515_104141_864861_9ACDAC83)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> iwlegacy firmware can crash when power save is configured. PS was
> allowed in "dbdac2b iwlegacy: properly enable power saving" with belive
> that user who enable PS is aware of that and can relate firmware crahes
> with PS. However some distributions seems to enable PS without user
> intervention, so warn about that.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/intel/iwlegacy/common.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
> index 140b6ea..6aaa0e7 100644
> --- a/drivers/net/wireless/intel/iwlegacy/common.c
> +++ b/drivers/net/wireless/intel/iwlegacy/common.c
> @@ -5147,6 +5147,8 @@ void il_mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  
>  	if (changed & (IEEE80211_CONF_CHANGE_PS | IEEE80211_CONF_CHANGE_IDLE)) {
>  		il->power_data.ps_disabled = !(conf->flags & IEEE80211_CONF_PS);
> +		WARN_ONCE(!il->power_data.ps_disabled,
> +			  "Enabling power save might cause firmware crashes\n");

This prints the whole stack trace, right? Isn't that excessive and
fooling the users to think that they found a bug, which would mean more
bug reports sent to us? So maybe a simple printk is better here?

-- 
Kalle Valo
