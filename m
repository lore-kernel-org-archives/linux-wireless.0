Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57548 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057Ab3CLQP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 12:15:56 -0400
Message-ID: <513F54B5.1040203@qca.qualcomm.com> (sfid-20130312_171601_653647_B9C044B8)
Date: Tue, 12 Mar 2013 21:45:49 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Julien Massot <jmassot@aldebaran-robotics.com>,
	<linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Subject: Re: ath6kl: AR6004 failed to start on computer boot
References: <CADGp=QfF1bBgqP_X9=+PXfH0xCgPFn=h2VG19uV8_cJ8xzg8gg@mail.gmail.com> <87ehghanxe.fsf@kamboji.qca.qualcomm.com> <CADGp=Qf=j+kWA4EM1Z-xyKkuutW64Fi0vfUNqm1tPM1+4WEKyQ@mail.gmail.com> <511E44B8.3000308@qca.qualcomm.com> <CADGp=QfOyyTpwEg1=XXiyvRE7ZOGsn6TfiPQHs3+Jc3C69RM6Q@mail.gmail.com> <51262CB2.6070208@qca.qualcomm.com> <87sj46mbhn.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87sj46mbhn.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/08/2013 03:58 PM, Kalle Valo wrote:
> Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com> writes:
>
>> Hi Julien,
>>
>> On 02/21/2013 07:33 PM, Julien Massot wrote:
>>> Hi,
>>> I just find a quick and dirty patch to workaround this issue.
>>> I just reset the device on initialization failure.
>>>
>>> I hope this helps to understand the real issue.
>>>
>>> [    7.012514] usb 1-7: firmware: requesting ath6k/AR6004/hw1.3/bdata.bin
>>> [    7.035276] cfg80211: World regulatory domain updated:
>>> [    7.035287] cfg80211:   (start_freq - end_freq @ bandwidth),
>>> (max_antenna_gain, max_eirp)
>>> [    7.035299] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
>>> (300 mBi, 2000 mBm)
>>> [    7.037916] usb 1-7: firmware: requesting ath6k/AR6004/hw1.3/fw-3.bin
>>> [    9.378940] ath6kl: f59afe4c
>>> [    9.379054] ath6kl: f59afe6c
>>> [    9.379391] ath6kl_usb: probe of 1-7:1.0 failed with error -5
>>> Here I reset the device.
>>
>> that was the suggestion gave by Wei. The failure it seems
>> check hostapp area to check target status and reset the device
>> if needed.
>>
>> Great that you figured it out yourself!
>
> The power of Open Source in action :)
>
> But thanks a lot Julien, it was really great that you could solve it
> yourself.
>
>> We will send a proper patch for this.
>
> I now sent a patch (plus few cleanups) to fix this.
>
yeah, I had a few patches in my stash, but you addressed them in your 
series. thanks :-)

-- 
thanks,
shafi
