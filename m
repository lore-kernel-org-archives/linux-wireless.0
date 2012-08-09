Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34068 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758674Ab2HIAYy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 20:24:54 -0400
Received: by lagy9 with SMTP id y9so737479lag.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 17:24:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344448792.18836.14.camel@dcbw.foobar.com>
References: <CANZ_KY5-EZ2n54G3P3wnjUdTdVknarnXFK2cj9WobnQemAr5kA@mail.gmail.com>
	<CANZ_KY5yLJrHKQ4c30sNpVXPBRRTzwjyUYREcOaX8YP=OAB=Ew@mail.gmail.com>
	<1344448792.18836.14.camel@dcbw.foobar.com>
Date: Wed, 8 Aug 2012 21:24:52 -0300
Message-ID: <CANZ_KY7YvEiOxTU29vQ4MaXDVg+keuhiKO6j=Y-Rkc18pZgnjA@mail.gmail.com> (sfid-20120809_022457_857996_9B5A11B0)
Subject: Re: Problem: BCM 4313 (brcmsmac) always hard blocked
From: Arliton Rocha <arliton@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rfkill list all:
      0: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: yes

None platform killswitch. As i said when unblocked by
windows another thing that appears is hci0 (bluetooth).

Yes, i think you can be right about the rfkill, ids, ...This is not a wifi bug.
Wifi and bluetooth works very well after unblock.

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: Compal
	Product Name: PBL0001
	Version: 1.70
	Serial Number: 123456789
	UUID: 0E2F618D-BDB1-E011-8221-B870F4B1DE9F
	Wake-up Type: Power Switch
	SKU Number: HuronRiver_CRB
	Family: Intel_Mobile

Thanks Dan.

On Wed, Aug 8, 2012 at 2:59 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Wed, 2012-08-08 at 08:14 -0300, Arliton Rocha wrote:
>> Hi devs,
>>
>> The following card does not work (remains always 'hard blocked'):
>>     02:00.0 Network controller [0280]: Broadcom Corporation BCM4313
>> 802.11b/g/n Wireless LAN Controller [14e4:4727] (rev 01)
>>
>> There is no a physical lock on the notebook in question.
>> I know windows can change only by software.
>> When i do this, wireless net (and bluetooth) works fine on linux.
>> Ok, install windows, unblock... But, why linux can't do this?
>> I have trying a lot of tips about rfkill (unblock all, ...) but
>> nothing, remains hard blocked.
>> Also i tried, unsuccessfully, map Fn + F12 keys...
>
> BIOS usually controls this sort of thing.  Check "rfkill list" and see
> if you have a "platform" killswitch.  On my HP, that looks like:
>
> 0: hp-wifi: Wireless LAN
>
> and when that is blocked, it hardblocks the internal wifi.  This switch
> is provided by a small driver that talks to your laptop's BIOS.  It's
> likely that either your laptops device IDs are not added to the correct
> kernel driver, or your laptop does things in a different way than
> previous ones, and doesn't have a kernel driver yet.  But in the end,
> this is most likely a kernel rfkill driver bug, not a wifi bug.
>
> What make and model of laptop is this?
>
> Dan
>
>> Someone have an idea?
>>
>> Hardware information in attachment.
>>
>> Thanks in advance.
>> Best regards.
>>
>> --
>> Arliton Rocha
>
>

-- 
Arliton Rocha
