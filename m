Return-path: <linux-wireless-owner@vger.kernel.org>
Date: Wed, 5 Mar 2008 16:11:09 +0200
From: Jouni Malinen <j@w1.fi>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Fwd: Re: hostapd with mac80211 progress]
Message-ID: <20080305141109.GB8788@jm.kir.nu> (sfid-20080305_141850_226940_E2B1490B)
References: <1204680021.3087.132.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1204680021.3087.132.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 05, 2008 at 09:20:20AM +0800, Zhu Yi wrote:

> Does hostpad disable 5GHz channels intentionally? For regulation reason?

The hw_feature/channel selection code was originally using a regulatory
domain database within hostapd and that information was used to select
which channels are to be enabled. However, that code was never cleaned
up and not merged into the open source version.

I don't remember all the details anymore, but it looks like I just left
it to hardcoded 802.11g channels 1-11 only configuration. In other
words, yes, I would say that 5 GHz channels were disabled intentionally
for the time being. This will obviously need to be changed once more
suitable mechanism for regulatory domain information becomes available
(the TODO comment in the hostapd function that was mentioned in this
thread..).

-- 
Jouni Malinen                                            PGP id EFC895FA
