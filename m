Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:55052 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbXIRRh5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 13:37:57 -0400
Date: Tue, 18 Sep 2007 10:37:18 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlist and network-manager bug report
Message-ID: <20070918173718.GA1466@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <1189526874.6161.30.camel@johannes.berg> <1189610572.5644.28.camel@xo-3E-67-34.localdomain> <20070912170153.GA25785@bougret.hpl.hp.com> <1189667496.6161.77.camel@johannes.berg> <20070918003628.GA28939@bougret.hpl.hp.com> <1190110522.23521.36.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1190110522.23521.36.camel@johannes.berg>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 18, 2007 at 12:15:22PM +0200, Johannes Berg wrote:
> On Mon, 2007-09-17 at 17:36 -0700, Jean Tourrilhes wrote:
> 
> > > Yeah, I don't think they cared for non-ascii at the time.
> > 
> > 	There were not concerned about UI, witness the mess in
> > specifying WEP keys (do you want passphrase with that ?).
> 
> Is passphrase actually specified in 802.11? I always thought it was some
> external hashing but didn't look it up.

	Yes, it's some external hashing, and if I remember there is at
least two variants of it.

> But yes, I don't think in 1999
> many people cared about general UIs...
> 
> > 	I'm talking of all driver that have their own private API :
> > --------------------------------
> > # cat /proc/driver/aironet/eth0/SSID 
> > MY_ESSID
> > --------------------------------
> 
> Oh. I didn't think that existed. Is there any point in that or could we
> just remove it?

	I say we just ignore it, it mostly legacy drivers, and some
people may use it.

> > 	I forgot one little issue.
> > 	Remember all the fuss about the ESSID API change a long while
> > back ? The goal was to support ESSID a array of char as opposed to
> > ASCII strings in the API. There was a big fuss, and at that time John
> > did a backward compatibility hack to support the old API in the
> > kernel.
> > 	Well, the hack of John is broken on the receive side. It
> > basically prevents us to implement what you want, amongst other
> > things. This is what you currently get :
> > ---------------------------------------
> > >./iwconfig eth0
> > eth0      IEEE 802.11b  ESSID:"my_essid\x00"  Nickname:"HERMES I"
> >           Mode:Managed  Frequency:2.422 GHz  Access Point: Not-Associated   
> >           Bit Rate:11 Mb/s   Sensitivity:1/3  
> > ---------------------------------------
> 
> Hmmm. So we already \x00-escape the trailing NUL?

	No, that's only in the brand new version of Wireless Tools
30.pre1 that include the escaping code. I coded that following your
suggestions, it includes full escaping in output and input. But now
I'm stuck because of that bug, I can't really distribute it.

> > 	I've already sent the patch to fix that to John, don't know
> > where it went :
> > 		http://marc.info/?t=118401941300001&r=1&w=2
> > 	I can resend you a copy if you want. I feel this patch ought
> > to go also in the various stable series.
> 
> Probably got lost, you should probably resend and to -stable as well.

	I'll do, but you seem much more efficient at getting stuff in
the kernel ;-)

> johannes

	Regards,

	Jean

