Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53552 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0JGSj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 14:39:57 -0400
Message-ID: <4CAE13F6.2010003@candelatech.com>
Date: Thu, 07 Oct 2010 11:39:50 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAB59B2.5050106@candelatech.com> <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com> <4CAB5F3D.9060201@candelatech.com> <AANLkTimV3GrwU+9PPtirT4sCzveLY2egr3PRQhfDBET1@mail.gmail.com> <4CAB627F.8020804@candelatech.com> <AANLkTi=sT5QJe4V8gFGjF-nzx0uJAMLG_XG2715qrEEd@mail.gmail.com> <4CAB64AD.4080105@candelatech.com> <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com> <4CAB6B08.4050801@candelatech.com> <4CAE0474.4090605@candelatech.com> <1286475250.20974.22.camel@jlt3.sipsolutions.net> <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com>
In-Reply-To: <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/07/2010 11:29 AM, Luis R. Rodriguez wrote:
> On Thu, Oct 7, 2010 at 11:14 AM, Johannes Berg
> <johannes@sipsolutions.net>  wrote:
>> On Thu, 2010-10-07 at 10:33 -0700, Ben Greear wrote:
>>> In case it helps, here is a dump of where the corrupted SKB was deleted.
>>
>> I wonder, do you have a machine with a decent IOMMU? Adding IOMMU
>> debugging into the mix could help you figure out if it's a DMA problem.
>
> Ben, how much traffic are you RX'ing on these virtual interfaces?

I disabled my user-space application, and this script alone can reproduce
the problem fairly quickly on my system.  You will need to change some
of those first variables.  Just start it and wait a few minutes and
watch the splats show on the console :)

Note that I am not generating any traffic, but the wpa_supplicants are
doing their thing of course...

I'm using the kernel found here:
http://dmz2.candelatech.com/git/gitweb.cgi?p=linux.wireless-testing.ct/.git;a=summary

It's latest wireless-testing with some of my own patches, and some
I've gathered from here an there.  I doubt I'm causing this problem,
but if you can't reproduce it with this script on your kernels,
I can try with base wireless-testing or whatever you are using.


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


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

