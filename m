Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:37621 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752757AbaGPVwC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:52:02 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [ath9k-devel] [PATCH] ath9k: set up tx power into the MRR
From: =?iso-8859-1?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1405545610-17285-1-git-send-email-lorenzo.bianconi83@gmail.com>
Date: Wed, 16 Jul 2014 23:51:20 +0200
Cc: linville@tuxdriver.com, ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <1CE47156-DE51-46C6-AE39-C895AF9489EB@net.t-labs.tu-berlin.de> (sfid-20140716_235249_112396_C7D0ADAD)
References: <1405545610-17285-1-git-send-email-lorenzo.bianconi83@gmail.com>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lozenro,

As I am shaping up my TPC code and might comment as well  :)

What about defining just:

#define AR_XmitPower        0x003f0000
#define AR_XmitPower_S      16
#define AR_XmitPower2          0x3f000000
#define AR_XmitPower2_S                24

.. as AR_XmitPower1 == AR_XmitPower2 == AR_XmitPower3 (with its shift as well) and AR_XmitPower == AR_XmitPower0

Or do you have someting in mind to have the same value seperated ?

Greetings from Berlin
Thomas

> Set up tx power for each MRR segment in the tx descriptor
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> ---
> drivers/net/wireless/ath/ath9k/ar9002_mac.c |  6 +++++-
> drivers/net/wireless/ath/ath9k/ar9003_mac.c |  6 +++++-
> drivers/net/wireless/ath/ath9k/mac.h        | 10 ++++++++--
> 3 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
> index 741b38d..59af9f9 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
> @@ -281,7 +281,7 @@ ar9002_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
> 
> 	ACCESS_ONCE(ads->ds_ctl0) = (i->pkt_len & AR_FrameLen)
> 		| (i->flags & ATH9K_TXDESC_VMF ? AR_VirtMoreFrag : 0)
> -		| SM(i->txpower, AR_XmitPower)
> +		| SM(i->txpower, AR_XmitPower0)
> 		| (i->flags & ATH9K_TXDESC_VEOL ? AR_VEOL : 0)
> 		| (i->flags & ATH9K_TXDESC_INTREQ ? AR_TxIntrReq : 0)
> 		| (i->keyix != ATH9K_TXKEYIX_INVALID ? AR_DestIdxValid : 0)
> @@ -306,6 +306,10 @@ ar9002_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
> 		| set11nRateFlags(i->rates, 2)
> 		| set11nRateFlags(i->rates, 3)
> 		| SM(i->rtscts_rate, AR_RTSCTSRate);
> +
> +	ACCESS_ONCE(ads->ds_ctl9) = SM(i->txpower, AR_XmitPower1);
> +	ACCESS_ONCE(ads->ds_ctl10) = SM(i->txpower, AR_XmitPower2);
> +	ACCESS_ONCE(ads->ds_ctl11) = SM(i->txpower, AR_XmitPower3);
> }
> 
> static int ar9002_hw_proc_txdesc(struct ath_hw *ah, void *ds,
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> index 729ffbf..71e38e8 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> @@ -101,7 +101,7 @@ ar9003_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
> 
> 	ACCESS_ONCE(ads->ctl11) = (i->pkt_len & AR_FrameLen)
> 		| (i->flags & ATH9K_TXDESC_VMF ? AR_VirtMoreFrag : 0)
> -		| SM(i->txpower, AR_XmitPower)
> +		| SM(i->txpower, AR_XmitPower0)
> 		| (i->flags & ATH9K_TXDESC_VEOL ? AR_VEOL : 0)
> 		| (i->keyix != ATH9K_TXKEYIX_INVALID ? AR_DestIdxValid : 0)
> 		| (i->flags & ATH9K_TXDESC_LOWRXCHAIN ? AR_LowRxChain : 0)
> @@ -151,6 +151,10 @@ ar9003_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
> 		| SM(i->rtscts_rate, AR_RTSCTSRate);
> 
> 	ACCESS_ONCE(ads->ctl19) = AR_Not_Sounding;
> +
> +	ACCESS_ONCE(ads->ctl20) = SM(i->txpower, AR_XmitPower1);
> +	ACCESS_ONCE(ads->ctl21) = SM(i->txpower, AR_XmitPower2);
> +	ACCESS_ONCE(ads->ctl22) = SM(i->txpower, AR_XmitPower3);
> }
> 
> static u16 ar9003_calc_ptr_chksum(struct ar9003_txc *ads)
> diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
> index da76867..6c56caf 100644
> --- a/drivers/net/wireless/ath/ath9k/mac.h
> +++ b/drivers/net/wireless/ath/ath9k/mac.h
> @@ -346,8 +346,14 @@ struct ar5416_desc {
> #define AR_FrameLen         0x00000fff
> #define AR_VirtMoreFrag     0x00001000
> #define AR_TxCtlRsvd00      0x0000e000
> -#define AR_XmitPower        0x003f0000
> -#define AR_XmitPower_S      16
> +#define AR_XmitPower0       0x003f0000
> +#define AR_XmitPower0_S     16
> +#define AR_XmitPower1	    0x3f000000
> +#define AR_XmitPower1_S     24
> +#define AR_XmitPower2	    0x3f000000
> +#define AR_XmitPower2_S     24
> +#define AR_XmitPower3	    0x3f000000
> +#define AR_XmitPower3_S     24
> #define AR_RTSEnable        0x00400000
> #define AR_VEOL             0x00800000
> #define AR_ClrDestMask      0x01000000
> -- 
> 1.9.1
> 
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel

