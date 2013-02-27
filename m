Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414Ab3B0Mj3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 07:39:29 -0500
Message-ID: <1361968754.8172.6.camel@jlt4.sipsolutions.net> (sfid-20130227_133932_768868_C98F4834)
Subject: Re: [PATCH 3.9] rt2x00: error in configurations with mesh support
 disabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Date: Wed, 27 Feb 2013 13:39:14 +0100
In-Reply-To: <CAL1gcdO-SYTeXQhaGQgwE8=ZpK=S9YOnSuizR9WGCHA-X+7kyw@mail.gmail.com> (sfid-20130227_133725_662731_7731F824)
References: <1361891395-59990-1-git-send-email-nbd@openwrt.org>
	 <CAL1gcdO-SYTeXQhaGQgwE8=ZpK=S9YOnSuizR9WGCHA-X+7kyw@mail.gmail.com>
	 (sfid-20130227_133725_662731_7731F824)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-27 at 13:37 +0100, Gertjan van Wingerde wrote:
> Hi Felix,
> 
> On Tue, Feb 26, 2013 at 4:09 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> > If CONFIG_MAC80211_MESH is not set, cfg80211 will now allow advertising

typo: "will not allow"

> > interface combinations with NL80211_IFTYPE_MESH_POINT present.
> > Add appropriate ifdefs to avoid running into errors.
> 
> I'm not sure if rt2x00 is the proper place to fix this. To me it
> doesn't look good to have to sprinkle these kind of ifdefs throughout
> the drivers to check if mac80211 has mesh enabled.
> I would prefer a solution where drivers are still able to indicate
> that they support mesh interfaces, but where mac80211/cfg80211 prevent
> these kind of interfaces from being created.
> 
> @Johannes: What is your view on this?

It would be nicer, but the data is const so mac80211 can't modify it,
and I don't see that we should add a lot of code/handshaking to
mac80211/cfg80211 just to avoid one ifdef here.

johannes

