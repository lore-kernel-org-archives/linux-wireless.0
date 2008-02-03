Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:34935 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbYBCLWB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 06:22:01 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1549454fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 03:21:59 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] wireless: Fix WARN_ON() with ieee802.11b
Date: Sun, 3 Feb 2008 12:21:27 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200802022353.10286.IvDoorn@gmail.com> <1202034082.4188.116.camel@johannes.berg>
In-Reply-To: <1202034082.4188.116.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200802031221.28432.IvDoorn@gmail.com> (sfid-20080203_112207_638316_D5097486)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 03 February 2008, Johannes Berg wrote:
> 
> > When the driver registers a IEEE80211_BAND_2GHZ band,
> > it can either be 802.11b or 802.11g. But when 802.11b rates
> > are registered "want" will be 3 (since 4 rates are being registered,
> > and each of those 4 rates will decrease "want").
> 
> Huh, yeah, you're right, this is a thinko.
> 
> > -		WARN_ON(want != 0 && want != 6);
> > +		WARN_ON(want != 0 && want != 3 && want != 6);
> 
> However, I think it should just be
> 
> 		WARN_ON(want != 0 && want != 3);
> 
> 6 just doesn't make sense, does it?

Well from your code it seemed that you only made 1Mbit mandatory for
802.11b. So if you want to make all b rates mandatory then the 6 check should
indeed be removed.
But shouldn't the 2Mbit, 5.5Mbit and 11Mbit set as IEEE80211_RATE_MANDATORY_B
as well?

Ivo
