Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:37854 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753991AbeBGO2G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Feb 2018 09:28:06 -0500
Received: by mail-qk0-f196.google.com with SMTP id c128so1288260qkb.4
        for <linux-wireless@vger.kernel.org>; Wed, 07 Feb 2018 06:28:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1518011483-7704-1-git-send-email-kvalo@codeaurora.org>
References: <1518011483-7704-1-git-send-email-kvalo@codeaurora.org>
From: Mike Lothian <mike@fireburn.co.uk>
Date: Wed, 7 Feb 2018 14:27:45 +0000
Message-ID: <CAHbf0-H-3xKV9tPhX1zUttPG440nKd9xNrDoMrrXSffFnbEeww@mail.gmail.com> (sfid-20180207_152810_269416_9383FD7A)
Subject: Re: [PATCH] Revert "ath10k: add sanity check to ie_len before parsing
 fw/board ie"
To: Kalle Valo <kvalo@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Ryan Hsu <ryanhsu@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 February 2018 at 13:51, Kalle Valo <kvalo@codeaurora.org> wrote:
> From: Ryan Hsu <ryanhsu@codeaurora.org>
>
> This reverts commit 9ed4f91628737c820af6a1815b65bc06bd31518f.
>
> The commit introduced a regression that over read the ie with
> the padding.
>
> - the expected IE information
>
> ath10k_pci 0000:03:00.0: found firmware features ie (1 B)
> ath10k_pci 0000:03:00.0: Enabling feature bit: 6
> ath10k_pci 0000:03:00.0: Enabling feature bit: 7
> ath10k_pci 0000:03:00.0: features
> ath10k_pci 0000:03:00.0: 00000000: c0 00 00 00 00 00 00 00
>
> - the wrong IE with padding is read (0x77)
>
> ath10k_pci 0000:03:00.0: found firmware features ie (4 B)
> ath10k_pci 0000:03:00.0: Enabling feature bit: 6
> ath10k_pci 0000:03:00.0: Enabling feature bit: 7
> ath10k_pci 0000:03:00.0: Enabling feature bit: 8
> ath10k_pci 0000:03:00.0: Enabling feature bit: 9
> ath10k_pci 0000:03:00.0: Enabling feature bit: 10
> ath10k_pci 0000:03:00.0: Enabling feature bit: 12
> ath10k_pci 0000:03:00.0: Enabling feature bit: 13
> ath10k_pci 0000:03:00.0: Enabling feature bit: 14
> ath10k_pci 0000:03:00.0: Enabling feature bit: 16
> ath10k_pci 0000:03:00.0: Enabling feature bit: 17
> ath10k_pci 0000:03:00.0: Enabling feature bit: 18
> ath10k_pci 0000:03:00.0: features
> ath10k_pci 0000:03:00.0: 00000000: c0 77 07 00 00 00 00 00
>
> Signed-off-by: Ryan Hsu <ryanhsu@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index b0fdc1023619..fe9341c97f31 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -1276,10 +1276,7 @@ static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
>                 len -= sizeof(*hdr);
>                 data = hdr->data;
>
> -               /* jump over the padding */
> -               ie_len = ALIGN(ie_len, 4);
> -
> -               if (len < ie_len) {
> +               if (len < ALIGN(ie_len, 4)) {
>                         ath10k_err(ar, "invalid length for board ie_id %d ie_len %zu len %zu\n",
>                                    ie_id, ie_len, len);
>                         ret = -EINVAL;
> @@ -1318,6 +1315,9 @@ static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
>                         goto out;
>                 }
>
> +               /* jump over the padding */
> +               ie_len = ALIGN(ie_len, 4);
> +
>                 len -= ie_len;
>                 data += ie_len;
>         }
> @@ -1448,9 +1448,6 @@ int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
>                 len -= sizeof(*hdr);
>                 data += sizeof(*hdr);
>
> -               /* jump over the padding */
> -               ie_len = ALIGN(ie_len, 4);
> -
>                 if (len < ie_len) {
>                         ath10k_err(ar, "invalid length for FW IE %d (%zu < %zu)\n",
>                                    ie_id, len, ie_len);
> @@ -1556,6 +1553,9 @@ int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
>                         break;
>                 }
>
> +               /* jump over the padding */
> +               ie_len = ALIGN(ie_len, 4);
> +
>                 len -= ie_len;
>                 data += ie_len;
>         }
> --
> 2.7.4
>

Tested-by: Mike Lothian <mike@fireburn.co.uk>

Sent at HTML the first time sorry
