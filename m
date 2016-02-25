Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38043 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933406AbcBYSkY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 13:40:24 -0500
Subject: Re: [PATCH 1/4] ath10k: remove supported chain mask
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	"janusz.dziedzic@tieto.com" <janusz.dziedzic@tieto.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>
References: <1445948474-16738-1-git-send-email-rmanohar@qti.qualcomm.com>
 <87fv0uq6p7.fsf@kamboji.qca.qualcomm.com>
 <CALhHN=orRg2mkjcJ1TGssjEocNrRWEhhDV=SKGYANQ-c+YEyzA@mail.gmail.com>
 <1456233812853.59898@qti.qualcomm.com> <1456421947524.85405@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <56CF4A96.3080105@candelatech.com> (sfid-20160225_194034_361882_1C320BD9)
Date: Thu, 25 Feb 2016 10:40:22 -0800
MIME-Version: 1.0
In-Reply-To: <1456421947524.85405@qti.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2016 09:39 AM, Manoharan, Rajkumar wrote:
>>>>> Removing supported chainmask fields as it can be always derived
>>>>> from num_rf_chains.
>>>>>
>>>>> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
>>>>
>>> Hello,
>>>
>>> This one break monitor mode for qca988x and 10.x firmware:
>>> After Revert "ath10k: remove supported chain mask" - works correctly.
>>>
>> Janusz,
>>
>> Thanks for reporting. Will send out patch asap.
>>
>
> Janusz,
>
> It seems the change ("ath10k: remove supported chain mask") just exposed an
> hidden problem. The same target assert can be reproduced by below sequence
> even after reverting the commit.
>
> ifconfig wlan0 down
> iw wlan0 set type monitor
> iw phy0 set antenna 7
> ifconfig wlan0 up
>
> The actual cause of target assert is below commit.
>
> commit 5572a95b4b5768187652a346356e39e7542ca6e0
> Author: Ben Greear <greearb@candelatech.com>
> Date:   Mon Nov 24 16:22:10 2014 +0200
>
>      ath10k: apply chainmask settings to vdev on creation
>
> Configuring NSS vdev param on interface addition is causing the target assert in 10.1 firmware.
> Just creating monitor interface is causing assert with qca_main firmware.

Maybe change that patch so that it does not attempt to set nss just for monitor interfaces?

Thanks,
Ben

>
>
> -Rajkumar
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

