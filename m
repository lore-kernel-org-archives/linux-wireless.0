Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:32876 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbXBPWHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 17:07:51 -0500
Received: by nf-out-0910.google.com with SMTP id o25so1667765nfa
        for <linux-wireless@vger.kernel.org>; Fri, 16 Feb 2007 14:07:50 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] d80211: Add software sequence support
Date: Fri, 16 Feb 2007 23:07:16 +0100
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702141423.27823.IvDoorn@gmail.com> <20070216135827.7d262ae3@griffin.suse.cz> <1171660484.3575.34.camel@johannes.berg>
In-Reply-To: <1171660484.3575.34.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702162307.16826.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 February 2007 22:14, Johannes Berg wrote:
> On Fri, 2007-02-16 at 13:58 +0100, Jiri Benc wrote:
> 
> > Both.
> > 
> > When you have a WDS link and some other wireless interface at the same
> > time, their source addresses are (in most cases) the same. You want to
> > have the sequence control counter shared by them. Actually, it will
> > probably work most of time even when they have different counters. The
> > situation where it won't work is if you have two virtual interfaces,
> > one in STA and second in WDS mode, both connected to the same AP. I
> > can't figure out how this particular setup could be useful but it's
> > generally not disallowed.
> > 
> > Anyway, using different counter for a WDS interface probably violates
> > 802.11 (although it's not much specific in this case). I believe it
> > will work in most cases, though.
> > 
> > Any ideas how to solve that?
> 
> Make the counter per-mac address?

Wouldn't that be the same as per-interface?

Ivo
