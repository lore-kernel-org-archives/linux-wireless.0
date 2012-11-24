Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:47604 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab2KXLWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 06:22:08 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so9515911oag.19
        for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2012 03:22:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353667565-4212-1-git-send-email-Wojciech.Dubowik@neratec.com>
References: <1353667565-4212-1-git-send-email-Wojciech.Dubowik@neratec.com>
Date: Sat, 24 Nov 2012 16:52:04 +0530
Message-ID: <CAD2nsn0xrnWbrEZzhaKhipuwE-Hyc-KpCEWcuef+=NeF0gFmDg@mail.gmail.com> (sfid-20121124_122213_588223_7BB2E3CD)
Subject: Re: [RFC 1/1] ath9k: Add radiotap vendor specific data example
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 23, 2012 at 4:16 PM, Wojciech Dubowik
<Wojciech.Dubowik@neratec.com> wrote:
> As an exmaple of vendor specific data we can extract rssi
> and evm values for all the chains so one can see them on
> per packet basis. More can be added depending on the needs i.e.
> noise floor, Ness, STBC, key miss, etc.
> AtheorsC OUI is used in this example but it should be replaced
> by own when in use.
>
> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
> ---
>  drivers/net/wireless/ath/ath9k/recv.c |   33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index 6aafbb7..02c36c4 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -1246,6 +1246,39 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>                 if ((ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) && sc->ant_rx == 3)
>                         ath_ant_comb_scan(sc, &rs);
>
> +#if 0

please remove ifdefs .


> +               /*TODO: Replace oui and vendor sub namespace with valid data
> +                * and add/remove fields below
> +                */
> +               if( skb_headroom(skb) >  22 ) {
> +                       int8_t* vendor_data;

we can use s8 ?


> +
> +                       vendor_data = skb_push(skb, 22);
> +
> +                       rxs->vendor_radiotap_len = 22;
> +                       rxs->vendor_radiotap_align = 4;
> +                       rxs->vendor_radiotap_oui[0] = 0x0;
> +                       rxs->vendor_radiotap_oui[1] = 0x3;
> +                       rxs->vendor_radiotap_oui[2] = 0x7f;
> +                       rxs->vendor_radiotap_subns = 0;
> +                       rxs->vendor_radiotap_bitmap = 0x00000001;
> +
> +                       /* count bytes below and put it as the length*/
> +                       *vendor_data++ = rs.rs_rssi;
> +                       *vendor_data++ = rs.rs_rssi_ctl0;
> +                       *vendor_data++ = rs.rs_rssi_ctl1;
> +                       *vendor_data++ = rs.rs_rssi_ctl2;
> +                       put_unaligned_le32(rs.evm0, vendor_data);
> +                       vendor_data += 4;
> +                       put_unaligned_le32(rs.evm1, vendor_data);
> +                       vendor_data += 4;
> +                       put_unaligned_le32(rs.evm2, vendor_data);
> +                       vendor_data += 4;
> +                       put_unaligned_le32(rs.evm3, vendor_data);
> +                       vendor_data += 4;
> +                       put_unaligned_le16(rs.evm4, vendor_data);
> +               }
> +#endif


would be nice check this stuff in sniffer.

>                 ieee80211_rx(hw, skb);
>
>  requeue_drop_frag:
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
