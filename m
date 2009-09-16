Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:46967 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbZIPXPU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 19:15:20 -0400
Received: by bwz19 with SMTP id 19so3852365bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 16:15:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909170005.56145.fabio.coatti@gmail.com>
References: <200909161521.15710.fabio.coatti@gmail.com>
	 <200909161657.44453.fabio.coatti@gmail.com>
	 <1253118619.26521.420.camel@rc-desk>
	 <200909170005.56145.fabio.coatti@gmail.com>
Date: Thu, 17 Sep 2009 00:15:23 +0100
Message-ID: <3ace41890909161615u64d2878i8ddb52c2ba03ea52@mail.gmail.com>
Subject: Re: iwlagn rfkill and 2.6.31 on Intel Corporation PRO/Wireless 5100
	AGN
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mjg@redhat.com" <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 16, 2009 at 11:05 PM, Fabio Coatti <fabio.coatti@gmail.com> wrote:
> In data mercoledì 16 settembre 2009 18:30:19, reinette chatre ha scritto:
>
>> On Wed, 2009-09-16 at 07:57 -0700, Fabio Coatti wrote:
>> > But the behaviour of wifi sybsystem is still weird, (maybe for some
>> > faults on my side). Basically if the laptop starts with wifi enabled
>> > (rfkill off) wpa_supplicant can establish a connection, that can be
>> > killed by rfkill switch (both wifi and bluetooth seems to be killed). But
>> > when I turn off rfkill switch wpa_supplicant is unable to connect again;
>> > looking at syslog/dmesg I can see activity in bt stack, but no messages
>> > regarding wlan0.
>>
>> I think at this point you need to bring the interface back up. When you
>> enable rfkill the interface is brought down, the opposite (bringing
>> interface up) is not done automatically when you disable rfkill.
>>
>
> Ok, I understand your point. In fact I can bring up the interface using
> "ip link set wlan0 up"
> but this leads me to another question: I fail to see how restart the interface
> automatically when rfkill switch is turned off.
> The expected behaviour in this case should be, imho, that wpa_supplicant wakes
> up and restarts the connection.
> IIRC netplug doesn't work with wireless connections and this leaves me
> wondering how I can have wireless la to wake up after turning off rfkill
> switch :)

Hmm, I recently looked to the interaction between rfkill and hal, and
may be able to answer that. The kernel rfkill module also exports its
state via either /dev/rfkill or sysfs's /sys/class/rfkill (depending
on kernel version; I think /dev/rfkill is new to
2.6.31/wireless-testing/compat-wireless, and not in 2.6.30). hald or
devicekit (again, depend on distro/kernel version) monitors those, and
informs NetworkManager via d-bus messaging when the rkfill state
changes. NetworkManager then if up/down the device and tell
wpa_supplicant accordingly. So the ifconfig-interface-up is supposed
to happen automatically, if hald/devicekit works and talk to
NetworkManager.

i.e. the waking-up should happen automatically if you have the
combination of hald/devicekit and networkmanager.

Does this answer your question?
