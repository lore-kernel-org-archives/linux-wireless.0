Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63244 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab0J2Fyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 01:54:36 -0400
Received: by wyf28 with SMTP id 28so2747531wyf.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Oct 2010 22:54:35 -0700 (PDT)
MIME-Version: 1.0
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Fri, 29 Oct 2010 15:54:14 +1000
Message-ID: <AANLkTimUu50FRU_r-Og9OqP6oGJ4q=-WsmdWU_k0_AZp@mail.gmail.com>
Subject: Accessing channel utilization stats
To: ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

So, I've been banging my head against the wall trying to work out
what's going on here. I'm trying to access the channel utilization
data that was added to cfg80211/nl80211's survey dump on an atheros
card.

It's been difficult to get a working kernel to do this, as the current
master has the correct nl80211 patch, but not the ath5k one. I've
pulled my tree to the latest version, and then cherry-picked the ath5k
commit which adds the survey data to mac80211.

Unfortunately, requesting a survey dump using the modified iw from the
openwrt tree which should be able to extract the new information
causes my kernel to panic.

It appears to be dereferencing a non-existent pointer as the trace
contains a line mentioning CopyToUser. I'm wondering if anyone has
come across this problem and would know what's going wrong? I tried to
get a kernel dump from the alix board we have, but it's now gone into
a reboot cycle, and I can't fix it until Monday.

Any help would be greatly appreciated.

Thanks,

--
Jonathan Guerin
