Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:60161 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750871AbdJDEwY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 00:52:24 -0400
Message-ID: <1507092741.908.56.camel@intel.com> (sfid-20171004_065228_955576_A44B3091)
Subject: Re: iwlwifi: ToF usage
From: Luciano Coelho <luciano.coelho@intel.com>
To: Joel =?ISO-8859-1?Q?Bjurstr=F6m?= <maxxflow@gmail.com>,
        linux-wireless@vger.kernel.org, assaf.krauss@intel.com,
        johannes.berg@intel.com, emmanuel.grumbach@intel.com
Cc: linuxwifi@intel.com
Date: Wed, 04 Oct 2017 07:52:21 +0300
In-Reply-To: <d3356a70-b90e-d0cc-6328-17f055b2ed1c@maxxflow.com>
References: <981d5fb9-4c3f-be8e-265a-6d21a2591e40@maxxflow.com>
         <d3356a70-b90e-d0cc-6328-17f055b2ed1c@maxxflow.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joel,

Unfortunately we don't have full support for ToF on the mainline kernel
yet.  But you can try to use one of our Core releases (which is a
backports-based tree) that you can find here:

You could try the release/Core30 branch, for example.

--
Cheers,
Luca.

On Thu, 2017-09-21 at 21:35 +0200, Joel Bjurström wrote:
> Including some people I've seen mentioned in ToF-related e-mails...
> 
> This is what I've tried:
> 
> 
> -- Responder --
> 
> * hostapd running, hostapd.conf:
> 	driver=nl80211
> 	interface=wlan1
> 	hw_mode=g
> 	channel=1
> 	wmm_enabled=1
> 	ssid=tof_test
> 	ftm_responder=1
> 	ftm_initiator=1
> 
> $ cd /sys/kernel/debug/iwlwifi/0000:06:00.0/iwlmvm/netdev:wlan1
> $ echo channel_num=1 > tof_responder_params
> $ echo bssid=bb:bb:bb:bb:bb:bb > tof_responder_params
> $ echo rate=1 > tof_responder_params
> $ echo ftm_per_burst=5 > tof_responder_params
> 
> $ echo send_responder_cfg=1 > tof_responder_params
> 
> 
> -- Initiator --
> 
> $ cd /sys/kernel/debug/iwlwifi/0000:06:00.0/iwlmvm/netdev:wlan1
> $ echo send_tof_cfg=1 > tof_enable
> $ echo 'num_of_ap=1' > tof_range_request
> $ echo 'ap=0 1 0 0 bb:bb:bb:bb:bb:bb 0 10 0 5 5 0 0 0 0 -40' \
> 	> tof_range_request
> 
> $ echo 'send_range_request=1' > tof_range_request
> 
> $ cat tof_range_response
> request_id = 0
> status = 2
> last_in_batch = 1
> num_of_aps = 0
> 
> 
> 
> (bb:bb:bb:bb:bb:bb is the responder's BSSID)
> 
> Am I even close? Fumbling in the dark here.
> 
> The 'status = 2' from tof_range_response comes directly from the FW, 
> AFAICT. What do different values mean?
> 
> Cheers,
> Joel
> 
> 
> On 09/14/2017 09:44 PM, Joel B wrote:
> > Hi,
> > 
> > Starting to play around with the FTM/ToF support in iwlwifi, but 
> > documentation is (understandably) scarce at this point. Using a
> > pair of 
> > 8260:s I had lying around.
> > 
> > Can someone give me some hints on how to work the debugfs API for
> > a 
> > successful measurement?
> > 
> > I've set up one card as AP with hostapd (with ftm_responder=1 and 
> > ftm_initiator=1 in hostapd.conf), the other as a STA.
> > 
> >  From the STA, I've played with 'tof_range_request' in debugfs.
> > Writing 
> > send_range_request=1, which it doesn't choke on or anything, but
> > nothing 
> > seems to happen. Guess I need to set things up a bit first, but
> > how?
> > 
> > If it's possible to get this to work at all at this stage, some
> > hints on 
> > how to do it would be great.
> > 
> > 
> > Thanks,
> > Joel
