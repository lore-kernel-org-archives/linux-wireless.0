Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:52198 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab0GODbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jul 2010 23:31:34 -0400
Message-ID: <003201cb23cd$527f3f90$aa01a8c0@satya>
From: "Satya" <satya.rao@redpinesignals.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Tushit Jain" <tushit.jain@atheros.com>,
	"Kyungwan Nam" <kyungwan.nam@atheros.com>
References: <1279152521-10805-1-git-send-email-lrodriguez@atheros.com>
Subject: Re: [PATCH] ath9k_hw: Fix AR9003 MPDU delimeter CRC check for middle subframes
Date: Thu, 15 Jul 2010 08:54:18 +0530
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I just wonder if the delimiter length CRC is wrong, where from we
get the length of the data packet to get to a state where we say
we have received the data packet with correct CRC ?

I am not sure about this. I appreciate if someone could clarify this.
Thanks.


Regards,
Satya.
----- Original Message ----- 
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>; "Luis R. Rodriguez" 
<lrodriguez@atheros.com>; "Tushit Jain" <tushit.jain@atheros.com>; "Kyungwan 
Nam" <kyungwan.nam@atheros.com>
Sent: Thursday, July 15, 2010 5:38 AM
Subject: [PATCH] ath9k_hw: Fix AR9003 MPDU delimeter CRC check for middle 
subframes


> An A-MPDU may contain several subframes each containing its own
> CRC for the data. Each subframe also has a respective CRC for the
> MPDU length and 4 reserved bits (aka delimeter CRC). AR9003 will
> ACK frames that have a valid data CRC but have failed to pass the
> CRC for the MPDU length, if and only if the subframe is not the
> last subframe in an A-MPDU and if an OFDM phy OFDM reset error has
> been caught. Discarding those subframes results in packet loss under
> heavy stress conditions, an example being UDP video. Since the
> frames are ACK'd by hardware we need to let these frames through
> and process them as valid frames.
>
> Cc: Tushit Jain <tushit.jain@atheros.com>
> Cc: Kyungwan Nam <kyungwan.nam@atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
> drivers/net/wireless/ath/ath9k/ar9003_mac.c |   31 
> +++++++++++++++++++++++++-
> 1 files changed, 29 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c 
> b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> index 06ef710..5b995be 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> @@ -579,12 +579,39 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, 
> struct ath_rx_status *rxs,
>  rxs->rs_flags |= ATH9K_RX_DECRYPT_BUSY;
>
>  if ((rxsp->status11 & AR_RxFrameOK) == 0) {
> + /*
> + * AR_CRCErr will bet set to true if we're on the last
> + * subframe and the AR_PostDelimCRCErr is caught.
> + * In a way this also gives us a guarantee that when
> + * (!(AR_CRCErr) && (AR_PostDelimCRCErr)) we cannot
> + * possibly be reviewing the last subframe. AR_CRCErr
> + * is the CRC of the actual data.
> + */
>  if (rxsp->status11 & AR_CRCErr) {
>  rxs->rs_status |= ATH9K_RXERR_CRC;
>  } else if (rxsp->status11 & AR_PHYErr) {
> - rxs->rs_status |= ATH9K_RXERR_PHY;
>  phyerr = MS(rxsp->status11, AR_PHYErrCode);
> - rxs->rs_phyerr = phyerr;
> + /*
> + * If we reach a point here where AR_PostDelimCRCErr is
> + * true it implies we're *not* on the last subframe. In
> + * in that case that we know already that the CRC of
> + * the frame was OK, and MAC would send an ACK for that
> + * subframe, even if we did get a phy error of type
> + * ATH9K_PHYERR_OFDM_RESTART. This is only applicable
> + * to frame that are prior to the last subframe.
> + * The AR_PostDelimCRCErr is the CRC for the MPDU
> + * delimiter, which contains the 4 reserved bits,
> + * the MPDU length (12 bits), and follows the MPDU
> + * delimiter for an A-MPDU subframe (0x4E = 'N' ASCII).
> + */
> + if ((phyerr == ATH9K_PHYERR_OFDM_RESTART) &&
> +     (rxsp->status11 & AR_PostDelimCRCErr)) {
> + rxs->rs_phyerr = 0;
> + } else {
> + rxs->rs_status |= ATH9K_RXERR_PHY;
> + rxs->rs_phyerr = phyerr;
> + }
> +
>  } else if (rxsp->status11 & AR_DecryptCRCErr) {
>  rxs->rs_status |= ATH9K_RXERR_DECRYPT;
>  } else if (rxsp->status11 & AR_MichaelErr) {
> -- 
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> 



