Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:61798 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbXIRAh4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 20:37:56 -0400
Date: Mon, 17 Sep 2007 17:36:28 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlist and network-manager bug report
Message-ID: <20070918003628.GA28939@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <1189526874.6161.30.camel@johannes.berg> <1189610572.5644.28.camel@xo-3E-67-34.localdomain> <20070912170153.GA25785@bougret.hpl.hp.com> <1189667496.6161.77.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1189667496.6161.77.camel@johannes.berg>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 13, 2007 at 09:11:36AM +0200, Johannes Berg wrote:
> 
> > [Jean]
> > 	I personally can't see how we could figure out the encoding,
> > because we are talking of other's people network. It would have been
> > nice for IEEE 802.11 to specify something, but it's now probably too
> > late, as each vendor did his own stuff.
> 
> Yeah, I don't think they cared for non-ascii at the time.

	There were not concerned about UI, witness the mess in
specifying WEP keys (do you want passphrase with that ?).

> > 	Note that ideally, we should also do the same with regards to
> > setting an ESSID. And all the /proc files of the various drivers may
> > want to be sanitized (yuck).
> 
> I thought it all went through some common code?

	I'm talking of all driver that have their own private API :
--------------------------------
# cat /proc/driver/aironet/eth0/SSID 
MY_ESSID
--------------------------------

> > 	One way would be to check if the ESSID is Ascii, and if it's
> > not, display it entirely in hex with a leading 0x. Then, iwconfig
> > would recognise the leading 0x and do the right stuff.
> > 	The problem with escaping is that you always have to escape
> > the escape sequence, otherwise you get ambiguity.
> 
> Yeah, that's the thing. I don't like displaying it entirely in hex just
> because a single character is not ascii though. I think we should
> display as much in ascii as possible. Maybe a regular \xAA conversion
> would be appropriate as having a backslash in an SSID is probably less
> common than using Umlauts or even Chinese.

	I forgot one little issue.
	Remember all the fuss about the ESSID API change a long while
back ? The goal was to support ESSID a array of char as opposed to
ASCII strings in the API. There was a big fuss, and at that time John
did a backward compatibility hack to support the old API in the
kernel.
	Well, the hack of John is broken on the receive side. It
basically prevents us to implement what you want, amongst other
things. This is what you currently get :
---------------------------------------
>./iwconfig eth0
eth0      IEEE 802.11b  ESSID:"my_essid\x00"  Nickname:"HERMES I"
          Mode:Managed  Frequency:2.422 GHz  Access Point: Not-Associated   
          Bit Rate:11 Mb/s   Sensitivity:1/3  
---------------------------------------
	I've already sent the patch to fix that to John, don't know
where it went :
		http://marc.info/?t=118401941300001&r=1&w=2
	I can resend you a copy if you want. I feel this patch ought
to go also in the various stable series.

> johannes

	Have fun...

	Jean

