Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58078 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759858AbZEKWjT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 18:39:19 -0400
Subject: Re: [PATCH] cfg80211: implement wext key handling
From: Dan Williams <dcbw@redhat.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	Samuel Ortiz <sameo@linux.intel.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <3ace41890905111516m2d5f9f70k83edbdef1ca6e2b8@mail.gmail.com>
References: <1242042898.18637.0.camel@johannes.local>
	 <1242049846.28322.12.camel@localhost.localdomain>
	 <1242050962.29777.12.camel@johannes.local>
	 <3ace41890905111516m2d5f9f70k83edbdef1ca6e2b8@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 11 May 2009 18:40:08 -0400
Message-Id: <1242081608.24094.14.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-05-11 at 23:16 +0100, Hin-Tak Leung wrote:
> On Mon, May 11, 2009 at 3:09 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Mon, 2009-05-11 at 09:50 -0400, Dan Williams wrote:
> >
> >> I modified the meaning of RESTRICTED/OPEN a few years ago to control the
> >> WEP auth mode, for a few reasons...  First, some fullmac drivers already
> >> used it to mean WEP auth mode.  Second, there was no other mechanism to
> >> control WEP auth mode at the time, and there were a lot of Shared Key
> >> installations around.  Third, WE-18/WPA was nowhere near being landed,
> >> and it was only supported by one driver (hostap), and it was the only
> >> thing that would plausibly support WEP auth mode via SIWAUTH.  Fourth,
> >> only hostap and maybe airo really implemented the refuse-non-encoded
> >> anyway.
> >
> > But didn't update the header file ;)
> >
> >> TBH, SK is nice because it tells you that the WEP key is wrong
> >> *immediately*, and the only reason NM doesn't use SK by default (and
> >> then fall back to OS) like the original Mac Airport drivers did is that
> >> WEXT simply cannot return reliable association error information.
> >
> > Hah. Well, we could have that now, but I suspect SK is no longer common
> > enough to put a lot of work into it.
> >
> >> But in the end, we still need a mechanism with WEXT to be able to set SK
> >> auth when associating.
> >
> > We still have that, with WE18, in IW_AUTH_80211_AUTH_ALG. And mac80211
> > never actually supported _setting_ the WEP auth mechanism with
> > RESTRICTED/OPEN, only _getting_ that information.
> >
> > johannes
> >
> >
> 
> Argh, is this the reason why compat-wireless(wireless-testing?) today
> doesn't quite work any more?
> NetworkManager no longer wants to work, with this message in syslog:
> 
> localhost NetworkManager: <WARN>  nm_device_wifi_disable_encryption():
> error setting key for device wlan2: Invalid argument

That specific call shouldn't cause a hard error.  It's just advisory.
And really, I could just remove that call in NM entirely, since
wpa_supplicant does clear keys in the MLME disconnect method now.

Dan

