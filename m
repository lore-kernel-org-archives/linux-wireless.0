Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56658 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbaHKPeU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 11:34:20 -0400
Message-ID: <1407771253.9844.27.camel@jlt4.sipsolutions.net> (sfid-20140811_173424_167156_2E61B5AF)
Subject: Re: [PATCH v2] cfg80211: Changes to support key management offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Chet Lanctot <clanctot@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com
Date: Mon, 11 Aug 2014 17:34:13 +0200
In-Reply-To: <1406076875-8549-1-git-send-email-clanctot@qca.qualcomm.com>
References: <1406076875-8549-1-git-send-email-clanctot@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chet,

I apologise that it basically took me forever to really review this.

In general, this seems like a reasonable feature. I'd like to know which
driver is planning to use this, maybe ath6kl? It's a complicated enough
feature that I think a reference implementation would be good in
addition to the review.

> On a successful key management offload, the driver will invoke
> cfg80211_authorization_event with status NL80211_AUTHORIZED.  If the
> key management offload is not successful, then NL80211_CONNECTED is
> passed as the status in cfg80211_authorization_event and it is expected
> the supplicant will take over key management.

You should probably document (in the header file, not just the commit
log) what happens with the EAPOL frames otherwise. Are they passed up to
the supplicant even if they're parsed?

Maybe this event is even not really needed in the case that the firmware
can't process the EAPOL frame correctly and needs to pass it up - it
could just do so and otherwise "swallow" it while processing? Or is
there any need for it to go up after it has been processed? It seems you
capture the relevant information:

> The last used EAPOL key reply counter value is passed to the supplicant
> in cfg80211_authorization_event.



> In the case of key management offload after roaming,
> cfg80211_authorization_event will always be called immediately after a
> call to cfg80211_roamed.

Would it make sense to include this in the roamed event? Maybe not since
these are two completely separate things though. Similar here of course
for my above note regarding the EAPOL frames.

> In the case of PTK rekeying, cfg80211_authorization_event is called
> after the device has handled rekeying.  This allows the supplicant
> to recieve an updated EAPOL key reply counter value.

(typo: receive)
What use does wpa_supplicant have for the replay counter btw, if
everything is handled in the device? Are there some situations/options
that the device may decide not to handle, and pass up the frame instead
of responding?

I also assume that this is not going to be usable with mac80211 devices,
in fact only with devices that assign the TX sequence number in firmware
(otherwise you can't TX data frames from there)

>    1. The driver advertises general key management offload capability
>       with the wiphy flag WIPHY_FLAG_HAS_KEY_MGMT_OFFLOAD.  Device
>       attributes NL80211_KEY_MGMT_OFFLOAD_SUPPORT_PSK and
>       NL80211_KEY_DERIVE_OFFLOAD_SUPPORT_IGTK are advertised.
> 
>    2. Using existing mechanisms, the supplicant decides that a
>       connection should be made to a network.  The network is an RSN
>       supporting WPA2 and Protected Management Frames.  Seeing that the
>       device supports key management offload for WPA2 and key derivation
>       for IGTK, it signals to the driver that it wants to take advantage
>       of key management offload by specifying ASSOC_REQ_OFFLOAD_KEY_MGMT
>       in cfg80211_assoc_req_flags in the cfg80211_connect command.  The
>       PSK for the connection is also included in cfg80211_connect.

What if the supplicant decides not to request the offload? Would the
firmware continue working as is (passing EAPOL frame up) or would there
be any issues? I guess it can't really even do anything else.

OTOH, why even then bother having the ASSOC_REQ_OFFLOAD_KEY_MGMT instead
of just having wpa_supplicant pass the necessary key material for all
cases, and letting the driver treat it as potential for optimisation? It
seems that if the supplicant listens to the event and/or EAPOL frame (as
discussed above) then there's not really any need to explicitly enable
this feature.

In fact, even if it is explicitly enabled the device may still decide
not to do it, so I'm not sure what that really buys us?

>    5. Immediately, the supplicant gets a cfg80211_authorization_event
>       with success status, indicating that the key management has been
>       done by the device.  The supplicant enters "authorized" state for
>       the connection and allows transmission and reception of data
>       frames on the network.  Here, during roaming, the key management
>       was offloaded to the device and did not need to be handled by the
>       supplicant.

I assume the device is also going to enable the port, so setting the
port control would not be done by the supplicant? This would presumably
be visible in "iw wlan0 station dump" (or whatever)

> + * @psk:  The Preshared Key to be used for the connection.
> + *	(only valid if ASSOC_REQ_OFFLOAD_KEY_MGMT is set)
>   */
>  struct cfg80211_connect_params {
>  	struct ieee80211_channel *channel;
> @@ -1767,6 +1773,7 @@ struct cfg80211_connect_params {
>  	struct ieee80211_ht_cap ht_capa_mask;
>  	struct ieee80211_vht_cap vht_capa;
>  	struct ieee80211_vht_cap vht_capa_mask;
> +	const u8 *psk;

The length is implied?

>  enum wiphy_flags {
>  	/* use hole at 0 */
> @@ -2615,6 +2638,7 @@ enum wiphy_flags {
>  	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
>  	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
>  	WIPHY_FLAG_HAS_CHANNEL_SWITCH		= BIT(23),
> +	WIPHY_FLAG_HAS_KEY_MGMT_OFFLOAD		= BIT(24),

Wouldn't that make sense as an nl80211 feature flag directly?

> +	u32 key_mgmt_offload_support;
> +	u32 key_derive_offload_support;

or is it only used to control the appearance of these in nl80211?
(I guess I'll find out below)

> +/**
> + * enum nl80211_authorization_status - key management offload status
> + *
> + * Status of key management offload.  Provided as part of
> + * NL80211_CMD_AUTHORIZATION_EVENT.
> + *
> + * @NL80211_CONNECTED: Device did not successfully offload key
> + *	management.  Supplicant should expect to do the security
> + *	exchange necessary to establish the temporal keys for the
> + *	connection.

What I was thinking is that in this case you could just pass the EAPOL
frame (if it is otherwise swallowed) so you don't even need this whole
enum/attribute.

> +	[NL80211_ATTR_AUTHORIZATION_STATUS] = { .type = NLA_U8 },
> +	[NL80211_ATTR_KEY_REPLAY_CTR] = { .type = NLA_BINARY,
> +				   .len = NL80211_KEY_REPLAY_CTR_LEN },
> +	[NL80211_ATTR_PSK] = { .type = NLA_BINARY,
> +				   .len = NL80211_KEY_LEN_PSK },
> +	[NL80211_ATTR_OFFLOAD_KEY_MGMT] = { .type = NLA_FLAG },
> +	[NL80211_ATTR_KEY_MGMT_OFFLOAD_SUPPORT] = { .type = NLA_U32 },
> +	[NL80211_ATTR_KEY_DERIVE_OFFLOAD_SUPPORT] = { .type = NLA_U32 },
> +	[NL80211_ATTR_PMK] = { .type = NLA_BINARY,
> +				   .len = NL80211_KEY_LEN_PMK },

are all of these even input (to the kernel?) we don't usually list the
output-only ones, though obviously it doesn't hurt, but they all should
be documented in the header file too

>  /* policy for the key attributes */
> @@ -1293,6 +1303,13 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
>  		if ((rdev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP) &&
>  		    nla_put_flag(msg, NL80211_ATTR_TDLS_EXTERNAL_SETUP))
>  			goto nla_put_failure;
> +		if ((dev->wiphy.flags & WIPHY_FLAG_HAS_KEY_MGMT_OFFLOAD) &&
> +		    (nla_put_u32(msg, NL80211_ATTR_KEY_MGMT_OFFLOAD_SUPPORT,
> +				 dev->wiphy.key_mgmt_offload_support) ||
> +		     nla_put_u32(msg, NL80211_ATTR_KEY_DERIVE_OFFLOAD_SUPPORT,
> +				 dev->wiphy.key_derive_offload_support)))
> +			goto nla_put_failure;

Ok so you're using the flag here - that's reasonable.

>  		state->split_start++;
>  		if (state->split)
>  			break;
> @@ -7191,6 +7208,12 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
>  		       sizeof(connect.vht_capa));
>  	}
>  
> +	if (nla_get_flag(info->attrs[NL80211_ATTR_OFFLOAD_KEY_MGMT]))
> +		connect.flags |= ASSOC_REQ_OFFLOAD_KEY_MGMT;
> +
> +	if (info->attrs[NL80211_ATTR_PSK])
> +		connect.psk = nla_data(info->attrs[NL80211_ATTR_PSK]);

Would it make sense to only do the latter if the former is true?

> +static int nl80211_key_mgmt_set_pmk(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct net_device *dev = info->user_ptr[1];
> +	u8 *pmk;
> +
> +	if (info->attrs[NL80211_ATTR_PMK])
> +		pmk = nla_data(info->attrs[NL80211_ATTR_PMK]);
> +	else
> +		return -EINVAL;
> +
> +	if (!rdev->ops->key_mgmt_set_pmk)
> +		return -EOPNOTSUPP;
> +
> +	return rdev_key_mgmt_set_pmk(rdev, dev, pmk);
> +}

Should this check that the network is connected or something? Maybe not
really needed?

Well, overall, looks reasonable. :-)

johannes

