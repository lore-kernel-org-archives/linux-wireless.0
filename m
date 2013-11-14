Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48866 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab3KNPFc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 10:05:32 -0500
Message-ID: <1384441523.13941.35.camel@jlt4.sipsolutions.net> (sfid-20131114_160535_792925_454BF773)
Subject: Re: [RFC 1/5] cfg80211: pass the wdev on the country IE regulatory
 hint
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Thu, 14 Nov 2013 16:05:23 +0100
In-Reply-To: <20131114151159.GA29954@garbanzo.do-not-panic.com> (sfid-20131114_160125_849382_647DC657)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
	 <1384366379-25301-2-git-send-email-mcgrof@do-not-panic.com>
	 <1384377637.28806.14.camel@jlt4.sipsolutions.net>
	 <20131114140505.GA19070@garbanzo.do-not-panic.com>
	 <1384437774.13941.25.camel@jlt4.sipsolutions.net>
	 <20131114151159.GA29954@garbanzo.do-not-panic.com>
	 (sfid-20131114_160125_849382_647DC657)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-11-14 at 07:12 -0800, Luis R. Rodriguez wrote:

> > But that's kinda unsafe. Might also be worth just making it a
> > void* to avoid people trying to use it.
> 
> OK. I can see the cookie in theory race against the allocator
> releasing and creating a new wdev and it magically being
> the same pointer, but chances are really low of that.

Hmm, good point, maybe it'd be better to clean it up on netdev
unregistration.

johannes

