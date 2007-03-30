Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35322
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbXC3KLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2007 06:11:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: cfg80211 wext compat w/o wext code changes, rtnl locking
Date: Fri, 30 Mar 2007 12:11:04 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	James Ketrenos <jketreno@linux.intel.com>
References: <1175122815.8807.21.camel@johannes.berg>
In-Reply-To: <1175122815.8807.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200703301211.05261.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 29 March 2007 01:00, Johannes Berg wrote:
> -			if(handler != NULL) {
> +			if (handler) {
> +				if (!dev->wireless_handlers->no_locking)
> +					rtnl_lock();

Is sparse OK with this conditional locking?

-- 
Greetings Michael.
