Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:45028 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890Ab0EBJFF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 May 2010 05:05:05 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1O8V6l-00009Z-Ow
	for linux-wireless@vger.kernel.org; Sun, 02 May 2010 11:05:03 +0200
Received: from host86-155-146-179.range86-155.btcentralplus.com ([86.155.146.179])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 02 May 2010 11:05:03 +0200
Received: from Adrian.Bassett by host86-155-146-179.range86-155.btcentralplus.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 02 May 2010 11:05:03 +0200
To: linux-wireless@vger.kernel.org
From: Adrian Bassett <Adrian.Bassett@hotmail.co.uk>
Subject: Re: [PATCH] rtl8180: fix tx status reporting
Date: Sun, 2 May 2010 09:02:10 +0000 (UTC)
Message-ID: <loom.20100502T102244-788@post.gmane.org>
References: <1272496482-12687-1-git-send-email-linville@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville <linville@...> writes:

> 
> When reporting Tx status, indicate that only one rate was used.
> Otherwise, the rate is frozen at rate index 0 (i.e. 1Mb/s).
> 
> Signed-off-by: John W. Linville <linville@...>
> ---
>  drivers/net/wireless/rtl818x/rtl8180_dev.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c
b/drivers/net/wireless/rtl818x/rtl8180_dev.c
> index d84ad05..8487327 100644
> --- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
> @@ -188,6 +188,7 @@ static void rtl8180_handle_tx(struct ieee80211_hw *dev,
unsigned int prio)
>  			info->flags |= IEEE80211_TX_STAT_ACK;
> 
>  		info->status.rates[0].count = (flags & 0xFF) + 1;
> +		info->status.rates[1].idx = -1;
> 
>  		ieee80211_tx_status_irqsafe(dev, skb);
>  		if (ring->entries - skb_queue_len(&ring->queue) == 2)

John,

I can confirm that this patch fixes the regression reported in the thread at
http://marc.info/?l=linux-wireless&m=123720659723688&w=2 so that the rtl8180
wireless driver and the minstrel rate controller now play together OK.  I would
endorse the suggestion that this patch is backported to stable.  Any chance of
late inclusion in 2.6.34?

Stats for info:

2.6.34-rc6-wl-00-47739-g27957c6

Rate control from /sys/kernel/debug/ieee80211/phy0/rc/name: minstrel

Stats from /sys/kernel/debug/ieee80211/phy0/stations/xx:xx:xx:xx:xx:xx/rc_stats

rate throughput  ewma prob   this prob  this succ/attempt   success    attempts
  P  1      0.9       98.1      100.0          0(  0)        137         142
     2      1.8       95.7      100.0          0(  0)         11          11
     5.5    4.8       95.7      100.0          0(  0)         11          11
    11      9.1       95.7      100.0          0(  0)         11          11
     6      5.4       95.9      100.0          0(  0)         18          20
     9      8.0       95.2      100.0          0(  0)         14          16
    12     10.5       95.3      100.0          0(  0)         13          14
    18     15.5       95.2      100.0          0(  0)         21          28
    24     20.3       95.4      100.0          0(  0)         65         110
 t  36     24.8       81.5      100.0          0(  0)        443         600
T   48     34.7       89.0      100.0          1(  1)       5348        6735
    54     17.8       41.1       25.0          0(  0)      16939       20381

Total packet count::    ideal 2794      lookaround 147


Thanks,

Adrian Bassett


