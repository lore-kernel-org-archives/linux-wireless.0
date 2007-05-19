Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653AbXESDRK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 23:17:10 -0400
Message-ID: <464E6B82.40607@redhat.com>
Date: Sat, 19 May 2007 11:14:10 +0800
From: Eugene Teo <eteo@redhat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org, jeff@garzik.org,
	Florin Malita <fmalita@gmail.com>
Subject: Re: [2.6 patch] drivers/net/wireless/libertas/rx.c: fix use-after-free
References: <464DD957.9040803@redhat.com> <20070518174623.GA3492@tuxdriver.com>
In-Reply-To: <20070518174623.GA3492@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> First, please send all wireless patches to
> linux-wireless@vger.kernel.org, and be sure to CC me as well...thanks!
> 
> On Sat, May 19, 2007 at 12:50:31AM +0800, Eugene Teo wrote:
>> libertas_upload_rx_packet() calls netif_rx() before returning, and it always return 0.
>> Also within libertas_upload_rx_packet(), it will initialize skb->protocol anyways.
>>
>> Spotted by the Coverity checker.
> 
> A nearly identical patch was posted by Florin Malita <fmalita@gmail.com>
> to netdev (also the wrong list) on Wednesday evening.

Nod. I wasn't subscribed to netdev list.

>>  done:
>>         LEAVE();
>>
>> -       skb->protocol = __constant_htons(0x0019);       /* ETH_P_80211_RAW */
>> -
> 
> Except for this part...is this intentional?

skb could have been freed by then. And, in libertas_upload_rx_packet(), skb->protocol
is initialized by eth_type_trans(skb, priv->wlan_dev.netdev).

Eugene

