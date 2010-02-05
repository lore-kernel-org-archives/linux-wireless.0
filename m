Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933246Ab0BEG6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 01:58:09 -0500
Subject: Re: [PATCH] airo: fix setting zero length WEP key
From: Dan Williams <dcbw@redhat.com>
To: Chris Siebenmann <cks@cs.toronto.edu>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
In-Reply-To: <20100204233608.90E172B0054@apps0.cs.toronto.edu>
References: <20100204233608.90E172B0054@apps0.cs.toronto.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 22:57:20 -0800
Message-ID: <1265353040.11066.2.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-02-04 at 18:36 -0500, Chris Siebenmann wrote:
> | >  In the GUI, no wireless networks show up/are listed in the usual
> | > dropdown menu; this means that I can't go as far as even trying to
> | > connect to anything.  From the command line, 'iwlist wifi0 scanning'
> | > lists nothing.
> |
> | Wait, wifi0?  You need to be using 'eth0' or 'eth1', whichever eth
> | device that 'iwconfig' reports. wifi0 is a historical airo anomaly
> | that's only used for packet capture and sniffing of the 802.11 frames.
> | It should not be used for anything other than Wireshark basically.
> |
> | Do you get the same behavior if you use the normal ethX interface of
> | the airo device?
> 
>  Yes; on a 'bad' kernel, 'iwlist eth1 scanning' lists nothing, and on a
> good kernel it lists the networks that I expect (with some variability;
> where I have the machine at the moment is on the edge of visibility for
> some networks, and they appear and disappear periodically).
> 
> | Note that just because wifi0 may return scan results doesn't mean it
> | should be used with iwconfig...
> |
> | But also, you're doing the iwlist scan as root, correct?
> 
>  Yes (on both the good and the bad kernels).
> 
>  I haven't been trying to use iwconfig for anything; all of my actual
> use of the wireless networks has been done through the Fedora 11 GUI.

I've been able to reproduce the issue with my 350.  Note that even with
the original patch, the 350 will never return a scan result *other* than
the associated AP.  If you turn off the AP, the airo will not return any
scan results even though before it connected to the AP it would return a
bunch.

Airo firmware is, well, old and crappy, and nobody ever got enough
documentation out of Cisco to get the driver working extremely well.

But oddly enough, the patch does fix the issue, though I have a slightly
modified version that I'd rather be applied (see other mails).

Dan


