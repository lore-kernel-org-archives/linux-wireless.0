Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35085 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751081AbcIGNoH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2016 09:44:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: avoid potential stack overflow in
 brcmf_cfg80211_start_ap()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1473068749-22487-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20160907134406.D3123602A9@smtp.codeaurora.org> (sfid-20160907_154410_987092_58070F37)
Date: Wed,  7 Sep 2016 13:44:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> User-space can choose to omit NL80211_ATTR_SSID and only provide raw
> IE TLV data. When doing so it can provide SSID IE with length exceeding
> the allowed size. The driver further processes this IE copying it
> into a local variable without checking the length. Hence stack can be
> corrupted and used as exploit.
> 
> Cc: stable@vger.kernel.org # v4.7
> Reported-by: Daxing Guo <freener.gdx@gmail.com>
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Thanks, 1 patch applied to wireless-drivers.git:

ded89912156b brcmfmac: avoid potential stack overflow in brcmf_cfg80211_start_ap()

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9313305/
