Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:35222 "EHLO
	mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbbLPO7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 09:59:38 -0500
Received: by mail-qk0-f179.google.com with SMTP id u65so47912003qkh.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 06:59:37 -0800 (PST)
Date: Wed, 16 Dec 2015 09:59:33 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
Message-ID: <20151216145933.GE4073@localhost> (sfid-20151216_155941_713823_1E2E78EB)
References: <5670DA9A.4010102@candelatech.com>
 <1450257464.3159.1.camel@sipsolutions.net>
 <56716386.4070107@candelatech.com>
 <1450272308.8247.11.camel@sipsolutions.net>
 <567168AF.4060804@candelatech.com>
 <1450273362.8247.15.camel@sipsolutions.net>
 <56717119.1040701@candelatech.com>
 <1450275340.8247.18.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1450275340.8247.18.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 16, 2015 at 03:15:40PM +0100, Johannes Berg wrote:
> On Wed, 2015-12-16 at 06:11 -0800, Ben Greear wrote:
> 
> > My code expected that the key was the MAC of the radio, not the
> > MAC of a vif.  It set up mappings accordingly in the user-space
> > program.
> 
> I guess you were trying to be much smarter than wmediumd :)
> 
> Bob, any thoughts?

So, now that I understand the argument, I see the value in having
an unchanging key for each phy.  I'm also pretty sure that it was by
accident that it used to work that way.  If we were designing the ABI
from scratch, radio id would probably be better than a mac address for
that purpose.

Anyway, in the interest of not breaking userspace, I'm not opposed to
reverting that patch, and perhaps adding some documentation on top to make
it clear that the addr attributes have nothing to do with any mac addresses
actually in use.

For wmediumd users that would mean going back to the way it was previously,
in which only the 42:xx mac addresses will work, until I can work out another
way to do it.  I think that would break the test_wmediumd.py in hostapd
test suite in the meantime though.

-- 
Bob Copeland %% http://bobcopeland.com/
