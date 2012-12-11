Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59962 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab2LKPI7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 10:08:59 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so1665321bkw.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2012 07:08:57 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH 3/3] p54: zero-out rx_status
Date: Tue, 11 Dec 2012 16:08:43 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1355234105-12013-1-git-send-email-juhosg@openwrt.org> <1355234105-12013-3-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1355234105-12013-3-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201212111608.43293.chunkeey@googlemail.com> (sfid-20121211_160907_576808_50E80D43)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, December 11, 2012 02:55:05 PM Gabor Juhos wrote:
> In commit 'mac80211: support radiotap vendor namespace RX data'
> new fields were added to 'struct ieee80211_rx_status'.
> The ath5k driver does not initializes those fields and
      ^^^^^ p54?!

> this can cause unexpected behaviour. The patch ensures
> that each field gets initialized with zeroes.

Actually, when the skb is alloced/initialized by
__alloc_skb, the skb->cb is already zeroed (which
is where the ieee80211_rx_status will be stored).

And while p54 recycles command response skbs, the 
driver does not touch the skb->cb of 802.11 skbs,
until the frame is destined for ieee80211_rx_irqsave.

If this issue just popped up now, I suspect that 
something else is silently corrupting our SKBs 
[or can anybody see how rt2x00 hit this issue?]

> Cc: Christian Lamparter <chunkeey@googlemail.com>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> ---
> Compile tested only.
> ---
>  drivers/net/wireless/p54/txrx.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
> index 12f0a34..be2552e 100644
> --- a/drivers/net/wireless/p54/txrx.c
> +++ b/drivers/net/wireless/p54/txrx.c
> @@ -345,6 +345,8 @@ static int p54_rx_data(struct p54_common *priv, struct sk_buff *skb)
>  	if (!(hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_IN_FCS_GOOD)))
>  		return 0;
>  
> + 	memset(rx_status, 0, sizeof(*rx_status));
> +
>  	if (hdr->decrypt_status == P54_DECRYPT_OK)
>  		rx_status->flag |= RX_FLAG_DECRYPTED;
>  	if ((hdr->decrypt_status == P54_DECRYPT_FAIL_MICHAEL) ||
> 
