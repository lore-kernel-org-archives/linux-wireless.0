Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31368 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdBFMVi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 07:21:38 -0500
From: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
        <mohammed@qti.qualcomm.com>
To: Michael Ney <neym@vorklift.com>,
        Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
CC: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v3] ath10k: Fix crash during rmmod when probe firmware
 fails
Date: Mon, 6 Feb 2017 12:21:21 +0000
Message-ID: <1486383699520.26295@qti.qualcomm.com> (sfid-20170206_132144_629851_8DC29E4B)
References: <1482221351-24029-1-git-send-email-mohammed@qca.qualcomm.com>
 <8760l38dz0.fsf@kamboji.qca.qualcomm.com>
 <871svr8d83.fsf@kamboji.qca.qualcomm.com>
 <20170206100448.GA13894@atheros-ThinkPad-T61>,<2DBE5232-FF3F-4B0E-8739-B6E82361316C@vorklift.com>
In-Reply-To: <2DBE5232-FF3F-4B0E-8739-B6E82361316C@vorklift.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,=0A=
=0A=
even with the below patch applied ?=0A=
https://patchwork.kernel.org/patch/9452265/=0A=
=0A=
regards=0A=
shafi=0A=
________________________________________=0A=
From: Michael Ney <neym@vorklift.com>=0A=
Sent: 06 February 2017 17:46=0A=
To: Mohammed Shafi Shajakhan=0A=
Cc: Valo, Kalle; linux-wireless@vger.kernel.org; ath10k@lists.infradead.org=
; Shajakhan, Mohammed Shafi (Mohammed Shafi)=0A=
Subject: Re: [PATCH v3] ath10k: Fix crash during rmmod when probe firmware =
fails=0A=
=0A=
Symmetry is still broken on firmware crash (at least with 6174). ath10k_pci=
_hif_stop gets called twice, once from the driver restart (warm restart) an=
d once from ieee80211 start (cold restart), resulting in napi_synchrionize/=
napi_disable getting called twice and sticking the driver in an infinite wa=
it loop (napi_synchronize waits until NAPI_STATE_SCHED is off, while napi_d=
isable leaves NAPI_STATE_SCHED to on when leaving).=0A=
=0A=
=0A=
> On Feb 6, 2017, at 5:04 AM, Mohammed Shafi Shajakhan <mohammed@codeaurora=
.org> wrote:=0A=
>=0A=
> Hi Kalle,=0A=
>=0A=
> the change suggested by you helps, and the device probe, scan=0A=
> is successful as well. Still good to have this change part of your=0A=
> basic sanity and regression testing !=0A=
>=0A=
> regards,=0A=
> shafi=0A=
>=0A=
> On Wed, Jan 25, 2017 at 01:46:28PM +0000, Valo, Kalle wrote:=0A=
>> Kalle Valo <kvalo@qca.qualcomm.com> writes:=0A=
>>=0A=
>>> Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:=0A=
>>>=0A=
>>>> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>=0A=
>>>>=0A=
>>>> This fixes the below crash when ath10k probe firmware fails,=0A=
>>>> NAPI polling tries to access a rx ring resource which was never=0A=
>>>> allocated, fix this by disabling NAPI right away once the probe=0A=
>>>> firmware fails by calling 'ath10k_hif_stop'. Its good to note=0A=
>>>> that the error is never propogated to 'ath10k_pci_probe' when=0A=
>>>> ath10k_core_register fails, so calling 'ath10k_hif_stop' to cleanup=0A=
>>>> PCI related things seems to be ok=0A=
>>>>=0A=
>>>> BUG: unable to handle kernel NULL pointer dereference at (null)=0A=
>>>> IP:  __ath10k_htt_rx_ring_fill_n+0x19/0x230 [ath10k_core]=0A=
>>>> __ath10k_htt_rx_ring_fill_n+0x19/0x230 [ath10k_core]=0A=
>>>>=0A=
>>>> Call Trace:=0A=
>>>>=0A=
>>>> [<ffffffffa113ec62>] ath10k_htt_rx_msdu_buff_replenish+0x42/0x90=0A=
>>>> [ath10k_core]=0A=
>>>> [<ffffffffa113f393>] ath10k_htt_txrx_compl_task+0x433/0x17d0=0A=
>>>> [ath10k_core]=0A=
>>>> [<ffffffff8114406d>] ? __wake_up_common+0x4d/0x80=0A=
>>>> [<ffffffff811349ec>] ? cpu_load_update+0xdc/0x150=0A=
>>>> [<ffffffffa119301d>] ? ath10k_pci_read32+0xd/0x10 [ath10k_pci]=0A=
>>>> [<ffffffffa1195b17>] ath10k_pci_napi_poll+0x47/0x110 [ath10k_pci]=0A=
>>>> [<ffffffff817863af>] net_rx_action+0x20f/0x370=0A=
>>>>=0A=
>>>> Reported-by: Ben Greear <greearb@candelatech.com>=0A=
>>>> Fixes: 3c97f5de1f28 ("ath10k: implement NAPI support")=0A=
>>>> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>=0A=
>>>=0A=
>>> Is there an easy way to reproduce this bug? I don't see it on my x86=0A=
>>> laptop with qca988x and I call rmmod all the time. I would like to test=
=0A=
>>> this myself.=0A=
>>>=0A=
>>>> --- a/drivers/net/wireless/ath/ath10k/core.c=0A=
>>>> +++ b/drivers/net/wireless/ath/ath10k/core.c=0A=
>>>> @@ -2164,6 +2164,7 @@ static int ath10k_core_probe_fw(struct ath10k *a=
r)=0A=
>>>>    ath10k_core_free_firmware_files(ar);=0A=
>>>>=0A=
>>>> err_power_down:=0A=
>>>> +  ath10k_hif_stop(ar);=0A=
>>>>    ath10k_hif_power_down(ar);=0A=
>>>>=0A=
>>>>    return ret;=0A=
>>>=0A=
>>> This breaks the symmetry, we should not be calling ath10k_hif_stop() if=
=0A=
>>> we haven't called ath10k_hif_start() from the same function. This can=
=0A=
>>> just create a bigger mess later, for example with other bus support lik=
e=0A=
>>> sdio or usb. In theory it should enough that we call=0A=
>>> ath10k_hif_power_down() and pci.c does the rest correctly "behind the=
=0A=
>>> scenes".=0A=
>>>=0A=
>>> I investigated this a bit and I think the real cause is that we call=0A=
>>> napi_enable() from ath10k_pci_hif_power_up() and napi_disable() from=0A=
>>> ath10k_pci_hif_stop(). Does anyone remember why?=0A=
>>>=0A=
>>> I was expecting that we would call napi_enable()/napi_disable() either=
=0A=
>>> in ath10k_hif_power_up/down() or ath10k_hif_start()/stop(), but not=0A=
>>> mixed like it's currently.=0A=
>>=0A=
>> So below is something I was thinking of, now napi_enable() is called=0A=
>> from ath10k_hif_start() and napi_disable() from ath10k_hif_stop(). Would=
=0A=
>> that work?=0A=
>>=0A=
>> --- a/drivers/net/wireless/ath/ath10k/pci.c=0A=
>> +++ b/drivers/net/wireless/ath/ath10k/pci.c=0A=
>> @@ -1648,6 +1648,8 @@ static int ath10k_pci_hif_start(struct ath10k *ar)=
=0A=
>>=0A=
>>      ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif start\n");=0A=
>>=0A=
>> +    napi_enable(&ar->napi);=0A=
>> +=0A=
>>      ath10k_pci_irq_enable(ar);=0A=
>>      ath10k_pci_rx_post(ar);=0A=
>>=0A=
>> @@ -2532,7 +2534,6 @@ static int ath10k_pci_hif_power_up(struct ath10k *=
ar)=0A=
>>              ath10k_err(ar, "could not wake up target CPU: %d\n", ret);=
=0A=
>>              goto err_ce;=0A=
>>      }=0A=
>> -    napi_enable(&ar->napi);=0A=
>>=0A=
>>      return 0;=0A=
>>=0A=
>> --=0A=
>> Kalle Valo=0A=
>=0A=
> _______________________________________________=0A=
> ath10k mailing list=0A=
> ath10k@lists.infradead.org=0A=
> http://lists.infradead.org/mailman/listinfo/ath10k=0A=
=0A=
