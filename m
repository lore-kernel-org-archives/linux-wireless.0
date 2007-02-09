Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:56967 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946488AbXBIOny (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 09:43:54 -0500
Date: Fri, 9 Feb 2007 15:43:51 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: remove hosttime from ieee80211_rx_status
Message-ID: <20070209154351.60b36308@griffin.suse.cz>
In-Reply-To: <200702082359.47085.flamingice@sourmilk.net>
References: <200702082359.47085.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 8 Feb 2007 23:59:42 -0500, Michael Wu wrote:
> Nobody fills hosttime in ieee80211_rx_status. Removing it allows
> ieee80211_rx_status to fit in skb->cb.

It can lead to different times being presented in the same frame
delivered to different interfaces (like two monitor interfaces). That's
probably no issue, just wanted to point it out.

Michael Buesch's comment is valid, though.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
