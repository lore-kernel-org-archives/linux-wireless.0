Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:35192 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934413AbbLPRqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 12:46:07 -0500
Received: by mail-qg0-f46.google.com with SMTP id i91so32923209qgf.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 09:46:07 -0800 (PST)
Date: Wed, 16 Dec 2015 12:46:02 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "Adam R. Welle" <arwelle@cert.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
Message-ID: <20151216174602.GG4073@localhost> (sfid-20151216_184623_649787_A98BA8BD)
References: <5670DA9A.4010102@candelatech.com>
 <1450257464.3159.1.camel@sipsolutions.net>
 <56716386.4070107@candelatech.com>
 <1450272308.8247.11.camel@sipsolutions.net>
 <567168AF.4060804@candelatech.com>
 <1450273362.8247.15.camel@sipsolutions.net>
 <2DE9F46DD36D2A458CD6347950113F2535C1ED@marathon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2DE9F46DD36D2A458CD6347950113F2535C1ED@marathon>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 16, 2015 at 05:30:20PM +0000, Adam R. Welle wrote:
> 
> > Well, it was always rather awkward since it was the *second* address :)
> 
> Could somebody provide background information on why the decision was
> made to use a second address for the netlink frames instead of the same
> address as was used for the non-netlink frames? 

I can't; I believe it was done that way from the start but I don't really
know if there was a reason.

> I too have an obscure user-space app which uses this API :)
> 
> My app was written to account for both the old and new logic being debated,
> so I can cope either way with the flip of a switch. I would just like to
> say that for my purposes the patch worked better as I already intended for
> my app to track MAC address changes made by a user.

In any case, we'll need to support that.  However the addr attribute is
interpreted, the actual userspace app should accept any user defined address
as long as it can map it back to the attribute.  It just may be the case
going forward that the attribute bears no obvious relationship to the
addresses used in frames.

> I should note that I am passing these frames between virtual machines so
> the use of unique addresses (instead of hard-coded 0x42 addresses) as a key
> simplifies things when determining which radio transmitted a given frame
> and which radio needs to receive the frame. My app has always relied on the
> MAC address assigned by the user as a unique key across virtual machines.

Sounds interesting - is this app open source?

> Also, I will point out that I am not using multiple vifs on a radio but if
> I were, I imagine that I would send a copy of the frame to each vif.

I guess this is what wmediumd would wind up doing too, but it would result in
duplicate frames at the receivers with multiple vifs.

-- 
Bob Copeland %% http://bobcopeland.com/
