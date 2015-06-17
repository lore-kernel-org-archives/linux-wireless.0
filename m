Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46698 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbbFQI2A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:28:00 -0400
Message-ID: <1434529677.1884.9.camel@sipsolutions.net> (sfid-20150617_102805_500443_26E51E96)
Subject: Re: [PATCH v2] Add new mac80211 driver mwlwifi.
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lin <dlin@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>,
	Chor Teck Law <ctlaw@marvell.com>
Date: Wed, 17 Jun 2015 10:27:57 +0200
In-Reply-To: <7e061b3712f4408284917b5a5b4d3813@SC-EXCH02.marvell.com>
References: <2127ea28a2a74cd6a89d45b88caf06cb@SC-EXCH02.marvell.com>
	 <1434526059.1884.7.camel@sipsolutions.net>
	 <7e061b3712f4408284917b5a5b4d3813@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-17 at 08:07 +0000, David Lin wrote:

> > Also, you probably really should have two header files - one for the firmware
> > structs and one for the driver structs - especially since you seem to be
> > confusing the two!
> >
> As mentioned before, this is current interface with F/W, and this F/W
> is used by other marvell's drivers, I can't change it.

You're misunderstanding. I'm not asking you to change the interface. I'm
just asking you to make sure you know which part is firmware interface
and which isn't. Clearly, pointers *cannot* be firmware interface - if
there's something "cookie-like" that you use as pointers you at least
need to make sure you know how long this field is (32 or 64 bits)...

> All structures defined in this file are related to F/W commands, it
> should be better let them be defined in this file.

Given your own confusion on what's firmware API and what isn't, I'm not
so sure about that ...

johannes

