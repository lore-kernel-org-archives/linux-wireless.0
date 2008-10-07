Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39895 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbYJGRWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 13:22:38 -0400
Date: Tue, 7 Oct 2008 13:21:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chr <chunkeey@web.de>, Ivo van Doorn <ivdoorn@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Javier Cardona <javier@cozybit.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: Re: mac80211 driver API
Message-ID: <20081007172149.GA3287@tuxdriver.com> (sfid-20081007_192243_192422_64F0EF69)
References: <1223398885.7328.47.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223398885.7328.47.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 07, 2008 at 07:01:25PM +0200, Johannes Berg wrote:

> Another thing I noticed when looking at the short slot stuff is that a
> number of drivers do not use the use_short_preamble flag but also do not
> set IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE; this seems like a bug
> affecting at least b43legacy, ath5k, at76_usb, rtl8180, rtl8187.
> 
> You should review the mac80211 driver API for things you aren't using
> but should be using, this affects a number of drivers, for example
> adm8211, p54, stlc45xx, ath5k, ath9k, libertas_tf, rtl8180, rtl8187
> don't use radio_enabled; a number of drivers don't use power_level.
> 
> There are also still drivers (ath5k, adm8211, rtl8180, iwlwifi,
> libertas_tf, zd1211rw, mac80211_hwsim, ...?) not using the
> IEEE80211_TX_CTL_ASSIGN_SEQ flag, I can fix those since I broke them,
> but help from the authors would be appreciated since I don't know the hw
> in all cases, I know that stlc45xx for example can use a corresponding
> firmware flag for it.

Should we recruit janitor's (or gregkh's army) to help with stuff
like the above?

> Do we need a document that indicates which parts of the API must be
> implemented? Or should we mark such things in mac80211.h? Would
> something like this help? I've thrown this together quickly so it
> probably isn't complete yet...

<snip>

Looks like a good start, and I would definitely value such a list.
Please continue to improve it, and we'll figure-out where it needs
to live in the long run.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
