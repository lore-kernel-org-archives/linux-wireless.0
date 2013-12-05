Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52821 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932920Ab3LER1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 12:27:36 -0500
Message-ID: <1386264448.4182.19.camel@jlt4.sipsolutions.net> (sfid-20131205_182755_323901_9B55FB27)
Subject: Re: [PATCH 0/8] mac80211: speed up station cleanup/AP shutdown
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 05 Dec 2013 18:27:28 +0100
In-Reply-To: <1952067.PDj1Tev3s2@blech> (sfid-20131205_180211_819129_F0306273)
References: <1386192610.5660.4.camel@jlt4.sipsolutions.net>
	 <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
	 <1952067.PDj1Tev3s2@blech> (sfid-20131205_180211_819129_F0306273)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 18:02 +0100, Christian Lamparter wrote:
> On Thursday, December 05, 2013 01:35:48 PM Johannes Berg wrote:
> > Inspired by hostap shutdown potentially taking a long time (which is
> > in part also its fault), I took a closer look at the station removal
> > code and I think it's too complex. Only a single driver (iwlmvm) has
> > a need for an RCU grace period after sta_state() returns, and that
> > can easily be addressed differently.
> > 
> > So consolidate many of the synchronize_rcu()/_net() in these paths
> > and get rid of the rcu_barrier() stuff completely.
> > 
> > Testing is still pending, but it should improve timing.
> 
> So far, I see no crashes or other undefined behavior with
> current carl9170 driver.

Cool. What I wrote came out bad - I did test that it still works with
hwsim and iwlwifi, but I didn't get any *timing* testing yet :)

johannes

