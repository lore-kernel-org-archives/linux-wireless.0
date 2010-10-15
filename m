Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:19950 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458Ab0JOVHW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 17:07:22 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 14:07:13 -0700
Date: Fri, 15 Oct 2010 14:07:20 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
Message-ID: <20101015210720.GA2007@tux>
References: <AANLkTi=1oOCcdvBHo+8WAVHv-M8tE14ntmK4M_09SWh5@mail.gmail.com>
 <AANLkTi=pp2Ob06YCi6GsR9rtRaDWPP95n2M72qWLdbwM@mail.gmail.com>
 <20101014225150.GB15740@tux>
 <20101014231958.GA3242@tux>
 <4CB79299.7000005@candelatech.com>
 <AANLkTinQmE6wm1pXkRL6p_3rkMvNrppmirjj3-jagMp8@mail.gmail.com>
 <20101014234853.GA10113@tux>
 <4CB886AF.3070800@candelatech.com>
 <AANLkTinhFj_iYjVzyfSfpUVdytfk4O9kCBnN8=Bwv0N7@mail.gmail.com>
 <4CB8AD3F.50201@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4CB8AD3F.50201@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 15, 2010 at 12:36:31PM -0700, Ben Greear wrote:
> I was just writing that my script wouldn't reproduce it..but it did before I
> was done typing.  Same looking poison exception as ever.

OK I was able to reproduce with the latest patch.

> I also notice my Trendnet AP is very un-happy with anything past around 30 STA
> devices associated, and according to it's status page..NONE of my STAs are associated,
> though things show up in /proc/net/wireless and I see auth/assoc messages in
> /var/log/messages on my STA system, so the AP may just be funky.

Well we are stress testing the hell out of the AP too!

> On my system, most of the STAs are constantly trying to associate and being
> rejected by the AP.
> 
> Here is updated script, creates 130 STAs and sleeps a bit between starting supplicants.
> It assumes you have a single PHY device, and if you do, it will use it's name regardless
> of how many times you reload the driver.
> 
> Please forgive the lameness in the MAC creation logic..though it does at least appear
> to work :)

I'm now using this patch to force pressure:

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index db677c4..2834c41 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -665,6 +665,13 @@ static void ath_rx_send_to_mac80211(struct ieee80211_hw *hw,
 				    struct ieee80211_rx_status *rxs)
 {
 	struct ieee80211_hdr *hdr;
+	struct sk_buff *tmp_skb;
+	unsigned int i;
+
+	for (i=0; i < 5; i++) {
+		tmp_skb = skb_copy(skb, GFP_ATOMIC);
+		dev_kfree_skb_any(tmp_skb);
+	}
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 

And this script, slightly simplified mac address configuration.

#!/usr/bin/perl

use strict;

my $iw = "/usr/sbin/iw";
my $ip = "/sbin/ip";
my $wpa_s = "/usr/local/sbin/wpa_supplicant";
my $ssid = "tesla-2g-bcm";
my $key = "stuff";

my $phy = "phy0";
my $max = 130;
my $i;
my $bmac = "00:01:02:03:04";
my $cmd;

# Create stations
for ($i = 0; $i<$max; $i++) {
	runCmd("$iw phy $phy interface add sta$i type station");
	my $mc5 = sprintf("%02x", $i);
	my $mac = "$bmac:$mc5";
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
   proto=RSN
   key_mgmt=WPA-PSK
   psk=\"$key\"
   pairwise=CCMP
   group=CCMP
}
";
	runCmd("$wpa_s -B -i sta$i -c sta$i" . "_wpa.conf -P sta$i" . "_wpa.pid -t ");
	sleep(2);
}


sub runCmd {
	my $cmd = shift;
	print "$cmd\n";
	`$cmd`;
}
