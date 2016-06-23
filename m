Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57047 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbcFWRMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 13:12:06 -0400
Message-ID: <576C1861.7020402@candelatech.com> (sfid-20160623_191210_742937_179276D2)
Date: Thu, 23 Jun 2016 10:12:01 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	ath10k@lists.infradead.org
CC: mohammed@codeaurora.org, linux-wireless@vger.kernel.org,
	Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] ath10k: Fix sending NULL/ Qos NULL data frames for
 QCA99X0 and later
References: <1466700001-4883-1-git-send-email-mohammed@qca.qualcomm.com> <1466700001-4883-2-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1466700001-4883-2-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/23/2016 09:40 AM, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> For chipsets like QCA99X0, IPQ4019 and later we are not getting proper
> NULL func status (always acked/successs !!) when hostapd does a
> PROBE_CLIENT via nullfunc frames when the station is powered off
> abruptly (inactive timer probes client via null func after the inactive
> time reaches beyond the threshold). Fix this by disabling the workaround
> (getting the ACK status of NULL func frames by sending via HTT mgmt-tx
>   path) introduced by the change ("ath10k: fix beacon loss handling ")
> for QCA99X0 and later chipsets. The normal tx path provides the proper
> ACK status for NULL data frames. As of now disable this workaround for
> chipsets QCA99X0 and later, once the 10.1 firmware is obselete we can
> completely get rid of this workaround for all the chipsets

Did you see my fix for the tx-status that Kalle posted about recently?
That fixed my problem with 9980, but I normally test status with tx over
the htt mgt path instead of wmi path, so possibly that makes a difference.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

