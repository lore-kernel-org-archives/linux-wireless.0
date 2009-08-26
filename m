Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:64141 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbZHZWGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 18:06:48 -0400
Received: by iwn42 with SMTP id 42so401161iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 15:06:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890908261333m1d576fdhaa16088affec5426@mail.gmail.com>
References: <850984.89698.qm@web23108.mail.ird.yahoo.com> <1251297273.15619.11.camel@johannes.local>
	<43e72e890908261333m1d576fdhaa16088affec5426@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 Aug 2009 15:06:30 -0700
Message-ID: <43e72e890908261506h6b9ec4efq2d190388663d4671@mail.gmail.com>
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: htl10@users.sourceforge.net,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 26, 2009 at 1:33 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Wed, Aug 26, 2009 at 7:34 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
>> On Wed, 2009-08-26 at 13:33 +0000, Hin-Tak Leung wrote:
>>
>>> > Or wait ... are you using compat-wireless?
>>>
>>> Yes, I am. I mentioned this and did wonder if the _backport/ part
>>> in /sys/class is important.
>>
>> Sorry, didn't see.
>>
>> Anyway, that's pretty clearly the reason -- Luis added NETDEV_PRE_UP to
>> some compat*.h but obviously the kernel won't ever call that notifier,
>> so cfg80211 doesn't get a chance to reject the IFUP. No idea how to
>> handle that -- it'll be working fine in a regular tree.
>>
>> Luis, the only way to handle that would be to manually call the PRE_UP
>> notifier from mac80211's subif_open() and if that returns an error
>> (warning: the calling convention is weird) return the error... that's
>> weird but would work.
>
> Neat, thanks. Not sure if I'll get to this this anytime soon, but if
> someone is interested in it please give it a shot and send a patch.
> That would be nice.

What if we *also* just do that from mac80211 as well upstream?

  Luis
