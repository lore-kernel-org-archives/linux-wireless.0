Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:54626 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZGaT13 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 15:27:29 -0400
Subject: Re: [PATCH 000/002] Fix frequent reconnects caused by new
 conection monitor
From: Marcel Holtmann <marcel@holtmann.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1249067293.19089.10.camel@maxim-laptop>
References: <1249056817.20593.1.camel@maxim-laptop>
	 <1249066338.30019.214.camel@rc-desk>
	 <1249067293.19089.10.camel@maxim-laptop>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 12:27:29 -0700
Message-Id: <1249068449.23662.17.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Maxim,

> > > Hi, here is the updated version of these two patches that fix the
> > > $SUBJECT issue.
> > > 
> > > I attach these (in case mailer mangles them), and reply with patches.
> > > 
> > > Tested both with low quality signal, and beacon loss.
> > > Lack of TX is found, every 30 seconds now, and quite reliable.
> > > Lack of beacons, triggers probe like it did every 2 seconds.
> > 
> > Thanks!
> > 
> > I've been running with this for two hours now with no disconnects. This
> > is where before the patches I would get disconnected after a few
> > minutes. I did get two "No probe response from AP xx:xx:xx:xx:xx:xx
> > after 500ms, try 1" messages in my log.
> This is normal, or at least can be normal, I patched the driver to
> display this message, when there is a probe timeout, but instead of
> disconnect, it retries, currently 5 times, but this can be even further
> increased is necessarily.
> (these messages are only in logs when verbose mac debugging is enabled)
> 
> I don't know exactly why probes aren't answered, but I strongly suspect
> that my AP sometimes 'goes out to lunch' and then answers, since
> typically after a failed probe it sends many replies.
> (Or it could be some buffering done by iwl3945 microcode). I currently
> can't monitor the connection from outside, but as soon as I can I see
> whether the above is true. Nevertheless if signal quality isn't great,
> there are valid reasons for probe loss, and it shouldn't cause all the
> fuzz (and since I use WPA2, every reconnection causes whole WPA
> handshake to be preformed, and this takes at least 2 seconds, and if a
> reconnection happens each 5 seconds, it gets very very annoying, and
> almost unusable.

I am testing your patches and so far so good. Seems to be working
perfectly fine. I see this in the logs:

[41027.333419] wlan0: detected beacon loss from AP - sending probe request
[41027.389260] wlan0: cancelling probereq poll due to a received beacon
[41027.793518] No probe response from AP 00:1c:f0:62:88:5b after 500ms, try 1
[41028.292731] No probe response from AP 00:1c:f0:62:88:5b after 500ms, try 2

Need to watch out if this pattern emerges and if the beacon loss trigger
might give us an indication. Maybe the ucode is just not ready then.

Regards

Marcel


