Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52692 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760364Ab2IGMJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 08:09:33 -0400
Message-ID: <1347019809.4256.21.camel@jlt4.sipsolutions.net> (sfid-20120907_140936_874593_88241394)
Subject: Re: [RFC v2] cfg80211: VHT regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Fri, 07 Sep 2012 14:10:09 +0200
In-Reply-To: <50489165.1080902@posedge.com>
References: <5046FB3D.6090803@posedge.com>
	  <1346852356.4364.9.camel@jlt4.sipsolutions.net>
	  <50481C2E.5040303@posedge.com>
	 <1346925298.5469.4.camel@jlt4.sipsolutions.net>
	 <50489165.1080902@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-06 at 17:34 +0530, Mahesh Palivela wrote:
> On 09/06/2012 03:24 PM, Johannes Berg wrote:
> > On Thu, 2012-09-06 at 09:14 +0530, Mahesh Palivela wrote:
> >> On 09/05/2012 07:09 PM, Johannes Berg wrote:
> >
> > No, it doesn't. It *derives* these. Check "Table 22-22—Fields to specify
> > VHT channels" for how it actually *specifies* them.
> >
> 
> hostapd.conf specifies using numbers only. hostapd converts to freq 
> values, puts into NL attribs and cfg80211 directly gets freq values 
> rather than channel numbers.
> we have to do these calculations either in app or cfg80211. user space 
> vs krnl space. I am ok either way.

We don't have to do any calculation in kernel though as far as I can
tell? Maybe we do need the channel, but I think in terms of
*specifying*, in particular in the nl80211 and cfg80211 APIs, we should
stick to the standard if we're going to change it now.

> >> This is to find the regulatory rule only. Not checking desired BW around
> >> prim channel. center freq chan 42 of 36, 40, 44 and 48 for 80 MHz BW may
> >> not be in list of freq values in reg rule.
> >
> > Hmm? Don't think I understand this. Why do you pass in the right
> > bandwidth if it's not used?
> >
> 
> ok. I will define new freq_reg_info_regd() to take center freq and 
> desired BW and return reg_rule. I think current freq_reg_info_regd() may 
> fail if we give chan 42.

I have no idea. I don't know the regulatory code very well, sorry.

> >>> This seems better, but is missing the bandwidth check?
> >>
> >> bandwidths are checked in reg_chan_use_permitted. reg rule decides it right?
> >
> > I guess I don't really understand this.
> >
> 
> what should I do for bandwidth check in reg_sec_chans_permitted() ?

It seems to me that if we're going to specify things as an overall
center frequency + bandwidth then we don't really care about
primary/secondary channels? We'd rather just get the reg rule(s) from
the center freq(s)/bandwidth, and then check all channels that happen to
fall into this space, or something like that?

Even if we do that, there's still another issue though. Some drivers,
like ours, don't support HT40 everywhere. Right now I believe we pretty
much support HT40 everywhere that is allowed, but that might not be the
case for all drivers.

So previously, the driver was able to set the IEEE80211_CHAN_NO_HT40PLUS
etc. flags on a channel before registering. If we remove these flags
we'll have to find a way to allow the driver to influence the decision
about what is allowed in some way, I guess? Or maybe the driver would
have to register a regulatory rule that encapsulates everything in the
device's EEPROM?

johannes

