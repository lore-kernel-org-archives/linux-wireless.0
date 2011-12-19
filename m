Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:54973 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab1LSMeH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 07:34:07 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1RccPq-0008Qt-CK
	for linux-wireless@vger.kernel.org; Mon, 19 Dec 2011 13:34:02 +0100
Received: from 207.59.80.172 ([207.59.80.172])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 13:34:02 +0100
Received: from viscous.liquid by 207.59.80.172 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 13:34:02 +0100
To: linux-wireless@vger.kernel.org
From: Daniel Smith <viscous.liquid@gmail.com>
Subject: Re: Question about IEEE80211_TX_CTL_NO_ACK in ath_9k
Date: Mon, 19 Dec 2011 07:33:45 -0500
Message-ID: <jcnavc$psk$1@dough.gmane.org> (sfid-20111219_133411_312636_1BF4C827)
References: <4EED232D.3010208@lwfinger.net> <20111219112845.C748820066@mail.watchdata.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
In-Reply-To: <20111219112845.C748820066@mail.watchdata.com.cn>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

On 12/19/2011 6:38 AM, ภ๎ธี wrote:
> Hi everybody!
>
> My wireless card is AR9280. I set the IEEE80211_TX_CTL_NO_ACK flag before
> send a packet, but found it no use. It still wait for an ACK. Then I read
> the code,
> in ath9k_htc_tx_data(htc_drv_txrx.c) , it seems there is only two flags:
>
> #define ATH9K_HTC_TX_CTSONLY      0x1
> #define ATH9K_HTC_TX_RTSCTS       0x2
>
> None is about ack.
>
> Does anyone know how to make this flag work properly?
>

As an FYI if your card is a AR9280, then you should be looking in xmit.c
and not at the HTC related code.

I am also working on this issue to enable per-frame no-ack and have
already tracked it down to the following snippet in the function
ieee80211_tx_prepare (mac80211/tx.c).

if (is_multicast_ether_addr(hdr->addr1)) {
tx->flags &= ~IEEE80211_TX_UNICAST;
info->flags |= IEEE80211_TX_CTL_NO_ACK;
} else {
tx->flags |= IEEE80211_TX_UNICAST;
if (unlikely(local->wifi_wme_noack_test))
info->flags |= IEEE80211_TX_CTL_NO_ACK;
else
info->flags &= ~IEEE80211_TX_CTL_NO_ACK;
}

So if you send a unicast frame without this wifi_wme_noack_test flag set
then mac80211 will force the frame to require an ACK. To set the flag,

# sudo -s "echo 1> /sys/kernel/debug/ieee80211/phy0/noack"

Assuming phy0 is the wireless card with which you are wanting to do the
frame injection. The downside to this is that now every frame is passed
to ath9k with the no ack flag set.

Daniel

