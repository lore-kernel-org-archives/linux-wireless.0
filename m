Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867Ab2KWHjS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 02:39:18 -0500
Message-ID: <1353656386.10197.2.camel@jlt4.sipsolutions.net> (sfid-20121123_083921_963196_DC549E51)
Subject: Re: [PATCH v2] mac80211: support radiotap vendor namespace RX data
From: Johannes Berg <johannes@sipsolutions.net>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Nov 2012 08:39:46 +0100
In-Reply-To: <50AF24EF.7080800@neratec.com>
References: <1353061591-22284-1-git-send-email-johannes@sipsolutions.net>
	  <87ehjtygci.fsf@purkki.adurom.net>
	  <1353063966.9490.1.camel@jlt4.sipsolutions.net>
	  <50ADE0E3.2020909@neratec.com>
	  <1353573266.9806.14.camel@jlt4.sipsolutions.net>
	 <1353573671.9806.15.camel@jlt4.sipsolutions.net>
	 <50ADE504.3060508@neratec.com> <50AF24EF.7080800@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 08:25 +0100, Wojciech Dubowik wrote:
> On 11/22/2012 09:40 AM, Wojciech Dubowik wrote:
> > On 11/22/2012 09:41 AM, Johannes Berg wrote:
> >> On Thu, 2012-11-22 at 09:34 +0100, Johannes Berg wrote:
> >>> On Thu, 2012-11-22 at 09:22 +0100, Wojciech Dubowik wrote:
> >>>> Shouldn't all functions between ieee80211_rx
> >>>> and remove_monitor_info map header with
> >>>> (struct ieee80211_hdr *)(skb->data + status->vendor_radiotap_len) ?
> >>>>
> >>>> Otherwise function like should_drop_frame uses header mapped over
> >>>> potential vendor data.
> >>> Huh, yes, how did I miss that. It only applies to should_drop_frame()
> >>> though, or do you see any other place?
> >> So I think this is sufficient?
> > I guess so. I will test it today.
> > Wojtek
> I have tested with ath9k vendor data and it doesn't seem to drop frames. 
> I will post my patch as RFC
> once I clean it up a bit. Just for reference.

Great, thanks. I'll send out the fix & merge it.

johannes

