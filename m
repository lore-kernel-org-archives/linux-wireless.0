Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55277 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933576AbcIAQfP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 12:35:15 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mwifiex: handle edmac vendor command
Date: Thu, 1 Sep 2016 16:34:56 +0000
Message-ID: <0fa2b5d5e09f4396a9c273c3c8dfc3db@SC-EXCH04.marvell.com> (sfid-20160901_183536_475825_6B173C4C)
References: <1461945483-3239-1-git-send-email-akarwar@marvell.com>
        <cbd542a552db4d368a5b402307976494@SC-EXCH04.marvell.com>
        <87zirg8qxo.fsf@kamboji.qca.qualcomm.com>
        <e2b7d7d9aef1488a97eb7ec44b4c46af@SC-EXCH04.marvell.com>
 <87poon1xka.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87poon1xka.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Thursday, September 01, 2016 8:23 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: [PATCH] mwifiex: handle edmac vendor command
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> >> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> >> Sent: Tuesday, May 24, 2016 1:53 AM
> >> To: Amitkumar Karwar
> >> Cc: linux-wireless@vger.kernel.org
> >> Subject: Re: [PATCH] mwifiex: handle edmac vendor command
> >>
> >> Amitkumar Karwar <akarwar@marvell.com> writes:
> >>
> >> > Hi Kalle,
> >> >
> >> >> From: Amitkumar Karwar [mailto:akarwar@marvell.com]
> >> >> Sent: Friday, April 29, 2016 9:28 PM
> >> >> To: linux-wireless@vger.kernel.org
> >> >> Cc: Jeff CF Chen; Amitkumar Karwar
> >> >> Subject: [PATCH] mwifiex: handle edmac vendor command
> >> >>
> >> >> From: chunfan chen <jeffc@marvell.com>
> >> >>
> >> >> Userspace can configure edmac values through a custom vendor
> command.
> >> >> They will be used by hardware for adaptivity.
> >> >>
> >> >> Signed-off-by: chunfan chen <jeffc@marvell.com>
> >> >> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> >>
> >> [deleted over 200 lines of unnecessary quotes]
> >>
> >> > This patch seems to have deferred. We basically want a way to
> >> > download a vendor specific configuration to our firmware. Do you
> >> > have any suggestions on how can achieve this in better way?
> >> >
> >> > I can see below iw command suits our requirement.
> >> >
> >> > iw dev <devname> vendor send <oui> <subcmd> <filename|-|hex data>
> >> >
> >> > Please guide.
> >>
> >> It was deferred because use of the nl80211 vendor interface (which I
> >> don't think belong to upstream drivers). I'll take a look at this
> >> patch in detail after the merge window.
> >>
> >
> > Did you get a chance to check this patch?
> > Please let me know if you have any suggestions.
> 
> Sorry for the delay. I have been thinking about vendor commands quite a
> lot and I don't think they belong to upstream drivers. For regular use
> cases (used by normal users) we have nl80211, for developer and testing
> purposes we have debugfs and for manufacturing type of tests we have
> nl80211 testmode interface. The focus of development should be adding
> new functionality to nl80211 (and other generic interfaces), not to
> driver specific vendor commands.
> 
> I know brcm80211 and ti's wlcore have few vendor commands but I'm hoping
> to remove them sometime soon.
> 
> Thoughts?
> 

Thanks for your reply.

There is something called energy detect mode. Chip can detect non-WiFi radio signal also and monitor it for specified time before transmitting frames.
As per ETSI specification, enabling this mode is mandatory for some countries for certain frequencies.

The purpose of this patch is to configure the chip for working in this mode.
I can see cfg80211 has a framework to handle vendor specific commands and events. I think having vendor commands would be helpful to support vendor specific functionalities which can't be generalized.

I suppose debugfs interface is only for collecting stats and info which can be used for debugging purpose.

Regards,
Amitkumar
