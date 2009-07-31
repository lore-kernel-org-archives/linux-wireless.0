Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:54289 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbZGaUFo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 16:05:44 -0400
Received: by fxm17 with SMTP id 17so1568874fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 13:05:44 -0700 (PDT)
Subject: Re: [PATCH 000/002] Fix frequent reconnects caused by new
 conection monitor
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1249068449.23662.17.camel@localhost.localdomain>
References: <1249056817.20593.1.camel@maxim-laptop>
	 <1249066338.30019.214.camel@rc-desk>
	 <1249067293.19089.10.camel@maxim-laptop>
	 <1249068449.23662.17.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 23:05:39 +0300
Message-Id: <1249070739.25620.11.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-31 at 12:27 -0700, Marcel Holtmann wrote:
> Hi Maxim,
> 
> > > > Hi, here is the updated version of these two patches that fix the
> > > > $SUBJECT issue.
> > > > 
> > > > I attach these (in case mailer mangles them), and reply with patches.
> > > > 
> > > > Tested both with low quality signal, and beacon loss.
> > > > Lack of TX is found, every 30 seconds now, and quite reliable.
> > > > Lack of beacons, triggers probe like it did every 2 seconds.
> > > 
> > > Thanks!
> > > 
> > > I've been running with this for two hours now with no disconnects. This
> > > is where before the patches I would get disconnected after a few
> > > minutes. I did get two "No probe response from AP xx:xx:xx:xx:xx:xx
> > > after 500ms, try 1" messages in my log.
> > This is normal, or at least can be normal, I patched the driver to
> > display this message, when there is a probe timeout, but instead of
> > disconnect, it retries, currently 5 times, but this can be even further
> > increased is necessarily.
> > (these messages are only in logs when verbose mac debugging is enabled)
> > 
> > I don't know exactly why probes aren't answered, but I strongly suspect
> > that my AP sometimes 'goes out to lunch' and then answers, since
> > typically after a failed probe it sends many replies.
> > (Or it could be some buffering done by iwl3945 microcode). I currently
> > can't monitor the connection from outside, but as soon as I can I see
> > whether the above is true. Nevertheless if signal quality isn't great,
> > there are valid reasons for probe loss, and it shouldn't cause all the
> > fuzz (and since I use WPA2, every reconnection causes whole WPA
> > handshake to be preformed, and this takes at least 2 seconds, and if a
> > reconnection happens each 5 seconds, it gets very very annoying, and
> > almost unusable.
> 
> I am testing your patches and so far so good. Seems to be working
> perfectly fine. I see this in the logs:
> 
> [41027.333419] wlan0: detected beacon loss from AP - sending probe request
> [41027.389260] wlan0: cancelling probereq poll due to a received beacon
> [41027.793518] No probe response from AP 00:1c:f0:62:88:5b after 500ms, try 1
> [41028.292731] No probe response from AP 00:1c:f0:62:88:5b after 500ms, try 2
> 
> Need to watch out if this pattern emerges and if the beacon loss trigger
> might give us an indication. Maybe the ucode is just not ready then.
Here (on my system) I see no beacon losses at all, like I said there
could be many reasons behind packet losses, and best way to mitigate
them is to retry.

Your logs indicate that beacons weren't recieved for 2 seconds, then
mac80211 tried to send a probe, but a beacon is recieved before the
probe answer, this probe is canceled (at least should be) then after a
while, a probe request (same one?) is time outed, and retried twice,
then finally answered.


Best regards,
	Maxim Levitsky

> 
> Regards
> 
> Marcel
> 
> 

