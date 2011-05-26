Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54427 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080Ab1EZSBJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 14:01:09 -0400
Date: Thu, 26 May 2011 13:55:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Daniel Halperin <dhalperi@cs.washington.edu>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"gregkh@suse.de" <gregkh@suse.de>
Subject: Re: %d in wlan log messages
Message-ID: <20110526175553.GE3595@tuxdriver.com> (sfid-20110526_200113_545115_76A6E107)
References: <4DDE63B4.4030309@broadcom.com>
 <BANLkTina0R-SJamJ_GFbxJsYcvvdyxzZNg@mail.gmail.com>
 <4DDE9391.6020302@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DDE9391.6020302@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 26, 2011 at 07:53:21PM +0200, Arend van Spriel wrote:
> On 05/26/2011 05:09 PM, Daniel Halperin wrote:
> >On Thu, May 26, 2011 at 7:29 AM, Arend van Spriel<arend@broadcom.com>  wrote:
> >>[  563.120590] wlan%d: authenticate with c0:c1:c0:04:b8:2c (try 1)
> >>[  563.128143] wlan%d: authenticated
> >>[  563.131517] wlan%d: associate with c0:c1:c0:04:b8:2c (try 1)
> >>[  563.140933] wlan%d: RX AssocResp from c0:c1:c0:04:b8:2c (capab=0x411
> >>status=0 aid=4)
> >>[  563.148714] wlan%d: associated
> >>[  563.177019] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> >>
> >>On latest staging-next I noticed above mentioned log messages. I assume
> >>these message are from cfg80211 or mac80211. Has this been reported?
> >>
> >Interface names [including any numbers] are set by userspace, right?
> >On my Ubuntu 10.04.2 LTS system, it's
> >/etc/udev/rules.d/70-persistent.net.rules (or so, this is from
> >memory). Not a kernel bug.
> >
> >Dan
> 
> Weird. I did not change anything in udev rules (using Ubuntu 10.10
> over here). So the only variant in my setup is move to 2.6.39. Can
> you explain that netdev apparently has the proper interface id (see
> timestamp [563.177019] above?

Wasn't a problem like this recently reported w/ compat-wireless?
And the fix was to backport some patch to the networking core?
I could be hallucinating again...

Is it possible that you somehow have a "dirty" build?  Could you try
doing a 'make clean' and rebuilding?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
