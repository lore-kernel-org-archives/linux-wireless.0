Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:21972 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751755AbYC1KxJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 06:53:09 -0400
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: use hardware flags for signal/noise units
Date: Fri, 28 Mar 2008 19:52:47 +0900
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
References: <20080326123042.11233.80949.stgit@localhost> <1206622063.22530.25.camel@johannes.berg>
In-Reply-To: <1206622063.22530.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803281952.47401.bruno@thinktube.com> (sfid-20080328_105313_446372_6CEF3322)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 27 March 2008 21:47:43 Johannes Berg wrote:
> On Wed, 2008-03-26 at 21:30 +0900, Bruno Randolf wrote:
> > trying to clean up the signal/noise mess. the previous code in mac80211
> > did not have much definition of what units of signal and noise were
> > provided and used weird implicit mechanisms from the wireless extensions.
> >
> > introduce hardware capability flags to let the hardware specify if it can
> > provide signal and noise level values and which units it can provide:
> >
> >   IEEE80211_HW_SIGNAL_UNSPEC - unspecified, unknown, hw specific
> >   IEEE80211_HW_SIGNAL_DB     - dB difference to unspecified reference
> > point IEEE80211_HW_SIGNAL_DBM    - dBm, difference to 1mW
> >
> >   IEEE80211_HW_NOISE_DBM     - dBm, difference to 1mW
> >
> > also clean up the misleading and confusing names which were used for
> > signal, noise and qual before.
>
> I have to admit to not particularly caring about these things, so if
> you're willing to accept responsibility for all breakage I'm ok with the
> patch going in :)

well, i'm going to - for whatever that means :)

i have compile tested the current patch with all mac80211 based drivers, i 
believe and function tested with ath5k and iwl4965 - but lets give the driver 
authors some more time for feedback and review. also i'd like to integrate 
jean's suggestion that unspec doesn't have to be linear.

bruno
