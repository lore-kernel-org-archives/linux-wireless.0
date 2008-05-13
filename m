Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:5566 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbYEMIwW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 04:52:22 -0400
Received: by wa-out-1112.google.com with SMTP id j37so4004580waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2008 01:52:19 -0700 (PDT)
Message-ID: <1ba2fa240805130152va2e8f03i1f9291942776b311@mail.gmail.com> (sfid-20080513_105224_814290_9000C1E9)
Date: Tue, 13 May 2008 11:52:18 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH] mac80211 : Association with 11n hidden ssid ap.
Cc: "Zhu Yi" <yi.zhu@intel.com>,
	"Abhijeet Kolekar" <abhijeet.kolekar@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1210667747.3646.32.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12103509413156-git-send-email-abhijeet.kolekar@intel.com>
	 <1210641995.2506.200.camel@debian.sh.intel.com>
	 <1210667747.3646.32.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 13, 2008 at 11:35 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  > Johannes, can you please take a look at this patch? The original code
>  > looks like a shortcut to start authentication/association when all the
>  > three parameters (BSSID/SSID/CHANNEL) are provided. But this is not
>  > sufficient in the case of associate with an 11N hidden SSID AP. The 11n
>  > and wmm information must be retrieved by an active probe request. Not
>  > doing so will cause the 11N AP refuse to associate with the client.
>
>
>
> > > -   if (!(ifsta->flags & (IEEE80211_STA_AUTO_SSID_SEL |
>  > > -       IEEE80211_STA_AUTO_BSSID_SEL | IEEE80211_STA_AUTO_CHANNEL_SEL))) {
>  > > -           ifsta->state = IEEE80211_AUTHENTICATE;
>  > > -           ieee80211_sta_reset_auth(dev, ifsta);
>  > > -           return 0;
>  > > -   }
>  > > -
>  > >     spin_lock_bh(&local->sta_bss_lock);
>
>  Well, I'm not sure I'm the right person to look at this, I'm very
>  unfamiliar with the code in question. For all I care we can put it in
>  and revert/fixup when we get bug reports from it.
>

You should always had in hand at least one probe response before
attempting association as mot all information elements are present in
beacons.  This is not only case for 11n but for QoS in general.
I would suggest that association process in BSS will always start with
sending probe request.

Tomas


>  johannes
>
