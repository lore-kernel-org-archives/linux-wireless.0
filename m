Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17862 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbcCGJgy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 04:36:54 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "michal.kazior@tieto.com" <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 07/11] ath10k: implement wake_tx_queue
Date: Mon, 7 Mar 2016 09:36:50 +0000
Message-ID: <87mvqavdcl.fsf@kamboji.qca.qualcomm.com> (sfid-20160307_103657_775741_74879ECF)
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
	<1456828376-2795-1-git-send-email-michal.kazior@tieto.com>
	<1456828376-2795-8-git-send-email-michal.kazior@tieto.com>
	<87ziubvfzm.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQm=vskz3WhSZjQcMLscWEs4NVoM37hpoYHMiaQb0fYyAw@mail.gmail.com>
In-Reply-To: <CA+BoTQm=vskz3WhSZjQcMLscWEs4NVoM37hpoYHMiaQb0fYyAw@mail.gmail.com>	(Michal
 Kazior's message of "Mon, 7 Mar 2016 07:04:16 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 6 March 2016 at 15:27, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> This implements very basic support for software
>>> queueing. It also contains some knobs that will be
>>> patched later.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> Oddly this patch introduces a new warning:
>>
>> drivers/net/wireless/ath/ath10k/mac.c: In function ath10k_mac_op_tx:
>> drivers/net/wireless/ath/ath10k/mac.c:3949:29: warning: is_mgmt may be used uninitialized in this function [-Wuninitialized]
>>
>> But I think that's just a false warning, most likely because my gcc is
>> ancient. Do you agree?
>
> Yes, I agree. It must be the fact is_mgmt is set/used across two
> is_htt condition branches.
>
>
>> gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3
>
> gcc (Debian 4.9.2-10) 4.9.2 -- no warning for me.

Actually kbuild also found this but let's just ignore it.

-- 
Kalle Valo