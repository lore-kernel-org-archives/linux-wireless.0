Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62742 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab1JZKcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 06:32:53 -0400
Received: by wyg36 with SMTP id 36so1491276wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2011 03:32:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4EA70429.8070505@candelatech.com>
References: <201110251910.37638.david.goodenough@btconnect.com>
	<4EA70429.8070505@candelatech.com>
Date: Wed, 26 Oct 2011 12:32:52 +0200
Message-ID: <CACVrECHsEQ5fNeeZsaFUh=oHy9Kgc_ZLbnn4-fypSBhCbooq-g@mail.gmail.com> (sfid-20111026_123257_698119_54C29316)
Subject: Re: How to find the phy's associated with a wireless dev
From: Mariana Gambande <mlgambande@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: David Goodenough <david.goodenough@btconnect.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Davis,
Maybe is easier for you to create an udev rule to rename your wireless
devices always the same way. An example:

file /etc/udev/rules.d/wireless-devices.rules:

KERNEL=="phy*", SYSFS{address}=="00:xx:xx:xx:xx:xx", NAME="phy0"
KERNEL=="phy*", SYSFS{address}=="00:xx:xx:xx:xx:xx", NAME="phy1"

You can see more information here
http://www.science.uva.nl/research/air/wiki/LogicalInterfaceNames?show_comments=1

This works fine for me :)


2011/10/25 Ben Greear <greearb@candelatech.com>
>
> On 10/25/2011 11:10 AM, David Goodenough wrote:
>>
>> I notice that if I remove the kernel module for a wireless
>> interface and reload it, that a new phy is defined.  This is
>> confusing my script that sets up interfaces, in particular I
>> need to set the distance for a long distance link and that has
>> to be done on the phy not the dev.
>>
>> I am doing this from a script so I guess it has to be a query
>> using iw, but I can not see which one to use.
>
> On a recent kernel:
> cat /sys/class/net/wlan0/phy80211/name
>
> Thanks,
> Ben
>
>
>>
>> David
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
