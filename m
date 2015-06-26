Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40341 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbbFZIus (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 04:50:48 -0400
Message-ID: <1435308646.2106.4.camel@sipsolutions.net> (sfid-20150626_105053_504805_8978C749)
Subject: Re: iw and non-ASCII SSIDs
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg <pommnitz@yahoo.com>, linux-wireless@vger.kernel.org
Date: Fri, 26 Jun 2015 10:50:46 +0200
In-Reply-To: <loom.20150625T224327-49@post.gmane.org> (sfid-20150625_225037_608129_0D468D05)
References: <loom.20150625T181029-814@post.gmane.org>
	  (sfid-20150625_181310_521075_380CF492) <1435255854.2096.18.camel@sipsolutions.net>
	 <loom.20150625T224327-49@post.gmane.org>
	 (sfid-20150625_225037_608129_0D468D05)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-06-25 at 20:50 +0000, Joerg wrote:
> Johannes Berg <johannes@...> writes:
> 
> > 
> > On Thu, 2015-06-25 at 16:12 +0000, Joerg wrote:
> > > Hello all,
> > > is there a way to submit a non-ASCII SSID with iw? One that 
> > > contains 
> > > 0 as in an octet with value zero?
> > 
> > No, that doesn't seem to be possible in the code.
> > 
> > But it's certainly possible in wp_supplicant config file, which you
> > should probably be using anyway?
> > 
> > johannes
> 
> That's what I thought from looking at the code, too. 
> 
> And no, this is for an IBSS network that uses an IPsec overlay for 
> security. 
> It doesn't use wpa_supplicant and changing the code that way would be 
> a major 
> hassle. 
> 
> I would volunteer to change iw to accept a hex encoded binary blob as 
> SSID. 
> What commandline would be acceptable?

Well I guess you're not interested in "connect" but rather "ibss join"
then.

We *could* break backward compatibility and say that if you pass "\x00"
it's no longer interpreted as the bytes 5c 78 30 30 but rather as the
byte 00, but I'm not sure we should?

OTOH, what choice do we really have - the only other option would be to
add a command line flag indicating that this behaviour is desired?

johannes
