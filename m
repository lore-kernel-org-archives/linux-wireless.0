Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47649 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbaIWQ5t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 12:57:49 -0400
Message-ID: <5421A68C.8090508@candelatech.com> (sfid-20140923_185753_644442_4DB37506)
Date: Tue, 23 Sep 2014 09:57:48 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 2/2] ath10k: apply chainmask settings to vdev on creation.
References: <1411419245-25799-1-git-send-email-greearb@candelatech.com> <1411419245-25799-2-git-send-email-greearb@candelatech.com> <CA+BoTQ=NtS3hOD+gVZ2whx+K2xsKrZUWBPUa=gfKxaNFcoTHEw@mail.gmail.com>
In-Reply-To: <CA+BoTQ=NtS3hOD+gVZ2whx+K2xsKrZUWBPUa=gfKxaNFcoTHEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/23/2014 01:53 AM, Michal Kazior wrote:
> On 22 September 2014 22:54,  <greearb@candelatech.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> It appears it takes more than just setting the
>> hardware's chainmask to make things work well.  Without
>> this patch, a vdev would only use 1x1 rates when chainmask
>> was set to 0x3.
>>
>> Setting the 'nss' (number of spatial streams) on the vdev
>> helps the firmware's rate-control algorithm work properly.
>>
>> Tested on CT firmware, but probably this works (and
>> is required) on normal firmware.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/mac.c | 24 ++++++++++++++++++++++++
>>  1 file changed, 24 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index 4dc5a40..855c71c 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -2767,6 +2767,17 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
>>         return ret;
>>  }
>>
>> +static u32 get_nss_from_chainmask(u16 chain_mask)
>> +{
>> +       if ((chain_mask & 0x15) == 0x15)
>> +               return 4;
>> +       else if ((chain_mask & 0x7) == 0x7)
>> +               return 3;
>> +       else if ((chain_mask & 0x3) == 0x3)
>> +               return 2;
>> +       return 1;
>> +}
> 
> So a chainmask of `BIT(0) | BIT(2) = 0x5` is nss=1?

That is how the firmware treats it.

> Why not just use `hweight16()` kernel macro? Or do we want to forbid
> odd chainmasks (in which case additional checks need to be added as
> well)?

Even after looking at the hweight16 code I don't know what it is supposed
to do.  I think open-coding is plenty adequate.

Maybe the driver should only allow a chainmask of 1, 3, 7, (and eventually 15 when 4x4 exists),
but maybe also that can just be on the user to get it right.  It is possible that there
is some use for having a different chainmask, but it would require someone with good knowledge
of the hardware to answer that I think.

>> +       if (ar->cfg_tx_chainmask) {
>> +               u16 nss = get_nss_from_chainmask(ar->cfg_tx_chainmask);
>> +               vdev_param = ar->wmi.vdev_param->nss;
>> +               ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
>> +                                               nss);
>> +               if (ret) {
>> +                       ath10k_warn(ar, "failed to set vdev %i chainmask 0x%x, nss %i: %d\n",
>> +                                   arvif->vdev_id, ar->cfg_tx_chainmask, nss,
>> +                                   ret);
>> +                       goto err_vdev_delete;
>> +               }
>> +       }
>> +
> 
> If this is required won't setting up peer nss (after association) be
> necessary as well?
> 
> Shouldn't the vdev nss param be set in __ath10k_set_antenna() as well?
> What about peer nss (assuming it's necessary to update it) in that
> case?

Did the second patch address all of this?  I may have missed more cases,
but at least with the second patch it seems to work for me reliably.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

