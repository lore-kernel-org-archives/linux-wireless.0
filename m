Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:35050 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbXLNOUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 09:20:52 -0500
Received: by py-out-1112.google.com with SMTP id u77so1157187pyb.16
        for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2007 06:20:51 -0800 (PST)
Message-ID: <43e72e890712140620h90676b5x831563376ccbc1ec@mail.gmail.com> (sfid-20071214_142059_086225_FC160E50)
Date: Fri, 14 Dec 2007 09:20:50 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [WIP] cfg80211 infrastructure for channels/bitrates, mac80211 and b43 conversion
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <1197631004.16079.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1197631004.16079.25.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 14, 2007 6:16 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hi,
>
> This patch creates new cfg80211 wiphy API for channel and bitrate
> registration and converts mac80211 (and, as an example and for testing,
> b43) to the new API. The old mac80211 API is completely ripped out.
>
> So far, it has survived all my testing: only active scanning :)
>
> Note that this has one major regression: with this patch you will have
> all hardware channels available because I completely ripped out the
> regulatory "enforcement" code. I believe that is for the better because
> then we can cleanly add new regulatory enforcement code to cfg80211.
>
> I've also ripped out all power adjustment and antenna gain fields/code,
> this too will have to be added back, again I believe part of new
> regulatory enforcement code.
>
> Along with the regulatory code I've also ripped out the
> IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED flag, I believe it to be
> unnecessary if the hardware simply gives us whatever channels it wants
> to support and we then enable/disable them as required, which is pretty
> much required for travelling. Those with varying EEPROMs will obviously
> have to allocate the array dynamically for each wiphy.
>
> Here are a few more TODOs:
>  * do ERP stuff again, this is currently pretty broken (even before the
>    patch)
>  * do basic rate handling again, this is probably broken before the
>    patch
>  * do mandatory rate handling again (probably broken as well, partially
>    done)
>  * reimplement channel use calculations... they looked too broken to
>    worry about right now
>
> Luis, please see the API in include/net/wireless.h. You'll have to add
> to that for the regulatory stuff.

Looks great, I'm glad I don't have to deal with these changes now :)
just a few questions and observations:

* I didn't see the definition for ieee80211_channel_to_frequency() and
its counter part, where are those defined?
* This patch didn't have b43 changes
* I'd like to base work on these patches, where can I find them the
complete series to wget

  Luis
