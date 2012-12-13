Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:34345 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2LMW1d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 17:27:33 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so2255987lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 14:27:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812784-15845-2-git-send-email-johannes@sipsolutions.net>
References: <1354812784-15845-1-git-send-email-johannes@sipsolutions.net> <1354812784-15845-2-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 13 Dec 2012 14:27:11 -0800
Message-ID: <CAB=NE6XpVxRudaZ0EXRR6KkgPOTqw4pXO+x0Pim+Bt2_HT8fnQ@mail.gmail.com> (sfid-20121213_232737_469506_5F08A683)
Subject: Re: [RFC 1/2] regulatory: allow arbitrary channel widths
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:53 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> There aren't any channel width restrictions in the
> 2.4 GHz band (except the natural ones by the (sub)band
> boundaries), nor do default restrictions in the 5 GHz
> band make sense when limited to passive scan/no IBSS
> etc.
>
> Allow passing NL80211_NO_REG_BANDWIDTH_LIMIT as the
> max_bandwidth_khz and make that mean no restrictions.
> Use it for the default world roaming regdomain.
>
> Also make the awk script accept "NL" for "no limit"
> and substitute NL80211_NO_REG_BANDWIDTH_LIMIT.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

For 2.4 GHz this seems fine. For 5 GHz, just to clarify for Michael,
the changes you are making are for non-DFS channels, and for the
channels where we always never initiate radiation and just world roam
unless we get a beacon hint. That is the world regulatory domain
enabled 5 GHz channels that are non-DFS.

Michael, just a sanity check for you. What Johannes is saying is that
regulatory wise for the 2.4 GHz band on channels 1-11 and on 5 GHz on
non DFS channels where we never initiate radiation we don't have a
specific bandwidth restriction. Are you aware of any country
restricting any 5 GHz world roaming frequency (non DFS) or channel
1-11 on 2.4 GHz in terms of bandwidth used?

  Luis
