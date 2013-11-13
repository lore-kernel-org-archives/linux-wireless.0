Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:40863 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab3KMLiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 06:38:06 -0500
Received: by mail-bk0-f47.google.com with SMTP id mx10so261610bkb.6
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 03:38:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131113112810.5221.69685.stgit@localhost6.localdomain6>
References: <20131113112810.5221.69685.stgit@localhost6.localdomain6>
Date: Wed, 13 Nov 2013 12:38:04 +0100
Message-ID: <CA+BoTQkLsbwEAX6RomC_ZA-rtL6q1Q871=9n-Mgry=AZgrKs6Q@mail.gmail.com> (sfid-20131113_123810_048270_EFE53F41)
Subject: Re: [PATCH] ath10k: remove htt rx amsdu clear retry bit hack
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 November 2013 12:28, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> With commit 0cfcefef1 ("mac80211: support reporting A-MSDU subframes
> individually") there's no need to have the hack to clear the retry bit in
> ath10k_htt_rx_amsdu(), mac80211 can handle this properly now.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/htt_rx.c |   17 -----------------
>  1 file changed, 17 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index 90d4f74..76c152b 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -659,23 +659,6 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
>         memcpy(hdr_buf, hdr, hdr_len);
>         hdr = (struct ieee80211_hdr *)hdr_buf;
>
> -       /* FIXME: Hopefully this is a temporary measure.
> -        *
> -        * Reporting individual A-MSDU subframes means each reported frame
> -        * shares the same sequence number.
> -        *
> -        * mac80211 drops frames it recognizes as duplicates, i.e.
> -        * retransmission flag is set and sequence number matches sequence
> -        * number from a previous frame (as per IEEE 802.11-2012: 9.3.2.10
> -        * "Duplicate detection and recovery")
> -        *
> -        * To avoid frames being dropped clear retransmission flag for all
> -        * received A-MSDUs.
> -        *
> -        * Worst case: actual duplicate frames will be reported but this should
> -        * still be handled gracefully by other OSI/ISO layers. */
> -       hdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_RETRY);
> -
>         first = skb;
>         while (skb) {
>                 void *decap_hdr;
>

You're missing RX_FLAG_AMSDU_MORE. All subframes (except the last one)
from an A-MSDU that are reported separately must have the bit set in
status->flag. Only then mac80211 can apply retransmission/duplication
check properly.


Michał
