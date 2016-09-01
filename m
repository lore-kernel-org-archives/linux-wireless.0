Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34842 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932857AbcIAOxP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 10:53:15 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mwifiex: handle edmac vendor command
References: <1461945483-3239-1-git-send-email-akarwar@marvell.com>
        <cbd542a552db4d368a5b402307976494@SC-EXCH04.marvell.com>
        <87zirg8qxo.fsf@kamboji.qca.qualcomm.com>
        <e2b7d7d9aef1488a97eb7ec44b4c46af@SC-EXCH04.marvell.com>
Date: Thu, 01 Sep 2016 17:53:09 +0300
In-Reply-To: <e2b7d7d9aef1488a97eb7ec44b4c46af@SC-EXCH04.marvell.com>
        (Amitkumar Karwar's message of "Wed, 3 Aug 2016 11:20:57 +0000")
Message-ID: <87poon1xka.fsf@kamboji.qca.qualcomm.com> (sfid-20160901_165318_676013_CBC18D68)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

>> From: Kalle Valo [mailto:kvalo@codeaurora.org]
>> Sent: Tuesday, May 24, 2016 1:53 AM
>> To: Amitkumar Karwar
>> Cc: linux-wireless@vger.kernel.org
>> Subject: Re: [PATCH] mwifiex: handle edmac vendor command
>> 
>> Amitkumar Karwar <akarwar@marvell.com> writes:
>> 
>> > Hi Kalle,
>> >
>> >> From: Amitkumar Karwar [mailto:akarwar@marvell.com]
>> >> Sent: Friday, April 29, 2016 9:28 PM
>> >> To: linux-wireless@vger.kernel.org
>> >> Cc: Jeff CF Chen; Amitkumar Karwar
>> >> Subject: [PATCH] mwifiex: handle edmac vendor command
>> >>
>> >> From: chunfan chen <jeffc@marvell.com>
>> >>
>> >> Userspace can configure edmac values through a custom vendor command.
>> >> They will be used by hardware for adaptivity.
>> >>
>> >> Signed-off-by: chunfan chen <jeffc@marvell.com>
>> >> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
>> 
>> [deleted over 200 lines of unnecessary quotes]
>> 
>> > This patch seems to have deferred. We basically want a way to download
>> > a vendor specific configuration to our firmware. Do you have any
>> > suggestions on how can achieve this in better way?
>> >
>> > I can see below iw command suits our requirement.
>> >
>> > iw dev <devname> vendor send <oui> <subcmd> <filename|-|hex data>
>> >
>> > Please guide.
>> 
>> It was deferred because use of the nl80211 vendor interface (which I
>> don't think belong to upstream drivers). I'll take a look at this patch
>> in detail after the merge window.
>> 
>
> Did you get a chance to check this patch?
> Please let me know if you have any suggestions.

Sorry for the delay. I have been thinking about vendor commands quite a
lot and I don't think they belong to upstream drivers. For regular use
cases (used by normal users) we have nl80211, for developer and testing
purposes we have debugfs and for manufacturing type of tests we have
nl80211 testmode interface. The focus of development should be adding
new functionality to nl80211 (and other generic interfaces), not to
driver specific vendor commands.

I know brcm80211 and ti's wlcore have few vendor commands but I'm hoping
to remove them sometime soon.

Thoughts?

-- 
Kalle Valo
