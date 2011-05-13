Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57972 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab1EMHRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 03:17:06 -0400
Received: by qwk3 with SMTP id 3so1148225qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 00:17:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305262715.4065.436.camel@localhost>
References: <13602.31426.qm@web161615.mail.bf1.yahoo.com>
	<1305262715.4065.436.camel@localhost>
Date: Fri, 13 May 2011 09:17:05 +0200
Message-ID: <BANLkTim75f2p8wXyfeoz02asRd+Qm9aepA@mail.gmail.com> (sfid-20110513_091716_537112_4AAC9956)
Subject: Re: Bug#596626: [gsimmons@gsimmons.org: Bug#596626: Please support
 Linksys WUSB600N v2 WiFi USB stick]
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Walter Goldens <goldenstranger@yahoo.com>, 596626@bugs.debian.org,
	maximilian attems <max@stro.at>,
	linux-wireless@vger.kernel.org,
	Geoff Simmons <gsimmons@gsimmons.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> > As mentioned by Jan, the device contains a RT3572
>> > chipset.  Its entry
>> > could moved into the section for known RT35XX devices (i.e.
>> > "#ifdef
>> > CONFIG_RT2800USB_RT35XX") as an alternative.
>> >
>> > Geoff
>>
>> This has already been done: http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commitdiff;h=ce2919c9fffe2aa52f9c3e327176d03764dbf9b5
>
> That's all very well, but that isn't going to get into a stable release
> for another 3 months!  Device ID updates that don't require new
> supporting code should be sent upstream straight away (and cc'd to
> stable@kernel.org).

The patch has been send upstream, it has been in wireless-next-2.6.git
since April 19...
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commit;h=ce2919c9fffe2aa52f9c3e327176d03764dbf9b5
The patch depends on the RT53xx support patch which was also intented
for 2.6.40.

> I've cherry-picked this and the other two updates in rt2800usb that
> aren't in Linus's tree, but that doesn't help the users of other
> distributions that would benefit from them.

True, but the normal flow for new features and hardware support is that they
should be properly merged during the normal merge window. The addition
of support of RT53xx is not something that should go to stable@kernel.org...

Patches from rt2x00.git are quite quickly send from rt2x00.git to upstream,
and patches which are not send upstream directly have a reason for not being
send at that time (Usually it means that it requires some extra testing).

Ivo
