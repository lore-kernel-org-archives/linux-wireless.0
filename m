Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36443 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab3EJM1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 08:27:03 -0400
Message-ID: <1368188814.8390.15.camel@jlt4.sipsolutions.net> (sfid-20130510_142711_226952_55581FF3)
Subject: Re: [RFC 4/4] cfg80211/mac80211: use cfg80211 wdev mutex in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com
Date: Fri, 10 May 2013 14:26:54 +0200
In-Reply-To: <518CE683.2040402@broadcom.com>
References: <1368187689-29706-1-git-send-email-johannes@sipsolutions.net>
	 <1368187689-29706-5-git-send-email-johannes@sipsolutions.net>
	 <518CE683.2040402@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-05-10 at 14:22 +0200, Arend van Spriel wrote:
> On 05/10/2013 02:08 PM, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > Using separate locks in cfg80211 and mac80211 has always
> > caused issues, for example having to unlock in places in
> > mac80211 to call cfg80211, which even needed a framework
> > to make cfg80211 calls after some functions returned etc.
> >
> > Additionally, I suspect some issues people have reported
> > with the cfg80211 state getting confused could be due to
> > such issues, when cfg80211 is asking mac80211 to change
> > state but mac80211 is in the process of telling cfg80211
> > that the state changed (in another way.)
> 
> I guess this change affects fullmac drivers like brcmfmac, right?

I don't think so.

johannes

