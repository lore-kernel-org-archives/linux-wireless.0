Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:37212 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbZIGKpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2009 06:45:00 -0400
Received: by fxm17 with SMTP id 17so1897201fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2009 03:45:02 -0700 (PDT)
To: Jason Andryuk <jandryuk@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: at76c50x-usb Broken was: [PATCH] mac80211: allow configure_filter  callback to sleep
References: <c4d76b3b0909050711o5f423115qaf1e5c80fded024d@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 07 Sep 2009 13:45:00 +0300
In-Reply-To: <c4d76b3b0909050711o5f423115qaf1e5c80fded024d@mail.gmail.com> (Jason Andryuk's message of "Sat\, 5 Sep 2009 10\:11\:33 -0400")
Message-ID: <87fxaz2fv7.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

> On Mon, Aug 17, 2009 at 10:24 AM, Kalle Valo<kalle.valo@iki.fi> wrote:
>> BTW, at76c50x-usb is broken currently. The change of providing bssid to
>> the driver only after association broke it. I don't have time to fix it
>> right now, but I try to find some time next week.
>
> Do you know the commit that broke at76c50x-usb?  Was it "mac80211:
> unify config_interface and bss_info_changed" or something else?

Actually I believe it was this patch:

  commit 9cef873798dfcdc10ff40b02abf1de935ceeba85
  Author: Johannes Berg <johannes@sipsolutions.net>
  Date:   Thu May 14 13:10:14 2009 +0200

    mac80211: fix managed mode BSSID handling
    
    Currently, we will ask the driver to configure right away
    when somebody changes the desired BSSID. That's totally
    strange because then we will configure the driver without
    even knowing whether the BSS exists. Change this to only
    configure the BSSID when associated, and configure a zero
    BSSID when not associated.

I implemented a hack to at76c50x-usb where it checks bssid to see if
association has started and should it use CMD_SCAN or CMD_JOIN. Now that
bssid is set after association at76 broke. I haven't checked yet if this
is really the case, though.

IIRC the reason for the hack was that I didn't manage to get CMD_JOIN
working unless there was a valid bssid.

-- 
Kalle Valo
