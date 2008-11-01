Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:49948 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbYKAQau (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 12:30:50 -0400
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Subject: Re: Michael MIC failures in AP mode?
References: <87wsfnldq9.fsf@nokia.com> <20081101151938.GA4857@jm.kir.nu>
	<1225554697.3619.13.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sat, 01 Nov 2008 18:30:34 +0200
In-Reply-To: <1225554697.3619.13.camel@johannes.berg> (ext Johannes Berg's message of "Sat\, 01 Nov 2008 16\:51\:37 +0100")
Message-ID: <87od0zl87p.fsf@nokia.com> (sfid-20081101_173054_908817_EF9C5965)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sat, 2008-11-01 at 17:19 +0200, Jouni Malinen wrote:
>
>> Anyway, if you just want to test Michael MIC error processing on a
>> client, force mac80211 to do software encryption
>
> On that matter, should we put a debugfs control knob in place to
> completely disable HW encryption in mac80211, so we don't need this
> override in all drivers?

I think there's a need for this and we should do it. Just look at this
commit from earlier this week:

commit 05e6eb6f607cc3623c50b2a7c62b29ba6707a316
Author: Bob Copeland <me@bobcopeland.com>
Date:   Wed Oct 29 08:30:54 2008 -0400

    ath5k: enable hardware encryption for WEP
    
    This change re-enables hardware encryption for ath5k after setting up
    mac80211 to handle the initialization vectors which happens to make it
    work.  Add a module param (nohwcrypt) to optionally turn it off.
    
    Signed-off-by: Bob Copeland <me@bobcopeland.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Having a support in mac80211 would make it easier both for the driver
developers and users.

-- 
Kalle Valo
