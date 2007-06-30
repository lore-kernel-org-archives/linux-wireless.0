Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41301
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbXF3MsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2007 08:48:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH] mac80211: Export short-preamble bit to drivers
Date: Sat, 30 Jun 2007 14:47:10 +0200
Cc: Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200706251628.00838.mb@bu3sch.de> <200706291013.07660.mb@bu3sch.de> <46858A31.3050609@gentoo.org>
In-Reply-To: <46858A31.3050609@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200706301447.10650.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 30 June 2007 00:39:45 Daniel Drake wrote:
> Michael Buesch wrote:
> > Configure it for management/ctl frames that are sent in hw. We send them
> > with long preamble atm.
> 
> I am working on patches which will help you here. Currently mac80211's 
> handling of short preambles is correct for hostap/master mode but not 
> for a STA.
> 
> The interface I'm working on adding will be somewhat similar to the 
> softmac interface. That is, preambles are available on a per-frame basis 
> and the driver also gets a notification when the availability of short 
> preambles changes.
> 
> zd1211rw seems to have similar requirements for bcm43xx. The correct 
> behaviour (IMO) is to send frames with long preambles until mac80211 
> uses the above notification to tell you that short preambles are now 
> allowable. This is how zd1211rw-softmac does it.
> 
> I have written the code for the above but have not had time to test it 
> yet. Hopefully within the next few days...

Great!
So Jiri please drop my patch infavour of Daniel's.

-- 
Greetings Michael.
