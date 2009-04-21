Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:44997 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752660AbZDUUmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 16:42:07 -0400
Date: Tue, 21 Apr 2009 23:41:46 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>
Subject: Re: SME/MLME notes
Message-ID: <20090421204146.GA8325@jm.kir.nu> (sfid-20090421_224213_722618_CB681CD9)
References: <1239980203.32113.31.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1239980203.32113.31.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 17, 2009 at 04:56:43PM +0200, Johannes Berg wrote:

> 1) I think I've asked this before but don't remember the answer, why
>    does nl80211 not require an SSID for AUTH? It seems wpa_supplicant's
>    sme.c always requires an SSID, so we would always have one in the
>    kernel -- and it would seem to be easier to implement it all too.
>    Also, it seems very strange things might happen if the SSID isn't
>    passed and the kernel somehow knows, from a previous scan, about a
>    hidden SSID that was unwanted, but now gets selected?! Can we just
>    require the SSID?
>    I know technically we don't need it, we could auth with multi-SSID
>    network's AP and only at assoc time select the SSID, but ...

wpa_supplicant happens to know the SSID at that point and adding SSID to
authentication data helped in implementing some steps for
authentication. Since SSID is not strictly speaking required for
authentication, I did not make it a required attribute. However, I do
not have anything against making this attribute required for
authentication (maybe with a suitable note in nl80211.h indicating why
it is required since that may be somewhat surprising requirement for
someone familiar with the MLME primitives).

> 2) We need a way to query which AP(s) we're authenticated with -- we
>    should have association too but that you can get via the station
>    code. But for authentications we don't add any station structs. Or do
>    we not care and say that the SME needs to keep track?

I would say that SME should keep track of this regardless of whether we
internally have that information or not. As such, I would not consider
this mechanism essential (but sure, if we ever end up adding the STA
entry at this point, its authentication status should be available at
least in debugfs).

> 3) Related to 2), when we authenticate with two or more APs, but then go
>    to associate with one of them, which is possible to request in the
>    current API, we might never know, due to powersaving features,
>    whether the other APs deauthenticated us. Can we rely on the SME not
>    doing stupid things like that?

Which part here do you consider to be "stupid"? ;-) Authenticating with
multiple APs? I think it would be perfectly fine for the SME to try to
do this and the AP that deauthenticated the STA would just reply with a
deauthentication frame (which needs to be reported to the SME). Anyway,
I would expect a common implementation of SME to request authentication
just before the association in all cases even if a previous
authentication might exist.

> 4) When we try to authenticate while associated (FT-over-the-air), we
>    need to turn off powersaving, I think?

It depends on what exactly you mean with power saving.. Especially, if
we were to support FT resource reservation protocol at some point, it
would be reasonable to expect the STA to go to power save mode with the
current (old) AP prior to starting FT over-the-air with the target AP.
If the authentication (FT resource reservation) fails, the STA may still
continue to use the association with the old AP.

As far as power save state with the new AP is concerned, yes, we will
need to remain awake to receive the authentication frame from the AP.

> 5) Like 1) and the SSID, the SME always knows about the channel too;
>    should we also require that? Might make things simpler, and not
>    require scanning in the kernel?

Probably.

> 6) The sme.c code contains a TODO about timeout -- mac80211 gives up
>    authenticating when it doesn't get a reply to the frame after three
>    times. Should
>    a) those retries be configurable or at least discoverable, maybe
>       some devices do not support configuration, or maybe both?

I think I would be fine keeping this simple and just make this
automatically configured in the driver and not bother with making this
discoverable. Trying the same frame three times does not make much point
in most cases, i.e., one attempt (at least if a reply is received)
should be enough..

>    b) there be an event when reached?

Yes, that sounds like a good idea.

> 7) Your SME code never tries to use a different authentication algorithm
>    if the first one failed? Is that correct or could networks use LEAP
>    _or_ OPEN?

I did not yet implement proper handling for the case where multiple auth
algs are enabled. SME should interpret the non-zero status code and
figure otu that it need to try another authentication algorithm.

> 8) The associate command takes a channel -- is that required? It seems
>    that once you've authenticated you pretty much know that already, or
>    do we need the SSID/BSSID/Channel to uniquely determine the BSS? The
>    corresponding mac80211 code ignores it completely too.

Since SME has it, it was simple to just pass it in. I don't know whether
it would really ever be required. This is partly from the design where a
single connect request could be used (the alternative for supporting
drivers that do not support separate authentication and association
step) and it would be useful to have all the needed information
available.

> 9) Disassoc should check that we are associated, deauth is more
>    complicated because of multiple authentications, cf. 3), do we care
>    about auth?

Hmm.. There could be potential problems if the AP and STA get
out-of-sync on auth or assoc state and we prevent the SME from sending
out a deauthentication frame which could otherwise be used as a way to
clean up the state in the AP (until 802.11w comes into play ;-). I
wouldn't be concerned if we do not verify the state for deauthentication
(or even for disassociation, for that matter).

> 10) I would like the cfg80211 auth/assoc ops to take cfg80211_bss
>     structs. This requires having the SSID -- see 1). It would mean
>     cfg80211 could hold the BSS and keep a pointer, also fixing that
>     "hidden SSID scan result hold forever" issue. Also, it would mean
>     that cfg80211 has to issue a scan when it cannot find the BSS, but
>     that scan can be restricted to the SSID (and possibly the channel)

OK, sounds reasonable (and yes, please do restrict it to the channel,
too, if known ;-).

> 11) Since now cfg80211 keeps track of auth/assoc, we need a "I've given
>     up" call from the driver, cf. 6), so it can unhold the BSS struct.

Agreed.

> 12) Beacon updates could update all BSS structs we know about that have
>     the same BSSID (and channel?) -- also the one we're holding, just in
>     case we are connected to a hidden network. Not quite sure yet how to
>     do this though, the SSID might disappear then or something... Needs
>     more thought.

Signal strength should be updated for all entries with matching BSSID
and same probably for other radio parameters (WMM changes, HT, quiet
period, etc.). The parameters that are likely to be specific to an
SSID (security configuration like WPA/RSN IE) should not be updated if
there is not a matching SSID.

> 13) For WEXT, just do most things in cfg80211.
> 
> This would reduce mac80211's mlme to just filling and sending the
> frames, and filtering the responses, I think. And doing all the other
> stuff inbetween, of course.

Sounds reasonable.

-- 
Jouni Malinen                                            PGP id EFC895FA
