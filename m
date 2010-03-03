Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f212.google.com ([209.85.218.212]:48998 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab0CCG5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 01:57:44 -0500
Subject: Re: [net-2.6 PATCH] af_packet: move strict addr_len check right
 before dev_[mc/unicast]_[add/del]
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Pirko <jpirko@redhat.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net,
	linux-wireless@vger.kernel.org, tcpdump-workers@lists.tcpdump.org,
	proski@gnu.org
In-Reply-To: <20100303064001.GB2648@psychotron.redhat.com>
References: <1267578048.14049.11.camel@mj>
	 <20100303064001.GB2648@psychotron.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 07:57:39 +0100
Message-ID: <1267599459.2839.91.camel@edumazet-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le mercredi 03 mars 2010 à 07:40 +0100, Jiri Pirko a écrit :
> Subject: [net-2.6 PATCH] af_packet: move strict addr_len check right before dev_[mc/unicast]_[add/del]
> 
> My previous patch 914c8ad2d18b62ad1420f518c0cab0b0b90ab308 incorrectly changed
> the length check in packet_mc_add to be more strict. The problem is that
> userspace is not filling this field (and it stays zeroed) in case of setting
> PACKET_MR_PROMISC or PACKET_MR_ALLMULTI. So move the strict check to the point
> in path where the addr_len must be set correctly.
> 
> Signed-off-by: Jiri Pirko <jpirko@redhat.com>
> 

I am not sure it solves Pavel Roskin concern, but some credit should be
given to him :)

Reported-by: Pavel Roskin <proski@gnu.org>

Thanks


