Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:42732 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbcGVNci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2016 09:32:38 -0400
Message-ID: <57922074.5060009@candelatech.com> (sfid-20160722_153241_287477_175301E4)
Date: Fri, 22 Jul 2016 06:32:36 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	"Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Subject: Re: ath10k + iw set bitrates is causing FW crash
References: <CABPxzYLwye1t1Ycjr3nO5C18vc7OqS9dbbQ1yJ7B-YN+Bkx_PA@mail.gmail.com> <CABPxzYL5DHU7ZE1X1AibygBUz0TJEnNLLTp5_hDivmBBkjnVtg@mail.gmail.com> <1467972560885.99812@qti.qualcomm.com> <CABPxzY+8Y-FHUFALGueN1hQwgjJHNpeyy_BRkrM4osguxJZS0Q@mail.gmail.com> <1467982766213.21223@qti.qualcomm.com> <CABPxzYLO8rzvOJ_1iqng89kYFS-xqC3qstbgETVRJHDpO4rikQ@mail.gmail.com> <CABPxzYJPi4CqO+KUFA7=r=zpq_c2vFtrgBQ+nF_nThO-cYrteg@mail.gmail.com> <CABPxzYKomhw5rF4Crj6sMbmr3VuuDYi=zqN2ky83v-=RJe7Zhg@mail.gmail.com> <1469188781289.75799@qti.qualcomm.com> <CABPxzYL2D1b08vOJc9b9WCjjEDtgHW2UQFNVSyxD5wSjidmiQA@mail.gmail.com>
In-Reply-To: <CABPxzYL2D1b08vOJc9b9WCjjEDtgHW2UQFNVSyxD5wSjidmiQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/22/2016 05:21 AM, Krishna Chaitanya wrote:
> On Fri, Jul 22, 2016 at 5:29 PM, Manoharan, Rajkumar
> <rmanohar@qti.qualcomm.com> wrote:
>> [...]
>>>>> Thanks Raj, with this fix the rates are 0-7, if i disable then i am
>>>>> seeing 0-9, so its
>>>>> working.
>>>>>
>>>>> But i am seeing a weird issues, the moment i give bitrates command,
>>>>> ath10k no longer does encryption, link is a WPA2-PSK: AES. Even after
>>>>> interface up/down
>>>>> it doesn't work.
>>>> After reboot i dont see the "unencrypted" packet issue, i will do
>>>> some more testing on limiting the rates, currently in my setup its
>>>> not reaching MCS9 so cannot verify now.
>>> Rajkumar,
>>>
>>> I am still not able to make mcs9 work, so i have tried to change the Nss to 1
>>> using iw, but that is not taking affect. This command is not taking effect.
>>>
>> you mean not able to fix VHT rates alone. am i right? By auto rate mode, is firmware selecting
>> mcs9? What is the command used for fixing vht rate?
> Basically my requirement is to disable MCS8 and 9 for comparison.
> to check whether ath10k honors the iw command, i used below
> command. changing to 1SS, but i could see that it still transmits
> using 2SS. Does your patch ignore these settings except for
> adhoc mode?
>
> iw set bitrates vht-mcs-5 1:0-7

You can set the number of spatial streams on the phy device.  Search around
for a 'chainmask' configurable.

In general, stock ath10k firmware does not have full support for setting
arbitrary bitrates options.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
