Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46304 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3EMHJ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 03:09:29 -0400
Message-ID: <1368428965.8300.0.camel@jlt4.sipsolutions.net> (sfid-20130513_090933_445160_0AAF4A03)
Subject: Re: [RFC 4/4] cfg80211/mac80211: use cfg80211 wdev mutex in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com
Date: Mon, 13 May 2013 09:09:25 +0200
In-Reply-To: <518E6FA9.3060205@broadcom.com>
References: <1368187689-29706-1-git-send-email-johannes@sipsolutions.net>
	 <1368187689-29706-5-git-send-email-johannes@sipsolutions.net>
	 <518CE683.2040402@broadcom.com>
	 <1368188814.8390.15.camel@jlt4.sipsolutions.net>
	 <518E6FA9.3060205@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > I don't think so.
> 
> I am asking because I noticed the following documentation change:
> 
> - * @mtx: mutex used to lock data in this struct
> + * @mtx: mutex used to lock data in this struct, may be used by drivers
> + *	and some API functions require it held
> 
> I did not look at the individual API functions, but I guess to be sure I 
> should check whether we are using any of them.

Yes, but these API functions are all only used with userspace SME
(auth/assoc calls and similar.)

johannes

