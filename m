Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:57106 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751738AbdIUTft (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 15:35:49 -0400
Received: by mail-lf0-f53.google.com with SMTP id a18so6738637lfl.13
        for <linux-wireless@vger.kernel.org>; Thu, 21 Sep 2017 12:35:48 -0700 (PDT)
From: "=?UTF-8?Q?Joel_Bjurstr=c3=b6m?=" <maxxflow@gmail.com>
Subject: Re: iwlwifi: ToF usage
To: linux-wireless@vger.kernel.org, assaf.krauss@intel.com,
        luciano.coelho@intel.com, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com
References: <981d5fb9-4c3f-be8e-265a-6d21a2591e40@maxxflow.com>
Message-ID: <d3356a70-b90e-d0cc-6328-17f055b2ed1c@maxxflow.com> (sfid-20170921_213553_171372_99B7D8B7)
Date: Thu, 21 Sep 2017 21:35:46 +0200
MIME-Version: 1.0
In-Reply-To: <981d5fb9-4c3f-be8e-265a-6d21a2591e40@maxxflow.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Including some people I've seen mentioned in ToF-related e-mails...

This is what I've tried:


-- Responder --

* hostapd running, hostapd.conf:
	driver=nl80211
	interface=wlan1
	hw_mode=g
	channel=1
	wmm_enabled=1
	ssid=tof_test
	ftm_responder=1
	ftm_initiator=1

$ cd /sys/kernel/debug/iwlwifi/0000:06:00.0/iwlmvm/netdev:wlan1
$ echo channel_num=1 > tof_responder_params
$ echo bssid=bb:bb:bb:bb:bb:bb > tof_responder_params
$ echo rate=1 > tof_responder_params
$ echo ftm_per_burst=5 > tof_responder_params

$ echo send_responder_cfg=1 > tof_responder_params


-- Initiator --

$ cd /sys/kernel/debug/iwlwifi/0000:06:00.0/iwlmvm/netdev:wlan1
$ echo send_tof_cfg=1 > tof_enable
$ echo 'num_of_ap=1' > tof_range_request
$ echo 'ap=0 1 0 0 bb:bb:bb:bb:bb:bb 0 10 0 5 5 0 0 0 0 -40' \
	> tof_range_request

$ echo 'send_range_request=1' > tof_range_request

$ cat tof_range_response
request_id = 0
status = 2
last_in_batch = 1
num_of_aps = 0



(bb:bb:bb:bb:bb:bb is the responder's BSSID)

Am I even close? Fumbling in the dark here.

The 'status = 2' from tof_range_response comes directly from the FW, 
AFAICT. What do different values mean?


Cheers,
Joel


On 09/14/2017 09:44 PM, Joel B wrote:
> Hi,
> 
> Starting to play around with the FTM/ToF support in iwlwifi, but 
> documentation is (understandably) scarce at this point. Using a pair of 
> 8260:s I had lying around.
> 
> Can someone give me some hints on how to work the debugfs API for a 
> successful measurement?
> 
> I've set up one card as AP with hostapd (with ftm_responder=1 and 
> ftm_initiator=1 in hostapd.conf), the other as a STA.
> 
>  From the STA, I've played with 'tof_range_request' in debugfs. Writing 
> send_range_request=1, which it doesn't choke on or anything, but nothing 
> seems to happen. Guess I need to set things up a bit first, but how?
> 
> If it's possible to get this to work at all at this stage, some hints on 
> how to do it would be great.
> 
> 
> Thanks,
> Joel
