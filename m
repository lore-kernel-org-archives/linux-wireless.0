Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5F835FF58;
	Tue, 13 Oct 2026 13:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791899738; cv=none; b=GlMWRtzjdl31Rhw8BHX0vrt2V1l2sX2Up6FIYKADTnXkG8J0Gpa8uGr2EhJKUR5os+NliOQPC65+j9Cu4rarF1/cnt7qezTybXEw0qMHsQdmmNVwubDrBdq6U3WEDp4XU+B4JadNKYd5Ue7GKcKktPDuyP4o4bsHo/G12vn+/6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791899738; c=relaxed/simple;
	bh=tSNHSqvQs1HNuMGiTEwyVR3bH3c2RazL9IaBxJzzD4s=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oJ85NC72mn77u54cc1EXH/JtasqbyhYeb5dt7HSunU376/prCWDtpo2wazO0sYLWLxnfyD+2suK/AP05ZQS9PwMrSn+J+7nOc3jtKicjaYTFEDl/YlpCegMfKK7u0eiPVu5R1zYVuE2pz4osxsoh4UnurYM11q8p+2nRwV1v66s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bR2pamVL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bR2pamVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373381F000FF;
	Tue, 13 Oct 2026 13:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791899736;
	bh=GeHLrZQpxoBTtl0Ik+mGgDnVq9bwLr039r+CkHRFz5Q=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bR2pamVLYJHgqnskcUhXpcf0nwiIMyqHajZYs7WRLf3rrLI9Rt2S4drahRf6dnIhw
	 D/kDQX4TQZzf6N+IUddIkv0DQDCRiy1OjcZcg0oIMV6Yq2gv5rNULyPa6tEKlrGQ64
	 9hzTITlNhtYv2kEHaoaLQfxA7BT2fMAiHhEbHRlvgjNYnhrVb/zzEbAZoHgAgXweks
	 Twxqrl/ayxKBer3RhXbtJB4ALlo6eIfofpDJXWKbfIwXFknILWx9o8YtPKlnmYCs2Y
	 QnrCEOzhkl6aMvBPTzpeRYLZaym0m/UxCNJxIFPuOQvD4/atPHd6Ti4yKzVbWHwzd9
	 WkXGp0VxZNvvQ==
Subject: Re: [PATCH] wifi: cfg80211: allow IR on a channel the wiphy already
 operates on
From: netdev-bot+sashiko@kernel.org
To: 1914018426@qq.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 johannes@sipsolutions.net, kuba@kernel.org
Date: Tue, 13 Oct 2026 13:55:35 +0000
Message-ID: <179189973572.434549.4673154130343153035@kernel.org>
In-Reply-To: <tencent_2B956CE56BB4DE6A4748896922E04666FD0A@qq.com>
References: <tencent_2B956CE56BB4DE6A4748896922E04666FD0A@qq.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 6 potential
issue(s) to consider.

Critical: 0 · High: 4 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The new same-channel exemption in cfg80211_ir_permissive_chan()
  (net/wireless/chan.c:1709-1725) returns true before two gates that…
- [High] The new loop in cfg80211_ir_permissive_chan() does not skip the
  wdev being validated and ignores the requested iftype.
- [High] The exemption compares only the 20 MHz control channel.
- [High] The exemption is justified by the station already radiating on
  the channel, but the dependent AP is never re-checked when that…
- [Medium] Adding `iftype != NL80211_IFTYPE_AP` to the whitelist in
  cfg80211_ir_permissive_chan() (chan.c:1735) lets plain AP interfaces…
- [Low] Several comments in net/wireless/chan.c no longer match what the
  code does.

--

wifi: cfg80211: allow IR on a channel the wiphy already operates on

This patch adds a same-channel exemption to cfg80211_ir_permissive_chan().
If any connected station or beaconing AP on the wiphy already operates on
the requested channel, IR is allowed, and this check runs before the
CONFIG_CFG80211_REG_RELAX_NO_IR / REGULATORY_ENABLE_RELAX_NO_IR gate. The
patch also adds NL80211_IFTYPE_AP to the relaxation iftype whitelist, so
hostapd can start an AP on the station's channel on LAR devices such as
iwlwifi.

> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> index 9183cd19dbdc4..a1f86b8735bb5 100644
> --- a/net/wireless/chan.c
> +++ b/net/wireless/chan.c
> @@ -1700,6 +1700,30 @@ static bool cfg80211_ir_permissive_chan(struct wiphy *wiphy,
>  
>  	lockdep_assert_held(&rdev->wiphy.mtx);
>  
> +	/*
> +	 * A channel the wiphy is already operating on (e.g. a station
> +	 * connection) is already being radiated on by this device; starting
> +	 * an AP on the very same channel adds nothing new from a regulatory
> +	 * point of view. Allow it regardless of the driver's relax opt-in.
> +	 */
> +	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
> +		struct ieee80211_channel *other_chan = NULL;
> +		unsigned int link_id;
> +
> +		for_each_valid_link(wdev, link_id) {
> +			if (wdev->iftype == NL80211_IFTYPE_STATION &&
> +			    wdev->links[link_id].client.current_bss)
> +				other_chan = wdev->links[link_id].client.current_bss->pub.channel;
> +			else if (wdev->iftype == NL80211_IFTYPE_AP &&
> +				 wdev->links[link_id].ap.beacon_interval)
> +				other_chan = wdev->links[link_id].ap.chandef.chan;

[Severity: High]
The wdev being validated is itself on rdev->wiphy.wdev_list. Won't a
beaconing AP always match its own ap.chandef.chan here?

If so, every relax = true re-check of a running AP on its own primary
channel returns true. cfg80211_reg_check_beaconing() then drops
IEEE80211_CHAN_NO_IR from prohibited_flags.

One path affected is regulatory re-validation:

reg_leave_invalid_chans_wk()
  reg_wdev_chan_valid()  (iftype = AP, chandef = ap.chandef, relax = true)
    cfg80211_reg_check_beaconing()
      cfg80211_ir_permissive_chan()  -> matches itself, returns true

Suppose the AP's channel becomes NO_IR after a country IE, a user hint, a
LAR update, or clearing the indoor setting. Would cfg80211_leave_locked()
then never be called for this AP?

The same self-approval seems to apply in two more places:

  - __nl80211_set_channel(), for a beaconing AP that keeps its primary
    channel
  - the "recheck beaconing is permitted with possibly changed power type"
    check in nl80211_set_beacon()

For example, a 6 GHz AP started as VLP on a NO_IR channel is only allowed
there through IEEE80211_CHAN_ALLOW_6GHZ_VLP_AP. Could it then switch its
beacon to LPI or SP?

None of this needs a station or a second interface. It also runs before
the opt-in gate, so it affects every driver and every build.

[Severity: High]
The exemption is justified by the station already radiating on the
channel. What happens to an AP started this way after that station
disconnects?

__cfg80211_disconnected() calls cfg80211_schedule_channels_check(), but
that only schedules a re-check for some drivers:

net/wireless/nl80211.c:cfg80211_schedule_channels_check() {
    ...
	if (wdev->iftype == NL80211_IFTYPE_STATION &&
	    (wiphy_ext_feature_isset(wiphy,
				     NL80211_EXT_FEATURE_DFS_CONCURRENT) ||
	    (IS_ENABLED(CONFIG_CFG80211_REG_RELAX_NO_IR) &&
	     wiphy->regulatory_flags & REGULATORY_ENABLE_RELAX_NO_IR)))
		reg_check_channels();
}

For the drivers this exemption newly covers, no re-check runs. When a
re-check does run, the AP validates against itself, as described above.
Could the AP then keep beaconing on the NO_IR channel with no authorized
master?

This branch also makes any beaconing AP an anchor for any requested
iftype. Could more APs, P2P GOs or TDLS off-channel links then be chained
onto the channel?

The existing cfg80211_ir_permissive_check_wdev() only allows a GO to
anchor another GO. It guards that case with !INDOOR_ONLY, and its comment
says this is because the station relied on may have disconnected:

	if (iftype == NL80211_IFTYPE_P2P_GO &&
	    wdev->iftype == NL80211_IFTYPE_P2P_GO &&
	    wdev->links[link_id].ap.beacon_interval &&
	    !(chan->flags & IEEE80211_CHAN_INDOOR_ONLY))

Should the new AP anchor have a similar restriction?

Also, this loop ignores P2P_CLIENT and P2P_GO. reg_wdev_chan_valid()
handles those together with STATION and AP.

> +
> +			if (other_chan == chan)
> +				return true;

[Severity: High]
Only the 20 MHz control channel is compared here. On a match,
cfg80211_reg_check_beaconing() drops IEEE80211_CHAN_NO_IR for the whole
chandef:

	return _cfg80211_reg_can_beacon(wiphy, chandef, cfg->iftype,
					check_no_ir ? IEEE80211_CHAN_NO_IR : 0,
					permitting_flags);

_cfg80211_chandef_usable() then checks every subchannel against that
reduced mask.

Take a station associated at 20 MHz on channel 36. Hostapd then starts an
80 MHz AP on 36-48, where 40, 44 and 48 are NO_IR. Wouldn't all of those
subchannels pass?

An existing AP could also widen itself through __nl80211_set_channel().
That function only requires chandef.chan == cur_chan, and the AP then
matches itself here.

This early return also comes before the IEEE80211_CHAN_IR_CONCURRENT and
regulatory_indoor_allowed() checks. Does it then apply in these cases too?

  - wiphys with a fully known regdomain
  - NO_IR plus INDOOR_ONLY channels without an indoor declaration
  - 6 GHz channels where NO_IR means AP operation is not allowed for this
    device

The commit message says:

  Meanwhile starting an AP on the exact channel the wiphy is already
  operating a station connection on adds nothing new from a regulatory
  point of view: the device is already initiating radiation there.

Does that premise hold? A station transmits under the control of its
master, but an AP is itself the master. At wider widths it also occupies
channels the station never used.

> +			other_chan = NULL;
> +		}
> +	}
> +
>  	if (!IS_ENABLED(CONFIG_CFG80211_REG_RELAX_NO_IR) ||
>  	    !(wiphy->regulatory_flags & REGULATORY_ENABLE_RELAX_NO_IR))
>  		return false;

[Severity: High]
The new loop returns true before this gate and before the iftype
whitelist. Doesn't that make NO_IR relaxation unconditional for every
kernel build, every driver and every iftype?

Before this patch, a kernel built without CONFIG_CFG80211_REG_RELAX_NO_IR
always returned false here. The Kconfig help for that option says:

  - it depends on CFG80211_CERTIFICATION_ONUS and is not enabled by
    default
  - relaxations apply only to drivers that declare support
  - a GO started due to the relaxation should not allow connections from
    non P2P clients

With the new loop, hostapd can start an AP on a NO_IR channel as soon as
a station is associated there (passive association is allowed):

nl80211_start_ap()  (relax = true)
  cfg80211_reg_check_beaconing()
    cfg80211_ir_permissive_chan()
      -> new loop matches current_bss->pub.channel, returns true
    _cfg80211_reg_can_beacon(..., prohibited_flags = 0, ...)

The iftype whitelist is skipped as well. reg_wdev_chan_valid() re-checks
ADHOC and MESH_POINT with relax = true, so those would also get NO_IR
waived when they share a channel with a station or AP.

Separately, the commit message says:

  - cfg80211_ir_permissive_chan() gates on the driver opting in via
    REGULATORY_ENABLE_RELAX_NO_IR (iwlwifi does not), and its iftype
    whitelist covers P2P-GO/STATION/P2P-CLIENT but not AP;

Is that accurate? Both iwlwifi op-modes appear to set the flag:

drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c:iwl_mvm_mac_setup_register() {
    ...
	hw->wiphy->regulatory_flags |= REGULATORY_ENABLE_RELAX_NO_IR;
    ...
}

drivers/net/wireless/intel/iwlwifi/mld/mld.c:
	wiphy->regulatory_flags |= REGULATORY_ENABLE_RELAX_NO_IR;

So on the test device, the gate that blocked the AP seems to be the
Kconfig option. The commit message doesn't say that the patch bypasses
it.

> @@ -1707,7 +1731,8 @@ static bool cfg80211_ir_permissive_chan(struct wiphy *wiphy,
>  	/* only valid for GO and TDLS off-channel (station/p2p-CL) */

[Severity: Low]
This isn't a bug, but this comment no longer matches the whitelist
below, which now includes NL80211_IFTYPE_AP.

A few other comments in net/wireless/chan.c look stale too:

  - The header comment of cfg80211_ir_permissive_chan() only describes
    the IR_CONCURRENT plus associated station rule and the indoor rule.
    The new early return needs neither.
  - The new block's comment talks about starting an AP, but the loop
    never reads iftype.
  - The comment in cfg80211_reg_check_beaconing() still says only a
    GO/STA can IR on NO_IR channels, and only when such relaxations are
    enabled.

>  	if (iftype != NL80211_IFTYPE_P2P_GO &&
>  	    iftype != NL80211_IFTYPE_STATION &&
> -	    iftype != NL80211_IFTYPE_P2P_CLIENT)
> +	    iftype != NL80211_IFTYPE_P2P_CLIENT &&
> +	    iftype != NL80211_IFTYPE_AP)
>  		return false;

[Severity: Medium]
Does adding NL80211_IFTYPE_AP here conflict with the uAPI documentation
for NL80211_FREQUENCY_ATTR_IR_CONCURRENT?

include/uapi/linux/nl80211.h:
 *	the guidance of an authorized master, i.e., setting up a GO or TDLS
 *	off-channel while the device is also connected to an AP with DFS and
 *	radar detection on the UNII band (it is up to user-space, i.e.,
 *	wpa_supplicant to perform the required verifications). Using this
 *	attribute for IR is disallowed for master interfaces (IBSS, AP).

IEEE80211_CHAN_IR_CONCURRENT takes its meaning from that attribute. With
AP in the whitelist, cfg80211_ir_permissive_check_wdev() returns true for
an AP when a station is connected on the same channel or in the same UNII
band.

This change also opens the indoor branch to AP:

	if (regulatory_indoor_allowed() &&
	    (chan->flags & IEEE80211_CHAN_INDOOR_ONLY))
		return true;

Through nl80211_start_ap() (relax = true), that seems to allow a
standalone AP on NO_IR plus INDOOR_ONLY channels, with no station
connected at the same time.

The commit message only describes the IR_CONCURRENT case. Was the indoor
expansion intended?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/tencent_2B956CE56BB4DE6A4748896922E04666FD0A%40qq.com
