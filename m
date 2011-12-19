Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [119.255.1.60] ([119.255.1.60]:49525 "EHLO
	mail.watchdata.com.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1LSNBq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 08:01:46 -0500
Received: from localhost (mail.watchdata.com.cn [127.0.0.1])
	by mail.watchdata.com.cn (Postfix) with SMTP id 455D920069
	for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 20:50:52 +0800 (CST)
From: =?gb2312?B?wO641Q==?= <gang.li@watchdata.com>
To: "'Daniel Smith'" <viscous.liquid@gmail.com>,
	<linux-wireless@vger.kernel.org>
Subject: RE: Question about IEEE80211_TX_CTL_NO_ACK in ath_9k
Date: Mon, 19 Dec 2011 21:00:22 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
In-Reply-To: <jcnavc$psk$1@dough.gmane.org>
Message-Id: <20111219125052.3B5A42005C@mail.watchdata.com.cn> (sfid-20111219_140150_030830_3F853F47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> Hi!
> 
> On 12/19/2011 6:38 AM, ภ๎ธี wrote:
> > Hi everybody!
> >
> > My wireless card is AR9280. I set the IEEE80211_TX_CTL_NO_ACK flag
before
> > send a packet, but found it no use. It still wait for an ACK. Then I
read
> > the code,
> > in ath9k_htc_tx_data(htc_drv_txrx.c) , it seems there is only two flags:
> >
> > #define ATH9K_HTC_TX_CTSONLY      0x1
> > #define ATH9K_HTC_TX_RTSCTS       0x2
> >
> > None is about ack.
> >
> > Does anyone know how to make this flag work properly?
> >
> 
> As an FYI if your card is a AR9280, then you should be looking in xmit.c
> and not at the HTC related code.

Hi, Daniel, Thanks you !

Sorry,  I didn't make it clear!  My 9280 is an USB card, so the related code
is htc_drv_*.c.



> 
> I am also working on this issue to enable per-frame no-ack and have
> already tracked it down to the following snippet in the function
> ieee80211_tx_prepare (mac80211/tx.c).
> 
> if (is_multicast_ether_addr(hdr->addr1)) {
> tx->flags &= ~IEEE80211_TX_UNICAST;
> info->flags |= IEEE80211_TX_CTL_NO_ACK;
> } else {
> tx->flags |= IEEE80211_TX_UNICAST;
> if (unlikely(local->wifi_wme_noack_test))
> info->flags |= IEEE80211_TX_CTL_NO_ACK;
> else
> info->flags &= ~IEEE80211_TX_CTL_NO_ACK;
> }

I have seen these codes in tx.c,  and at first I thought it should work, but
does not.


> 
> So if you send a unicast frame without this wifi_wme_noack_test flag set
> then mac80211 will force the frame to require an ACK. To set the flag,
> 
> # sudo -s "echo 1> /sys/kernel/debug/ieee80211/phy0/noack"
> 
> Assuming phy0 is the wireless card with which you are wanting to do the
> frame injection. The downside to this is that now every frame is passed
> to ath9k with the no ack flag set.
> 
> Daniel
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

