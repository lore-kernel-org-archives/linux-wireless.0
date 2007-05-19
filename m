Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.osdl.org ([207.189.120.12]:52430 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487AbXESFYj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 May 2007 01:24:39 -0400
Date: Fri, 18 May 2007 22:23:08 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Florin Malita <fmalita@gmail.com>, marcelo@kvack.org,
	linville@redhat.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: skb dereferenced after netif_rx
Message-ID: <20070518222308.11c2b34d@localhost>
In-Reply-To: <20070518180903.GC3492@tuxdriver.com>
References: <464B7127.5080502@gmail.com>
	<20070518180903.GC3492@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 18 May 2007 14:09:03 -0400
"John W. Linville" <linville@tuxdriver.com> wrote:

> On Wed, May 16, 2007 at 05:01:27PM -0400, Florin Malita wrote:
> > In libertas_process_rxed_packet() and process_rxed_802_11_packet() the 
> > skb is dereferenced after being passed to netif_rx (called from 
> > libertas_upload_rx_packet). Spotted by Coverity (1658, 1659).
>  
> Relocating the libertas_upload_rx_packet call is fine, but...
> 
> > Also, libertas_upload_rx_packet() unconditionally returns 0 so the error 
> > check is dead code - might as well take it out.
> 
> Is this merely an implementation detail?  Or an absolute fact?
> If the former is true, then we should preserve the error
> checking.  If the latter, then we should change the signature of
> libertas_upload_rx_packet to return void.

netif_rx() used to return a value in older kernels.
