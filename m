Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:42351 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbcFGP6V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 11:58:21 -0400
Message-ID: <5756E01F.6080107@ispras.ru> (sfid-20160607_175846_905086_4F771A62)
Date: Tue, 07 Jun 2016 18:54:23 +0400
From: Pavel Andrianov <andrianov@ispras.ru>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	libertas-dev@lists.infradead.org, ldv-project@linuxtesting.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, vaishali.thakkar@oracle.com
Subject: Re: [ldv-project] [net] libertas: potential race condition
References: <57569424.9040906@ispras.ru> <1465310395.29158.2.camel@redhat.com>
In-Reply-To: <1465310395.29158.2.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

07.06.2016 18:39, Dan Williams пишет:
> On Tue, 2016-06-07 at 13:30 +0400, Pavel Andrianov wrote:
>> Hi!
>>
>> There is a potential race condition in
>> drivers/net/wireless/libertas/libertas.ko.
>> In the function lbs_hard_start_xmit(..), line 159, a socket buffer
>> is
>> written to priv->current_skb with a spin_lock protection.
>> In the function lbs_mac_event_disconnected(..), lines 50-51, the
>> field
>> current_skb is cleaned. There is no protection used. The
>> corresponding
>> handlers are activated at the same time in lbs_start_card(..) and
>> then
>> may be executed simultaneously. Note, there are two structures
>> lbs_netdev_ops and mesh_netdev_ops, which have the target handler
>> lbs_hard_start_xmit.
>> Is it a real race or I have missed something?
> Yeah, it looks like it should be grabbing priv->driver_lock before
> clearing priv->currenttxskb in lbs_mac_event_disconnected().  Care to
> submit a patch after testing?  Do you have any of that hardware?
>
> Dan
I have no that hardware and I have some doubts about the simple fix, 
you've suggested. For instance, in lbs_hard_start_xmit the lock is 
acquired twice and the priv->tx_pending_len can be modified also by 
lbs_mac_event_disconnected (even if spin_lock will be added to 
lbs_mac_event_disconnected). Moreover, the function lbs_send_tx_feedback 
also cleaned priv->currenttxskb, but it happens also without any 
protection. Thus, the fix has to be more complicated, and I have no 
ideas about it.

-- 
Pavel Andrianov
Linux Verification Center, ISPRAS
web: http://linuxtesting.org
e-mail: andrianov@ispras.ru

