Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36677 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbcFXG45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2016 02:56:57 -0400
MIME-Version: 1.0
In-Reply-To: <1466050770-21789-1-git-send-email-prasunmaiti87@gmail.com>
References: <1466050770-21789-1-git-send-email-prasunmaiti87@gmail.com>
From: Prasun Maiti <prasunmaiti87@gmail.com>
Date: Fri, 24 Jun 2016 12:26:56 +0530
Message-ID: <CAEO8o4=k2y4RBDFJ8RH9RF1xobWKW-zZobRFvrn8Hp8MB=L9AA@mail.gmail.com> (sfid-20160624_085716_503862_613F1468)
Subject: Re: [PATCH] mwifiex: Fixed endianness for event TLV type TLV_BTCOEX_WL_SCANTIME
To: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux Next <linux-next@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 16, 2016 at 9:49 AM, Prasun Maiti <prasunmaiti87@gmail.com> wrote:
> The two members min_scan_time and max_scan_time of structure
> "mwifiex_ie_types_btcoex_scan_time" are of two bytes each. The values
> are assigned directtly from firmware without endian conversion handling.
> So, wrong datas will get saved in big-endian systems.
>
> This patch converts the values into cpu's byte order before assigning them
> into the local members.
>
> Signed-off-by: Prasun Maiti <prasunmaiti87@gmail.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/sta_event.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
> index 0104108..7dff452 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
> @@ -474,8 +474,8 @@ void mwifiex_bt_coex_wlan_param_update_event(struct mwifiex_private *priv,
>                         scantlv =
>                             (struct mwifiex_ie_types_btcoex_scan_time *)tlv;
>                         adapter->coex_scan = scantlv->coex_scan;
> -                       adapter->coex_min_scan_time = scantlv->min_scan_time;
> -                       adapter->coex_max_scan_time = scantlv->max_scan_time;
> +                       adapter->coex_min_scan_time = le16_to_cpu(scantlv->min_scan_time);
> +                       adapter->coex_max_scan_time = le16_to_cpu(scantlv->max_scan_time);
>                         break;
>
>                 default:
> --
> 1.9.1
>

Hi Amitkumar,

Please let me know your opinion about this patch.

-- 
Thanks,
Prasun
