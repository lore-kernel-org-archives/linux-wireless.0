Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:55124 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042AbYERPOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 May 2008 11:14:51 -0400
Message-ID: <483047DD.2050205@lwfinger.net> (sfid-20080518_171455_514561_0D0F5E49)
Date: Sun, 18 May 2008 10:14:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Tomas Winkler <tomasw@gmail.com>, Helmut Schaa <hschaa@suse.de>,
	John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2] mac80211: fix NULL pointer dereference in	ieee80211_compatible_rates
References: <20080517203531.vus3gj5ce8ksskkc@imap.suse.de>	 <1ba2fa240805180337h35bc3244od619e78c0d95d895@mail.gmail.com> <1211117578.686.12.camel@localhost.localdomain>
In-Reply-To: <1211117578.686.12.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Sun, 2008-05-18 at 13:37 +0300, Tomas Winkler wrote:
>> Again, mac should rather solve the problem that we do not connect to
>> AP's that are not in the BSS list
>> Personally I would NACK this as it's just hiding  the real problem
> 
> Ugh; is that what's happening?  If the AP isn't in the BSS list of the
> card, then the card shouldn't be connecting to it.  It should have been
> probe-scanned already and thus exist in the BSS list, right?
> 
> Dan
> 
>> The other issue is that we call ieee80211_rx_bss_put(dev, bss); before
>> this call in ieee80211_send_assoc.

This AP certainly should have been in the BSS list. As I stated in the 
original post, the system had been connected to that AP for about 18 hours 
before the NULL bss NULL event occurred.

Clearly the sequence of events is improbable and it may be some time before 
it happens again. What diagnostic information would be useful to capture 
if/when it occurs? Is there any other location that I should monitor?

Larry
