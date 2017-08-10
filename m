Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33434 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752095AbdHJFZ6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Aug 2017 01:25:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: james@nurealm.net
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Ben Greear <greearb@candelatech.com>,
        Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: wireless drivers fail to report link speed?
References: <9645388a-2350-8fa0-ca34-e2289743888b@nurealm.net>
        <1502228547.24881.5.camel@redhat.com>
        <3a24351b-6875-fe65-58f1-f624c9f1832f@candelatech.com>
        <5f4422cc-2943-7863-bef3-c2c2653bde24@nurealm.net>
        <5a5cb91f-443c-8cc1-ea1f-50de4d07cb25@candelatech.com>
        <3d16a276-0e15-c722-483c-c17d715ebb5e@nurealm.net>
        <598AD624.1060003@broadcom.com>
        <318f60de-5589-1218-9848-d3514724e9c1@nurealm.net>
Date: Thu, 10 Aug 2017 08:25:53 +0300
In-Reply-To: <318f60de-5589-1218-9848-d3514724e9c1@nurealm.net> (James
        Feeney's message of "Wed, 9 Aug 2017 11:01:52 -0600")
Message-ID: <87tw1gt2n2.fsf@purkki.adurom.net> (sfid-20170810_072602_543988_6BF0E711)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Please don't drop me from CC)

James Feeney <james@nurealm.net> writes:

> @ Kalle Valo
>
>> Have you reported this on netdev (CCing linux-wireless, David Miller and
>> the patch authors)? I think the offending bonding patch should be
>> reverted but first it needs to be properly reported on the mailing list.
>> Most people don't really follow bugzilla.
>
> I have not. I first contacted David Miller and the patch authors
> personally, to see what sort of tact they might want to take. They
> have been notified. There has been no response from anyone except
> Andy. I can only make-up stories, based upon no information, about why
> they are ignoring this issue.

Contacting people privately is not a good idea as most people just
ignore them, me included. So this is not a surprise for me.

> I have been following an ever-expanding sequence of suggestions about
> where to discuss this issue - privately, Arch Linux, kernel bugzilla,
> linux-wireless - and now, netdev. 

Also bugzilla.kernel.org is not really actively followed by all
maintainers, so the best approach is to report the issue via
corresponding mailing lists and CC the developers and maintainters.

> I may do that next, but then, there
> may be so many different forums where this topic is being introduced,
> that no one anywhere will want to track it at all, or participate.

Let's not wait any longer, I'll report this forward. v4.13 release is
getting close and if we want to get this fixed for that release we have
to be quick.

> Really, who's responsibility is it, and who should have the authority, deciding
> what functionality wireless drivers "must" provide for functionality like
> "wireless bonding"?

The MAINTAINERS documents the responsibility. Usually the best approach
is to connect patch authors and CC mailing lists and maintainers
involved.

For bonding it's:

BONDING DRIVER
M:      Jay Vosburgh <j.vosburgh@gmail.com>
M:      Veaceslav Falico <vfalico@gmail.com>
M:      Andy Gospodarek <andy@greyhouse.net>
L:      netdev@vger.kernel.org
W:      http://sourceforge.net/projects/bonding/
S:      Supported
F:      drivers/net/bonding/
F:      include/uapi/linux/if_bonding.h

And for wireless:

CFG80211 and NL80211
M:      Johannes Berg <johannes@sipsolutions.net>
L:      linux-wireless@vger.kernel.org
W:      http://wireless.kernel.org/
T:      git
git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
T:      git
git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
S:      Maintained
F:      include/uapi/linux/nl80211.h
F:      include/net/cfg80211.h
F:      net/wireless/*
X:      net/wireless/wext*

MAC80211
M:      Johannes Berg <johannes@sipsolutions.net>
L:      linux-wireless@vger.kernel.org
W:      http://wireless.kernel.org/
T:      git
git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
T:      git
git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
S:      Maintained
F:      Documentation/networking/mac80211-injection.txt
F:      include/net/mac80211.h
F:      net/mac80211/
F:      drivers/net/wireless/mac80211_hwsim.[ch]


NETWORKING DRIVERS (WIRELESS)
M:      Kalle Valo <kvalo@codeaurora.org>
L:      linux-wireless@vger.kernel.org
Q:      http://patchwork.kernel.org/project/linux-wireless/list/
T:      git
git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git
T:      git
git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
S:      Maintained
F:      Documentation/devicetree/bindings/net/wireless/
F:      drivers/net/wireless/

-- 
Kalle Valo
