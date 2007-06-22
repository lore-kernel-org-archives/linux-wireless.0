Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:41860 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752472AbXFVNqR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 09:46:17 -0400
Date: Fri, 22 Jun 2007 15:45:45 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Jiri Benc <jbenc@suse.cz>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] mac80211: kill mgmt interface
Message-ID: <20070622154545.29eeebdb@griffin.suse.cz>
In-Reply-To: <20070621151441.500d62d5@griffin.suse.cz>
References: <1182418939.10821.8.camel@johannes.berg>
	<20070621143558.68fc8e4a@griffin.suse.cz>
	<1182429920.21939.1.camel@johannes.berg>
	<20070621151441.500d62d5@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 21 Jun 2007 15:14:41 +0200, Jiri Benc wrote:
> That's true. Still, couldn't we find a better solution?

I have a new idea. Maybe it will turn out to have fatal design or
implementation problems, but anyway.

First, I thought how all of this would be easier if we have a native
802.11 (virtual) interfaces and don't translate from Ethernet. Then I
realized it wouldn't help us much - we want to specify some parameters
for each frame, so we'd have to use some encapsulation anyway to allow
radiotap headers. Hm, wait a moment - why we cannot use the
encapsulation we currently have? That means, why can't we encapsulate
raw 802.11 frames in Ethernet frames?

Before you reject the whole idea, please think a moment about it.

The actual implementation is not hard: use our own proprietary
ethertype and use the whole 802.11 frame including MAC and radiotap
header as a payload. We can even use the same format for sending
management frames to the user space for hostapd's use without any extra
interface.

Several things need to be handled first, of course:

- Returning of tx status. That could be solved by adding a stamp into
radiotap header of injected frame and returning a status (not the whole
frame, just the stamp plus some relevant info) through netlink.

- Interference with bridging. We don't want our injected (or returned
management) frame to be bridged. That could perhaps be solved by using
a certain Ethernet destination address (our own address?), but I'm not
sure here.

- There will probably more issues pop up.

 Jiri

-- 
Jiri Benc
SUSE Labs
