Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58565 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab1GTQFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 12:05:43 -0400
Received: by vxh35 with SMTP id 35so261011vxh.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2011 09:05:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107201709.42141.helmut.schaa@googlemail.com>
References: <CAN=pzdLRaRHkg4NquUpDhEwRzq-roKQXMtMcwnr031maDSLRfw@mail.gmail.com>
	<201107201536.01392.helmut.schaa@googlemail.com>
	<CAN=pzdKLtB2yz4-OhKL5gzYF0Qm2weAmNAz-0MqdFuooFNYzwQ@mail.gmail.com>
	<201107201709.42141.helmut.schaa@googlemail.com>
Date: Wed, 20 Jul 2011 18:05:42 +0200
Message-ID: <CAMEN=G50-CYW-+zdiVV-tUF2Ghhatrr0zk5oVYrN8=EN-03ZzA@mail.gmail.com> (sfid-20110720_180546_216104_E5A42DA7)
Subject: Re: rt2x00, AP mode, 802.11n is not working properly
From: Juan Carlos Garza Fernandez <juancarlosgarza@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Stanislav Demakov <s.demakov@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

On Wed, Jul 20, 2011 at 5:09 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Am Mittwoch, 20. Juli 2011 schrieb Stanislav Demakov:
>> 2011/7/20 Helmut Schaa <helmut.schaa@googlemail.com>:
>> > Am Mittwoch, 20. Juli 2011 schrieb Stanislav Demakov:
>> >> I'm using hostapd 0.73 and 1T1R rt2x00 based wireless dongle to create
>> >> an AP. The problem is that since version
>> >> compat-wireless-2010-12-14.tar.bz2 802.11n mode is not working
>> >> properly. In this driver version and all later you've broken
>> >> something!
>> >
>> > So, 2010-12-14 already shows the problem you've described while 2010-12-13
>> > does not, right?
>> Yes, correct.
>
> One major change from 12-13 to 12-14 was the queue refactoring. Haven't found
> anything else that looks related. However, this patchset is quite big and
> really changed the way the queues are handled in rt2x00. So it's not trivial
> to find the root cause for your problem ...

I am running an AP with hostapd 0.73 with also a 1T1R dongle and it
works (maybe not as fast as it could, but I am happy with its
performance).
I use the compat-wireless version from 2011-03-13 plus some patches
that Helmut suggested (which are already merged in the main branch):

[1] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=878a2bbc20100d8bccf84cc058373fe7de2e6501
[2] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=4f3ab1e88d8b5ce4852d075016ca784a00383452
[3] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=c8cb3a0af064fb5d9cbbaa16bd2f308ba3b90ceb
[4] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=66b096e6ad64f718425d2de9a70d82ba187d7db4

I later tried the version compat-wireless-2011-05-05 and it did not
work, some major changes took
place in between, and I unfortunately did not have time to go deeper,
so I stayed with my
running system.

Since then, some other things have been changed in the TX queues and I
will eventually try it again.

>
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
________________________________
Juan Carlos Garza
