Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54224 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbbDNAKS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 20:10:18 -0400
Message-ID: <552C5AE9.4050304@candelatech.com> (sfid-20150414_021023_870235_80C177E4)
Date: Mon, 13 Apr 2015 17:10:17 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: ath10k <ath10k@lists.infradead.org>
CC: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: CT ath10k firmware now supports IBSS + RSN
References: <55285D8D.6070703@candelatech.com> <552BFFB8.6030301@candelatech.com>
In-Reply-To: <552BFFB8.6030301@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/13/2015 10:41 AM, Ben Greear wrote:
> Looks like I have some more work to do.  For any moderately large frames,
> I am now dropping the last 16 bytes.  Looks like the skb_put_padto logic
> was working around a more serious issue...

A better-tested version of kernel and firmware is uploaded now.

Looks like I needed to add a hack to firmware to bump pkt-size by
16 for IBSS + RSN encrypted frames.  Not sure exactly why, but seems
to work in light testing.

I removed the skb-padto hack from the kernel, and kernel is rebased on
top of official 4.0 now.

Thanks,
Ben

> On 04/10/2015 04:32 PM, Ben Greear wrote:
>> First, thanks to everyone that helped me with questions,
>> QCA/Tieto's upstream patches, etc.
>>
>> This needs more testing, but it appears to at least mostly work.
>>
>> I am using this 4.0 related kernel.  I think only the last 3 patches
>> are IBSS specific, but possibly there are others that matter as well.
>>
>> http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-4.0.dev.y/.git;a=summary
>>
>> Firmware binaries and release notes are here:
>> http://www.candelatech.com/downloads/ath10k-fw-beta/
>>
>> I'm using a very recent wpa_supplicant..upstream should work I think,
>> but I am using this one:
>>
>> https://github.com/greearb/hostap-ct/tree/master/hostapd
>>
>> supplicant needs to have this enabled, among other things:
>>
>> CONFIG_IBSS_RSN=y
>>
>>
>> I suspect there are lingering bugs, perhaps in supplicant, as it seems to take
>> a few tries for the 4-way to happen properly, and I have to re-start hostapd
>> on each side each time I associate.
>>
>> My supplicant config files look like this (you can comment out any options
>> your supplicant doesn't know about...I have a few extra features not specifically
>> related to IBSS in my hostapd tree)
>>
>> ctrl_interface=/var/run/wpa_supplicant
>> fast_reauth=1
>> concurrent_assoc_ok=1
>> scan_cur_freq=1
>> min_scan_gap=5
>> freq_list=5180
>>
>> bss_max_count=2000
>> network={
>>     ssid="ota-ibss-ssid"
>>     disable_ht=0
>>     disable_vht=0
>>     ieee80211w=0
>>     disable_ht40=1
>>     disable_sgi=0
>>     ht_mcs=""
>>     disable_max_amsdu=-1
>>     ampdu_factor=-1
>>     ampdu_density=-1
>>     freq_list=5180
>>     fixed_freq=1
>>
>>     mode=1
>>     frequency=5180
>>     proto=RSN
>>     key_mgmt=WPA-PSK
>>     #psk="ben-ota-passwd"
>>     psk=fc29b6edf32abd7a9818af3c94b2aa5364c785eee33ed3df11605a3db8f905bc
>>     pairwise=CCMP
>>     group=CCMP
>>     proactive_key_caching=0
>>
>> }
>>
>>
>> I'm curious to know if anyone tries it out.
>>
>> Thanks,
>> Ben
>>
> 
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

