Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60096 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964886AbcIFR0l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 13:26:41 -0400
Subject: Re: [PATCH] ath10k: ensure pdev sta kickout threshold is set.
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
References: <1472843202-12428-1-git-send-email-greearb@candelatech.com>
 <1473147582638.99419@qti.qualcomm.com> <57CEC0A4.8020808@candelatech.com>
 <258eb1b46e360aeae1cddfa9185ab1ce@codeaurora.org>
Cc: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <880ee88a-6292-ce36-e9d0-d0dd5c9a5a2a@candelatech.com> (sfid-20160906_192644_703759_0E5D6108)
Date: Tue, 6 Sep 2016 10:26:39 -0700
MIME-Version: 1.0
In-Reply-To: <258eb1b46e360aeae1cddfa9185ab1ce@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/06/2016 10:16 AM, Rajkumar Manoharan wrote:
> On 2016-09-06 18:42, Ben Greear wrote:
>> On 09/06/2016 12:39 AM, Manoharan, Rajkumar wrote:
>>> [...]
>>>
>>>> +int ath10k_mac_set_pdev_kickout(struct ath10k *ar)
>>>> +{
>>>> +       u32 param = ar->wmi.pdev_param->sta_kickout_th;
>>>> +       int rv;
>>>> +
>>>> +       rv = ath10k_wmi_pdev_set_param(ar, param,
>>>> +                                      ar->sta_xretry_kickout_thresh);
>>>> +       if (rv) {
>>>> +               ath10k_warn(ar, "failed to set sta kickout threshold to %d: %d\n",
>>>> +                           ar->sta_xretry_kickout_thresh, rv);
>>>> +       }
>>>> +       return rv;
>>>> +}
>>>>
>>> Ben,
>>>
>>> I plan to get rid of setting station kickout threshold from host. Each firmware revision (i.e qca988x, qca99x0, ipq4019)  follows different logic based on hw
>>> capability for station kickout and follows different default paramters. So configuring common threshold will affect firmware logic. Better to get rid of
>>> these configuration from host driver and let firmware to work with default parameters.
>>>
>>> Also I could not find out sta_xretry_kickout_thresh definition in upstream driver. Have you posted any changes for the same?
>>
>> Hmm, maybe that last bit is something I added in another patch.  Probably my
>> patch to enable firmware config on a per radio basis (fwcfg in my
>> tree).  Those patches are
>> larger and probably will never make it upstream.
>>
>> I need a way to configure this kickout, since firmware is kicking out
>> stations when it should
>> not.
>>
>
> Could you please explain the scenario?

A customer reported issues when having a bunch of android tablets connected to
a QCA9880 NIC running my 10.1 CT firmware in AP mode.

It is not clear exactly why the peers suddenly cannot ack packets,
but disabling the logic that kicks out stations due to low acks appears
to resolve the issue.

To turn the question around:  Is there any benefit to having the
firmware handle this keep-alive stuff?

I can see maybe it is useful in station only mode for power-saving reasons,
but not in AP mode.

>> Instead of removing the capability, you should instead make it configurable
>> through debugfs or something like my fwcfg patches, and/or disable the
>> kickout entirely.
>> Since mac80211 can deal with kicking out stations already, the stuff
>> in the firmware just makes
>> things less stable in poor RF environments and/or with stations with
>> flaky power-save and
>> off-channel roaming.
>>
> I plan to get rid of hardcoded value and fix this through proper netlink interface instead of debugfs. While ago, I posted a change for configuring low ack
> threshold. It is still pending in my TODO list.
>
> http://comments.gmane.org/gmane.linux.kernel.wireless.general/137645

That sounds nice.  I would hope that setting the value to 0 would
disable as much firmware keep-alive logic as possible.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
