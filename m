Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40834 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758264AbXHOPYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 11:24:17 -0400
Subject: Re: [PATCHv3] mac80211: dynamic wep
From: Volker Braun <volker.braun@physik.hu-berlin.de>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200708142355.27708.flamingice@sourmilk.net>
References: <1187151162.3253.18.camel@thinkpad>
	 <200708142355.27708.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 11:24:15 -0400
Message-Id: <1187191455.6462.14.camel@carrot.hep.upenn.edu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-08-14 at 23:55 -0700, Michael Wu wrote:
> I suspect keyidx > 0 is done to allow hardware 
> without individual WEP key support to continue using hardware WEP.

I've wondered for a long time why Cisco chose to use keyidx>0 for WEP
unicast keys, but I think I finally understand that this is a weird
feature (8.5.1): In a mixed WEP and TKIP network a WEP key[0] would
conflict with the TKIP key (which must have keyidx == 0), forcing a dumb
TKIP STA to downgrade to WEP. (A good TKIP STA would just rely on
per-STA keys and not have this problem)

Volker Braun


