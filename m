Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.77.101.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793865032;
	b=E5eLt1/VSNfpc+EcpFmyO+FGZZejTXQ06dN25dlzQafRryOAJcyWJWvBbd0j6qwRVwYM
	 ZX4jCmoFRM/onOgpgvw5zXnXT6fehP8F4JWOvmkV/B3BhsRIwJoe5k8O2ZKes/iakFXIi
	 Rj7lMC5OV9iW1rOTaMdwvWSsG4FJboLviwxjfeGvXcgvgDAlxQj646aYxQw7XlpTAl+U8
	 Q0yEeWne1jahfmey1YdSS3G8xnnGvU5DYGBGDgGz12NQX7VsgZOvlRojWhCOTQAummtY/
	 XqEA7KUrEuGKF9FbAMjiJZ8y3t6z7hKRb1Eusm7MaUlFQ7yJBKrOhK8HLzdPISB+JpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793865032;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=MT7CHxtYrEBjce/G8CudYmVuEwhrgxDZngOuUCegR5s=;
	b=Jto5DG3F9sfWqSuwdsx0u6xf9NgU2ji4aUQdJ3MW3umqa+7zike8DDugFXwfg2NbvA1p
	 OMK7tuptxpVSM7THn1KrhXVU2/ZzEzFF7w6SMW5smJFADxjdmA26AZtlDsvcSFYGKTTEz
	 PgB3OUdPIVD+r+ZPHXej0127MDDj0I1LbQ+lmxN776mRGBUEQZjL+tU0U9DMnUqCTEOnp
	 L4D3vxm3xPqjgLtmVwQ1/4kBFFy2bqSCZxiPPNKspfprWBXzFnOESSCDn+QWNPh9qXdi5
	 qgm3UbNNEM0CkvkL8JFDHLcPqv213QY7lWzdmMS3hvULEzYlrGRXaf69+sYlfjm9Jbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wp.pl;
	spf=pass smtp.mailfrom=wp.pl;
	dkim=pass header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=HYFklPJ8;
	arc=none smtp.remote-ip=212.77.101.12
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA51606A329
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 07:50:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EA51606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=HYFklPJ8
Received: (wp-smtpd smtp.wp.pl 8454 invoked from network); 5 Nov 2026 08:50:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1793865028; bh=MT7CHxtYrEBjce/G8CudYmVuEwhrgxDZngOuUCegR5s=;
          h=From:To:Cc:Subject;
          b=HYFklPJ8Jz+u1quSO5zrrTCKNril2QrpsA2ht6Mj6C5gGkhB5JhXHoHxOP2gww3ls
           gDYG72l3A2ywieDfVZB1N+F0f2mExV2DtMlvC+cD6NDX7edn8HR2Q1hPBIPZlGF1Ml
           Opl2fs7QAUXYZhff0oFF/oy32cOZLRLnlWnzCsoDjLjCJERyE3JRjOh0e1U1bt4siF
           pKF3aEoaiQK5Vm5+gkEuuwyULT1A60dUHix0SqgYLLfilG2Dzkt91jPPhjgPhKyrGz
           nVCwhyj1T356NFIqNsvYI9SEUTRx8a7Q5/6YknvaTkNykUTwLVrjpP2EnmIXUpJmPU
           kOs8xZATGOySA==
Received: from localhost (77-236-11-168.static.play.pl [77.236.11.168])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <hjf3108@gmail.com>; 5 Nov 2026 08:50:28 +0100
Date: Thu, 5 Nov 2026 08:50:28 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Ho Jie Feng <hjf3108@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-next v2 2/7] wifi: rt2800: calibrate the crystal
 of RT3593 with the beacons
Message-ID: <20261105075028.GB64923@wp.pl>
References: <20261031165117.2868671-1-hjf3108@gmail.com>
 <20261031165117.2868671-3-hjf3108@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261031165117.2868671-3-hjf3108@gmail.com>
X-WP-MailID: 551f157876d80c84defb86f2e927fff3
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [oSM0]                               

Hi,

On Sun, Nov 01, 2026 at 12:51:09AM +0800, Ho Jie Feng wrote:
> On a Netgear WNDA4100 (RT3593), as the adapter warms up, the
> frequency offset drifts enough to affect the link quality.
> In certain cases it can cause the link speed to drop
> to 1Mbit/s or below.
> 
> Add a frequency calibration step function to RT3593 to use
> the frequency offset obtained from the beacon frames of the AP
> for tuning.
> 
> Test results:
>    before after
> TX 27.7   28.5
> RX 31.6   69.7
> 
> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2800.h   |   1 +
>  .../net/wireless/ralink/rt2x00/rt2800lib.c    | 101 ++++++++++++++++++
>  .../net/wireless/ralink/rt2x00/rt2800lib.h    |   4 +
>  .../net/wireless/ralink/rt2x00/rt2800usb.c    |   1 +
>  drivers/net/wireless/ralink/rt2x00/rt2x00.h   |   6 ++
>  .../net/wireless/ralink/rt2x00/rt2x00lib.h    |   2 +
>  .../net/wireless/ralink/rt2x00/rt2x00link.c   |   9 ++
>  7 files changed, 124 insertions(+)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
> index 8930589b4967d..b9f6de3a462e3 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
> @@ -3163,6 +3163,7 @@ enum rt2800_eeprom_word {
>   */
>  #define RXWI_W3_SNR0			FIELD32(0x000000ff)
>  #define RXWI_W3_SNR1			FIELD32(0x0000ff00)
> +#define RXWI_W3_FOFFSET			FIELD32(0xff000000)
>  
>  /*
>   * Macros for converting txpower from EEPROM to mac80211 value
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index 2e2e382b62475..e7b6edf485099 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -897,6 +897,28 @@ static int rt2800_agc_to_rssi(struct rt2x00_dev *rt2x00dev, u32 rxwi_w2)
>  	return (int)max(rssi0, rssi2);
>  }
>  
> +static void rt2800_rx_freq_offset(struct queue_entry *entry,
> +				  struct rxdone_entry_desc *rxdesc)
> +{
> +	struct rt2800_drv_data *drv_data = entry->queue->rt2x00dev->drv_data;
> +	__le32 *rxwi = (__le32 *) entry->skb->data;
> +	struct ieee80211_hdr *hdr =
> +	    (void *)(entry->skb->data + entry->queue->winfo_size);
> +	u32 word;
> +
> +	if (!(rxdesc->dev_flags & RXDONE_MY_BSS) ||
> +	    (rxdesc->flags & RX_FLAG_FAILED_FCS_CRC) ||
> +	    !ieee80211_is_beacon(hdr->frame_control))
> +		return;
> +
> +	word = rt2x00_desc_read(rxwi, 3);
> +
> +	spin_lock_bh(&drv_data->bcn_lock);
> +	drv_data->bcn_freq_offset = rt2x00_get_field32(word, RXWI_W3_FOFFSET);
> +	drv_data->bcn_rate_mode = rxdesc->rate_mode;
> +	spin_unlock_bh(&drv_data->bcn_lock);
> +}
> +
>  void rt2800_process_rxwi(struct queue_entry *entry,
>  			 struct rxdone_entry_desc *rxdesc)
>  {
> @@ -935,6 +957,14 @@ void rt2800_process_rxwi(struct queue_entry *entry,
>  	 * Convert descriptor AGC value to RSSI value.
>  	 */
>  	rxdesc->rssi = rt2800_agc_to_rssi(entry->queue->rt2x00dev, word);
> +
> +	/*
> +	 * The frequency offset of the beacons is used for the frequency
> +	 * calibration.
> +	 */
> +	if (rt2x00_rt(entry->queue->rt2x00dev, RT3593))
> +		rt2800_rx_freq_offset(entry, rxdesc);
> +

I dislike fact that this is part of ->fill_rxdone() callback.
I think it would be better to add new field in rxdesc and
add flag there indicating the bcn_freq_offset is valid. 

Then add new function in rt2x00lib_rxdone_skb().

Regards
Stanislaw

