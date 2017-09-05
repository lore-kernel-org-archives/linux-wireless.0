Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:36570 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbdIEUCe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 16:02:34 -0400
Received: by mail-yw0-f176.google.com with SMTP id w204so16129884ywg.3
        for <linux-wireless@vger.kernel.org>; Tue, 05 Sep 2017 13:02:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1504510473-13549-1-git-send-email-wright.feng@cypress.com>
References: <1504510473-13549-1-git-send-email-wright.feng@cypress.com>
From: Franky Lin <franky.lin@broadcom.com>
Date: Tue, 5 Sep 2017 13:02:13 -0700
Message-ID: <CA+8PC_fV70z-ELAEWgg0Q3MM6N7niHozeDh-PWNLYmJ7YY-mVQ@mail.gmail.com> (sfid-20170905_220439_779699_12BA09EE)
Subject: Re: [PATCH] brcmfmac: return -EPERM when getting error in vendor
 command handler
To: Wright Feng <wright.feng@cypress.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 4, 2017 at 12:34 AM, Wright Feng <wright.feng@cypress.com> wrote:
> Firmware returns proprietary error code when getting error in
> fil_cmd_data_set or fil_cmd_data_get. The vendor tools or
> utilities which uses libnl may stuck in some commands when wl is down.
> For example, issue "scan" command after issuing "down" command, the
> "scan" command will be the blocking call and stuck as no response from
> libnl. It is caused by that firmware returns BCME_NOTUP(-4) when wl
> is down, but the -4 is -EINTR in Linux kernel, so libnl catches the error
> and not passes to upper layer.
> Because of that, the driver should return Linux error code instead of the
> proprietary error code, and the tools or utilities need to get the real
> firmware error code by command "bcmerror" or "bcmerrorstr" after receiving
> the error.
>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
> index 8eff275..2b88ba1 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
> @@ -80,8 +80,12 @@ static int brcmf_cfg80211_vndr_cmds_dcmd_handler(struct wiphy *wiphy,
>         else
>                 ret = brcmf_fil_cmd_data_get(ifp, cmdhdr->cmd, dcmd_buf,
>                                              ret_len);
> -       if (ret != 0)
> +
> +       if (ret != 0) {
> +               brcmf_dbg(INFO, "error(%d), return -EPERM\n", ret);
> +               ret = -EPERM;
>                 goto exit;
> +       }

It would be better to handle the conversion in brcmf_fil_cmd_data so
everyone can benefit. Also please try to assign an appropriate error
code when possible to provide more information to the upper layer. For
this case "ENETDOWN" seems to be a better fit for BCME_NOTUP.

Thanks,
Franky

>         wr_pointer = dcmd_buf;
>         while (ret_len > 0) {
> --
> 1.9.1
>
