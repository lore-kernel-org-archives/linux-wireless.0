Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89AA9C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 19:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 594C2217D7
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 19:08:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IGRggmSj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbfBRTIl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:08:41 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44636 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbfBRTIl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 14:08:41 -0500
Received: by mail-wr1-f65.google.com with SMTP id w2so4962507wrt.11
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2019 11:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=96/giZF0UYtTmMF+I5lRhGWC4N6rrUIK5GwnXlHZleU=;
        b=IGRggmSjAEMxavdO9NvuVLu147wkJCvlipDunBRCRmilImbafX3EOjWqIGVjVi8jfc
         pl5hstEDyryFMFN8ibLk0kryXYO/w6K8KCtyn6djhwjzJDVaFax4WQLcpRFQ0/4Diol2
         BqDQZnvMpItN6uMqdi7/8QAXRIKXEDlguM1Sm4EQzYFIRRZjzsuAeiCo2DnVdfqQ7hB1
         BEDFZj8069utRtRr+fmGmBIMG29F2bJJwclRgq6eIe/1nndK1+0Zh54yNQV/oNuNohW4
         6FK1ZJFhrjZnbgcAneBZyOt+tNgOKJVKoTwskQKUMdCncGxxuqTXWNATp/LozTGzzwjq
         JsGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=96/giZF0UYtTmMF+I5lRhGWC4N6rrUIK5GwnXlHZleU=;
        b=fyxeGwtAPiCZ+SOrR4glYLJhKFtiXrx2OFaA7xSho8U4zD2rGNzhPlP9AmPSz//Y1Q
         idrp5SGeBOBjcWGK4EOwEvU468Yt7Mj0NUoKfm2iFHJfoz3SK55dcZaSlSnexk1QamHi
         5mc4Y69uzoVTCnhE4MwVqwe8a1Cb41XBBHzmlw+DMjvPNou6iQHBYeAz/dFSyKhax6Qq
         eFRTGiZyGDccP0PlB21TyzuFC7sLMDD50EEPRtfkRvKP6IGcFgUPnR894BdigjHktdpx
         WAy/Zyrzvxjj+6GOSXwS7VBr+6CU77RUY/rgjjUC2J4vUEcq+/SuzjkjvJ5PQdahj7mz
         RehA==
X-Gm-Message-State: AHQUAua6iHB8XcKIY4QLBStDw5n00LxgT2DYq0fRVtnZVvUtx1HKk5yE
        1hcAQiP+Uzrp5Yt7c+lh44NEFKXNcdPVcl+dSR3PMGUO
X-Google-Smtp-Source: AHgI3IbBaa5iTj/Sww0Xr1DIO9taKm7DbK2hEgb8fy25SAkbjejT/UetOactMX1LdiQLg0QEkA2vPT376gfrfqSqf1k=
X-Received: by 2002:adf:ecc7:: with SMTP id s7mr17521091wro.255.1550516919648;
 Mon, 18 Feb 2019 11:08:39 -0800 (PST)
MIME-Version: 1.0
References: <20190218150952.6889-1-wangxuerui@qiniu.com>
In-Reply-To: <20190218150952.6889-1-wangxuerui@qiniu.com>
From:   Jonas Gorski <jonas.gorski@gmail.com>
Date:   Mon, 18 Feb 2019 20:08:30 +0100
Message-ID: <CAOiHx=md7Ba=OkbgJTSgYJzwDYDyBA_cyCgenJEGSjPPV7BQ1g@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: mvm: fix an unaligned access
To:     wangxuerui@qiniu.com
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Mon, 18 Feb 2019 at 19:40, <wangxuerui@qiniu.com> wrote:
>
> From: Wang Xuerui <wangxuerui@qiniu.com>
>
> Tested with a Wireless AC 7265 on a MIPS box, confirmed to fix the
> unaligned accesses.
>
> Signed-off-by: Wang Xuerui <wangxuerui@qiniu.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
> index 6653a238f32e..a155e816262e 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
> @@ -57,6 +57,7 @@
>   * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
>   * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>   *****************************************************************************/
> +#include <asm/unaligned.h>
>  #include <linux/etherdevice.h>
>  #include <linux/skbuff.h>
>  #include "iwl-trans.h"
> @@ -355,8 +356,8 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
>         rx_res = (struct iwl_rx_mpdu_res_start *)pkt->data;
>         hdr = (struct ieee80211_hdr *)(pkt->data + sizeof(*rx_res));
>         len = le16_to_cpu(rx_res->byte_count);
> -       rx_pkt_status = le32_to_cpup((__le32 *)
> -               (pkt->data + sizeof(*rx_res) + len));
> +       rx_pkt_status = le32_to_cpu(get_unaligned((__le32 *)
> +               (pkt->data + sizeof(*rx_res) + len)));

There's get_unaligned_le32() for that purpose.


Regards
Jonas
