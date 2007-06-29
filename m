Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp136.iad.emailsrvr.com ([207.97.245.136]:48691 "EHLO
	smtp136.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXF2WlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2007 18:41:07 -0400
Message-ID: <46858A31.3050609@gentoo.org>
Date: Fri, 29 Jun 2007 18:39:45 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Export short-preamble bit to drivers
References: <200706251628.00838.mb@bu3sch.de> <1183024620.4769.80.camel@johannes.berg> <200706282301.16474.flamingice@sourmilk.net> <200706291013.07660.mb@bu3sch.de>
In-Reply-To: <200706291013.07660.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> Configure it for management/ctl frames that are sent in hw. We send them
> with long preamble atm.

I am working on patches which will help you here. Currently mac80211's 
handling of short preambles is correct for hostap/master mode but not 
for a STA.

The interface I'm working on adding will be somewhat similar to the 
softmac interface. That is, preambles are available on a per-frame basis 
and the driver also gets a notification when the availability of short 
preambles changes.

zd1211rw seems to have similar requirements for bcm43xx. The correct 
behaviour (IMO) is to send frames with long preambles until mac80211 
uses the above notification to tell you that short preambles are now 
allowable. This is how zd1211rw-softmac does it.

I have written the code for the above but have not had time to test it 
yet. Hopefully within the next few days...

Daniel
