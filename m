Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53137 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758248AbbJILfz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 07:35:55 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Arnd Bergmann <arnd@arndb.de>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "y2038@lists.linaro.org" <y2038@lists.linaro.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 05/12] mwifiex: avoid gettimeofday in ba_threshold setting
Date: Fri, 9 Oct 2015 11:35:47 +0000
Message-ID: <4d9d7f2dc1a44e00b9ce74660e306640@SC-EXCH04.marvell.com> (sfid-20151009_133640_238165_A9907344)
References: <1443612402-3000775-1-git-send-email-arnd@arndb.de>
 <1443612402-3000775-6-git-send-email-arnd@arndb.de>
In-Reply-To: <1443612402-3000775-6-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arnd,

> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Wednesday, September 30, 2015 4:57 PM
> To: netdev@vger.kernel.org
> Cc: y2038@lists.linaro.org; linux-kernel@vger.kernel.org; David S.
> Miller; Arnd Bergmann; Amitkumar Karwar; Nishant Sarmukadam; Kalle Valo;
> linux-wireless@vger.kernel.org
> Subject: [PATCH 05/12] mwifiex: avoid gettimeofday in ba_threshold
> setting
> 
> mwifiex_get_random_ba_threshold() uses a complex homegrown
> implementation to generate a pseudo-random number from the current time
> as returned from do_gettimeofday().
> 
> This currently requires two 32-bit divisions plus a couple of other
> computations that are eventually discarded as only eight bits of the
> microsecond portion are used at all.
> 
> We could replace this with a call to get_random_bytes(), but that might
> drain the entropy pool too fast if this is called for each packet.
> 
> Instead, this patch converts it to use ktime_get_ns(), which is a bit
> faster than do_gettimeofday(), and then uses a similar algorithm as
> before, but in a way that takes both the nanosecond and second portion
> into account for slightly-more-but-still-not-very-random
> pseudorandom number.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Amitkumar Karwar <akarwar@marvell.com>
> Cc: Nishant Sarmukadam <nishants@marvell.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> ---
>  drivers/net/wireless/mwifiex/wmm.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/wmm.c
> b/drivers/net/wireless/mwifiex/wmm.c
> index 173d3663c2e0..878d358063dc 100644
> --- a/drivers/net/wireless/mwifiex/wmm.c
> +++ b/drivers/net/wireless/mwifiex/wmm.c
> @@ -117,22 +117,15 @@ mwifiex_wmm_allocate_ralist_node(struct
> mwifiex_adapter *adapter, const u8 *ra)
>   */
>  static u8 mwifiex_get_random_ba_threshold(void)
>  {
> -	u32 sec, usec;
> -	struct timeval ba_tstamp;
> -	u8 ba_threshold;
> -
> +	u64 ns;
>  	/* setup ba_packet_threshold here random number between
>  	 * [BA_SETUP_PACKET_OFFSET,
>  	 * BA_SETUP_PACKET_OFFSET+BA_SETUP_MAX_PACKET_THRESHOLD-1]
>  	 */
> +	ns = ktime_get_ns();
> +	ns += (ns >> 32) + (ns >> 16);
> 
> -	do_gettimeofday(&ba_tstamp);
> -	sec = (ba_tstamp.tv_sec & 0xFFFF) + (ba_tstamp.tv_sec >> 16);
> -	usec = (ba_tstamp.tv_usec & 0xFFFF) + (ba_tstamp.tv_usec >> 16);
> -	ba_threshold = (((sec << 16) + usec) %
> BA_SETUP_MAX_PACKET_THRESHOLD)
> -						      + BA_SETUP_PACKET_OFFSET;
> -
> -	return ba_threshold;
> +	return ((u8)ns % BA_SETUP_MAX_PACKET_THRESHOLD) +
> +BA_SETUP_PACKET_OFFSET;
>  }
> 
>  /*
> --

Looks fine to me.
Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar
