Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19330 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735AbcF3IzU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 04:55:20 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Prasun Maiti <prasunmaiti87@gmail.com>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux Next <linux-next@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: RE: [PATCH v2] mwifiex: Fix endianness for event TLV type
 TLV_BTCOEX_WL_SCANTIME
Date: Thu, 30 Jun 2016 08:37:15 +0000
Message-ID: <9f524718509042ac904b2db09081048e@SC-EXCH04.marvell.com> (sfid-20160630_105528_512365_F37A987E)
References: <10cf2879532349d29143ecbac3b459b7@SC-EXCH04.marvell.com>
 <1467275483-24091-1-git-send-email-prasunmaiti87@gmail.com>
In-Reply-To: <1467275483-24091-1-git-send-email-prasunmaiti87@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Prasun,

> -----Original Message-----
> From: Prasun Maiti [mailto:prasunmaiti87@gmail.com]
> Sent: Thursday, June 30, 2016 2:01 PM
> To: Amitkumar Karwar
> Cc: Nishant Sarmukadam; Linux Wireless; Linux Next; Linux Kernel; Kalle
> Valo
> Subject: [PATCH v2] mwifiex: Fix endianness for event TLV type
> TLV_BTCOEX_WL_SCANTIME
> 
> The two members min_scan_time and max_scan_time of structure
> "mwifiex_ie_types_btcoex_scan_time" are of two bytes each. The values
> are assigned directtly from firmware without endian conversion handling.
> So, wrong datas will get saved in big-endian systems.
> 
> This patch converts the values into cpu's byte order before assigning
> them into the local members.
> 
> Signed-off-by: Prasun Maiti <prasunmaiti87@gmail.com>
> ---
> Changes in v2:
> 	- Fixed the following sparse compilation warnings:
> 	* sta_event.c:477:55: warning: cast to restricted __le16
> 	* sta_event.c:478:55: warning: cast to restricted __le16
> 
>  drivers/net/wireless/marvell/mwifiex/fw.h        | 4 ++--
>  drivers/net/wireless/marvell/mwifiex/sta_event.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h
> b/drivers/net/wireless/marvell/mwifiex/fw.h
> index 8e4145a..03d3edf 100644
> --- a/drivers/net/wireless/marvell/mwifiex/fw.h
> +++ b/drivers/net/wireless/marvell/mwifiex/fw.h
> @@ -1958,8 +1958,8 @@ struct mwifiex_ie_types_btcoex_scan_time {
>  	struct mwifiex_ie_types_header header;
>  	u8 coex_scan;
>  	u8 reserved;
> -	u16 min_scan_time;
> -	u16 max_scan_time;
> +	__le16 min_scan_time;
> +	__le16 max_scan_time;
>  } __packed;
> 
>  struct mwifiex_ie_types_btcoex_aggr_win_size { diff --git
> a/drivers/net/wireless/marvell/mwifiex/sta_event.c
> b/drivers/net/wireless/marvell/mwifiex/sta_event.c
> index 0104108..7dff452 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
> @@ -474,8 +474,8 @@ void mwifiex_bt_coex_wlan_param_update_event(struct
> mwifiex_private *priv,
>  			scantlv =
>  			    (struct mwifiex_ie_types_btcoex_scan_time *)tlv;
>  			adapter->coex_scan = scantlv->coex_scan;
> -			adapter->coex_min_scan_time = scantlv->min_scan_time;
> -			adapter->coex_max_scan_time = scantlv->max_scan_time;
> +			adapter->coex_min_scan_time = le16_to_cpu(scantlv-
> >min_scan_time);
> +			adapter->coex_max_scan_time = le16_to_cpu(scantlv-
> >max_scan_time);
>  			break;
> 
>  		default:
> --
> 1.9.1

Updated change looks fine to me.

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar
