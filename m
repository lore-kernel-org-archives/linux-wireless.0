Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:49887 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab0FQG1T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 02:27:19 -0400
To: Sebastian Smolorz <Sebastian.Smolorz@gmx.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [RFC] Changes in mac80211 to make at76c50x-usb working again
References: <201006151416.36686.Sebastian.Smolorz@gmx.de>
	<1276609006.3648.233.camel@jlt3.sipsolutions.net>
	<AANLkTinHK_MbKZd9HUDoiWuWs5AmDOQiza0poofzYeDn@mail.gmail.com>
	<201006160946.54197.Sebastian.Smolorz@gmx.de>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 17 Jun 2010 09:27:16 +0300
In-Reply-To: <201006160946.54197.Sebastian.Smolorz@gmx.de> (Sebastian Smolorz's message of "Wed\, 16 Jun 2010 09\:46\:54 +0200")
Message-ID: <87typ2fa2j.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sebastian Smolorz <Sebastian.Smolorz@gmx.de> writes:

> Kalle Valo wrote:
>
>> I debugged this a long time ago. The problem is that firmware's
>> CMD_JOIN only works if bssid is correct one. I remember trying
>> ff:ff:ff:ff:ff:ff, but that didn't work for some reason. The join
>> command needs to be sent before association, otherwise transmission
>> won't work at all. And if I use a random bssid the firmware will
>> filter the replies. But I tested this a long time ago, I might
>> remember something wrong.
>> 
>> I was thinking a hack which would get bssid from association frames
>> and then send CMD_JOIN, before the association frame.
>
> Could you elaborate a little bit on this?

Basically my idea is this (all in tx path):

1. if tx frame is an association frame, get bssid from the frame
2. if bssid == priv->bssid, goto step 6
3. store tx frame, don't transmit it yet
4. send CMD_JOIN with new bssid
5. wait for command completion
6. priv->bssid = bssid
7. transmit tx frame
8. done

Ugly as hell, but one option to get the driver working again.

> How do we proceed to make the driver working again? Do you want to work on 
> this issue?

Sorry, currently I only have time to review patches and send comments.
If you have the time, it would be great to if you could fix the driver
finally.

-- 
Kalle Valo
