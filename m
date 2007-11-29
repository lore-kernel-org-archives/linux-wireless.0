Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:13292 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbXK2HnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 02:43:16 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "Albert Cahalan" <acahalan@gmail.com>,
	"Albert Cahalan" <acahalan@gmail.com>
Subject: Re: [PATCH] libertas: remove user-specified channel list
Date: Thu, 29 Nov 2007 08:44:10 +0100
Cc: "Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200711281730.21327.hs4233@mail.mn-solutions.de> <787b0d920711282012k38d6d2c8g2d9ae79c89b04059@mail.gmail.com>
In-Reply-To: <787b0d920711282012k38d6d2c8g2d9ae79c89b04059@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711290844.10501.hs4233@mail.mn-solutions.de> (sfid-20071129_074323_629411_F63E168B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 29 November 2007 05:12:06 Albert Cahalan wrote:
> On Nov 28, 2007 11:30 AM, Holger Schurig 
<hs4233@mail.mn-solutions.de> wrote:
> > Remove the ability to specify channels to scan via debugfs
>
> Why are you ripping out functionality? At the very least,
> that ought to be justified in the changelog comment.

This was discussed in libertas-dev.


Basically, I posted there a RFC (request-for-comment) patch about 
a newer implementation of how scanning could be implemented. The 
current version of scan.c is a bit complicated and not easy to 
follow. I was rewriting that up to a point where it worked. But 
my RFC patch had a bunch of TODO items, and I asked in 
libertas-dev how to deal with them.

Two TODOs were about the implementation the syntax 
of "probes=XXX" and "channel=XXX" that you can use via 
debugfs/extgetscan.

Dan thought that we could easily rip this out, because no one is 
known to use this feature. And I'm seconding Dan here. Both 
debugfs-features actually just exhibits a possibility of how to 
interact with the firmware. They don't have a real value.

Simply because you cannot set number of probes or channel-list 
from "normal" user-space application. E.g. when libertas needs 
to scan because of a new ESSID set via "iwlist eth1 essid BLAH" 
it would anyway scan all channels set by the country (11, 13 or 
14 for b/g). It wouldn't honor your manually crafted last scan 
from your last access to debugfs.

So extgetscan is merely a tool to play with, but nothing more.

madwifi for example also has the ability to specify "please scan 
only on channels 1, 7, 11", but this has been implemented via 
private ioctl's and set's this "sticky". So when you scan from 
iwlist, implicitly from iwconfig XXX essid, from wpa_supplicant 
etc, it would be honored. For such a feature you have a 
real-life usage scenario, it would be much more useful than the 
current way.


However, if people come with a "this makes sense" usage scenario, 
I'd add the needed implementation of it also to the newer 
scanning code.
