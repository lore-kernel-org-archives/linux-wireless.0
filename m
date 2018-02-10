Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39388 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750832AbeBJKcX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Feb 2018 05:32:23 -0500
Date: Sat, 10 Feb 2018 12:32:17 +0200
From: Jouni Malinen <jouni@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Srinivas Dasari <dasaris@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ieee80211: Increase the PMK maximum length to 64 bytes
Message-ID: <20180210103217.GA12147@jouni.qca.qualcomm.com> (sfid-20180210_113228_902461_AD331EE5)
References: <1518020451-8743-1-git-send-email-dasaris@codeaurora.org>
 <5A7B54E9.8070805@broadcom.com>
 <1518034894.3124.9.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1518034894.3124.9.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 07, 2018 at 09:21:34PM +0100, Johannes Berg wrote:
> On Wed, 2018-02-07 at 20:35 +0100, Arend van Spriel wrote:
> > On 2/7/2018 5:20 PM, Srinivas Dasari wrote:
> > > This is needed to cover the case of DPP with the NIST P-521 and
> > > brainpoolP512r1 curves which derive a PMK that is longer than the
> > > previously used limit.
> > 
> > So how are driver supposed to deal with this longer PMK. Maybe if you 
> > could elaborate on what DPP stands for in this context it would become 
> > more clear. 
> 
> device provisioning protocol, I guess? But longer curves and longer PMK
> is kinda obvious, whichever way that ends up getting used.

Yes, that's what DPP stands for here. With those two curves, the PMK
will be 64 octets.

> > Can we stick with PMK_MAX_LEN or does it need to be more 
> > fine-grained per use-case? If existing drivers only support 48 bytes PMK 
> > and trust nl80211 code to check that limit it may screw them up. Not?
> 
> Yeah I'm concerned about this too - and regardless of that issue, we
> probably need those drivers that do support it to advertise support for
> the new curves, and then allow the longer PMK length only for those that do?

Please note that some drivers may not support even the current
PMK_MAX_LEN (48) value. In fact, most of the cfg80211 cases using
NL80211_ATTR_PMK are separately enforcing shorter lengths (32 or that
48), so this change in PMK_MAX_LEN definition does not actually have any
impact for many of the existing cases. The only place where it does make
a difference is NL80211_CMD_SET_PMKSA and NL80211_ATTR_PMK was added for
that command with FILS authentication in mind in the first place (and
that would not get a 64 octet value from wpa_supplicant at least).

It turns out that there are no known use of PMK with DPP authentication
at the moment in any driver, so for now, I think I'll just make
wpa_supplicant skip addition of the NL80211_ATTR_PMK if the PMK is
longer than 48 octets. This should take care of the most immediate need,
but it would be good to prepare for the possibility of there being a
driver/firmware that would like to offload roaming and 4-way handshake
with DPP APs and do that using this PMK value from DPP network
introduction rather than offloading network introduction. For that to
work, PMK_MAX_LEN needs to be increased.

So DPP works just fine with most drivers even with the 64 octet PMK (as
long as that wpa_supplicant change goes in) when there is no requirement
of offloading 4-way handshake.

As far as driver support for various PMK lengths is concerned, how
should that be advertised? The limits can be different for each
particular use of NL80211_ATTR_PMK (NL80211_CMD_CONNECT,
NL80211_CMD_ASSOCIATE, NL80211_START_AP, NL80211_CMD_SET_PMKSA (for
FILS), NL80211_CMD_SET_PMKSA (for DPP), NL80211_CMD_SET_PMKSA (for
something else), NL80211_CMD_SET_PMK).

-- 
Jouni Malinen                                            PGP id EFC895FA
