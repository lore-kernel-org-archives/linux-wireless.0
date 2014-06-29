Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:50373 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752718AbaF2KnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 06:43:22 -0400
Date: Sun, 29 Jun 2014 13:43:18 +0300
From: Jouni Malinen <j@w1.fi>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 05/10] mac80211: use TDLS initiator in tdls_mgmt
 operations
Message-ID: <20140629104318.GA32230@w1.fi> (sfid-20140629_124344_246091_C3F8C1E1)
References: <1402496307-32522-1-git-send-email-arik@wizery.com>
 <1402496307-32522-5-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1402496307-32522-5-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2014 at 05:18:22PM +0300, Arik Nemtsov wrote:
> The TDLS initiator is set once during link setup. If determines the
> address ordering in the link identifier IE.
> Use the value from userspace in order to have a correct teardown packet.
> With the current code, a teardown from the responder side fails the TDLS
> MIC check because of a bad link identifier IE.

This series, and in particular, this patch, seems to break number of
TDLS use cases (well, almost all use of TDLS) with "old" user space
tools. This should be fixed or reverted until the changes are in state
that avoid such breaking of the old user interface. We cannot assume
that everyone will be updating kernel and wpa_supplicant in sync.

I would recommend running through full mac80211_hwsim test cases from
hostap.git when doing any changes to existing nl80211
commands/attributes or how they are used.

> diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
> @@ -242,27 +243,42 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
> -	/* the TDLS link IE is always added last */
> +	/* sanity check for initiator */

These sanity checks do not work with old user space since initiator will
be hardcoded to false for those cases.

>  	switch (action_code) {
>  	case WLAN_TDLS_SETUP_REQUEST:
>  	case WLAN_TDLS_SETUP_CONFIRM:
> -	case WLAN_TDLS_TEARDOWN:
>  	case WLAN_TDLS_DISCOVERY_REQUEST:
> -		/* we are the initiator */
> -		ieee80211_tdls_add_link_ie(skb, sdata->vif.addr, peer,
> -					   sdata->u.mgd.bssid);
> +		if (!initiator) {
> +			ret = -EINVAL;
> +			goto fail;
> +		}

This will reject all new request frames unless user space tools are
modified to add NL80211_ATTR_TDLS_INITIATOR.

For most of these, it should be possible to set initiator based on
action_code if the attribute had been designed to support backwards
compatibility, but it wasn't, i.e., there is no way of knowing whether
the user space is aware of this new attribute since it is a flag
attribute. For example, an u32 encoding an enum that indicates whether
the device is the initiator would have allowed cfg80211 to figure out on
its own which role the device is in if the new attribute is not
included.

Is it already too late to change the nl80211 attribute since this hit
wireless-testing.git? I was about to commit wpa_supplicant changes to
start using this new attribute, but I don't think I'll do it now to
avoid getting any actual users added for this until the kernel side
design gets fixed to address existing user space behavior.


PS.

This location and patch is not the only one that breaks TDLS tests.
'mac80211: make sure TDLS peer STA exists during setup' is also breaking
things at least for special test functionality (e.g.,
ap_wpa2_tdls_bssid_mismatch and ap_wpa2_tdls_concurrent_init). I'm not
sure what to do about those, though.

-- 
Jouni Malinen                                            PGP id EFC895FA
