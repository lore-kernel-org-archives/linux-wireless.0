Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:49439 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753132Ab2EOPQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 11:16:33 -0400
Date: Tue, 15 May 2012 11:16:25 -0400
From: Jouni Malinen <j@w1.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: retry auth and assoc on error 17
Message-ID: <20120515151625.GA1306@w1.fi> (sfid-20120515_171637_662472_1950305E)
References: <1337091676-29441-1-git-send-email-eliad@wizery.com>
 <1337092228.15553.0.camel@jlt3.sipsolutions.net>
 <CAB3XZEd49R_KSAMRwM-B9PW_yzmK7aS9zzFVueA=nrFM7odC=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB3XZEd49R_KSAMRwM-B9PW_yzmK7aS9zzFVueA=nrFM7odC=w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 15, 2012 at 05:40:17PM +0300, Eliad Peller wrote:
> On Tue, May 15, 2012 at 5:30 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Tue, 2012-05-15 at 17:21 +0300, Eliad Peller wrote:
> >> In some congested environments APs return
> >> WLAN_STATUS_AP_UNABLE_TO_HANDLE_NEW_STA on auth/assoc
> >> attempt. Instead of failing immediately, retry again
> >> in 200 msec.
> >
> > I think this should be in wpa_supplicant?
> >
> it behaves similarly to WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY, which
> handled by mac80211, so i thought it would be fine to handle it as
> well (and this way it can also be used by iw).

WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY is a special case in which the AP
provides a clear expectation of the association succeeding after the
specified amount of time. WLAN_STATUS_AP_UNABLE_TO_HANDLE_NEW_STA is
quite different since it can be used by APs to enforce load balancing.
It does not sound like a good idea to enforce mac80211 to retry
association with the same AP unconditionally in this case. I would also
leave this for wpa_supplicant which has already been optimized to handle
the load balancing case without this type of extra latency added.
Disabling this functionality would not be good for many enterprise
networks.

-- 
Jouni Malinen                                            PGP id EFC895FA
