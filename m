Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40100 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755980AbeDXF5a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 01:57:30 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] wcn36xx: pass correct BSS index when deleting BSS keys
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180412122330.6916-1-daniel@zonque.org>
References: <20180412122330.6916-1-daniel@zonque.org>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org,
        loic.poulain@linaro.org, Daniel Mack <daniel@zonque.org>
Message-Id: <20180424055729.942DC6085F@smtp.codeaurora.org> (sfid-20180424_075735_202335_D2DFCC41)
Date: Tue, 24 Apr 2018 05:57:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Mack <daniel@zonque.org> wrote:

> The firmware message to delete BSS keys expects a BSS index to be passed.
> This field is currently hard-coded to 0. Fix this by passing in the index
> we received from the firmware when the BSS was configured.
> 
> The encryption type in that message also needs to be set to what was used
> when the key was set, so the assignment of vif_priv->encrypt_type is now
> done after the firmware command was sent. This reportedly fixes the
> following error in AP mode:
> 
>   wcn36xx: ERROR hal_remove_bsskey response failed err=6
> 
> Also, AFAIU, when a BSS is deleted, the firmware apparently drops all the
> keys associated with it. Trying to remove the key explicitly afterwards
> will hence lead to the following message:
> 
>   wcn36xx: ERROR hal_remove_bsskey response failed err=16
> 
> This is now suppressed with an extra check for the BSS index validity.
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

0fc8bb50bbfc wcn36xx: pass correct BSS index when deleting BSS keys

-- 
https://patchwork.kernel.org/patch/10338447/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
