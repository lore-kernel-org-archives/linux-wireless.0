Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40275 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab0JNWF2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 18:05:28 -0400
Message-ID: <4CB77EA0.1000005@candelatech.com>
Date: Thu, 14 Oct 2010 15:05:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAE1DFB.303@candelatech.com>	<1286479642.20974.32.camel@jlt3.sipsolutions.net>	<AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com>	<AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com>	<AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com>	<4CB378CD.1080800@candelatech.com>	<AANLkTim42zmDwf744BCrPwa1kT5ph57bNMyvSyOpesVv@mail.gmail.com>	<4CB3D598.7050904@candelatech.com>	<AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com>	<4CB4AA89.1070009@candelatech.com>	<20101013053141.GA15798@vasanth-laptop>	<4CB5E0A8.5020502@candelatech.com>	<AANLkTimp_GSwwX_RnQSyN9QNe55HQ+0HZJ1yd8Xp+dWG@mail.gmail.com> <AANLkTinyVqdgPqzpyihuaPtVVqDmzj-ZbXzQ-4qdA2yH@mail.gmail.com>
In-Reply-To: <AANLkTinyVqdgPqzpyihuaPtVVqDmzj-ZbXzQ-4qdA2yH@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/14/2010 02:52 PM, Björn Smedman wrote:
> 2010/10/13 Björn Smedman<bjorn.smedman@venatech.se>:
>> Hi Ben,
>>
>> First of all keep up the good work. :)
>>
>> On Wed, Oct 13, 2010 at 6:39 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> [snip]
>>> Either way, it seems safer to null out the bf_ampdu field after
>>> the memory is consumed..it could prevent some tricky bugs later.
>>
>> I think this is a good idea. But it probably wont be enough to null
>> out bf_mpdu. You also need to look at bf_buf_addr (which if I
>> understand correctly is the physical address the DMA engine will
>> actually write RXed frames to) and bf_dmacontext (which seems in most
>> cases to hold an identical address and may in fact be where the DMA
>> engine will really write the frame).
>
> I took another look at the code. It turns out both bf_buf_addr and
> bf_dmacontext are in fact meaningless to the DMA. Instead each bf
> holds a pointer (bf_desc) to the real DMA descriptor which in turn
> holds the address (ds_data) where the DMA will really (really this
> time) write the frame. There is also a field to hold the virtual
> address of the same place (ds_vdata).
>
> It's a little too much work for me to set up the testbed you have Ben
> but would be interesting to see what happens if you set
> bf->bf_desc->ds_{data,vdata} = 0 as well. No?

I'll investigate those suggestions.

But setting up a test-bed is as easy
as getting an ath9k NIC in a system, with a few APs around, and run the
script below.

You do not need any traffic generation, dhcp, etc...seems just beacons and whatever
wpa_supplicant is doing is enough to hit the problem fast.  (Make sure
you are compiled to detect memory poisoning, of course).

You'll need to fix the paths to the executables most likely.



#!/usr/bin/perl

use strict;

my $iw = "./local/sbin/iw";
my $ip = "./local/sbin/ip";
my $wpa_s = "./local/bin/wpa_supplicant";
my $ssid = "candela-n";
my $key = "wpadmz123";

my $phy = "phy0";
my $max = 32;
my $i;
my $bmac = "00:01:02:03:04:";
my $cmd;

# Create stations
for ($i = 0; $i<$max; $i++) {
   runCmd("$iw phy $phy interface add sta$i type station");
   my $mc5 = "$i";
   if (length($mc5) == 1) {
     $mc5 = "0$mc5"; # pad mac octet
   }
   my $mac = "$bmac$mc5";
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
}


sub runCmd {
   my $cmd = shift;
   print "$cmd\n";
   `$cmd`;
}


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

