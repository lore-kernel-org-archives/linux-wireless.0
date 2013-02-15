Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58967 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932964Ab3BOJVM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 04:21:12 -0500
Message-ID: <1360920070.15040.6.camel@jlt4.sipsolutions.net> (sfid-20130215_102117_194558_F6AC1B29)
Subject: Re: [RFC] iw: support split wiphy dump
From: Johannes Berg <johannes@sipsolutions.net>
To: Dennis H Jensen <dennis.h.jensen@siemens.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 15 Feb 2013 10:21:10 +0100
In-Reply-To: <1360918601.12484.6.camel@djensen-laptop>
References: <1360855759-2377-1-git-send-email-johannes@sipsolutions.net>
	 <1360856049-2546-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130214_163418_636491_ECBFFDA6) <1360856422.8210.2.camel@jlt4.sipsolutions.net>
	 <1360918601.12484.6.camel@djensen-laptop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-15 at 09:56 +0100, Dennis H Jensen wrote:
> On Thu, 2013-02-14 at 16:40 +0100, Johannes Berg wrote:
> > On Thu, 2013-02-14 at 16:34 +0100, Johannes Berg wrote:
> > > From: Johannes Berg <johannes.berg@intel.com>
> > > 
> > > This adds support for the new split wiphy dump,
> > > it only uses it for "iw list", not for "info"
> > > though, so far. Using it for "info" would mean
> > > querying the kernel capability first and then
> > > using get/dump (with filter) depending on that.
> > 
> > Dennis, are you up for implementing this in wpa_supplicant?
> 
> Great, this will solve it. I can handle the wpa_supplicant; give me a
> couple of days to get it sorted.

FWIW, I think for wpa_s there are two possibilities:
 1) simply always use NL_F_DUMP with NL80211_CMD_GET_WIPHY, and include
    the filter & split attributes; this will mean on old kernels it will
    retrieve information for all devices so you have to filter it
 2) query the nl80211 global features first when initialising the
    nl80211 sockets, and then use NL_F_DUMP with the filter only if the
    feature is supported in the kernel

Both are about the same difficulty because for 2) you need the extra
feature command (once at init) while for 1) you need an extra command to
get the wiphy index for the device you care about for filtering. For 1)
that command would be NL80211_CMD_GET_INTERFACE.

> What's the procedure, do I post to both lists or just the hostap?

Just hostap is fine.

johannes

