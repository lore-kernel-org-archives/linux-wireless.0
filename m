Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:36662 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab0FINwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 09:52:00 -0400
Received: by wwb31 with SMTP id 31so263801wwb.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jun 2010 06:51:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1276080986.14580.6.camel@jlt3.sipsolutions.net>
References: <1275940207.29978.24.camel@jlt3.sipsolutions.net>
	<1276080986.14580.6.camel@jlt3.sipsolutions.net>
Date: Wed, 9 Jun 2010 09:51:58 -0400
Message-ID: <AANLkTilm2zuqCzc1VZf6r3NfuUnGmxkhYsp6qPKdV6lC@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: fix deauth before assoc
From: Miles Lane <miles.lane@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 9, 2010 at 6:56 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> When we receive a deauthentication frame before
> having successfully associated, we neither print
> a message nor abort assocation. The former makes
> it hard to debug, while the latter later causes
> a warning in cfg80211 when, as will typically be
> the case, association timed out.
>
> This warning was reported by many, e.g. in
> https://bugzilla.kernel.org/show_bug.cgi?id=15981,
> but I couldn't initially pinpoint it. I verified
> the fix by hacking hostapd to send a deauth frame
> instead of an association response.
>
> Cc: stable@kernel.org
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> That previous one didn't even apply to the right tree, how did you ever
> test it? Or did you just fix up the context?

patching file net/mac80211/mlme.c
Hunk #1 succeeded at 1722 with fuzz 3 (offset 27 lines).
