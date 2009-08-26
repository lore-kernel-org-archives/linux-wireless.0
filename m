Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57734 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZHZPOt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 11:14:49 -0400
Received: by bwz19 with SMTP id 19so201288bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 08:14:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251297273.15619.11.camel@johannes.local>
References: <850984.89698.qm@web23108.mail.ird.yahoo.com>
	 <1251297273.15619.11.camel@johannes.local>
Date: Wed, 26 Aug 2009 16:07:52 +0100
Message-ID: <3ace41890908260807t736848d8x57dff6cf3ac581c6@mail.gmail.com>
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: htl10@users.sourceforge.net,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 26, 2009 at 3:34 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Wed, 2009-08-26 at 13:33 +0000, Hin-Tak Leung wrote:
>
>> > Or wait ... are you using compat-wireless?
>>
>> Yes, I am. I mentioned this and did wonder if the _backport/ part
>> in /sys/class is important.
>
> Sorry, didn't see.
>
> Anyway, that's pretty clearly the reason -- Luis added NETDEV_PRE_UP to
> some compat*.h but obviously the kernel won't ever call that notifier,
> so cfg80211 doesn't get a chance to reject the IFUP. No idea how to
> handle that -- it'll be working fine in a regular tree.
>
> Luis, the only way to handle that would be to manually call the PRE_UP
> notifier from mac80211's subif_open() and if that returns an error
> (warning: the calling convention is weird) return the error... that's
> weird but would work.

Okay, that explains it. So I can have a Tested-by: ... I just grep for
NETDEV_PRE_UP in compat-wireless and it is only in
include/net/compat-2.6.31.h (not in 2.6.30) and I am on 2.6.30.5-X . I
can grab the rawhide 2.6.31 rpms and try it quickly;
and possibly look at some ugly quick hack backport that? Stay tuned.

Thanks for the help.

Hin-Tak
