Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33966 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbeBJU0j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Feb 2018 15:26:39 -0500
Message-ID: <1518294396.2029.3.camel@sipsolutions.net> (sfid-20180210_212642_471056_A44C9050)
Subject: Re: [PATCH v2] ieee80211: Increase the PMK maximum length to 64
 bytes
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Srinivas Dasari <dasaris@codeaurora.org>,
        linux-wireless@vger.kernel.org
Date: Sat, 10 Feb 2018 21:26:36 +0100
In-Reply-To: <20180210103217.GA12147@jouni.qca.qualcomm.com>
References: <1518020451-8743-1-git-send-email-dasaris@codeaurora.org>
         <5A7B54E9.8070805@broadcom.com> <1518034894.3124.9.camel@sipsolutions.net>
         <20180210103217.GA12147@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-02-10 at 12:32 +0200, Jouni Malinen wrote:
> 
> > Yeah I'm concerned about this too - and regardless of that issue, we
> > probably need those drivers that do support it to advertise support for
> > the new curves, and then allow the longer PMK length only for those that do?
> 
> Please note that some drivers may not support even the current
> PMK_MAX_LEN (48) value. In fact, most of the cfg80211 cases using
> NL80211_ATTR_PMK are separately enforcing shorter lengths (32 or that
> 48), so this change in PMK_MAX_LEN definition does not actually have any
> impact for many of the existing cases. 

Ok. If the drivers are checking/don't care then we can deal without
extra feature bits or something, IMHO, at least with respect to this
specific issue of length checks.

> The only place where it does make
> a difference is NL80211_CMD_SET_PMKSA and NL80211_ATTR_PMK was added for
> that command with FILS authentication in mind in the first place (and
> that would not get a 64 octet value from wpa_supplicant at least).

Ok.

> It turns out that there are no known use of PMK with DPP authentication
> at the moment in any driver, so for now, I think I'll just make
> wpa_supplicant skip addition of the NL80211_ATTR_PMK if the PMK is
> longer than 48 octets. This should take care of the most immediate need,

Fair enough.

> but it would be good to prepare for the possibility of there being a
> driver/firmware that would like to offload roaming and 4-way handshake
> with DPP APs and do that using this PMK value from DPP network
> introduction rather than offloading network introduction. For that to
> work, PMK_MAX_LEN needs to be increased.

So let's do the patch anyway? I mean ... it's one patch or the other,
so doesn't really make a huge difference?

> So DPP works just fine with most drivers even with the 64 octet PMK (as
> long as that wpa_supplicant change goes in) when there is no requirement
> of offloading 4-way handshake.

Right.

> As far as driver support for various PMK lengths is concerned, how
> should that be advertised? The limits can be different for each
> particular use of NL80211_ATTR_PMK (NL80211_CMD_CONNECT,
> NL80211_CMD_ASSOCIATE, NL80211_START_AP, NL80211_CMD_SET_PMKSA (for
> FILS), NL80211_CMD_SET_PMKSA (for DPP), NL80211_CMD_SET_PMKSA (for
> something else), NL80211_CMD_SET_PMK).

Yeah, that seems somewhat problematic? Though I'd hope they're kinda
all the same limits?

Perhaps we rather need something like "DPP supported" vs. "long PMK
supported" since just "long PMK" doesn't really say anything about the
supported curves?

johannes
