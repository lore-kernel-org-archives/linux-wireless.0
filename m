Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:51867 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaKDPWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 10:22:30 -0500
Message-ID: <5458EF33.7010701@broadcom.com> (sfid-20141104_162233_806317_4CB03935)
Date: Tue, 4 Nov 2014 16:22:27 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Amitkumar Karwar <akarwar@marvell.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Subject: Re: [PATCH 4/5] mwifiex: do not setup AMPDU/AMSDU with broadcast
 receiver
References: <1415102223-7118-1-git-send-email-akarwar@marvell.com> <1415102223-7118-4-git-send-email-akarwar@marvell.com>
In-Reply-To: <1415102223-7118-4-git-send-email-akarwar@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/14 12:57, Amitkumar Karwar wrote:
> From: Avinash Patil<patila@marvell.com>
>
> It is observed that device sometimes sends BA setup requests for
> broadcast mac address.
> Its pointless to check for availablity of AMPDU/AMSDU streams
> for broadcast mac address. This patch adds this check.

Maybe you should rephrase this a little. The last sentence seems to say: 
"This patch adds a pointless check".

Regards,
Arend

> Signed-off-by: Amitkumar Karwar<akarwar@marvell.com>
> Signed-off-by: Avinash Patil<patila@marvell.com>
> ---
>   drivers/net/wireless/mwifiex/11n.h | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
> index 2ee268b..f275675 100644
> --- a/drivers/net/wireless/mwifiex/11n.h
> +++ b/drivers/net/wireless/mwifiex/11n.h
> @@ -84,6 +84,8 @@ mwifiex_is_amsdu_in_ampdu_allowed(struct mwifiex_private *priv,
>   {
>   	struct mwifiex_tx_ba_stream_tbl *tx_tbl;
>
> +	if (is_broadcast_ether_addr(ptr->ra))
> +		return false;
>   	tx_tbl = mwifiex_get_ba_tbl(priv, tid, ptr->ra);
>   	if (tx_tbl)
>   		return tx_tbl->amsdu;
> @@ -96,6 +98,8 @@ static inline u8
>   mwifiex_is_ampdu_allowed(struct mwifiex_private *priv,
>   			 struct mwifiex_ra_list_tbl *ptr, int tid)
>   {
> +	if (is_broadcast_ether_addr(ptr->ra))
> +		return false;
>   	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) {
>   		return mwifiex_is_station_ampdu_allowed(priv, ptr, tid);
>   	} else {

