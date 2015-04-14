Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34263 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbbDNPBn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 11:01:43 -0400
Message-ID: <552D2BD5.7050204@candelatech.com> (sfid-20150414_170146_741026_F8570426)
Date: Tue, 14 Apr 2015 08:01:41 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: ath10k <ath10k@lists.infradead.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: CT ath10k firmware now supports IBSS + RSN
References: <55285D8D.6070703@candelatech.com>	<552BFFB8.6030301@candelatech.com>	<552C5AE9.4050304@candelatech.com> <CA+BoTQ=C0xxDifiiQVbyBe=OHYUjzHcu49mULJpU+=2SNCZ-dQ@mail.gmail.com>
In-Reply-To: <CA+BoTQ=C0xxDifiiQVbyBe=OHYUjzHcu49mULJpU+=2SNCZ-dQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/13/2015 10:34 PM, Michal Kazior wrote:
> On 14 April 2015 at 02:10, Ben Greear <greearb@candelatech.com> wrote:
>> On 04/13/2015 10:41 AM, Ben Greear wrote:
>>> Looks like I have some more work to do.  For any moderately large frames,
>>> I am now dropping the last 16 bytes.  Looks like the skb_put_padto logic
>>> was working around a more serious issue...
>>
>> A better-tested version of kernel and firmware is uploaded now.
>>
>> Looks like I needed to add a hack to firmware to bump pkt-size by
>> 16 for IBSS + RSN encrypted frames.  Not sure exactly why, but seems
>> to work in light testing.
>>
>> I removed the skb-padto hack from the kernel, and kernel is rebased on
>> top of official 4.0 now.
>
> Hmm.. Maybe this is related to MMIC. Maybe frame fragment length must
> be different from frame length (ath10k_htt_tx(),
> htt_data_tx_desc_frag)? Perhaps a similar hack as with RAW txmode[1]
> needs to be applied..?
>
>
> [1]: https://www.mail-archive.com/ath10k@lists.infradead.org/msg00241.html

This IBSS+RSN hack could be done in the kernel, but if my firmware is the only thing that
needs it, then it is more convenient for me to hack firmware than have it
incompatible with upstream drivers.

If you do find similar problems with other firmware, then certainly a driver
patch is welcome, and I will back out my firmware hack accordingly.

And, it would be nice if someone put some version if your raw-tx patch upstream.
I can also adjust length for raw pkts in firmware too, but again, in many cases
it is better to be similarly broken to existing firmware than to be technically
correct but break compatibility with the driver.  If I ever get a 'ct-firmware'
feature flag upstream, then we could of course do the changes to take advantage
of my firmwares differences as needed.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
