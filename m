Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:43906 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbbB1TTC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Feb 2015 14:19:02 -0500
Received: by labhv19 with SMTP id hv19so23300635lab.10
        for <linux-wireless@vger.kernel.org>; Sat, 28 Feb 2015 11:19:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425054660.1960.7.camel@sipsolutions.net>
References: <CA+uMeVeu0y892+HPCNK5zbuk48WTawaue9p5j690D9n77yzw1w@mail.gmail.com>
	<CA+uMeVct4LSHw9HsxFm1DCdEPDr81_SpkHFeyQptd2eR1+1XSg@mail.gmail.com>
	<CA+uMeVcwpfOfQ=TnQA5omYga5Qu1bynNYz1gAQbcR4VqpFcXXg@mail.gmail.com>
	<1425054660.1960.7.camel@sipsolutions.net>
Date: Sat, 28 Feb 2015 21:19:00 +0200
Message-ID: <CANUX_P2JqFrS-=imWCXCSp=SMoD38rtrLEhiuPV4uT9L1DRU-Q@mail.gmail.com> (sfid-20150228_201908_587709_321FF1BE)
Subject: Re: Intel Wireless 7260 - Possible bug within iwlwifi
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?UTF-8?B?0JHQvtGA0LjRgdC70LDQsiDQodGK0LHQtdCy?=
	<borislavsabev@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 27, 2015 at 6:31 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2015-02-27 at 18:11 +0200, Борислав Събев wrote:
>
>> The problem is that If our WiFi goes down (or we need to restart the
>> router) after the router is back up the connection could not be
>> established again.
>
> I'm not sure I understand - the below has nothing to do with the router?
>
>> In the dmesg line: "[  167.863245] iwlwifi 0000:02:00.0: RF_KILL bit
>> toggled to disable radio."      is wan produced when we try to stop/start
>> the adapter via its hardware button or the button in NetworkManager.
>
> That's pretty normal. Does it also show "to enable radio"? If you're
> saying it just gets stuck in rfkill-disabled state then this is much
> more likely a platform than iwlwifi issue, perhaps in the ACPI or other
> platform rfkill drivers.
>
>> Hope this helps to solve the issue for everyone.
>> Again I have 4 machines with this issue so I can also test different
>> stuff on Debian 8 Jessie & Ubuntu 14.04!
>
> I have no idea what you'd want to test :)
>

You want to test with this fix:
https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/iwlwifi-fixes.git/commit/?id=90ea15c1148bb1517e400ed14bb875e330aead2e
