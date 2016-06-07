Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948AbcFGOj6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 10:39:58 -0400
Message-ID: <1465310395.29158.2.camel@redhat.com> (sfid-20160607_164044_407443_22396C57)
Subject: Re: [ldv-project] [net] libertas: potential race condition
From: Dan Williams <dcbw@redhat.com>
To: Pavel Andrianov <andrianov@ispras.ru>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: libertas-dev@lists.infradead.org, LDV list <ldv-project@ispras.ru>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, vaishali.thakkar@oracle.com
Date: Tue, 07 Jun 2016 09:39:55 -0500
In-Reply-To: <57569424.9040906@ispras.ru>
References: <57569424.9040906@ispras.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-06-07 at 13:30 +0400, Pavel Andrianov wrote:
> Hi!
> 
> There is a potential race condition in 
> drivers/net/wireless/libertas/libertas.ko.
> In the function lbs_hard_start_xmit(..), line 159, a socket buffer
> is 
> written to priv->current_skb with a spin_lock protection.
> In the function lbs_mac_event_disconnected(..), lines 50-51, the
> field 
> current_skb is cleaned. There is no protection used. The
> corresponding 
> handlers are activated at the same time in lbs_start_card(..) and
> then 
> may be executed simultaneously. Note, there are two structures 
> lbs_netdev_ops and mesh_netdev_ops, which have the target handler 
> lbs_hard_start_xmit.
> Is it a real race or I have missed something?

Yeah, it looks like it should be grabbing priv->driver_lock before
clearing priv->currenttxskb in lbs_mac_event_disconnected().  Care to
submit a patch after testing?  Do you have any of that hardware?

Dan
