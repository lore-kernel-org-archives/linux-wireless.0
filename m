Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.183]:57705 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbYIOIci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 04:32:38 -0400
Received: from [192.168.0.136] (pc-029 [192.168.0.136])
	by corscience.de (Postfix) with ESMTP id BF93951BA9
	for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 10:32:35 +0200 (CEST)
Message-ID: <48CE1DA2.2030406@corscience.de> (sfid-20080915_103241_724462_A707293F)
Date: Mon, 15 Sep 2008 10:32:34 +0200
From: sHittmeyer <hittmeyer@corscience.de>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org >> \"linux-wireless@vger.kernel.org\""
	<linux-wireless@vger.kernel.org>
Subject: couldn't configure AR5416
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I've got a Kernel-2.6.23 running on my Targetsystem (M54455EVB) and 
compiled "compat-wireless-2.6-old" for that system, for using a D-Link 
DWA-547 with AR5416 chip.

I successfully loaded all necessary modules (cfg80211.ko mac80211.ko 
ath9k.ko) and "insmod"-ed them.
The ath9k driver responded after loading:
/
    ath9k: 0.1
    PCI: Enabling device 0000:00:14.0 (0000 -> 0002)
    Registered led device: ath9k-phy0:radio
    Registered led device: ath9k-phy0:assoc
    Registered led device: ath9k-phy0:tx
    Registered led device: ath9k-phy0:rx
    phy0: Atheros 5416: mem=0xa0000000, irq=67/

which seams like it works.
with "ifconfig wlan0 up" I can bring the system up and can check it with 
"ifconfig wlan0"
/
    wlan0     Link encap:Ethernet  HWaddr 00:19:5B:43:F5:ED
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
    wmaster0  Link encap:UNSPEC  HWaddr 
00-19-5B-43-F5-ED-80-1D-00-00-00-00-00-00-00-00
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)/

additionally I installed the actual "wireless tools for Linux"-Package 
in version 29 from
http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html to be 
compatible with the
new stack from compat-wireless-2.6-old.
But trying to configure the device creates the following 
Kernel-error-message:
/
iwconfig wlan0 essid wireless
/ # WARNING: at 
/home/stefan/00_Targetsourcen/compat-wireless-2.6-old/net/mac80211/tx.c:1264 
ieee80211_tx()
Stack from cf5a1ea0:
       <0> cf5a1eb0<0> cf968691<0> d006d1d6<0> d007720d<0> d0077283<0> 
000004f0<0> d00756b4<0> 00000000
       <0> c002c8e8(printk+0x0/0x1e)<0> c01ab8ec(kfree_skb+0x0/0x26)<0> 
c01ba90c(net_ratelimit+0x0/0x18)<0> c0025258(dump_stack+0x0/0x16)<0> 
cf58edc0<0> cf58edc0<0> cf86e000<0> c01b0d1e(dev_hard_start_xmit+0x0/0x212)
       <0> c01acf58(skb_segment+0x106/0x55e)<0> edc0cf1b<0> e000cf96<0> 
8180cf1b<0> e3800000<0> 00000000<0> 0000cf96<0> 9a2a0000
       <0> 00000000<0> 00000000<0> 00406c65<0> 00000000<0> 
c01bd14e(__qdisc_run+0x4a/0x156)<0> cf58edc0<0> cf86e000<0> 00000000
       <0> c002c8e8(printk+0x0/0x1e)<0> cfe5687c<0> 
c0047158(__print_symbol+0x0/0x32)<0> cf86e000<0> cf58edc0<0> cf1be000<0> 
d0062726<0> c01b322c(dev_queue_xmit+0x202/0x252)
       <0> cf86e000<0> cfe566c0<0> cf968180<0> cf968040<0> d006285e<0> 
cf58edc0<0> cf58edc0<0> 00000000
Call Trace:
       <0> [<c0038c08>]<0> [<c0038b7e>]<0> [<c003c08c>]<0> [<c02248a0>]
       <0> [<c003bccc>]<0> [<c003c126>]<0> [<c00390fa>]<0> [<c0039736>]
       <0> [<c0224ce2>]<0> [<c003bccc>]<0> [<c003906e>]<0> [<c0026ec8>]
       <0> [<c00216fa>]<0> [<c003c22e>]<0> [<c003bd34>]<0> [<c003bcda>]
       <0> [<c02248a0>]<0> [<c0021734>]/

Moreover even displaying the cardsetup with "iwconfig wlan0" or 
displaying the accessable networks with "iwlist scan" throws the 
errormessage "Illegal instruction". I grep-ed for that expression in 
sources of "wireless tools for linux", compat-wirless-2.6-old and 
kernel-sources but couldn't find it ... could this string be sent by the 
card?

I looked up the /compat-wireless-2.6-old/net/mac80211/tx.c:1264 and 
found the following:

Line:
1250             * possible to have happened.
                     */
                    if (!__netif_subqueue_stopped(local->mdev, queue)) {
            #if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,22))
                        clear_bit(IEEE80211_LINK_STATE_PENDING,
1255               &local->state[queue]);
            #else
                        clear_bit(queue, local->queues_pending);
            #endif
                        retries++;
1260                 /*
                         * Driver bug, it's rejecting packets but
                         * not stopping queues.
                         */
1264                        if (WARN_ON_ONCE(retries > 5))
                            goto drop;
                        goto retry;
                    }
                    store->skb = skb;
                    store->extra_frag = tx.extra_frag;
                    store->num_extra_frag = tx.num_extra_frag;
                    store->last_frag_rate_idx = tx.last_frag_rate_idx;
                    store->last_frag_rate_ctrl_probe =
                        !!(tx.flags & IEEE80211_TX_PROBE_LAST_FRAG);
                }
             out:
                rcu_read_unlock();
                return 0;
   
             drop:
1280            if (skb)  


/Has anybody an idea whats going wrong?
Thanks a lot for your help and time

regards
Stefan Hittmeyer
