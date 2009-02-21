Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:55845 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZBUH5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 02:57:53 -0500
Received: by bwz5 with SMTP id 5so3305501bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 23:57:51 -0800 (PST)
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] at76c50x-usb: support cfg80211 scanning
References: <c4d76b3b0902161643p73101b29hb55a9da696d16da9@mail.gmail.com>
	<8763j7qyfx.fsf@litku.valot.fi> <1235014330.6344.18.camel@rainbow>
	<87fxibhr5q.fsf@litku.valot.fi>
	<c4d76b3b0902192007s347ea4e3hcfa3fae1a1e3060b@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 21 Feb 2009 09:57:49 +0200
In-Reply-To: <c4d76b3b0902192007s347ea4e3hcfa3fae1a1e3060b@mail.gmail.com> (Jason Andryuk's message of "Thu\, 19 Feb 2009 23\:07\:03 -0500")
Message-ID: <87hc2okyrm.fsf@litku.valot.fi> (sfid-20090221_085757_544051_B37F13F7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

> I thought before I was not getting any scan results.  I may have been
> wrong.  However right now with the driver from wireless-testing
> 2009-02-18, 4 APs show up in NetworkManager.  Unfortunately, my AP is
> not one of them.  

What's your distance to the AP?

> No signal strength is reported for any of them.

Yes, this is a know issue. I'll try to fix it soon.

> Curiously, there are distinct results for each of at76c50x-usb, a
> semi-operational iwl3945 and the functional rtl8187.
>
> CMD_SCAN is receiving a lot of status 0x03 CMD_STATUS_INVALID_PARAMETER
>
> With debug=0xf022c001 I get the output below.  I was wondering if
> status=0x03 was being received because CMD_SET_MIB was called before
> CMD_SCAN's status was checked.  Hopefully you can make some sense out
> of the below logs.

After a quick look I didn't find anything, but I will investigate this
more.

Is at76_usb (the staging driver) is working fine with your device? Can
you take logs from it so that we can compare?

-- 
Kalle Valo
