Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53484 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731070AbeISRxB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 13:53:01 -0400
Message-ID: <1537359309.10305.39.camel@sipsolutions.net> (sfid-20180919_141537_523921_DA0947C8)
Subject: Re: [PATCH 0/7] netlink recursive policy validation
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 19 Sep 2018 14:15:09 +0200
In-Reply-To: <20180919120900.28708-1-johannes@sipsolutions.net> (sfid-20180919_140946_949394_5F70870F)
References: <20180919120900.28708-1-johannes@sipsolutions.net>
         (sfid-20180919_140946_949394_5F70870F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Below is an example of a policy I just built using this.

This may seem rather complex, but that's because the problem is complex
- we want to be able to measure multiple different things (currently
only FTM though) with different peers, and some attributes are shared
(like channel, MAC address) whereas others are method-specific...

I'm sticking all of the measurement request into a single top-level
nl80211 attribute (NL80211_ATTR_PEER_MEASUREMENTS), then in there you
specify global parameters (elided) as well as an array of peers.

Each peer again contains some method-independent parameters (only "CHAN"
shown), as well as request data, which has some parts that are common
and some that are method dependent (yet another nesting level).

All of this gets validated - with the channel data exception in the
comment below - entirely without ever writing another line of code for
it. Yes, we'll still have to write some code to actually use it, but
then we need to worry much less about formatting there.

johannes


static const struct nla_policy
nl80211_pmsr_ftm_req_attr_policy[NL80211_PMSR_FTM_REQ_ATTR_MAX + 1] = {
/* ... */
};

static const struct nla_policy
nl80211_pmsr_req_data_policy[NL80211_PMSR_TYPE_MAX + 1] = {
	[NL80211_PMSR_TYPE_FTM] =
		NLA_POLICY_NESTED(NL80211_PMSR_FTM_REQ_ATTR_MAX,
				  nl80211_pmsr_ftm_req_attr_policy),
};

static const struct nla_policy
nl80211_pmsr_req_attr_policy[NL80211_PMSR_REQ_ATTR_MAX + 1] = {
	[NL80211_PMSR_REQ_ATTR_DATA] =
		NLA_POLICY_NESTED(NL80211_PMSR_TYPE_MAX,
				  nl80211_pmsr_req_data_policy),
/* ... */
};

static const struct nla_policy
nl80211_psmr_peer_attr_policy[NL80211_PMSR_PEER_ATTR_MAX + 1] = {
	/*
	 * we could specify this again to be the top-level policy,
	 * but that would open us up to recursion problems ...
	 */
	[NL80211_PMSR_PEER_ATTR_CHAN] = { .type = NLA_NESTED },
	[NL80211_PMSR_PEER_ATTR_REQ] =
		NLA_POLICY_NESTED(NL80211_PMSR_REQ_ATTR_MAX,
				  nl80211_pmsr_req_attr_policy),
/* ... */
};

static const struct nla_policy
nl80211_pmsr_attr_policy[NL80211_PMSR_ATTR_MAX + 1] = {
	[NL80211_PMSR_ATTR_PEERS] =
		NLA_POLICY_NESTED_ARRAY(NL80211_PMSR_PEER_ATTR_MAX,
					nl80211_psmr_peer_attr_policy),
/* ... */
};

static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
/* ... */
	[NL80211_ATTR_PEER_MEASUREMENTS] =
		NLA_POLICY_NESTED(NL80211_PMSR_FTM_REQ_ATTR_MAX,
				  nl80211_pmsr_attr_policy),
};
