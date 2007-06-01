Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:61954 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761881AbXFAQAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 12:00:00 -0400
Message-ID: <46604279.3070908@lwfinger.net>
Date: Fri, 01 Jun 2007 10:59:53 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Joe Jezak <josejx@gentoo.org>, Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH] softmac: use list_for_each_entry
References: <20070527142740.GB13105@APFDCB5C> <1180643064.18266.2.camel@johannes.berg>
In-Reply-To: <1180643064.18266.2.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

Johannes Berg wrote:
> On Sun, 2007-05-27 at 23:27 +0900, Akinobu Mita wrote:
>> Cleanup using list_for_each_entry.
> 
>> This patch adds missing NULL check and trims a line longer than 80
>> columns.
> 
> Both patches look good to me but I do wonder why you're actually looking
> at this code :)
> 
> I sure hope somebody will port bcm43xx driver to mac80211 (again) soon
> so we can remove softmac.

As it is impossible to predict how long until we can remove softmac, such patches should be 
accepted. You understand that I'm not looking for problems in softmac.

As we discussed earlier, bcm43xx-softmac has to be ported to mac80211 to support 802.11b-only cards, 
as the V4 firmware does not accommodate them. I had started this project by changing the namespace 
to bcm4301. That patch went into Linville's wireless-dev pending list. I then started learning the 
interface to mac80211. For a number of reasons, that step was going slowly. Michael Wu recently 
offered to take over, which seemed reasonable given his familiarity with mac80211.

When Michael Wu gets a version of bcm4301-mac80211 that compiles cleanly, I will be testing it as he 
doesn't have the hardware. For my testing purposes, the 802.11g stuff will still be there. Once I 
get it working, I plan to post a patch to get as much testing as possible.

In the earlier discussion, we also concluded that the product of a conversion from softmac to 
mac80211 should not be included in mainline, with the exception of the b-only code. Depending on how 
long the port and testing take, and the state of bcm43xx-mac80211 at that time, a reversal of that 
earlier decision may be in order.

Larry
