Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:37066 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbeIRNXz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 09:23:55 -0400
Message-ID: <1537257137.2957.15.camel@sipsolutions.net> (sfid-20180918_095235_100961_7DA0FD45)
Subject: Re: [PATCH v4 1/3] cfg80211: support FTM responder
 configuration/statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>
Date: Tue, 18 Sep 2018 09:52:17 +0200
In-Reply-To: <1536702279-7643-2-git-send-email-pradeepc@codeaurora.org>
References: <1536702279-7643-1-git-send-email-pradeepc@codeaurora.org>
         <1536702279-7643-2-git-send-email-pradeepc@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry for the delay with this. I was a bit fed up by all the resends,
but I see the latest one did in fact finally make it to the list and
patchwork.
(As an aside - it would've helped to actually bump the version number
for every resend, even if it's identical - now I don't know which
version to reply to in my email so it goes to patchwork)


> + * @civic: CIVIC subelement content

> + * @civic_len: Civic data length

I was continuing work on the FTM initiator, and I think now that we
should call this "civicloc", otherwise we're missing the arguably more
important part of "civic location".

> + * @NL80211_ATTR_FTM_RESPONDER: attribute which user-space can include in
> + *	%NL80211_CMD_START_AP or %NL80211_CMD_SET_BEACON to enable(1)
> + *	fine timing measurement (FTM) responder functionality.
> + * @NL80211_ATTR_LCI: The content of Measurement Report Element (9.4.2.22
> + *	in 802.11-2016) with type 8 - LCI (9.4.2.22.10)
> + * @NL80211_ATTR_CIVIC: The content of Measurement Report Element (9.4.2.22
> + *	in 802.11-2016) with type 11 - Civic (Section 9.4.2.22.13)

Again, thinking about the FTM initiator side code, I think we're
probably better off to nest these.

NL80211_ATTR_FTM_RESPONDER -> nested

enum nl80211_ftm_responder_attr {
	NL80211_FTM_RESP_ATTR_INVALID,

	NL80211_FTM_RESP_ATTR_ENABLED,
	NL80211_FTM_RESP_ATTR_LCI,
	NL80211_FTM_RESP_ATTR_CIVICLOC,

	NUM/MAX...
};

That way we can extend this very easily in the future and don't need
these attributes at the top level.

The logic also makes sense in the beacon change command - if you don't
include the NL80211_ATTR_FTM_RESPONDER then it means no change; if you
do include it the new settings within it (which may be completely empty
to disable it) should take effect.

> +/**
> + * enum nl80211_ftm_responder_state - fine timing measurement responder state
> + * @NL80211_FTM_RESP_DISABLED: FTM responder is disabled
> + * @NL80211_FTM_RESP_ENABLED: FTM responder is enabled
> + */
> +enum nl80211_ftm_responder_state {
> +	NL80211_FTM_RESP_DISABLED,
> +	NL80211_FTM_RESP_ENABLED,
> +};

We won't need this either then.

> +	[NL80211_ATTR_FTM_RESPONDER] = { .type = NLA_U8 },

And that of course becomes NLA_NESTED

> +	[NL80211_ATTR_LCI] = { .type = NLA_BINARY },
> +	[NL80211_ATTR_CIVIC] = { .type = NLA_BINARY },

with those moving to a separate policy.

What do you think?

johannes
