Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:32979 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbZAIQhN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 11:37:13 -0500
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
From: Dan Williams <dcbw@redhat.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
In-Reply-To: <87skns29t5.fsf@litku.valot.fi>
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com>
	 <1229336057.4471.9.camel@johannes.berg>
	 <1229354532.12163.24.camel@localhost.localdomain>
	 <20081217174244.M36761@bobcopeland.com>
	 <1230064216.31228.46.camel@johannes> <20081224054951.GA32398@hash.localnet>
	 <1230102989.16960.14.camel@californication>
	 <1231260306.14565.21.camel@localhost.localdomain>
	 <1231261937.5246.16.camel@californication>
	 <1231267979.14565.34.camel@localhost.localdomain>
	 <1231270575.14901.6.camel@californication>
	 <1231432778.21643.40.camel@localhost.localdomain>
	 <87skns29t5.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 11:35:21 -0500
Message-Id: <1231518921.30057.14.camel@dhcp-18-190-61-35.dyn.mit.edu> (sfid-20090109_173718_501273_0CF9BB80)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-01-09 at 09:55 +0200, Kalle Valo wrote:
> Dan Williams <dcbw@redhat.com> writes:
> 
> >> Having the suspend scripts to tell NM to disconnect is just not a good
> >> solution and especially in the embedded world this is a broken design
> >> concept.
> >
> > Right; the missing piece is pushing the necessary roaming support down
> > to the supplicant and letting it make the decisions about what to
> > connect to.  There's a few things that I need from the supplicant before
> > I can simply push the entire config set down from NM and let it go wild:
> >
> > 1) A 'frequency' config item that works in infrastructure mode too,
> > ignoring any AP not matching that frequency
> 
> Just out of curiosity, why this feature is needed? I can understand
> hard-coding bssid, but I don't understand the use for hard-coding the
> frequency.

If the user wishes to lock the connection to a specific frequency,
irregardless of other values.  Maybe you're right and we don't really
care about it, but one other thing that would be nice is a "band"
argument for a network block to differentiate A vs. B/G APs that might
have the same SSID and security settings, but where the user only wants
to use the A-side for example.

Dan


