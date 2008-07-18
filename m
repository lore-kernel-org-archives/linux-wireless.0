Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.vyatta.com ([216.93.170.194]:38617 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760873AbYGRTFp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 15:05:45 -0400
Date: Fri, 18 Jul 2008 12:05:43 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, kaber@trash.net, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/31]: netdev: Allocate multiple queues for TX.
Message-ID: <20080718120543.17ccf177@extreme> (sfid-20080718_210612_224923_6A169256)
In-Reply-To: <20080717.051545.150785763.davem@davemloft.net>
References: <20080717.051545.150785763.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new multi-queue stuff confuses sparses lock annotation.
It thinks any usage of netif_tx_lock/netif_tx_unlock is commiting
lock imbalance. Maybe some magic annotation will fix it?
