Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37664 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901Ab1CIJmQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 04:42:16 -0500
Subject: Re: Delay enabling power save until 4-way Handshake completes
From: Johannes Berg <johannes@sipsolutions.net>
To: Jason Young <a.young.jason@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTikwjgKeMPo3UGL=0R2Qxa5DMYC7YejBSSLdqjKd@mail.gmail.com>
References: <AANLkTikwjgKeMPo3UGL=0R2Qxa5DMYC7YejBSSLdqjKd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Mar 2011 10:42:14 +0100
Message-ID: <1299663734.3769.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-08 at 15:54 -0800, Jason Young wrote:

> Something like the following prevents powersave from being enabled
> before the 4-way handshake completes, but we still need to call
> ieee80211_recalc_ps again after WLAN_STA_AUTHORIZED is set and I'm not
> sure the best place for that. Any ideas or alternate approaches that
> may solve this problem?

This seems fine to me, you just have to call recalc_ps whenever the
AUTHORIZED flag changes, which is easy enough.

johannes


