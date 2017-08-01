Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:35256 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752379AbdHAVUg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 17:20:36 -0400
Received: by mail-wr0-f171.google.com with SMTP id k71so11581443wrc.2
        for <linux-wireless@vger.kernel.org>; Tue, 01 Aug 2017 14:20:36 -0700 (PDT)
Subject: Re: [PATCH V5 2/2] brcmfmac: don't warn user about NVRAM if fallback
 to the platform one succeeds
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "Luis R . Rodriguez" <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>,
        Daniel Wagner <wagi@monom.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>, yi1.li@linux.intel.com,
        atull@kernel.org, Moritz Fischer <moritz.fischer@ettus.com>,
        pmladek@suse.com, Johannes Berg <johannes.berg@intel.com>,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        Kalle Valo <kvalo@codeaurora.org>, luto@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        David Howells <dhowells@redhat.com>, pjones@redhat.com,
        Hans de Goede <hdegoede@redhat.com>, alan@linux.intel.com,
        tytso@mit.edu, lkml <linux-kernel@vger.kernel.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20170731150945.8925-1-zajec5@gmail.com>
 <20170731150945.8925-2-zajec5@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d50d2577-b9d3-27f1-6e3d-8e0dc4ec2024@broadcom.com> (sfid-20170801_232231_251454_F5E06A38)
Date: Tue, 1 Aug 2017 23:20:32 +0200
MIME-Version: 1.0
In-Reply-To: <20170731150945.8925-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31-07-17 17:09, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Failing to load NVRAM *file* isn't critical if we manage to get platform
> NVRAM in the fallback path. It means warnings like:
> [   10.801506] brcmfmac 0000:01:00.0: Direct firmware load for brcm/brcmfmac43602-pcie.txt failed with error -2
> are unnecessary & disturbing for people with *platform* NVRAM as they
> are not expected to have NVRAM file. This is a very common case for
> Broadcom home routers.
> 
> Instead of printing warning immediately within the firmware subsystem
> let's try our fallback code first. If that fails as well, then it's a
> right moment to print an error.
> 
> This should reduce amount of false reports from users seeing this
> warning while having wireless working perfectly fine with the platform
> NVRAM.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V2: Update commit message as it wasn't clear enough (thanks Andy) & add extra
>     messages to the firmware.c.
> V3: Set FW_OPT_UEVENT to don't change behavior
> V4: Switch to the new request_firmware_async syntax
> V5: Rebase, update commit message, resend after drvdata discussion
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/firmware.c    | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> index d231042f19d6..524442b3870f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> @@ -462,8 +462,14 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
>  		raw_nvram = false;
>  	} else {
>  		data = bcm47xx_nvram_get_contents(&data_len);
> -		if (!data && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
> -			goto fail;
> +		if (!data) {
> +			brcmf_dbg(TRACE, "Failed to get platform NVRAM\n");

Better make this INFO level instead of TRACE. The intent of TRACE level
is for entry/exit points in functions.

Regards,
Arend
