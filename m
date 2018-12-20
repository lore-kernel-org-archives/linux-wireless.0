Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F3FC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 14:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FCF621720
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 14:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387506AbeLTOQe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 09:16:34 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:59924 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733282AbeLTOQd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 09:16:33 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gZz7n-0002JR-CW; Thu, 20 Dec 2018 15:16:31 +0100
Message-ID: <979af6feebca2ba26fffaeac5a94f230404a0ba6.camel@sipsolutions.net>
Subject: Re: [bug report] nl80211/cfg80211: add radar detection command/event
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        linux-wireless@vger.kernel.org
Date:   Thu, 20 Dec 2018 15:16:30 +0100
In-Reply-To: <20181220111726.GA19146@kadam> (sfid-20181220_121804_123496_0EB33570)
References: <20181220111726.GA19146@kadam>
         (sfid-20181220_121804_123496_0EB33570)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dan,

> The patch 04f39047af2a: "nl80211/cfg80211: add radar detection
> command/event" from Feb 8, 2013, leads to the following static
> checker warning:

Huh, that's kinda old :-)

I was wondering if it was surfaced by a recent station-side patch, but I
guess not.

> net/wireless/chan.c
>    242  static void cfg80211_set_chans_dfs_state(struct wiphy *wiphy, u32 center_freq,
>    243                                           u32 bandwidth,
>    244                                           enum nl80211_dfs_state dfs_state)
>    245  {
>    246          struct ieee80211_channel *c;
>    247          u32 freq;
>    248  
>    249          for (freq = center_freq - bandwidth/2 + 10;
>                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>    250               freq <= center_freq + bandwidth/2 - 10;
>                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[snip]

> This isn't really a big issue but center_freq comes from
> nla_get_u32(attrs[NL80211_ATTR_WIPHY_FREQ]) in nl80211_parse_chandef().
> Smatch is complaining that there is an issue with the math
> over/underflowing.  It just means that we loop for a long time.  It's
> not a security problem.  Even without the overflow, we could end up
> looping for a long time.
> 
> Is center_freq capped somewhere that I haven't seen?

I think so, but I'm not sure how you got here.

So we can only get to the code quoted above from
cfg80211_set_dfs_state(), which passes

        cfg80211_set_chans_dfs_state(wiphy, chandef->center_freq1,
                                     width, dfs_state);

or

        cfg80211_set_chans_dfs_state(wiphy, chandef->center_freq2,
                                     width, dfs_state);

It also checks cfg80211_chandef_valid() which limits the center_freq1
and 2 against each other, but that code might also have over- or under-
flows.

cfg80211_set_dfs_state() is called from

 * cfg80211_radar_event() - that should be OK, coming from driver code
 * regulatory_propagate_dfs_state() - also seems OK with kernel source
   of the data
 * nl80211_notify_radar_detection() which calls
   cfg80211_chandef_dfs_required() - that checks that the channel is
   actually advertised by a driver in some way, so you can't really get
   here with an invalid frequency afaict.

However, the way that cfg80211_chandef_dfs_required() checks is very
similar:

cfg80211_chandef_dfs_required()
-> cfg80211_get_chans_dfs_required(center_freq)
-> start_freq = center_freq - bandwidth/2 + 10;
   end_freq = center_freq + bandwidth/2 - 10;
   for (freq = start_freq; freq <= end_freq; freq += 20)



However, as you say we get center_freq from
nla_get_u32(attrs[NL80211_ATTR_WIPHY_FREQ]) in nl80211_parse_chandef().

In nl80211_parse_chandef() we have this code:

        control_freq = nla_get_u32(attrs[NL80211_ATTR_WIPHY_FREQ]);

        chandef->chan = ieee80211_get_channel(&rdev->wiphy, control_freq);


which requires that the control_freq (or center_freq later) is actually
a valid frequency that's advertised by the driver as a valid channel.
This of course will not be the case for things like 0 or 0xffffffff or
close to them.

However (again), we use center_freq1/center_freq2 as well - center_freq1
is validated against control_freq by cfg80211_chandef_valid(), but
center_freq2 isn't and cannot. For center_freq2, we just get to
cfg80211_secondary_chans_ok() eventually, which also contains:

        start_freq = cfg80211_get_start_freq(center_freq, bandwidth);
        end_freq = cfg80211_get_end_freq(center_freq, bandwidth);

        for (freq = start_freq; freq <= end_freq; freq += 20) {

and here it actually looks like we can get into overflow/underflow
issues.

I believe no driver actually supports 80+80MHz today so even this is
theoretical, but it makes sense to some semi-sane range, like

        [NL80211_ATTR_CENTER_FREQ2] = NLA_POLICY_RANGE(NLA_U32, 2000, 7000),

That will avoid the over/underflow issues and limit the iteration there
to the normal bandwidth-dependent, which is only 4 steps.

Need to check though if this actually ends up getting used for 60GHz
band, in which case we couldn't use NLA_POLICY_RANGE (it has s16 for
min/max for policy size reasons), but we could assign a validation
function instead and reject anything outside the range of e.g.
200..100000, as long as we avoid the over/underflow we don't really need
to worry about the exact range, right?

johannes

