Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:36175 "EHLO
	mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbcGVMWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2016 08:22:00 -0400
Received: by mail-yw0-f170.google.com with SMTP id u134so100959332ywg.3
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jul 2016 05:22:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1469188781289.75799@qti.qualcomm.com>
References: <CABPxzYLwye1t1Ycjr3nO5C18vc7OqS9dbbQ1yJ7B-YN+Bkx_PA@mail.gmail.com>
 <CABPxzYL5DHU7ZE1X1AibygBUz0TJEnNLLTp5_hDivmBBkjnVtg@mail.gmail.com>
 <1467972560885.99812@qti.qualcomm.com> <CABPxzY+8Y-FHUFALGueN1hQwgjJHNpeyy_BRkrM4osguxJZS0Q@mail.gmail.com>
 <1467982766213.21223@qti.qualcomm.com> <CABPxzYLO8rzvOJ_1iqng89kYFS-xqC3qstbgETVRJHDpO4rikQ@mail.gmail.com>
 <CABPxzYJPi4CqO+KUFA7=r=zpq_c2vFtrgBQ+nF_nThO-cYrteg@mail.gmail.com>
 <CABPxzYKomhw5rF4Crj6sMbmr3VuuDYi=zqN2ky83v-=RJe7Zhg@mail.gmail.com> <1469188781289.75799@qti.qualcomm.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 22 Jul 2016 17:51:40 +0530
Message-ID: <CABPxzYL2D1b08vOJc9b9WCjjEDtgHW2UQFNVSyxD5wSjidmiQA@mail.gmail.com> (sfid-20160722_142207_303751_D8BD6797)
Subject: Re: ath10k + iw set bitrates is causing FW crash
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 22, 2016 at 5:29 PM, Manoharan, Rajkumar
<rmanohar@qti.qualcomm.com> wrote:
> [...]
>> >> Thanks Raj, with this fix the rates are 0-7, if i disable then i am
>> >> seeing 0-9, so its
>> >> working.
>> >>
>> >> But i am seeing a weird issues, the moment i give bitrates command,
>> >> ath10k no longer does encryption, link is a WPA2-PSK: AES. Even after
>> >> interface up/down
>> >> it doesn't work.
>>> After reboot i dont see the "unencrypted" packet issue, i will do
>>> some more testing on limiting the rates, currently in my setup its
>>> not reaching MCS9 so cannot verify now.
>> Rajkumar,
>>
>> I am still not able to make mcs9 work, so i have tried to change the Nss to 1
>> using iw, but that is not taking affect. This command is not taking effect.
>>
> you mean not able to fix VHT rates alone. am i right? By auto rate mode, is firmware selecting
> mcs9? What is the command used for fixing vht rate?
Basically my requirement is to disable MCS8 and 9 for comparison.
to check whether ath10k honors the iw command, i used below
command. changing to 1SS, but i could see that it still transmits
using 2SS. Does your patch ignore these settings except for
adhoc mode?

iw set bitrates vht-mcs-5 1:0-7
