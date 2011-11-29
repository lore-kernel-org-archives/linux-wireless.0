Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50503 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab1K2QdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 11:33:13 -0500
Received: by bkas6 with SMTP id s6so727118bka.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2011 08:33:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322338337.4283.3.camel@jlt3.sipsolutions.net>
References: <CA++WF2O0WjyqU0HEGR1XE9xDFzR+sxRboVWexRCMPi8okOVkkA@mail.gmail.com>
	<1322338254.4283.2.camel@jlt3.sipsolutions.net>
	<1322338337.4283.3.camel@jlt3.sipsolutions.net>
Date: Tue, 29 Nov 2011 08:33:12 -0800
Message-ID: <CA++WF2Op0dScq=coD=qkjqE-Q3ncOVjWVfFsF6sWUi0M5To=7g@mail.gmail.com> (sfid-20111129_173322_167784_53DE5304)
Subject: Re: Converting ipw2x00 driver to mac80211 framework
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> It would be much less risky to convert the entire thing to cfg80211, I
>> think, basically just replacing the configuration layer in libipw_wx.c
>> with a cfg80211 based one.
>
> It might also be a good idea to do some cleanups first -- e.g. I notice,
> just in a random look at the code, that reset_port isn't used anywhere
> so all code related to that can be removed...

Do I understand correctly that you suggest remove reset_port from
libipw_device struct
and remove all code like this:

-          if (ieee->reset_on_keychange &&
-              ieee->iw_mode != IW_MODE_INFRA &&
-              ieee->reset_port && ieee->reset_port(dev)) {
-                 LIBIPW_DEBUG_WX("%s: reset_port failed\n", dev->name);
-                 return -EINVAL;
-         }

from libipw_wx.c ?

Stanislav.
