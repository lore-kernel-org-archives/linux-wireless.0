Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42389 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161169AbcIGL1X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2016 07:27:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mwifiex: handle edmac vendor command
References: <1461945483-3239-1-git-send-email-akarwar@marvell.com>
        <cbd542a552db4d368a5b402307976494@SC-EXCH04.marvell.com>
        <87zirg8qxo.fsf@kamboji.qca.qualcomm.com>
        <e2b7d7d9aef1488a97eb7ec44b4c46af@SC-EXCH04.marvell.com>
        <87poon1xka.fsf@kamboji.qca.qualcomm.com>
        <2320ad20-164e-12c5-0b01-9612a1d24300@broadcom.com>
Date: Wed, 07 Sep 2016 14:27:17 +0300
In-Reply-To: <2320ad20-164e-12c5-0b01-9612a1d24300@broadcom.com> (Arend Van
        Spriel's message of "Mon, 5 Sep 2016 10:33:02 +0200")
Message-ID: <87bn00x84q.fsf@kamboji.qca.qualcomm.com> (sfid-20160907_132743_316995_2AB6DBB7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> On 1-9-2016 16:53, Kalle Valo wrote:
>
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
>
> Grabbing the original commit message for vendor commands:
>
> commit ad7e718c9b4f717823fd920a0103f7b0fb06183f
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Wed Nov 13 13:37:47 2013 +0100
>
>     nl80211: vendor command support
>
>     Add support for vendor-specific commands to nl80211. This is
>     intended to be used for really vendor-specific functionality
>     that can't be implemented in a generic fashion for any reason.
>     It's *NOT* intended to be used for any normal/generic feature
>     or any optimisations that could be implemented across drivers.
>
> I agree that the effort needs to be made to come up with a solution that
> is usable by (most of) all drivers in the upstream wireless subsystem.
>
> The thing with the test mode is that you need to enable it in Kconfig.

And that's on purpose. We did not want testmode to be enabled on distro
kernels, for example.

> We have 1 vendor command in brcmfmac and it used to be under testmode
> api. However, because of the Kconfig thing it would mean we need a
> different kernel to do manufacturing testing. Especially when the
> modules are built-in. The OEMs typically don't like that as they want to
> do the testing using the same kernel as what ends up in the product.
> This was our motivation to use the vendor command when that was added.

Is there a specific reason why you can't keep the testmode always
enabled? Then you would have the same kernel both in manufacturing and
in "normal mode".

> It does have a nasty side-effect that some will see it as a drop-in
> replacement of the driver private ioctl-s. To some extent (as mentioned
> in the commit message above) that should be fine, but we need to make a
> good effort to move things to nl80211.

Sorry, but I'm way too cynical to buy that :) A "good effort" means that
in most of cases it will never happen. Once the vendor command is
accepted into upsteam trees the developer will lose any interest on
trying to make it a generic interface. That's just how humans work,
including me.

I do see your and Amitkumar's point how much easier the vendor commands
make it to implement new driver features and part of me also wants that.
I just think that in the long run that's detrimental for Linux wireless
and we end up into having multiple drivers having same features enabled
via different vendor commands.

-- 
Kalle Valo
