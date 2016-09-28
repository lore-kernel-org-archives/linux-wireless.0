Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58021 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754268AbcI1V53 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 17:57:29 -0400
Message-ID: <1475099847.21839.0.camel@sipsolutions.net> (sfid-20160928_235732_130416_3561E6F7)
Subject: Re: [PATCH 6/6] cfg80211: reduce connect key caching struct size
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 28 Sep 2016 23:57:27 +0200
In-Reply-To: <20160928205855.GA27770@w1.fi>
References: <1473777868-32429-1-git-send-email-johannes@sipsolutions.net>
         <1473777868-32429-6-git-send-email-johannes@sipsolutions.net>
         <20160928205855.GA27770@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> >  struct cfg80211_cached_keys {
> > -	struct key_params params[6];
> > -	u8 data[6][WLAN_MAX_KEY_LEN];
> > -	int def, defmgmt;
> > +	struct key_params params[4];
> > +	u8 data[4][WLAN_KEY_LEN_WEP104];
> > +	int def;
> >  };
> 
> As noted in our irc discussion, this is not really a good thing to
> do.
> WEXT compat code uses this structure for all ciphers, not just static
> WEP keys. BIP configuration can use key index 4-5 and the key lengths
> can go up to 32 bytes instead of WLAN_KEY_LEN_WEP104. In other words,
> this patch should be dropped or reverted since it causes kernel
> panics due to memory corruption when writing beyond this reduced size
> structure.

Yeah, this was obviously a mistake - and smatch even pointed it out to
me, but I *still* couldn't find it.

I've just sent a fix to *really* only store the WEP keys, which fixes
the issue (after I could reproduce it) for me.

johannes
