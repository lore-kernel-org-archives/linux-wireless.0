Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35317 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab3LKETk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Dec 2013 23:19:40 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1VqbGr-0002r3-Uv
	for linux-wireless@vger.kernel.org; Wed, 11 Dec 2013 05:19:37 +0100
Received: from ool-182c1fa2.dyn.optonline.net ([24.44.31.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 11 Dec 2013 05:19:37 +0100
Received: from kampowchicken by ool-182c1fa2.dyn.optonline.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 11 Dec 2013 05:19:37 +0100
To: linux-wireless@vger.kernel.org
From: Kam <kampowchicken@gmail.com>
Subject: Re: rtl8723ae owner.
Date: Wed, 11 Dec 2013 04:19:15 +0000 (UTC)
Message-ID: <loom.20131211T045200-389@post.gmane.org> (sfid-20131211_051943_710774_FCA9833B)
References: <loom.20131211T021101-974@post.gmane.org> <52A7DC0C.8090902@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@...> writes:

> 
> On 12/10/2013 07:42 PM, Kam wrote:
> > I have the rtl8723ae PCIe wifi card. I've read through the messages on the
> > forums and experience similar issues to others who have inquired about the
> > card. I experience sluggish connections and disconnects, I for the most
> > can't connect to my school wifi at all.
> >
> > I switched my router to 'AP' today after reading through the posts here and
> > initially the connection was faster than I've experienced thus far(since
> > switching to linux last year), I ended up shutting down the computer
> > eventually and after turning it back on few hours later, It was back to the
> > slow sluggish connection.
> 
> What does switching the router to 'AP' mean? If it was not an AP before, you 
> would never have been able to connect to it.
> 
> > I've collected all the output that I could think of and wanted to contribute
> > it in hopes that it can assist the devs in testing/debugging the issues with
> > the card. The text file is a little but over 800 lines, so I will post it on
> > fpaste, if this isn't acceptable please let me know and I will repost the
> > text in preferred format. I am about ready to smoke the beacons off this
> > thing :P.
> 
> One thing missing in what you posted is any messages from dmesg that describe 
> the disconnects.
> 
> The only thing I noted in your posting is that your channel is about as badly 
> chosen as is possible. Wifi is not like TV. The channel spacing is 5 MHz, but 
> the width for 802.11g is 20 MHz, and 802.11n is 40 MHz. If you do the
math, your 
> choice of channel 9 overlaps *every* AP in your neighborhood. At -60 dBm,
your 
> signal is not strong, and is even weaker than Home2.
> 
> I would choose a channel as low as possible. That would be #1 for 802.11g.
Your 
> AP may not allow lower than #3 for 802.11n.
> 
> Next, you might try loading the module with the option "ips=0". That will 
> disable power save mode, and it might help.
> 
> I have been running a long-term test of rtl8723ae. After 100 hours, I have
had a 
> total of 11 disconnects. Each of them has reconnected with very little 
> interruption in service. The difference is that my channel is chosen to
have as 
> little interference as possible, and my signal strength is -44 dBm.
> 
> Larry
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



Thank you for the prompt response, I really appreciate it. And I would like
to apologize ahead of time in case I mess up the format.

> What does switching the router to 'AP' mean? If it was not an AP before, you
> would never have been able to connect to it.

Unfortunately my router has a check box under Advanced > Advanced Setup >
Wireless Settings that switches the router to AP Mode. I looked into the
manual after seeing the posting here and it's how I discovered it. It was
never checked until today.

>From the manual:
"AP Mode. You can make the WNDR3400v2 function as an access point."
Page 77:
http://www.downloads.netgear.com/files/GDC/WNDR3400V2/WNDR3400v2_UM_23JAN2013.pdf

> The only thing I noted in your posting is that your channel is about as badly 
> chosen as is possible.

Channel selection isn't done by me, it is set to "auto" mode at the router
settings which explains that it will choose the best channel. I appreciate
you pointing that out because now it will give me more options to play
around with. I have seen the ips posting else where and will test this once
I configure the channel. Thank you.

Kam

