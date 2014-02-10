Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0186.hostedemail.com ([216.40.44.186]:47993 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751807AbaBJQjZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 11:39:25 -0500
Message-ID: <1392050359.2507.10.camel@joe-AO722> (sfid-20140210_173933_121998_355BBB2A)
Subject: Re: [PATCH] ieee80211: Print human-readable disassoc/deauth reason
 codes
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Calvin Owens <jcalvinowens@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 10 Feb 2014 08:39:19 -0800
In-Reply-To: <1392030546.4128.11.camel@jlt4.sipsolutions.net>
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
	 <1391661863.30094.56.camel@joe-AO722>
	 <1392030546.4128.11.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-02-10 at 12:09 +0100, Johannes Berg wrote:
> On Wed, 2014-02-05 at 20:44 -0800, Joe Perches wrote:
> 
> > Perhaps use a more common kernel style
> > 
> > struct ieee80211_reason_descriptions {
> > 	u16		code;
> > 	const char *	desc;
> > }
> > 
> > and enumerate the reason codes with #defines and use a
> > macro to populate the descriptions
> > 
> > #define IEEE80211_REASON_RESERVED		0
> > #define IEEE80211_REASON_UNSPECIFIED		1
[]
> Isn't it more efficient to just let the compiler generate it with a big
> switch() statement?

That'd be fine too.

The benefit of the #defines is that you typically
get an external .h file for the entries.

Calvin's suggested code looked pretty fragile.


