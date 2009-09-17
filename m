Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:32866 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbZIQMjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 08:39:09 -0400
Received: by bwz19 with SMTP id 19so262980bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2009 05:39:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909171116.19281.fabio.coatti@gmail.com>
References: <200909161521.15710.fabio.coatti@gmail.com>
	 <200909170005.56145.fabio.coatti@gmail.com>
	 <3ace41890909161615u64d2878i8ddb52c2ba03ea52@mail.gmail.com>
	 <200909171116.19281.fabio.coatti@gmail.com>
Date: Thu, 17 Sep 2009 13:39:11 +0100
Message-ID: <3ace41890909170539p29e0f369pf02457e6dca410f5@mail.gmail.com>
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

On Thu, Sep 17, 2009 at 10:16 AM, Fabio Coatti <fabio.coatti@gmail.com> wrote:
> I
>> Hmm, I recently looked to the interaction between rfkill and hal, and
>> may be able to answer that. The kernel rfkill module also exports its
>> state via either /dev/rfkill or sysfs's /sys/class/rfkill (depending
>> on kernel version; I think /dev/rfkill is new to
>> 2.6.31/wireless-testing/compat-wireless, and not in 2.6.30). hald or
>> devicekit (again, depend on distro/kernel version) monitors those, and
>> informs NetworkManager via d-bus messaging when the rkfill state
>> changes. NetworkManager then if up/down the device and tell
>> wpa_supplicant accordingly. So the ifconfig-interface-up is supposed
>> to happen automatically, if hald/devicekit works and talk to
>> NetworkManager.
>>
>> i.e. the waking-up should happen automatically if you have the
>> combination of hald/devicekit and networkmanager.
>>
>> Does this answer your question?
>>
>
> Indeed; it's a good explanation of what's going on. Now I'll follow each step
> of your descripiton and I'll try to find out where the chain breaks :)
>
>
> Many thanks for your help.
>

On my system - hal knows about the killswitch:

$lshal |grep -i killswitch
  info.addons.singleton = {'hald-addon-rfkill-killswitch'} (string list)
  info.capabilities = {'killswitch'} (string list)
  info.category = 'killswitch'  (string)
  info.interfaces = {'org.freedesktop.Hal.Device.KillSwitch'} (string list)
  info.product = 'phy0 wlan Killswitch'  (string)
  killswitch.access_method = 'rfkill'  (string)
  killswitch.name = 'phy0'  (string)
  killswitch.state = 1  (0x1)  (int)
  killswitch.type = 'wlan'  (string)

and NM also wrote to syslog saying it found the switch, and other
stuff when the switch is turned on and off:

#grep kill /var/log/message
...
Sep 16 00:08:48 localhost NetworkManager: <info>  Wireless now
disabled by radio killswitch
Sep 16 00:10:09 localhost NetworkManager: <info>  Wireless now enabled
by radio killswitch
Sep 16 01:40:18 localhost NetworkManager: <info>  Found radio
killswitch /org/freedesktop/Hal/devices/usb_device_XXXXXXX_if0_rfkill_phy0_wlan
...
