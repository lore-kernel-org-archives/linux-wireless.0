Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34115 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab1LSMdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 07:33:20 -0500
Received: by vcbfk14 with SMTP id fk14so3931267vcb.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 04:33:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111219112845.C748820066@mail.watchdata.com.cn>
References: <4EED232D.3010208@lwfinger.net>
	<20111219112845.C748820066@mail.watchdata.com.cn>
Date: Mon, 19 Dec 2011 18:03:19 +0530
Message-ID: <CAD2nsn1UO5Lz0h4DQiYr0n=W9TAyXeGYuPbvuNt9JKeGhBjB8g@mail.gmail.com> (sfid-20111219_133323_647414_E51B215A)
Subject: Re: Question about IEEE80211_TX_CTL_NO_ACK in ath_9k
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: =?GB2312?B?wO641Q==?= <gang.li@watchdata.com>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=GB2312
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/12/19 ภ๎ธี <gang.li@watchdata.com>:
> Hi everybody!
>
> My wireless card is AR9280. I set the IEEE80211_TX_CTL_NO_ACK flag before
> send a packet, but found it no use. It still wait for an ACK. Then I read
> the code,

may be any of the following hacks may work ?

@@ -1039,6 +1039,9 @@ static void ath_tx_fill_desc(struct ath_softc
*sc, struct ath_buf *bf,
        info.qcu = txq->axq_qnum;

        info.flags = ATH9K_TXDESC_INTREQ;
+
+               info.flags |= ATH9K_TXDESC_NOACK;
+
        if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
                info.flags |= ATH9K_TXDESC_NOACK;
        if (tx_info->flags & IEEE80211_TX_CTL_LDPC)

(or)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index edcd1c7..0454dee 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1185,6 +1185,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
        } else
                tx->flags |= IEEE80211_TX_UNICAST;

+               info->flags |= IEEE80211_TX_CTL_NO_ACK;
+
        if (!(info->flags & IEEE80211_TX_CTL_DONTFRAG)) {
                if (!(tx->flags & IEEE80211_TX_UNICAST) ||
                    skb->len + FCS_LEN <= local->hw.wiphy->frag_threshold ||



-- 
shafi
