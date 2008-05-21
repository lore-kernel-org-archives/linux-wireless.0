Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4214 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbYEUO3I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 10:29:08 -0400
Date: Wed, 21 May 2008 09:54:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Helmut Schaa <hschaa@suse.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Bruno Randolf <bruno@thinktube.com>
Subject: Re: [PATCHv5] mac80211: fix NULL pointer dereference in
	ieee80211_compatible_rates
Message-ID: <20080521135451.GA3545@tuxdriver.com> (sfid-20080521_162918_324533_C2278D4E)
References: <20080520095637.2cq5p5ohhc8440o4@imap.suse.de> <1ba2fa240805200554w9354d14v9abc70f676540b9b@mail.gmail.com> <1ba2fa240805210347w375b571djc922f814fa9f521f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240805210347w375b571djc922f814fa9f521f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 21, 2008 at 01:47:04PM +0300, Tomas Winkler wrote:
> On Tue, May 20, 2008 at 3:54 PM, Tomas Winkler <tomasw@gmail.com> wrote:

> > I found one  ieee80211_rx_bss_{get,put} imbalance   in
> > ieee80211_sta_join_ibss function
> > That may cause this problem yet it doesn't look like this is the case.
> > ieee80211_sta_join_ibss
> > calls ieee80211_rx_bss_put on 'bss' that it receives as an argument
> 
> The patch below introduced  _get/_put imbalance. ieee80211_rx_bss_info
> _put bss back at the end. Other callers of the ieee80211_sta_join_ibss
> function don't use put.
> I will post a patch that takes out the _put out of
> ieee80211_rx_bss_info, I think it's more readable.

Since you are doing _get and _add in ieee80211_rx_bss_info, it makes
sense to me to do _put at the end of it.  Perhaps we should remove
the _put from the end of ieee80211_sta_join_ibss and change it's
callers instead?

John
-- 
John W. Linville
linville@tuxdriver.com
