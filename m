Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:57091 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbYDPRpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 13:45:50 -0400
Received: by wa-out-1112.google.com with SMTP id m16so4065041waf.23
        for <linux-wireless@vger.kernel.org>; Wed, 16 Apr 2008 10:45:49 -0700 (PDT)
Message-ID: <a44ae5cd0804161045h37aafedbk5ff69bbb3c5ff850@mail.gmail.com> (sfid-20080416_184559_728441_DC036AE4)
Date: Wed, 16 Apr 2008 13:45:48 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: 2.6.25-rc9 -- bcm4306 performance is in the toilet
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"Jiri Benc" <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1208367041.11676.55.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48056406.2060502@gmail.com> <48060D71.6020507@lwfinger.net>
	 <a44ae5cd0804161012w7c07efb0w68f9a8664f077556@mail.gmail.com>
	 <1208367041.11676.55.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 16, 2008 at 1:30 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  > interface.c: In function 'get_if_type':
>  > interface.c:50: error: 'NL80211_IFTYPE_MESH_POINT' undeclared (first
>  > use in this function)
>  > interface.c:50: error: (Each undeclared identifier is reported only once
>  > interface.c:50: error: for each function it appears in.)
>  > interface.c: In function 'handle_interface_add':
>  > interface.c:121: error: 'NL80211_ATTR_MESH_ID' undeclared (first use
>  > in this function)
>
>  You need a newer copy of nl80211.h or revert back to an older revision
>  of iw before the mesh code was added.

Am I required to get the linux-wireless git kernel tree in order to
get the newer nl80211.h?

I checked in the 2.6.25-rc9 tree and was surprised to find four copies
of nl80211.h:
0 2008-04-14 23:48 ./include/config/nl80211.h
10074 2008-04-11 16:32 ./include/linux/nl80211.h
510 2008-04-11 16:32 ./net/wireless/nl80211.h
10074 2008-04-15 05:50 ./usr/include/linux/nl80211.h

It seems interesting that two copies have the same byte count and that
one of the files is empty.  What's up with that?

Thanks,
      Miles
