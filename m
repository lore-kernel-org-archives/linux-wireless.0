Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:30898 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422632AbXBPO34 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 09:29:56 -0500
Received: by nf-out-0910.google.com with SMTP id o25so1537572nfa
        for <linux-wireless@vger.kernel.org>; Fri, 16 Feb 2007 06:29:55 -0800 (PST)
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH v2] d80211: Add software sequence support
Date: Fri, 16 Feb 2007 15:29:22 +0100
Cc: Michael Wu <flamingice@sourmilk.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702141423.27823.IvDoorn@gmail.com> <200702161325.47396.IvDoorn@gmail.com> <20070216135827.7d262ae3@griffin.suse.cz>
In-Reply-To: <20070216135827.7d262ae3@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702161529.22717.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 February 2007 13:58, Jiri Benc wrote:
> On Fri, 16 Feb 2007 13:25:47 +0100, Ivo van Doorn wrote:
> > On Friday 16 February 2007 13:03, Jiri Benc wrote:
> > > On Thu, 15 Feb 2007 21:57:22 +0100, Jiri Benc wrote:
> > > > Thinking about it more, sdata should be the correct place. It's more
> > > > per-interface thing than per-BSS (although the difference is small in
> > > > this particular case).
> > > 
> > > ...and thinking about it even more, that won't work with WDS.
> > 
> > You mean storing the sequence counter per-interface won't work,
> > or per-bss?
> 
> Both.
> 
> When you have a WDS link and some other wireless interface at the same
> time, their source addresses are (in most cases) the same. You want to
> have the sequence control counter shared by them. Actually, it will
> probably work most of time even when they have different counters. The
> situation where it won't work is if you have two virtual interfaces,
> one in STA and second in WDS mode, both connected to the same AP. I
> can't figure out how this particular setup could be useful but it's
> generally not disallowed.
> 
> Anyway, using different counter for a WDS interface probably violates
> 802.11 (although it's not much specific in this case). I believe it
> will work in most cases, though.
> 
> Any ideas how to solve that?

Are there more situations where it might be important to know
if the WDS interface has to keep in mind that there is a virtual STA interface
on the same network? Because it might be worthwhile to make a check for that
in the creation of the WDS interface (and in the STA interface).

Ivo
