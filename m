Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:54530
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757593AbXFAJyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 05:54:10 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Update stop_queues kdoc
Date: Fri, 1 Jun 2007 11:53:46 +0200
Cc: Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200706011129.12432.mb@bu3sch.de> <1180691291.18266.3.camel@johannes.berg>
In-Reply-To: <1180691291.18266.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200706011153.46914.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 01 June 2007 11:48:11 Johannes Berg wrote:
> On Fri, 2007-06-01 at 11:29 +0200, Michael Buesch wrote:
> > This updates stop_queue(s) kdoc as currently there's
> > a undocumented dependency.
> > 
> > Stopping the queue from anywhere else than the ops->tx()
> > callback will result in a hard to debug deadlock and
> > system freeze (on UP).
> 
> Ugh. Any way to actually detect a wrong spot to call it at runtime?

Probably by verifying if netif_tx_lock is locked somehow.
But I'm not sure.

-- 
Greetings Michael.
