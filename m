Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40190 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3CSUoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 16:44:12 -0400
Message-ID: <1363725845.8336.33.camel@jlt4.sipsolutions.net> (sfid-20130319_214416_365436_A63FCDC1)
Subject: Re: [RFC] mac80211: avoid rearming BA session timers unnecessarily
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 19 Mar 2013 21:44:05 +0100
In-Reply-To: <1363691302-11947-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20130319_120831_560538_0494E1A8)
References: <1363691302-11947-1-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20130319_120831_560538_0494E1A8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-19 at 04:08 -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> If mac80211 tears down the BA sessions with del_timer_sync()
> technically mod_timer() can still rearm them. If mac80211
> tears the BA sessions down we don't want to rearm the timers
> at a later time so avoid this possibility.

Hmm, you may be onto something, but I'm not sure I want to apply this.
You don't seem to actually understand what you're doing -- two of the
three changes you're making don't really seem to be needed and the third
one should probably be fixed differently?

johannes

