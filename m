Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2002 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab0CLEpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 23:45:44 -0500
From: Bob Copeland <me@bobcopeland.com>
To: jouni.malinen@atheros.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH/RFC 0/3] hwsim user-space frame processing
Date: Thu, 11 Mar 2010 23:43:16 -0500
Message-Id: <1268368999-12734-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset moves the forwarding of frames in mac80211 hwsim
into user-space.  This gives the ability to simulate loss,
retransmission delays, collisions, etc. in a controlled environment
while still using the whole stack.

A few disclaimers:

 - We don't expire pending (transmitted but not status-reported) packets.
   This is a nice DoS waiting to happen, so that needs to be fixed.

 - This breaks the in-kernel forwarding.  It may be useful to still
   do that for quick-and-dirty testing, via modparam or something.

 - It really wants a configuration ioctl that happens before the device
   is registered, so you can set up the rate set and so forth.  The ABI
   needs work in general.

How to use:

1. Write a program to open /dev/mac80211_hwsim_control for as many radios
   as you want, and shuffle packets between the file descriptors.  Or
   suitably modify my proof-of-concept:

   http://bobcopeland.com/srcs/wifi_sim.tar.gz

2. Set up network namespaces, and put the devices in separate namespaces.
This may no longer be necessary, I haven't kept up.

3. Run hostapd on one interface and connect to it from the other(s).

I keep this patch to unbreak netns, which will likely explode your computer:

---
 net/core/dev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index bcc490c..2306aec 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5628,6 +5628,7 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 	if (dev->features & NETIF_F_NETNS_LOCAL)
 		goto out;
 
+#if 0
 #ifdef CONFIG_SYSFS
 	/* Don't allow real devices to be moved when sysfs
 	 * is enabled.
@@ -5636,6 +5637,7 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 	if (dev->dev.parent)
 		goto out;
 #endif
+#endif
 
 	/* Ensure the device has been registrered */
 	err = -EINVAL;
-- 
1.6.3.3

Here's the set of scripts I use to set up namespaces and run hostapd
and iperf.

(run.sh is just a wrapper around hostapd with the right config file etc.)

connect.sh:
~~~~~~~~~~~
#! /bin/sh

ifconfig wlan1 up
iw dev wlan1 connect -w test 5180
ifconfig wlan1 192.168.10.2
# end connect.sh


start_sim.pl
~~~~~~~~~~~~
#! /usr/bin/perl
# Launch simulation program in different netns.
# You probably have to manually run connect.sh due to timing
# and my Expect lameness.

use Expect;

my $args = join(" ", @ARGV);

my $exp = Expect->spawn("screen") or die "Couldn't start screen";
my $timeout = 3;
my $ctrla = chr(1);
my $sim = "./sim";

$exp->expect($timeout,
    [qr/\[Press Space for next page; Return to end.]/ =>
        sub { 
            my $exp = shift;
            # start screen
            $exp->send("\n");
            wait_prompt($exp);
            # load mac80211_hwsim
            $exp->send("modprobe mac80211_hwsim\n");
            wait_prompt($exp);
            # create a second window
            $exp->send("${ctrla}c");
            wait_prompt($exp);
            # start simulator here
            $exp->send("$sim $args | tee sim.log\n");

            # create a third window
            $exp->send("${ctrla}c");
            # start netns in this window
            $exp->send("./ns_exec -c -n /bin/bash\n");
            exp_continue;
        }],
    [qr/Parent waiting for pid (\d+)/ =>
        sub {
            my $exp = shift;
            my $pid = ($exp->matchlist)[0] . "\n";
            my $phy = `iw dev | head -1`;
            chomp $phy;
            $phy =~ s/.*(phy\d+).*/\1/g;
            print "pid: " . ($exp->matchlist)[0] . ", phy: $phy\n";
            # create loopback
            $exp->send("ip link set lo up\n");
            wait_prompt($exp);

            # start hostapd in background
            $exp->send("cd hostap/hostapd\n");
            wait_prompt($exp);

            $exp->send("iw reg set US\n");
            wait_prompt($exp);

            # go to window 0 and move the device to the other ns
            $exp->send("${ctrla}0");
            $exp->send("iw $phy set netns $pid\n");
            wait_prompt($exp);

            # go back to window 2 and start hostapd in background
            $exp->send("${ctrla}2");
            $exp->send("./run.sh >hostapd.log 2>&1 &\n");
            wait_prompt($exp);

            # start iperf in background
            $exp->send("iperf -s &\n");
            wait_prompt($exp);

            # go back to window 0 and get ready to do something
            $exp->send("${ctrla}0");
            wait_prompt($exp);
            sleep(1);
            $exp->send("./connect.sh\n");
            $exp->interact;
        }]
    );

sub wait_prompt
{
    my $exp = shift;
    $exp->expect($timeout, '#');
}

Bob Copeland (3):
  mac80211_hwsim: extract radio creation code
  mac80211_hwsim: add a control device
  mac80211_hwsim: enable user space frame processing

 drivers/net/wireless/mac80211_hwsim.c |  899 ++++++++++++++++++++-------------
 drivers/net/wireless/mac80211_hwsim.h |   42 ++
 2 files changed, 594 insertions(+), 347 deletions(-)
 create mode 100644 drivers/net/wireless/mac80211_hwsim.h


