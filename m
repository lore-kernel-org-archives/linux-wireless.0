Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48154 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbaBQQip (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 11:38:45 -0500
Message-ID: <1392655111.5202.11.camel@jlt4.sipsolutions.net> (sfid-20140217_173848_729533_EE58621A)
Subject: Re: [RFC 1/4] mac80211: Allow 5/10 MHz channel setting (for OCB)
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de
Date: Mon, 17 Feb 2014 17:38:31 +0100
In-Reply-To: <1392652166.878.19.camel@umadbro> (sfid-20140217_164933_948526_5C145D5F)
References: <1392643374-3545-1-git-send-email-lisovy@gmail.com>
	 <1392643374-3545-2-git-send-email-lisovy@gmail.com>
	 (sfid-20140217_142311_364138_9794E9CF) <1392644957.5202.7.camel@jlt4.sipsolutions.net>
	 <1392652166.878.19.camel@umadbro> (sfid-20140217_164933_948526_5C145D5F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-02-17 at 16:49 +0100, Rostislav Lisovy wrote:

> As you have already noticed, this is work in progress. I agree it is
> necessary to keep the code clean if I want others to read it -- I try to
> do so but it does not always go very well.

:-)

> One thing I am not sure about (mentioned in 0/4) and need some
> suggestions is frequency setting in the OCB mode.
> Since there are no beacons containing the information about the
> frequency to set, the frequency is set manually. Since the
> 'set_channel()' function is not present anymore (and we do not have
> 'ocb_join()' function, thus we cannot use 'preset_chandef'), I was not
> able to figure out how to set a fixed channel.

I don't really see why you didn't add an obc_join() method. I know that
it's not strictly a BSS concept, but still there should be *some*
indication that you want to participate in the OBC now, so you should
still have something like obc_join() that starts everything.

> If I would want to set the frequency with the
> ieee80211_vif_use_channel() function, I would need to somehow obtain the
> *sdata. If I check ieee80211_set_monitor_channel() I see how *sdata is
> obtained there, but I am not sure if it is a good idea to add *ocb_sdata
> to struct ieee80211_local?

That doesn't seem right, no; it seems in theory multiple OBC interfaces
could be present.

johannes

