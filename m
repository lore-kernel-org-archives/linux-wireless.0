Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36272 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751768AbdHABlB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Jul 2017 21:41:01 -0400
From: Xinming Hu <huxm@marvell.com>
To: Brian Norris <briannorris@chromium.org>,
        Xinming Hu <huxinming820@gmail.com>
CC: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: Re: Re: [PATCH 2/2] mwifiex: pcie: compatible with wifi-only image
 while extract wifi-part fw
Date: Tue, 1 Aug 2017 01:40:52 +0000
Message-ID: <1501551652281.43666@marvell.com> (sfid-20170801_034105_187961_2CC57D58)
References: <1501506447-31851-1-git-send-email-huxinming820@gmail.com>
 <1501506447-31851-2-git-send-email-huxinming820@gmail.com>,<20170731165857.GA136608@google.com>
In-Reply-To: <20170731165857.GA136608@google.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

Thanks for the review, fix below comment format in V2.

Regards,
Simon
________________________________________
From: Brian Norris <briannorris@chromium.org>
Sent: Tuesday, August 1, 2017 0:58
To: Xinming Hu
Cc: Linux Wireless; Kalle Valo; Dmitry Torokhov; rajatja@google.com; Zhiyuan Yang; Tim Song; Cathy Luo; Ganapathi Bhat; Xinming Hu
Subject: [EXT] Re: [PATCH 2/2] mwifiex: pcie: compatible with wifi-only image while extract wifi-part fw

External Email

----------------------------------------------------------------------
Hi,

Two nitpicks below:

On Mon, Jul 31, 2017 at 01:07:27PM +0000, Xinming Hu wrote:
> From: Xinming Hu <huxm@marvell.com>
>
> Sometimes, we might using wifi-only firmware with a combo firmware name,
> in this case, do not need to filter bluetooth part from header.
>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 3da1eeb..dc4e054 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -1985,7 +1985,8 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
>   * (3) wifi image.
>   *
>   * This function bypass the header and bluetooth part, return
> - * the offset of tail wifi-only part.
> + * the offset of tail wifi-only part. if the image is already wifi-only,

Sentences start with capital letters (i.e., "If the image ...").

> + * that is start with CMD1, return 0.
>   */
>
>  static int mwifiex_extract_wifi_fw(struct mwifiex_adapter *adapter,
> @@ -1993,7 +1994,7 @@ static int mwifiex_extract_wifi_fw(struct mwifiex_adapter *adapter,
>       const struct mwifiex_fw_data *fwdata;
>       u32 offset = 0, data_len, dnld_cmd;
>       int ret = 0;
> -     bool cmd7_before = false;
> +     bool cmd7_before = false, first_cmd = false;
>
>       while (1) {
>               /* Check for integer and buffer overflow */
> @@ -2014,20 +2015,29 @@ static int mwifiex_extract_wifi_fw(struct mwifiex_adapter *adapter,
>
>               switch (dnld_cmd) {
>               case MWIFIEX_FW_DNLD_CMD_1:
> -                     if (!cmd7_before) {
> -                             mwifiex_dbg(adapter, ERROR,
> -                                         "no cmd7 before cmd1!\n");
> +                     if (offset + data_len < data_len) {
> +                             mwifiex_dbg(adapter, ERROR, "bad FW parse\n");
>                               ret = -1;
>                               goto done;
>                       }
> -                     if (offset + data_len < data_len) {
> -                             mwifiex_dbg(adapter, ERROR, "bad FW parse\n");
> +
> +                     /* Image start with cmd1, already wifi-only firmware*/

You need a space before closing the comment. i.e.:

                        /* Image starts with cmd1; already wifi-only firmware */

Otherwise, I think both of these look fine:

Reviewed-by: Brian Norris <briannorris@chromium.org>

> +                     if (!first_cmd) {
> +                             mwifiex_dbg(adapter, MSG,
> +                                         "input wifi-only firmware\n");
> +                             return 0;
> +                     }
> +
> +                     if (!cmd7_before) {
> +                             mwifiex_dbg(adapter, ERROR,
> +                                         "no cmd7 before cmd1!\n");
>                               ret = -1;
>                               goto done;
>                       }
>                       offset += data_len;
>                       break;
>               case MWIFIEX_FW_DNLD_CMD_5:
> +                     first_cmd = true;
>                       /* Check for integer overflow */
>                       if (offset + data_len < data_len) {
>                               mwifiex_dbg(adapter, ERROR, "bad FW parse\n");
> @@ -2037,6 +2047,7 @@ static int mwifiex_extract_wifi_fw(struct mwifiex_adapter *adapter,
>                       offset += data_len;
>                       break;
>               case MWIFIEX_FW_DNLD_CMD_6:
> +                     first_cmd = true;
>                       /* Check for integer overflow */
>                       if (offset + data_len < data_len) {
>                               mwifiex_dbg(adapter, ERROR, "bad FW parse\n");
> @@ -2053,6 +2064,7 @@ static int mwifiex_extract_wifi_fw(struct mwifiex_adapter *adapter,
>                       }
>                       goto done;
>               case MWIFIEX_FW_DNLD_CMD_7:
> +                     first_cmd = true;
>                       cmd7_before = true;
>                       break;
>               default:
> --
> 1.9.1
>
