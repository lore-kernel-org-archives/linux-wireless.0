Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53273 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbbCQKSQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 06:18:16 -0400
Message-ID: <1426587485.1985.14.camel@sipsolutions.net> (sfid-20150317_111822_577469_31B29482)
Subject: Re: [PATCH v2] iw: display allowable channel bandwidth information
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, rmanohar@qti.qualcomm.com,
	vthiagar@qti.qualcomm.com
Date: Tue, 17 Mar 2015 11:18:05 +0100
In-Reply-To: <1425452686-28196-1-git-send-email-arnagara@qti.qualcomm.com>
References: <1425452686-28196-1-git-send-email-arnagara@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-04 at 12:34 +0530, Ashok Raj Nagarajan wrote:
> We already have allowable channel bandwidth information at userspace.
> Display this information with 'iw list'. Excerpt of iw list command
> 
> Frequencies:
> 	* 5180 MHz [36] (17.0 dBm)
> 	  (10MHZ, 20MHZ, HT40+, VHT80, VHT160)
> 	* 5200 MHz [40] (17.0 dBm)
> 	  (10MHZ, 20MHZ, HT40-, HT40+, VHT80, VHT160)
> 
> Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
> ---
> v2:
> 	Display channel bw information in separate line (Johannes)
> 	Updated commit log to reflect above change.

Thanks for the changes.

I was going to apply this, but then I realized that the above example is
probably incorrect, since I'm guessing it was done on a driver that
doesn't actually support 10 MHz? And if it was then it probably also
supported 5 MHz...

Now, the annoying thing is that to display the possible bandwidth we
need to parse a lot more information - i.e. the "supports 5 MHz" and
"supports 10 MHz" flags, along with the HT/VHT information.

The even more annoying thing is that we get that information only in
later nl80211 messages while printing this, so we can no longer parse
things in the right order.

One technical alternative would be to print exactly the attributes, i.e.
"no 5 MHz", "no 10 MHz", etc. instead of inverting and printing what's
supported, but that's perhaps a little too unfriendly for users?

I guess we can first collect all messages and print all the data later,
parsing them first for the capabilities and then the channels, but that
seems like a pretty big code change?

Additionally, the channel display information in "iw list" is getting
pretty big these days. Perhaps we should have a separate command that
prints the channel list with all the detail information, and then that
command can do all of the above?

johannes

