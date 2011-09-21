Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:38899 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab1IURBi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 13:01:38 -0400
Message-ID: <4E7A1868.1040401@adurom.com> (sfid-20110921_190159_837144_70FEC14A)
Date: Wed, 21 Sep 2011 20:01:28 +0300
From: Kalle Valo <kvalo@adurom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: client powersave is completely broken on ath9k and similar HW
References: <1316623059.3940.54.camel@jlt3.sipsolutions.net>
In-Reply-To: <1316623059.3940.54.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2011 07:37 PM, Johannes Berg wrote:
> iwconfig wlan0 power timeout 0
> iwconfig wlan0 power off
> iwconfig wlan0 power on
> 
> => observe that power saving stays disabled forever
> 
> Last little bit of http://paste.pocoo.org/raw/479987/ seems to make it
> work somewhat, but is then still completely broken when timeout is >0
> due to the abuse of the dynps timer/work to process tx status:
> 
> Clearly this is completely messed up. Somebody is going to need to pay
> back all the technical debt accumulated here and rewrite it all.

I think we should just remove the client PS support from mac8011 and
drivers instead should implement power save on their own. The current
setup simply don't work.

My reasoning:

1) all power save implementations in hardware are a bit different, which
makes mac80211 implementation complex (how many different designs do we
support now, three or four?)

2) Driver authors care only about their driver and the bugs they are
trying to fix with zero interest how it might affect other drivers. They
dump something to mac80211 and then the change is forgotten.

3) Power save bugs are difficult to notice, test and debug. So
regressions are easily missed.

4) If the power save support is implemented in the driver, they can't
break other drivers and are free to do whatever optimisations/fixes they
want.

I'm happy to create a patch to remove client PS code from mac80211 if we
so decide.

Kalle
