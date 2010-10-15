Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42566 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab0JOTge (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 15:36:34 -0400
Message-ID: <4CB8AD3F.50201@candelatech.com>
Date: Fri, 15 Oct 2010 12:36:31 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <AANLkTimp_GSwwX_RnQSyN9QNe55HQ+0HZJ1yd8Xp+dWG@mail.gmail.com> <AANLkTinyVqdgPqzpyihuaPtVVqDmzj-ZbXzQ-4qdA2yH@mail.gmail.com> <4CB77EA0.1000005@candelatech.com> <AANLkTimC0+6PiqWO+LmtBV7uKCVpZueAQs6m_6kAnbq9@mail.gmail.com> <AANLkTi=1oOCcdvBHo+8WAVHv-M8tE14ntmK4M_09SWh5@mail.gmail.com> <AANLkTi=pp2Ob06YCi6GsR9rtRaDWPP95n2M72qWLdbwM@mail.gmail.com> <20101014225150.GB15740@tux> <20101014231958.GA3242@tux> <4CB79299.7000005@candelatech.com> <AANLkTinQmE6wm1pXkRL6p_3rkMvNrppmirjj3-jagMp8@mail.gmail.com> <20101014234853.GA10113@tux> <4CB886AF.3070800@candelatech.com> <AANLkTinhFj_iYjVzyfSfpUVdytfk4O9kCBnN8=Bwv0N7@mail.gmail.com>
In-Reply-To: <AANLkTinhFj_iYjVzyfSfpUVdytfk4O9kCBnN8=Bwv0N7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/15/2010 11:47 AM, Luis R. Rodriguez wrote:
> On Fri, Oct 15, 2010 at 9:51 AM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 10/14/2010 04:48 PM, Luis R. Rodriguez wrote:
>>>
>>> On Thu, Oct 14, 2010 at 04:39:45PM -0700, Luis R. Rodriguez wrote:
>>>>
>>>> On Thu, Oct 14, 2010 at 4:30 PM, Ben Greear<greearb@candelatech.com>
>>>>   wrote:
>>>>>
>>>>> On 10/14/2010 04:19 PM, Luis R. Rodriguez wrote:
>>>>>>
>>>>>> Ok please try this patch, it cures it for me.
>>>>>
>>>>> Well, it got a lot further than normal, but it still
>>>>> hit the poison check after a few minutes.
>>>>>
>>>>> Current test case is my app loading 130 or so stations, each running
>>>>> wpa_supplicant.  All were created, and quite a few had associated
>>>>> when the poison check hit.
>>>>>
>>>>> So, it definitely looks like a step in the right direction, but
>>>>> not fully fixed yet.
>>>>>
>>>>> I'll do some more testing with this patch applied and using just my
>>>>> perl script to make sure the problem is reproducible outside of my
>>>>> application.
>>>>
>>>> Ok, whatever userspace does it should not corrupt to kernel, unless
>>>> its poking /dev/mem
>>>
>>> Can also try this one instead, it will prevent any other instances
>>> we would not have caught on stopping and starting RX here.
>>
>> It ran longer than before any of your locking patches (about 3 minutes), but
>> it did hit the poison check.
>>
>> Before it did, I had a bunch of OOM errors trying to allocate
>> skbs.  I have 2GB of RAM on this system, but maybe it's not tuned
>> properly, and not all of that can be used for networking on 32-bit
>> kernels....
>>
>> I have Felix's 3 ani patches from ~3 days ago applied, running 130 stations
>> in WPA mode.
>>
>> I'm going to try running fewer to dodge the OOM case,
>> but I have a few other things to take care of first.
>
> Thanks for testing. So now I cannot reproduce the poison anymore, any
> other ideas what I can try? Does the perl script still give you poison
> or just with your Über proprietary application?

I was just writing that my script wouldn't reproduce it..but it did before I
was done typing.  Same looking poison exception as ever.

I also notice my Trendnet AP is very un-happy with anything past around 30 STA
devices associated, and according to it's status page..NONE of my STAs are associated,
though things show up in /proc/net/wireless and I see auth/assoc messages in
/var/log/messages on my STA system, so the AP may just be funky.

On my system, most of the STAs are constantly trying to associate and being
rejected by the AP.

Here is updated script, creates 130 STAs and sleeps a bit between starting supplicants.
It assumes you have a single PHY device, and if you do, it will use it's name regardless
of how many times you reload the driver.

Please forgive the lameness in the MAC creation logic..though it does at least appear
to work :)

Thanks,
Ben


#!/usr/bin/perl

use strict;

my $iw = "./local/sbin/iw";
my $ip = "./local/sbin/ip";
my $wpa_s = "./local/bin/wpa_supplicant";
my $ssid = "candela-n";
my $key = "wpadmz123";

my $phy = `cat /sys/class/ieee80211/*/name`;
chomp($phy);
my $max = 130;
my $i;
my $j = 4;
my $k = 1;
my $bmac = "00:01:02:03:";
my $cmd;

# Create stations
for ($i = 0; $i<$max; $i++) {
   runCmd("$iw phy $phy interface add sta$i type station");
   if ($j > 99) {
     $j = 1;
     $k++;
   }
   my $mc5 = "$j";
   if (length($mc5) == 1) {
     $mc5 = "0$mc5"; # pad mac octet
   }
   my $mc4 = "$k";
   if (length($mc4) == 1) {
     $mc4 = "0$mc4"; # pad mac octet
   }
   $j++;

   my $mac = "$bmac$mc4:$mc5";
   runCmd("$ip link set sta$i address $mac");

   runCmd("$iw dev sta$i set power_save off");
}

# Bring them up with WPA
for ($i = 0; $i<$max; $i++) {
   open(FD, ">sta$i" . "_wpa.conf") || die("Couldn't open file: $!\n");
   print FD "
ctrl_interface=/var/run/wpa_supplicant
fast_reauth=1
#can_scan_one=1
network={
     ssid=\"$ssid\"
     proto=WPA
     key_mgmt=WPA-PSK
     psk=\"$key\"
     pairwise=TKIP CCMP
     group=TKIP CCMP
}
";
   runCmd("$wpa_s -B -i sta$i -c sta$i" . "_wpa.conf -P sta$i" . "_wpa.pid -t -f sta$i" . "_wpa.log");
   sleep(2);
}


sub runCmd {
   my $cmd = shift;
   print "$cmd\n";
   `$cmd`;
}



>
>    Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

