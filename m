Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54833
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750934AbYGZHdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jul 2008 03:33:41 -0400
Date: Sat, 26 Jul 2008 00:33:41 -0700 (PDT)
Message-Id: <20080726.003341.211819981.davem@davemloft.net> (sfid-20080726_093356_627865_68AC8E66)
To: Larry.Finger@lwfinger.net
Cc: jussi.kivilinna@mbnet.fi, kaber@trash.net,
	linux-kernel@vger.kernel.org, free_beer_for_all@yahoo.com,
	linux-wireless@vger.kernel.org
Subject: Re: Regression in 2.6.26-gitX: failure of wireless due to commit
 175f9c1bba9b825d22b142
From: David Miller <davem@davemloft.net>
In-Reply-To: <488AB2F4.7060806@lwfinger.net>
References: <488AB2F4.7060806@lwfinger.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Sat, 26 Jul 2008 00:15:32 -0500

> Wireless communication has failed for recent 2.6.26-gitX kernels - a definite 
> regression. The logs show sequences such as:
...
>      net_sched: Add size table for qdiscs
> 

Yes we know, it exposes a larger problem that's been
present in the wireless stack for a long time.  It
assumes that the SKB control block can survive across
the SKB going through the qdisc, but that has never
been true.

We're thinking about how to solve this but have no
easy answers yet.
