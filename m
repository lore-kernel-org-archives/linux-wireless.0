Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:40968 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbeCOJ1K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 05:27:10 -0400
Received: by mail-wr0-f182.google.com with SMTP id f14so7468283wre.8
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2018 02:27:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <871sgl90im.fsf@kamboji.qca.qualcomm.com>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
 <1520260620-4694-2-git-send-email-amitkarwar@gmail.com> <87ina00zwv.fsf@purkki.adurom.net>
 <CAEhWJFk3CGJ9-QJZJt23-vvrwXgVq9GeY9AhXbPy2=FAUMUnOw@mail.gmail.com> <871sgl90im.fsf@kamboji.qca.qualcomm.com>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Thu, 15 Mar 2018 14:57:08 +0530
Message-ID: <CAEhWJF=RByV+Ux2AuMTiWFRsG=3Jqe-2BzCDe=XQir98ex3Zag@mail.gmail.com> (sfid-20180315_102714_410242_368CB124)
Subject: Re: [PATCH 01/10] rsi: add support for hardware scan offload
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 15, 2018 at 2:30 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> On Tue, Mar 13, 2018 at 8:46 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>>>
>>>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>>>
>>>> With the current approach of scanning, roaming delays
>>>> are observed. Firmware has support for back ground scanning.
>>>> To get this advantage, mac80211 hardware scan is implemented.
>>>> In this method, foreground scan is performed in driver and
>>>> back ground scan is configured to firmware.
>>>
>>> To me doesn't like a good idea to duplicate scan functionality in the
>>> driver.
>>
>> There is a limitation with our device. We need to configure background
>> scan parameters to firmware when device is connected.
>
> Yeah, I guessed that.
>
>> In non-connected state, we can directly dump probe requests received
>> from mac80211 as a part of software scan. Some synchronization issues
>> are with existing software scan when device is connected. This patch
>> implements hw_scan where these issues are no seen, as driver has more
>> control on scan state machine
>
> What I don't like here is that you are duplicating functionality already
> existing in mac80211 and I hope there is a better way to solve the
> problem. Just as a a crazy idea what if the driver returns -EOPNOTSUPP
> when hardware scan is not possible and mac80211 falls back to software
> scan? But of course this depends on what Johannes thinks.

Currently mac80211 offloads scan to driver if "ops->hw_scan" is
implemented. Otherwise falls back to software scan.
I can see below vendors have already implemented hw_scan with their
own scan state machine. This patch does the same thing.
Let me know if I missed anything here.

/ath/ath10k/mac.c:7684: .hw_scan = ath10k_hw_scan,
./ath/wcn36xx/main.c:1115: .hw_scan = wcn36xx_hw_scan,
./ath/ath9k/main.c:2626: ath9k_ops.hw_scan                  = ath9k_hw_scan;
./st/cw1200/main.c:215: .hw_scan = cw1200_hw_scan,
./atmel/at76c50x-usb.c:2195: .hw_scan = at76_hw_scan,
./ti/wl1251/main.c:1376: .hw_scan = wl1251_op_hw_scan,
./ti/wlcore/main.c:5923: .hw_scan = wl1271_op_hw_scan,
./intel/iwlegacy/3945-mac.c:3485: .hw_scan = il_mac_hw_scan,
./intel/iwlegacy/3945-mac.c:3915: il3945_mac_ops.hw_scan = NULL;
./intel/iwlegacy/4965-mac.c:6352: .hw_scan = il_mac_hw_scan,
./intel/iwlwifi/mvm/mac80211.c:4343: .hw_scan = iwl_mvm_mac_hw_scan,
./intel/iwlwifi/dvm/mac80211.c:1627: .hw_scan = iwlagn_mac_hw_scan,
./mac80211_hwsim.c:2390: .hw_scan = mac80211_hwsim_hw_scan,

Regards,
Amitkumar
