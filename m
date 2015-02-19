Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32713 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbbBSLl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2015 06:41:59 -0500
From: "Salakava Jegadeesan, Senthil" <sjegadee@qti.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2] ath10k: Increase AST table SKID length limit
Date: Thu, 19 Feb 2015 11:41:50 +0000
Message-ID: <21dde87af2ca4a59aadabb94e586bd8b@aphydexm01a.ap.qualcomm.com> (sfid-20150219_124203_046510_3CFB1C72)
References: <1423841776-16288-1-git-send-email-sjegadee@qti.qualcomm.com>
 <54E4F4B4.4080904@candelatech.com>
In-Reply-To: <54E4F4B4.4080904@candelatech.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fix is specific to ath10K driver + 10.x firmware combinations. This has been tested extensively, didn't observe the mentioned issue.

Thanks,
Senthil J

-----Original Message-----
From: Ben Greear [mailto:greearb@candelatech.com] 
Sent: Thursday, February 19, 2015 1:53 AM
To: Salakava Jegadeesan, Senthil
Cc: ath10k@lists.infradead.org; linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: Increase AST table SKID length limit

Have you tried testing this with 30+ stations associated and streaming data, and with other traffic on nearby channels (say, channel 1 and 6)?

We see bad performance drop-off when we set number-of-peers above
100 (with CT firmware).  My kernel will set AST skid limit to number-of-peers + number-of-vdevs.

Performance is best at 32 peers or less (so skid is about 40).

I am wondering if the root cause is firmware/hardware walking the full skid-length for pkts from un-associated peers on same (or neighbouring) channels, or maybe unlucky hash distribution in existing peers?

Thanks,
Ben


On 02/13/2015 07:36 AM, SenthilKumar Jegadeesan wrote:
> The current SKID length configuration causes firmware to reject peer 
> creation for not able to allocate AST entries for peers. This issue is 
> observed when least significant 3 bytes are used ramdomly to create 
> client MAC addresses.
> 
> AST table SKID length configuration is increased to maximum value to 
> fix this issue.
> 
> Signed-off-by: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/hw.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/hw.h 
> b/drivers/net/wireless/ath/ath10k/hw.h
> index 460771f..7f04645 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -223,7 +223,7 @@ struct ath10k_pktlog_hdr {
>  #define TARGET_10X_NUM_WDS_ENTRIES		32
>  #define TARGET_10X_DMA_BURST_SIZE		0
>  #define TARGET_10X_MAC_AGGR_DELIM		0
> -#define TARGET_10X_AST_SKID_LIMIT		16
> +#define TARGET_10X_AST_SKID_LIMIT		128
>  #define TARGET_10X_NUM_STATIONS			128
>  #define TARGET_10X_NUM_PEERS			((TARGET_10X_NUM_STATIONS) + \
>  						 (TARGET_10X_NUM_VDEVS))
> --
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

