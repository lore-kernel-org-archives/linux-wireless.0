Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:34237 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752473AbdARKNx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 05:13:53 -0500
Received: by mail-pg0-f48.google.com with SMTP id 14so3613836pgg.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2017 02:13:11 -0800 (PST)
Subject: Re: [PATCH 1/2] brcmfmac: rename brcmf_bus_start function to
 brcmf_attach_phase2
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <20170117192325.14528-1-zajec5@gmail.com>
 <b2c7673d-ef13-f6ee-27be-54bf73221352@broadcom.com>
 <CACna6rw5wtw8mMTddKC-yncw-9UABUFija=hud8Q1tWPoCgaTQ@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <b8b1e009-ebdf-02c9-2c50-e2a32c05eaf1@broadcom.com> (sfid-20170118_111639_367356_EA89B833)
Date: Wed, 18 Jan 2017 11:13:04 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6rw5wtw8mMTddKC-yncw-9UABUFija=hud8Q1tWPoCgaTQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18-1-2017 10:51, Rafał Miłecki wrote:
> On 18 January 2017 at 10:25, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 17-1-2017 20:23, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> This change intends to make init/attach process easier to follow.
>>>
>>> What driver were doing in brcmf_bus_start wasn't bus specific at all and
>>> function brcmf_bus_stop wasn't undoing things done there. It seems
>>> brcmf_detach was actually undoing things done in both: brcmf_attach and
>>> brcmf_bus_start.
>>>
>>> To me it makes more sense to call these two function in a similar way as
>>> they both handle some part of attaching process. It also makes
>>> brcmf_detach more meaningful.
>>
>> To me this is all bike-shedding and I have two options 1) what's in a
>> name and let it pass, or 2) explain the naming. Let's try option 2). It
>> seems your expectation was different because of the name
>> brcmf_*bus*_start(). The function brcmf_attach() is called by
>> bus-specific code, ie. sdio, pcie, or usb, to instantiate the common
>> driver structures and essential common facilities, eg. debugfs, and
>> brcmf_bus_start() is called by bus-specific code when everything is
>> ready for use. For PCIe there is nothing between those calls but for
>> SDIO there are several steps before the party can start, hence the name.
> 
> Sorry you find this cleanup try this way. If you still have some
> patience for this /silly/ stuff, I've one more question.
> 
> So as you noticed (and confirmed my note) both: brcmf_attach and
> brcmf_bus_start are called from bus specific code. They initialize
> some *common* stuff. How did you come with the "brcmf_bus_start" name
> then?
> 1) It's called after bus got initialized (started?)
> 2) It's initializes common stuff
> 3) It doesn't execute bus specific code
> 
> My point is "brcmf_bus_start" name doesn't seem to make much sense. If
> you have any better suggestion than "brcmf_bus_start" and
> "brcmf_attach_phase2", I'll be happy to use it. What could it be?
> brcmf_attach_after_bus_started would be more accurate but too long.

It is a signal given by bus specific code that common code can "start
using the bus" for communication with the device. Maybe
brcmf_bus_started() is more accurate. The fact that common code uses
that signal to execute more initialization stuff is irrelevant.

Regards,
Arend
