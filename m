Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:42721 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab3I3XcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 19:32:16 -0400
Received: by mail-ve0-f171.google.com with SMTP id pa12so4590119veb.2
        for <linux-wireless@vger.kernel.org>; Mon, 30 Sep 2013 16:32:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130925180057.GA11394@mail.catnarok.net>
References: <20130921223440.GA5297@mail.catnarok.net>
	<523FF83D.8030103@broadcom.com>
	<20130924005224.GA27400@mail.catnarok.net>
	<524144FF.9020908@broadcom.com>
	<20130925180057.GA11394@mail.catnarok.net>
Date: Mon, 30 Sep 2013 18:32:15 -0500
Message-ID: <CAD_xsFNeTzqkyG5aeYWBGb756SW0_SHrdAKtkGQ_PBGZHxOXYg@mail.gmail.com> (sfid-20131001_013219_892358_8689949F)
Subject: Re: brcmsmac causes soft lockup in 3.12-rc1
From: Adam Honse <calcprogrammer1@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Same here, using the 3.12.0-rc2 or newer from Ubuntu kernel PPA and my
BCM4313 works flawlessly, something it's never done before.  Great
work!

On Wed, Sep 25, 2013 at 1:00 PM, Michael Stolovitzsky
<emestee@catnarok.net> wrote:
> On 13-09-24, Arend van Spriel wrote:
>> On 09/24/2013 02:52 AM, Michael Stolovitzsky wrote:
>> >On Mon, Sep 23, 2013 at 10:13:49AM +0200, Arend van Spriel wrote:
>> >>On 09/22/2013 12:34 AM, Michael Stolovitzsky wrote:
>> >>>Hi,
>> >>>
>> >>>On 3.12-rc1, modprobe brcmsmac causes a soft lockup (trace #1), effectively killing the box. This is a Lenovo S206
>> >>>with BCM4313 (14e4:4727), which I believe is a bluetooth combo board. After a while,
>> >>>RCU scheduler code detects a lockup (trace #2).
>> >>>
> [...]
>> >>
>> >>A fix for this problem has been submitted to John. I think it is in
>> >>transit to mainline so probably will be in 3.12-rc2.
>> >>
>> >>Here the URL of the patch:
>> >>
>> >>https://git.kernel.org/cgit/linux/kernel/git/linville/wireless.git/patch/?id=aaa2ced15ad8dca8048666c9f70736424d696a6b
>> >>
>> >
> [...]
>> The patch is in 3.12-rc2. There have been more reports on that, but
>> it still needs to be investigated. Can you provide content of
>> /sys/kernel/debug/brcmsmac/bcma*/hardware? You need to have
>> CONFIG_BRCMDBG selected.
>>
>
> Here you go:
>
> board vendor: 14e4
> board type: 587
> board revision: 1307
> board flags: 402201
> board flags2: 884
> firmware revision: 262032c
>
> Once again thank you. On 3.12.0-rc2, brcmsmac seems to work fine, which has never happened before, and makes me
> very happy. Now I am getting new bug messages that I have to look at.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
