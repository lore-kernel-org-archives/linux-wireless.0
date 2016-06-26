Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40835 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbcFZA1T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 20:27:19 -0400
Message-ID: <576F2165.3010109@candelatech.com> (sfid-20160626_022723_615901_78B25022)
Date: Sat, 25 Jun 2016 17:27:17 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
CC: Tamizh chelvam <c_traja@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] ath10k: Fix sending NULL/ Qos NULL data frames for
 QCA99X0 and later
References: <1466700001-4883-1-git-send-email-mohammed@qca.qualcomm.com> <1466700001-4883-2-git-send-email-mohammed@qca.qualcomm.com> <576C1861.7020402@candelatech.com> <20160625185350.GA25330@atheros-ThinkPad-T61>
In-Reply-To: <20160625185350.GA25330@atheros-ThinkPad-T61>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/25/2016 11:53 AM, Mohammed Shafi Shajakhan wrote:
> Hello Ben,
>
> On Thu, Jun 23, 2016 at 10:12:01AM -0700, Ben Greear wrote:
>> On 06/23/2016 09:40 AM, Mohammed Shafi Shajakhan wrote:
>>> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>>>
>>> For chipsets like QCA99X0, IPQ4019 and later we are not getting proper
>>> NULL func status (always acked/successs !!) when hostapd does a
>>> PROBE_CLIENT via nullfunc frames when the station is powered off
>>> abruptly (inactive timer probes client via null func after the inactive
>>> time reaches beyond the threshold). Fix this by disabling the workaround
>>> (getting the ACK status of NULL func frames by sending via HTT mgmt-tx
>>>   path) introduced by the change ("ath10k: fix beacon loss handling ")
>>> for QCA99X0 and later chipsets. The normal tx path provides the proper
>>> ACK status for NULL data frames. As of now disable this workaround for
>>> chipsets QCA99X0 and later, once the 10.1 firmware is obselete we can
>>> completely get rid of this workaround for all the chipsets
>>
>> Did you see my fix for the tx-status that Kalle posted about recently?
>> That fixed my problem with 9980, but I normally test status with tx over
>> the htt mgt path instead of wmi path, so possibly that makes a difference.
>
> [shafi] Yes Kalle suggested to try your change (BTW we were not aware that you
> already discovered this problem !!), https://patchwork.kernel.org/patch/8460831/
> but ..

Is there a better way than posting to the ath10k mailing list?  There are quite
a few more of my patches that are stuck in pending or ignored state.  If you
could review some of them and add them to your testing trees then it might help
them go upstream.

Maybe someone else with more time and resources could take over maintainer-ship of ath10k
and let Kalle focus on the drivers in general?

> "[ 747.803652] ath10k_pci 0000:01:00.0: htt tx completion msdu_id 0 discard 0
> no_ack 0 success 1"
>
> "[ 747.803843] ath10k_pci 0001:01:00.0: htt tx completion msdu_id 0 discard 0
> no_ack 0 success 1"
>
> to be more precise looks like we hit this path for MSG type 0xE,( management Tx
> completion indication) path(status ok ??) for null func frame without ACK
>
> case HTT_MGMT_TX_STATUS_OK:
> 	tx_done.status = HTT_TX_COMPL_STATE_ACK;
> 	break;
>
>
> a) The success bit being 'set' without the fix so the change you had mentioned may not help
> for the upstreamed f/w, should we  give a shot with your change as well to
> confirm it ?

I have no good way to know what exact source creates the upstream firmware.  But, grep
around for FILTERED and you will probably see your firmware using that tx code.

It could easily be that both of our patches are correct and needed.

> b) and also the workaround is for older firmware which got fixed in
> 10.2.4 and 10.4, if you can help us that 10.1 also reports NULL func frame
> status properly via normal data path, we can probably get rid of this workaround
> once and for all ? thoughts ?

I can fix my 10.1 if it is not already fixed.  If you are ready to have my
10.1 be the only supported 10.1, then we can do the tests.  If that is the
case, then you should add a feature flag for my firmware and fail to load any
other 10.1 firmware since it would then be guaranteed to fail since you are removing
workarounds for it...

I would rather focus on getting some of the debug patches upstream so that
I can actually make progress on firmware bugs found on stock kernels.  Without
them, I have to ask people to run patched drivers in order to get debug info,
and that is painful for all involved.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

