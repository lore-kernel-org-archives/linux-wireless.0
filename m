Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45259 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbbGBIjA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 04:39:00 -0400
Message-ID: <1435826335.2285.6.camel@sipsolutions.net> (sfid-20150702_103904_992495_C206EC09)
Subject: Re: Association race when acting as AP?
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Date: Thu, 02 Jul 2015 10:38:55 +0200
In-Reply-To: <CA+BoTQm==AM3F2Fxq6T_+uY+jq0yXc9JHFT0iwpe2XJrmxkSsg@mail.gmail.com>
References: <CA+BoTQm==AM3F2Fxq6T_+uY+jq0yXc9JHFT0iwpe2XJrmxkSsg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[please try to send w/o html if you're CC'ing the linux-wireless list]

> To me this looks like a race in hostapd. The station should be 
> installed to driver _before_ sending Assoc Resp frame, not after. My 
> quick-n-dirty hack seems to help:
> 
[...]
> Is anyone aware of this problem already? Anyone working on it? Any 
> gotchas I should be aware of before I go into fixing this in a proper 
> way? Or am I missing something and this isn't actually a problem?

The TI folks had a similar patch that broke open networks, not sure
what was wrong there.

Ultimately, depending on the nl80211 capabilities, the station should
in fact be added (as unauthenticated) before even sending the
authentication response frame, and then stepping through the stages
appropriately.

It should also react to errors by sending a negative association
response I guess.

johannes
