Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:37558 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZLHHg1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 02:36:27 -0500
Received: by ewy1 with SMTP id 1so2377835ewy.28
        for <linux-wireless@vger.kernel.org>; Mon, 07 Dec 2009 23:36:33 -0800 (PST)
To: Jason Andryuk <jandryuk@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: cfg80211 connect for at76c50x-usb
References: <c4d76b3b0912071955y25c31a11m104d9c4723ef578d@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 08 Dec 2009 09:36:31 +0200
In-Reply-To: <c4d76b3b0912071955y25c31a11m104d9c4723ef578d@mail.gmail.com> (Jason Andryuk's message of "Mon\, 7 Dec 2009 22\:55\:26 -0500")
Message-ID: <87ws0x3ojk.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

Hi Jason,

> I am unable to connect to my AP with at76c50x-usb.  I believe the
> cause is at76c50x-usb and mac80211 trying to send separate auth and
> assoc packets to an AP.  Unfortunately the packets for these commands,
> while sent over USB to the device, are not actually transmitted.  My
> understanding is prior to joining a network, packet transmission is
> block.  However, there is a USB command, CMD_JOIN, for connecting to
> wireless networks.

I actually think that the problem is because of missing bssid. I
recall that when I was, a long time ago, porting at76 to mac80211
CMD_JOIN didn't work unless I used the correct bssid. I tried to find
a workaround, for example all zeros or all 0xffs bssid, but no luck.
So I had to make an ugly hack that uses CMD_SCAN if the bssid is not
set and CMD_JOIN otherwise.

If you have the time, you could test my theory by hardcoding the bssid
for CMD_JOIN. Alternatively you could try Luciano Coelho's oper_bssid
patches from a month back.

-- 
Kalle Valo
