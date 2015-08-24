Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33375 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbbHXQPH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2015 12:15:07 -0400
Message-ID: <1440432904.3735.21.camel@sipsolutions.net> (sfid-20150824_181512_064944_1CECC0A8)
Subject: Re: mac80211: When adding a new station, notify driver before
 adding to hash
From: Johannes Berg <johannes@sipsolutions.net>
To: Marty Faltesek <mfaltesek@google.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 24 Aug 2015 18:15:04 +0200
In-Reply-To: <CAOiWkA95hm3LWwNt3EP1-OESjx775BC8YAznwy48XorSERuiew@mail.gmail.com> (sfid-20150824_181245_283521_DCA76F0C)
References: <CAOiWkA9iotcGij6wNeCUw+2iSfvWZGH+=vv_R2bwuDp92aXukw@mail.gmail.com>
	 <1440143840.2107.2.camel@sipsolutions.net>
	 <1440143920.2107.3.camel@sipsolutions.net>
	 <CAOiWkA-rNVHiVZo5oSuEOk_o6ioPzfpd0qzw_QsekRSHQ1EeEw@mail.gmail.com>
	 <1440419912.3735.16.camel@sipsolutions.net>
	 <CAOiWkA95hm3LWwNt3EP1-OESjx775BC8YAznwy48XorSERuiew@mail.gmail.com>
	 (sfid-20150824_181245_283521_DCA76F0C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-08-24 at 12:12 -0400, Marty Faltesek wrote:
> Yes, that would address the issue in a simple way. Would this be
> applicable to any of the other ops vectors? I will create a patch.
> 

Possible, we'll have to check which ones are possible to get at from
the RX (and possibly TX?) paths.

Another option could be to prevent looking up the station until it's
actually uploaded? But that might also cause the other races to happen
again, I suppose.

johannes
