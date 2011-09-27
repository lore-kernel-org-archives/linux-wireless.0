Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57814 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab1I0Lug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 07:50:36 -0400
Received: by ywb5 with SMTP id 5so5222712ywb.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 04:50:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317121681.4082.8.camel@jlt3.sipsolutions.net>
References: <1317119624-2974-1-git-send-email-stanv@altlinux.org>
	<1317109617.4082.0.camel@jlt3.sipsolutions.net>
	<CAN8FffqH=x+qWnz=YJzatbW-b3aOgoivazH6Nb5SpsGt4Q6hGg@mail.gmail.com>
	<1317110884.4082.5.camel@jlt3.sipsolutions.net>
	<CAN8FffqjeurgAvVHtMExgeAyBHRWznYBz2c043jcZgOmqw6TVg@mail.gmail.com>
	<1317113699.4082.7.camel@jlt3.sipsolutions.net>
	<CAN8FffrZuGu63oL7ZL8EjjdNqBaPDU6KHuatwrbNB0SjffvaTg@mail.gmail.com>
	<1317121681.4082.8.camel@jlt3.sipsolutions.net>
Date: Tue, 27 Sep 2011 15:50:35 +0400
Message-ID: <CAN8FffrnCt6TL-dWBJtnOpk=oELRXhnU0ksHntFWfbPo5mgWaA@mail.gmail.com> (sfid-20110927_135040_351771_38E1C6CD)
Subject: Re: [PATCH 1/1] rfkill: add module option to become inactive.
From: "Andrew V. Stepanov" <stanv@altlinux.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: davem@davemloft.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 27, 2011 at 3:08 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-09-27 at 13:34 +0400, Andrew V. Stepanov wrote:
>> On Tue, Sep 27, 2011 at 12:54 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Tue, 2011-09-27 at 12:46 +0400, Andrew V. Stepanov wrote:
>> >
>> >> I wan't to completely ignore events (state) of software\hardware rfkill buttons.
>> >
>> > Why would you ever want to do that? I can see that you might want to
>> > ignore soft buttons, but you can use urfkilld for that. Ignoring hard
>> > buttons is completely useless -- they will affect the device they're
>> > wired up to *anyway*.
>>
>> No. That is not true.
>>
>> Hardware rfkill button doesn't have any action to wlan\bluetooth
>> devices on ThinkPad x201i with "CONFIG_RFKILL is not set".
>> I can assume this is true for other notebooks.
>
> Then why is it a hard button instead of the soft button on a separate
> platform device?
>
> johannes
>

1.

Lenovo ThinkPad x201i has two rfkill buttons.
One soft: Fn-F5.
Second hard: small switch on left case side.

With RFKILL_CONFIG == "is not set" this two buttons became inactive.
They do not has any influence to adapter\drivers state.

This patch give ability disable rfkill sub-system by means to pass
special module parameter.

Example from real life. Some company want to make inactive rfkill
SW+HW buttons on some company notebooks.
For this, you advise to recompile kernel.

2.

One more thing, why this patch is necessary. You advise to use
urfkilld. But this is doesn't help in case of external USB WIFI
devices.

Turn on(off) HW button will be effect on all WIFI devices, even
external. rfkill kernel subsystem will bring all cfg80211 devices to
software lock. See: net/wireless/core.c for rfkill. I do not think,
that urfkilld will help.
