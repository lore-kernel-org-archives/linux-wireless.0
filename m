Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:61927 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbZHZQ3Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 12:29:25 -0400
Received: by mail-ew0-f206.google.com with SMTP id 2so330493ewy.17
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 09:29:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251297273.15619.11.camel@johannes.local>
References: <850984.89698.qm@web23108.mail.ird.yahoo.com>
	 <1251297273.15619.11.camel@johannes.local>
Date: Wed, 26 Aug 2009 17:29:26 +0100
Message-ID: <3ace41890908260929n66e4e56teaeadaab31f28725@mail.gmail.com>
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
>
> johannes
>

Hmm, got a bit side-tracked. But hal doesn't know the device having a
killswitch is still wrong somewhere?
(i.e. am wondering where we should advertise that ability, or how hal
works that out)

Hin-Tak
