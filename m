Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34489 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaAZI4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jan 2014 03:56:44 -0500
Received: by mail-ie0-f174.google.com with SMTP id tp5so4480550ieb.5
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jan 2014 00:56:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390566001-9698-1-git-send-email-johannes@sipsolutions.net>
References: <1390566001-9698-1-git-send-email-johannes@sipsolutions.net>
Date: Sun, 26 Jan 2014 10:56:43 +0200
Message-ID: <CAB3XZEc94pTAMXWPYeWhu7o_YLEnD1_9O035-+YXYiR0Uij28w@mail.gmail.com> (sfid-20140126_095647_466805_4260BCE4)
Subject: Re: [PATCH] nl80211: fix scheduled scan RSSI matchset attribute confusion
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 24, 2014 at 2:20 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> The scheduled scan matchsets were intended to be a list of filters,
> with the found BSS having to pass at least one of them to be passed
> to the host. When the RSSI attribute was added, however, this was
> broken and currently wpa_supplicant adds that attribute in its own
> matchset; however, it doesn't intend that to mean that anything
> that passes the RSSI filter should be passed to the host, instead
> it wants it to mean that everything needs to also have higher RSSI.
>
> This is semantically problematic because we have a list of filters
> like [ SSID1, SSID2, SSID3, RSSI ] with no real indication which
> one should be OR'ed and which one AND'ed.
>
> To fix this, move the RSSI filter attribute into each matchset. As
> we need to stay backward compatible, treat a matchset with only the
> RSSI attribute as a "default RSSI filter" for all other matchsets,
> but only if there are other matchsets (an RSSI-only matchset by
> itself is still desirable.)
>
> To make driver implementation easier, keep a global min_rssi_thold
> for the entire request as well. The only affected driver is ath6kl.
>
> I found this when I looked into the code after Raja Mani submitted
> a patch fixing the n_match_sets calculation to disregard the RSSI,
> but that patch didn't address the semantic issue.
>
> Reported-by: Raja Mani <rmani@qti.qualcomm.com>
> Acked-by: Luciano Coelho <luciano.coelho@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

> +
> +       /* However, if there's no other matchset, add the RSSI one */
> +       if (!n_match_sets && default_match_rssi != NL80211_SCAN_RSSI_THOLD_OFF)
> +               n_match_sets = 1;
>

this means that min-rssi-only sched scan request will be seen as
req->n_match_sets = 1 with empty SSID?
i don't think that's desirable (at least the current documentation
assumes n_match_sets=0 for this case).

Eliad.
