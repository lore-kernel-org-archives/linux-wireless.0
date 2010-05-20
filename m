Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:6041 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752942Ab0ETAfs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 20:35:48 -0400
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0900595745
	for <linux-wireless@vger.kernel.org>; Thu, 20 May 2010 09:35:47 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH v2 13/20] cfg80211: Add nl80211 antenna configuration
Date: Thu, 20 May 2010 09:35:40 +0900
References: <20100519012528.22206.77550.stgit@tt-desk> <20100519013147.22206.71360.stgit@tt-desk> <AANLkTikgyTZptw5CGu8MFinkqlXeqEJMJixdckb89aFc@mail.gmail.com>
In-Reply-To: <AANLkTikgyTZptw5CGu8MFinkqlXeqEJMJixdckb89aFc@mail.gmail.com>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201005200935.40377.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 20 May 2010 02:07:25 you wrote:
> On Tue, May 18, 2010 at 6:31 PM, Bruno Randolf <br1@einfach.org> wrote:
> > + * @NL80211_ATTR_ANTENNA_TX: Bitmap of antennas to use for transmitting.
> > + * @NL80211_ATTR_ANTENNA_RX: Bitmap of antennas to use for receiving.
>
> This gets the job done, but that's it. The API defined allows for a
> hugely loose implementation on each driver.

i tried to define it like this, in the commit log:

    The antenna configuration is defined as a bitmap of allowed antennas. This
    bitmap is 8 bit at the moment, each bit representing one antenna. If   
    multiple antennas are selected, the driver may use diversity for receive
    and transmit.

is this not precise enough? i am mostly concerned with what i believe is the 
most common usecase (selecting one fixed antenna, or antenna diversity). i'd 
say this is 99% of all use cases. but this API would also allow us to define 
more advanved things like 'transmit on antenna 1, receive on antenna 2". i 
know that there are possibly more crazy (and very rare) configurations, like 
use several panel antennas + omni, which can't be configured with this API, 
but it's hard to find a common API for all possibilities, and i think it would 
be possible to extend the API later on for such cases.

> And yet for another driver it could be something completely different
> in usersepace. 

what do you think that could be, realistically, given the above definition?

> I think it would be better for us to define a static
> API for all legacy cards and another for 802.11n cards, or unify them
> but to be very specific about the API for antenna settings/chainmask
> settings.

sure. any suggestions?

bruno
