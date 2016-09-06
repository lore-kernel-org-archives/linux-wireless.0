Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36343 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964859AbcIFRQj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 13:16:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 06 Sep 2016 22:46:38 +0530
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: Ben Greear <greearb@candelatech.com>
Cc: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k:  ensure pdev sta kickout threshold is set.
In-Reply-To: <57CEC0A4.8020808@candelatech.com>
References: <1472843202-12428-1-git-send-email-greearb@candelatech.com>
 <1473147582638.99419@qti.qualcomm.com> <57CEC0A4.8020808@candelatech.com>
Message-ID: <258eb1b46e360aeae1cddfa9185ab1ce@codeaurora.org> (sfid-20160906_191642_890576_0C7521E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-09-06 18:42, Ben Greear wrote:
> On 09/06/2016 12:39 AM, Manoharan, Rajkumar wrote:
>> [...]
>> 
>>> +int ath10k_mac_set_pdev_kickout(struct ath10k *ar)
>>> +{
>>> +       u32 param = ar->wmi.pdev_param->sta_kickout_th;
>>> +       int rv;
>>> +
>>> +       rv = ath10k_wmi_pdev_set_param(ar, param,
>>> +                                      
>>> ar->sta_xretry_kickout_thresh);
>>> +       if (rv) {
>>> +               ath10k_warn(ar, "failed to set sta kickout threshold 
>>> to %d: %d\n",
>>> +                           ar->sta_xretry_kickout_thresh, rv);
>>> +       }
>>> +       return rv;
>>> +}
>>> 
>> Ben,
>> 
>> I plan to get rid of setting station kickout threshold from host. Each 
>> firmware revision (i.e qca988x, qca99x0, ipq4019)  follows different 
>> logic based on hw capability for station kickout and follows different 
>> default paramters. So configuring common threshold will affect 
>> firmware logic. Better to get rid of these configuration from host 
>> driver and let firmware to work with default parameters.
>> 
>> Also I could not find out sta_xretry_kickout_thresh definition in 
>> upstream driver. Have you posted any changes for the same?
> 
> Hmm, maybe that last bit is something I added in another patch.  
> Probably my
> patch to enable firmware config on a per radio basis (fwcfg in my
> tree).  Those patches are
> larger and probably will never make it upstream.
> 
> I need a way to configure this kickout, since firmware is kicking out
> stations when it should
> not.
> 

Could you please explain the scenario?

> Instead of removing the capability, you should instead make it 
> configurable
> through debugfs or something like my fwcfg patches, and/or disable the
> kickout entirely.
> Since mac80211 can deal with kicking out stations already, the stuff
> in the firmware just makes
> things less stable in poor RF environments and/or with stations with
> flaky power-save and
> off-channel roaming.
> 
I plan to get rid of hardcoded value and fix this through proper netlink 
interface instead of debugfs. While ago, I posted a change for 
configuring low ack threshold. It is still pending in my TODO list.

http://comments.gmane.org/gmane.linux.kernel.wireless.general/137645

-Rajkumar
