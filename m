Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:2434 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab3J1JXl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 05:23:41 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: Re: ath10k hits warning in sta_info.c:839.
References: <5266C321.7000103@candelatech.com>
	<5266FAAD.3010800@candelatech.com>
	<CA+BoTQmomxywSjUB9nrniMT+HeZeBD=L3m2K8c=m6ehGcSp7eQ@mail.gmail.com>
Date: Mon, 28 Oct 2013 11:23:31 +0200
In-Reply-To: <CA+BoTQmomxywSjUB9nrniMT+HeZeBD=L3m2K8c=m6ehGcSp7eQ@mail.gmail.com>
	(Michal Kazior's message of "Wed, 23 Oct 2013 09:42:16 +0200")
Message-ID: <871u35eoks.fsf@kamboji.qca.qualcomm.com> (sfid-20131028_102349_736285_92C3F532)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 23 October 2013 00:22, Ben Greear <greearb@candelatech.com> wrote:
>> On 10/22/2013 11:25 AM, Ben Greear wrote:
>>> Kernel is stock 'ath' tree, with small printk to debug an ath10k
>>> crash.
>>>
>>> This is FYI for now...will be looking at other ath10k crash bugs
>>> before digging into this tone.
>>>
>>> Setup is 2 stations trying to associate to same AP, which causes
>>> endless failures and firmware crashes.  Good for chasing bugs :)
>>>
>>>
>>> DMAR:[fault reason 05] PTE Write access is not set
>>> dmar: DRHD: handling fault status reg 3
>>> dmar: DMAR:[DMA Write] Request device [05:00.0] fault addr ffd52000
>>> DMAR:[fault reason 05] PTE Write access is not set
>>> dmar: DRHD: handling fault status reg 3
>>> dmar: DMAR:[DMA Write] Request device [05:00.0] fault addr ffd52000
>>> DMAR:[fault reason 05] PTE Write access is not set
>>>
>>> sta300: authentication with 00:03:83:3d:30:aa timed out
>>> [root@ct523-9292 ~]# ath10k: Failed to delete peer: 00:03:83:3d:30:aa for VDEV: 1
>>> ath10k: WMI vdev stop failed: ret -108
>>
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 1 PID: 6 at /mnt/sda/home/greearb/git/ath/net/mac80211/sta_info.c:839 __sta_info_destroy+0x12)
>>> Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan pktgen lockd f71882fg coretemp hw]
>>
>> I think this may be a result of whatever bug or limitation
>> caused the firmware to error and/or crash when adding a second
>> station VIF and trying to associate it to the same AP.
>>
>> Probably not a problem with the rest of the wifi stacks.
>
> Yup. This originates from the firmware limitation. It's unable to
> handle two peer nodes with same mac addr on different vdevs. That's
> why it's impossible to associate 2 (or more) station interfaces to the
> same BSS.

I think we should add some sort of check to ath10k to detect that and
not crash firmware.

-- 
Kalle Valo
