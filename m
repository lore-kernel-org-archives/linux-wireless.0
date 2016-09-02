Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44767 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752384AbcIBO4g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 10:56:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mwifiex: handle edmac vendor command
References: <1461945483-3239-1-git-send-email-akarwar@marvell.com>
        <cbd542a552db4d368a5b402307976494@SC-EXCH04.marvell.com>
        <87zirg8qxo.fsf@kamboji.qca.qualcomm.com>
        <e2b7d7d9aef1488a97eb7ec44b4c46af@SC-EXCH04.marvell.com>
        <87poon1xka.fsf@kamboji.qca.qualcomm.com>
        <0fa2b5d5e09f4396a9c273c3c8dfc3db@SC-EXCH04.marvell.com>
Date: Fri, 02 Sep 2016 17:56:29 +0300
In-Reply-To: <0fa2b5d5e09f4396a9c273c3c8dfc3db@SC-EXCH04.marvell.com>
        (Amitkumar Karwar's message of "Thu, 1 Sep 2016 16:34:56 +0000")
Message-ID: <87d1km1hb6.fsf@kamboji.qca.qualcomm.com> (sfid-20160902_165643_708789_86F2558E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

>> Sorry for the delay. I have been thinking about vendor commands quite a
>> lot and I don't think they belong to upstream drivers. For regular use
>> cases (used by normal users) we have nl80211, for developer and testing
>> purposes we have debugfs and for manufacturing type of tests we have
>> nl80211 testmode interface. The focus of development should be adding
>> new functionality to nl80211 (and other generic interfaces), not to
>> driver specific vendor commands.
>> 
>> I know brcm80211 and ti's wlcore have few vendor commands but I'm hoping
>> to remove them sometime soon.
>> 
>> Thoughts?
>> 
>
> Thanks for your reply.
>
> There is something called energy detect mode. Chip can detect non-WiFi
> radio signal also and monitor it for specified time before
> transmitting frames. As per ETSI specification, enabling this mode is
> mandatory for some countries for certain frequencies.

To me this looks this is something which can be generic, not a driver
specific interface. And why can't regulatory code enable this
automatically, without any user involvement? It already knows what
country we are in.

> The purpose of this patch is to configure the chip for working in this
> mode. I can see cfg80211 has a framework to handle vendor specific
> commands and events. I think having vendor commands would be helpful
> to support vendor specific functionalities which can't be generalized.

First of all, I don't see how the interface is mwifiex specific. If I
could trust that using vendor commands will not slow down the
development of nl80211, and other generic interfaces, I might think
otherwise. But at the moment I am nowhere near that.

> I suppose debugfs interface is only for collecting stats and info
> which can be used for debugging purpose.

Correct. I consider debugfs as a development and debugging interface for
developers and advanced users.

-- 
Kalle Valo
