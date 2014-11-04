Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55306 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887AbaKDRYc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 12:24:32 -0500
From: Avinash Patil <patila@marvell.com>
To: Arend van Spriel <arend@broadcom.com>,
	Amitkumar Karwar <akarwar@marvell.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 4 Nov 2014 09:20:32 -0800
Subject: RE: [PATCH 4/5] mwifiex: do not setup AMPDU/AMSDU with broadcast
 receiver
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC666FA7DC0F@SC-VEXCH2.marvell.com> (sfid-20141104_182552_313593_42B0269E)
References: <1415102223-7118-1-git-send-email-akarwar@marvell.com>
 <1415102223-7118-4-git-send-email-akarwar@marvell.com>,<5458EF33.7010701@broadcom.com>
In-Reply-To: <5458EF33.7010701@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

Thanks for your review,
Yes; current description may be confusing. I will send v2 with correct patch description.

Thanks,
Avinash
________________________________________
From: Arend van Spriel [arend@broadcom.com]
Sent: Tuesday, November 04, 2014 8:52 PM
To: Amitkumar Karwar
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org; Avinash Patil
Subject: Re: [PATCH 4/5] mwifiex: do not setup AMPDU/AMSDU with broadcast receiver

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
>       struct mwifiex_tx_ba_stream_tbl *tx_tbl;
>
> +     if (is_broadcast_ether_addr(ptr->ra))
> +             return false;
>       tx_tbl = mwifiex_get_ba_tbl(priv, tid, ptr->ra);
>       if (tx_tbl)
>               return tx_tbl->amsdu;
> @@ -96,6 +98,8 @@ static inline u8
>   mwifiex_is_ampdu_allowed(struct mwifiex_private *priv,
>                        struct mwifiex_ra_list_tbl *ptr, int tid)
>   {
> +     if (is_broadcast_ether_addr(ptr->ra))
> +             return false;
>       if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) {
>               return mwifiex_is_station_ampdu_allowed(priv, ptr, tid);
>       } else {

