Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:40108 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3LERCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 12:02:11 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so11573803eaj.29
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 09:02:09 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/8] mac80211: speed up station cleanup/AP shutdown
Date: Thu, 05 Dec 2013 18:02:06 +0100
Message-ID: <1952067.PDj1Tev3s2@blech> (sfid-20131205_180214_191520_FBE80A1D)
In-Reply-To: <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
References: <1386192610.5660.4.camel@jlt4.sipsolutions.net> <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, December 05, 2013 01:35:48 PM Johannes Berg wrote:
> Inspired by hostap shutdown potentially taking a long time (which is
> in part also its fault), I took a closer look at the station removal
> code and I think it's too complex. Only a single driver (iwlmvm) has
> a need for an RCU grace period after sta_state() returns, and that
> can easily be addressed differently.
> 
> So consolidate many of the synchronize_rcu()/_net() in these paths
> and get rid of the rcu_barrier() stuff completely.
> 
> Testing is still pending, but it should improve timing.

So far, I see no crashes or other undefined behavior with
current carl9170 driver.

Regards,
	Chr
