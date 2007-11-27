Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:35609 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbXK0Dzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 22:55:39 -0500
Date: Mon, 26 Nov 2007 19:55:04 -0800
From: Jouni Malinen <j@w1.fi>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: mac80211: unencrypted packet vulnerability
Message-ID: <20071127035504.GE5698@jm.kir.nu> (sfid-20071127_035541_781887_F2614EBA)
References: <1195686097.6323.22.camel@johannes.berg> <1196091438.4202.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1196091438.4202.22.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 26, 2007 at 10:37:18AM -0500, Dan Williams wrote:
> On Thu, 2007-11-22 at 00:01 +0100, Johannes Berg wrote:
> > I'd offer the patch below but that's hardly complete. And then what
> > about wext's encode and IW_ENCODE_RESTRICTED? Isn't that exactly the
> > same thing? ieee80211 treats it that way and I can't find docs other
> > than this paragraph from iwconfig's man page

I'd guess it depends on who you ask.. For me, it was exactly this, but
I've certainly seen another functionality being claimed for it, i.e.,
this:

> IW_ENCODE_RESTRICTED is used in a few places to mean Shared Key auth
> mode, since there's no other way in WEXT to handle the difference
> between Shared Key and Open System, and because drivers usually don't
> (and really shouldn't) by trying to cycle between auth modes themselves.

There wasn't, but there is now. I added an explicit 802.11
authentication algorithm parameter (IW_AUTH_80211_AUTH_ALG) in WE-18 in
order to make it somewhat easier to push people away from misusing
IW_ENCOE_RESTRICTED.

-- 
Jouni Malinen                                            PGP id EFC895FA
