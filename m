Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2486 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbZAFRhV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 12:37:21 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
Date: Tue, 6 Jan 2009 12:35:11 -0500
Message-Id: <20090106172758.M47578@bobcopeland.com> (sfid-20090106_183726_253327_6AF806EE)
In-Reply-To: <1231262082.3654.5.camel@johannes>
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com> <1229336057.4471.9.camel@johannes.berg> <1229354532.12163.24.camel@localhost.localdomain> <20081217174244.M36761@bobcopeland.com> <1230064216.31228.46.camel@johannes> <20081224054951.GA32398@hash.localnet> <1230102989.16960.14.camel@californication> <1231260306.14565.21.camel@localhost.localdomain> <20090106165434.M2397@bobcopeland.com> <1231262082.3654.5.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 06 Jan 2009 18:14:41 +0100, Johannes Berg wrote
> > However, _with_ the current procedure of telling NM to go to sleep, it
> > tries to reconnect after resume because NM takes care of downing the
> > interfaces.  As a result mac80211 never gets the chance to save the
> > state of the running interfaces.
> 
> You mean restore?
> 
> Does that mean there's a race condition now, between userspace config
> and the resume stuff? Can't we fix that by taking the rtnl?

No, I mean that with dbus telling NM to go to sleep (as part of pm-utils)
NM then takes down the interfaces -- userspace is still running, this is
before the kernel actually suspends.

Consequently, all the interfaces look down to mac80211 when suspend() is
actually called so the suspend/resume in mac80211 doesn't wind up doing
anything with interfaces.  No race condition, but a re-association must 
happen from userspace on the resume side (NM will do this, though).

At least this appears the case on f10, correct me if I'm wrong, Dan.

-- 
Bob Copeland %% www.bobcopeland.com

