Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coco.cs.washington.edu ([128.208.3.82]:55229 "EHLO
	coco.cs.washington.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab0CDKZf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 05:25:35 -0500
Subject: Re: [ipw3945-devel] iwl4965: 11a channels disabled in current wireless-testing
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Daniel Halperin <dhalperi@cs.washington.edu>
In-Reply-To: <0A6DB552-23FC-46ED-9326-60EB0370C062@cs.washington.edu>
Date: Thu, 4 Mar 2010 02:24:01 -0800
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Message-Id: <C2DE0F0B-F62A-47BC-A719-E8A598146776@cs.washington.edu>
References: <201002281534.11656.helmut.schaa@googlemail.com> <201003011927.53208.helmut.schaa@googlemail.com> <43e72e891003011059v564931e2qfe390657b698c277@mail.gmail.com> <201003022047.10196.helmut.schaa@googlemail.com> <1267640304.15761.121.camel@rchatre-DESK> <03690D90-3C5E-4E37-8BC6-7EE6FE0B4E1D@cs.washington.edu> <1267651173.15761.155.camel@rchatre-DESK> <0A6DB552-23FC-46ED-9326-60EB0370C062@cs.washington.edu>
To: reinette chatre <reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mar 3, 2010, at 2:54 PM, Daniel Halperin wrote:

> 
> On Mar 3, 2010, at 1:19 PM, reinette chatre wrote:
>> 
>>> With some update between now and a while ago (October?) I can no
>>> longer even monitor on most 11a channels. (E.g., "iwconfig wlan0 mode
>>> monitor ; iwconfig wlan0 channel 64" returns an error). This was not
>>> the old behavior, and seems to be wrong to me.
>> 
>> What error do you get? Have you tried to set up monitor channel using
>> iw? Is bisect an option to try to find out what caused this?
> 
> Haven't dug into it yet; I will though!

Here's some initial analysis. Comments are inline at the commands I entered, and summary at the bottom. I think the problem is that iwlwifi doesn't implement/register reg_notifier with the relevant cfg80211 code in net/wireless/reg.c . I'm using Ubuntu 8.04 LTS, iwlwifi-2.6.git tip (2f12075065fc81c848a75a5c51cf2ddece8036c9) and I just updated/reinstalled my CRDA. 

# rmmod iwlagn iwlcore mac80211 cfg80211   [this last resets CRDA to world domain]
# modprobe iwlagn debug50=0x40003	   [iwlwifi's MAC80211 and INFO debug flags, plus the firmware crash dump flag]
# iw list				   [Note that channels 64 and nearby are completely disabled in world domain]
[...]
		Frequencies:
			* 5180 MHz [36] (15.0 dBm) (passive scanning, no IBSS)
			* 5200 MHz [40] (15.0 dBm) (passive scanning, no IBSS)
			* 5220 MHz [44] (15.0 dBm) (passive scanning, no IBSS)
			* 5240 MHz [48] (15.0 dBm) (passive scanning, no IBSS)
			* 5260 MHz [52] (disabled)
			* 5280 MHz [56] (disabled)
			* 5300 MHz [60] (disabled)
			* 5320 MHz [64] (disabled)
			* 5500 MHz [100] (disabled)
			* 5520 MHz [104] (disabled)
			* 5540 MHz [108] (disabled)
			* 5560 MHz [112] (disabled)
			* 5580 MHz [116] (disabled)
			* 5600 MHz [120] (disabled)
			* 5620 MHz [124] (disabled)
			* 5640 MHz [128] (disabled)
			* 5660 MHz [132] (disabled)
			* 5680 MHz [136] (disabled)
			* 5700 MHz [140] (disabled)
			* 5745 MHz [149] (15.0 dBm) (passive scanning, no IBSS)
			* 5765 MHz [153] (15.0 dBm) (passive scanning, no IBSS)
			* 5785 MHz [157] (15.0 dBm) (passive scanning, no IBSS)
			* 5805 MHz [161] (15.0 dBm) (passive scanning, no IBSS)
			* 5825 MHz [165] (15.0 dBm) (passive scanning, no IBSS)
[...]

# iw reg get			  [Note that channels 64 and nearby are completely disabled in world domain, matches iw list]
country 00:
	(2402 - 2472 @ 40), (3, 20)
	(2457 - 2482 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS
	(2474 - 2494 @ 20), (3, 20), NO-OFDM, PASSIVE-SCAN, NO-IBSS
	(5170 - 5250 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
	(5735 - 5835 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS

# iw reg set US
# iw reg get			  [Now channel 64 (5320) is a legitimate channel]
country US:
	(2402 - 2472 @ 40), (3, 27)
	(5170 - 5250 @ 40), (3, 17)
	(5250 - 5330 @ 40), (3, 20), DFS
	(5490 - 5600 @ 40), (3, 20), DFS
	(5650 - 5710 @ 40), (3, 20), DFS
	(5735 - 5835 @ 40), (3, 30)

# iw list			  [cfg80211 + mac80211 + iwlwifi didn't notice the regulatory change!]
[...]
		Frequencies:
			* 5180 MHz [36] (15.0 dBm) (passive scanning, no IBSS)
			* 5200 MHz [40] (15.0 dBm) (passive scanning, no IBSS)
			* 5220 MHz [44] (15.0 dBm) (passive scanning, no IBSS)
			* 5240 MHz [48] (15.0 dBm) (passive scanning, no IBSS)
			* 5260 MHz [52] (disabled)
			* 5280 MHz [56] (disabled)
			* 5300 MHz [60] (disabled)
			* 5320 MHz [64] (disabled)
			* 5500 MHz [100] (disabled)
			* 5520 MHz [104] (disabled)
			* 5540 MHz [108] (disabled)
			* 5560 MHz [112] (disabled)
			* 5580 MHz [116] (disabled)
			* 5600 MHz [120] (disabled)
			* 5620 MHz [124] (disabled)
			* 5640 MHz [128] (disabled)
			* 5660 MHz [132] (disabled)
			* 5680 MHz [136] (disabled)
			* 5700 MHz [140] (disabled)
			* 5745 MHz [149] (15.0 dBm) (passive scanning, no IBSS)
			* 5765 MHz [153] (15.0 dBm) (passive scanning, no IBSS)
			* 5785 MHz [157] (15.0 dBm) (passive scanning, no IBSS)
			* 5805 MHz [161] (15.0 dBm) (passive scanning, no IBSS)
			* 5825 MHz [165] (15.0 dBm) (passive scanning, no IBSS)

[...]

# rmmod iwlagn && modprobe iwlagn debug50=0x40003
# iw list			  [everything's better!]
[...]
		Frequencies:
			* 5180 MHz [36] (15.0 dBm) (passive scanning, no IBSS)
			* 5200 MHz [40] (15.0 dBm) (passive scanning, no IBSS)
			* 5220 MHz [44] (15.0 dBm) (passive scanning, no IBSS)
			* 5240 MHz [48] (15.0 dBm) (passive scanning, no IBSS)
			* 5260 MHz [52] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5280 MHz [56] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5300 MHz [60] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5320 MHz [64] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5500 MHz [100] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5520 MHz [104] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5540 MHz [108] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5560 MHz [112] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5580 MHz [116] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5600 MHz [120] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5620 MHz [124] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5640 MHz [128] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5660 MHz [132] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5680 MHz [136] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5700 MHz [140] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5745 MHz [149] (15.0 dBm) (passive scanning, no IBSS)
			* 5765 MHz [153] (15.0 dBm) (passive scanning, no IBSS)
			* 5785 MHz [157] (15.0 dBm) (passive scanning, no IBSS)
			* 5805 MHz [161] (15.0 dBm) (passive scanning, no IBSS)
			* 5825 MHz [165] (15.0 dBm) (passive scanning, no IBSS)
[...]

I have a guess as to the problem. In net/wireless/reg.c:wiphy_update_regulatory, the cfg80211 regulatory code is as follows:

        printk("%s: here\n", __func__);
        if (wiphy->reg_notifier) {
                printk("%s: here 1\n", __func__);
                wiphy->reg_notifier(wiphy, last_request);
        }

(obviously, the printk's are added). Looking at my dmesg, the second printk is never called, so Intel doesn't set a reg_notifier. This looks to be the mechanism by which it should be notified of the regulatory change, so the flag's aren't getting updated until the next time the driver is reloaded. And, given that the flags need to be an OR of the CRDA regulatory flags and the driver regulatory flags, it's presumably the driver's responsibility to update these flags. I note that ath9k does have a reg_notifier.

My hypothesis as to why this code used to work is that I was using the CONFIG_WIRELESS_OLD_REGULATORY.

Dan