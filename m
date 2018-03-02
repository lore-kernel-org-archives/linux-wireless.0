Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db5eur01on0120.outbound.protection.outlook.com ([104.47.2.120]:46180
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1427285AbeCBLhi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 06:37:38 -0500
Subject: Re: [PATCH net-next 1/2] mac80211_hwsim: Make hwsim_netgroup IDA
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        davem@davemloft.net, johannes@sipsolutions.net,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <151990341305.5011.3514278630677194656.stgit@localhost.localdomain>
 <151990380915.5011.5476607741974762054.stgit@localhost.localdomain>
 <9a826ac0-1354-567b-ec4c-ac8511bf89f6@uni-rostock.de>
From: Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <5319c18f-ce39-0d4c-e140-50b48b73803f@virtuozzo.com> (sfid-20180302_123756_394466_9F04E1E1)
Date: Fri, 2 Mar 2018 14:37:25 +0300
MIME-Version: 1.0
In-Reply-To: <9a826ac0-1354-567b-ec4c-ac8511bf89f6@uni-rostock.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01.03.2018 20:22, Benjamin Beichler wrote:
> Am 01.03.2018 um 12:30 schrieb Kirill Tkhai:
> 
>> Out of bounds of this patch, just as a report to wireless subsystem
>> maintainer, destroy_radio() increaments hwsim_radios_generation
>> without hwsim_radio_lock, so this may need one more patch to fix.
>>
> The lock is here implicit, because the value only could change at init
> (where netlink callbacks are deactivated and always happens sequential)
> or in netlink callbacks. The only reader of this variable is the dump
> callback, and the only other writers are also netlink callbacks and
> because they are implicitly not parallel (because the parallel flag is
> not set), there could be no race condition. Maybe this should be
> documented somehow, especially if somebody got the idea to allow
> parallel callbacks :-)


static void hwsim_exit_net(...)
{
	...
	INIT_WORK(&data->destroy_work, destroy_radio);
        queue_work(hwsim_wq, &data->destroy_work);
	...
}

destroy_radio() may be executed in parallel with everything above you wrote,
doesn't it? There may be several network namespaces, and destroy_radio()
queued from one net namespace may race with mac80211_hwsim_new_radio()
or hwsim_del_radio_nl() for another net namespace. I don't see, how netlink
locking can act on synchronization with a work. This is what I mention.

Thanks,
Kirill
