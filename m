Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58911 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab0C2Nny (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 09:43:54 -0400
Subject: Re: iw station del broken?
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@siemens.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4BB0ADFA.8010205@siemens.com>
References: <4BB0A16A.7080400@siemens.com>
	 <1269867487.4131.28.camel@jlt3.sipsolutions.net>
	 <4BB0A5B1.9090003@siemens.com>
	 <1269868155.4131.29.camel@jlt3.sipsolutions.net>
	 <4BB0ADFA.8010205@siemens.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 15:43:52 +0200
Message-ID: <1269870232.4131.36.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-03-29 at 15:41 +0200, Marco Porsch wrote:

> That makes any scripting impossible, because it would mean a fine timing 
> between the ifup on the stations. Also I think you can't build complex 
> topologies this way.

Hmm, you're probably right.

> The alternative iw dev <devname> mpath set <destination MAC address> 
> next_hop <next hop MAC address> is not useful (if it is still included 
> though ^^) because it sets paths hard. Means that these paths are not 
> changed, even if they are broken.
> 
> Well, you're the maintainer. Your choice.
> 
> By the way: which was the last version with 'station del' in mesh 
> intact? Which codeparts would have to be exchanged if i'd like to use 
> this further? Only iw and nl80211?

Actually I think you only need to change a line in nl80211.c allowing
deleting; in fact deleting is OK (and thus I think we can put a patch in
adding it back) -- adding was the problem.

johannes

