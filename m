Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48416 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab1JLPbq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 11:31:46 -0400
Subject: Re: [PATCH v2] mac80211: pass vif param to conf_tx() callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1317543352-29019-1-git-send-email-eliad@wizery.com> (sfid-20111002_101552_130579_7FDA5164)
References: <1317543352-29019-1-git-send-email-eliad@wizery.com>
	 (sfid-20111002_101552_130579_7FDA5164)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 17:31:36 +0200
Message-ID: <1318433496.3933.44.camel@jlt3.sipsolutions.net> (sfid-20111012_173148_359999_61EE8004)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-10-02 at 10:15 +0200, Eliad Peller wrote:
> tx params should be configured per interface.
> add ieee80211_vif param to the conf_tx callback,
> and change all the drivers that use this callback.

For the record, I said this to you on IRC but you weren't around I
guess. This patch (with the other ones) is now passing a bogus sdata/vif
pointer to drivers -- e.g. for monitor mode interfaces from
ieee80211_do_open -> ieee80211_set_wmm_default -> drv_conf_tx.

I suspect the way to fix this would be to move the call to
ieee80211_set_wmm_default into the last switch statement in do_open,
could you please look into it?

Thx,
johannes

