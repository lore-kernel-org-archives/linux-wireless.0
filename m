Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:37236 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbZBRUZ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 15:25:29 -0500
Received: by fk-out-0910.google.com with SMTP id f33so69935fkf.5
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 12:25:26 -0800 (PST)
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] at76c50x-usb: convert at76_debug to an unsigned int
References: <c4d76b3b0902151803m2d4517e0v434cdd12a7c3e074@mail.gmail.com>
	<c4d76b3b0902151817h35862687ta778434af4817f1c@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 18 Feb 2009 22:25:22 +0200
In-Reply-To: <c4d76b3b0902151817h35862687ta778434af4817f1c@mail.gmail.com> (Jason Andryuk's message of "Sun\, 15 Feb 2009 21\:17\:30 -0500")
Message-ID: <87ab8jqyq5.fsf@litku.valot.fi> (sfid-20090218_212550_060410_8DF59AEE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

> at76_debug should be an unsigned int as it used as a bit field.  In
> fact, modprobe fails when trying to set at76_debug's high bit.

Thanks. I'll send this to John.

> Also included is a compile fix to the ieee80211_scan_completed() call.

I separated this to a patch of it's own:

commit e8970b5f443eb4621c808c659131b47ebdf16af7
Author: Jason Andryuk <jandryuk@gmail.com>
Date:   Wed Feb 18 22:18:14 2009 +0200

    at76c50x-usb: update to latest mac80211 hw scan api
    
    With the latest mac80211 stack, the driver needs to be updated for
    cfg80211 scanning.  I based the changes off of modifications for
    at76_usb found here:
    
    http://johannes.sipsolutions.net/patches/old/all/2008-09-19-13:35/020-cfg80211-scan.patch
    
    The trick was that max_signal also needs to be set to avoid a divide
    by zero Oops.  I just guessed and used the value 100 for now.
    
    kvalo: handpicked the change from two different patches
    
    Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
    Signed-off-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
