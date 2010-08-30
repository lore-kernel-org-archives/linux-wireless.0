Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56393 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab0H3Orq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 10:47:46 -0400
Received: by bwz11 with SMTP id 11so3739207bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 07:47:44 -0700 (PDT)
Message-ID: <4C7BC4D9.1010108@lwfinger.net>
Date: Mon, 30 Aug 2010 09:48:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org,
	Rogerio Luz Coelho <rogluz.news@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>
Subject: Re: [PATCH] rtl8187b: do not do per packet TX AGC
References: <1282974868-22237-1-git-send-email-cascardo@holoscopio.com> <4C798080.8010002@lwfinger.net> <20100830141218.GB30864@tuxdriver.com>
In-Reply-To: <20100830141218.GB30864@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/2010 09:12 AM, John W. Linville wrote:
> On Sat, Aug 28, 2010 at 04:32:48PM -0500, Larry Finger wrote:
>> On 08/28/2010 12:54 AM, Thadeu Lima de Souza Cascardo wrote:
>>> The code for rtl8187 does not do per packet TX AGC. Resetting the per
>>> packet TX AGC for rtl8187b appears to increase its overall TX power.
>>> This allows the device to associate and a connection be established
>>> using APs a little further away.
>>>
>>> Tested-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
>>> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
>>> Cc: linux-wireless@vger.kernel.org
>>> Cc: Larry Finger <Larry.Finger@lwfinger.net>
>>> Cc: Rogerio Luz Coelho <rogluz.news@gmail.com>
>>> Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
>>> Cc: Hin-Tak Leung <hintak.leung@gmail.com>
>>> ---
>>
>> I'm a little confused here. The subject says not to set the per packet TX AGC,
>> while the submission text says that setting it helps. I don't have access to any
>> documents that describe this register, but I expect that clearing
>> RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT would disable that feature. As a result
>> the code change seems to match the subject.
>>
>> I have not yet tested this code, but I do note that all the Realtek drivers for
>> the RTL8187B set this bit.
>>
>> Until testing, I withhold judgment on the actual code change, but NACK for the
>> inconsistency.
> 
> Perhaps the word "clearing" rather than "resetting" would be less confusing?

I see the source of my confusion. I am in the habit of using lower case to
indicate the driver and upper case for the device. I would rewrite the commit
code to say "The code for the RTL8187L does not do per packet TX AGC. Clearing
the per packet TX AGC for RTL8187B ..."

I have now tested the patch. For my RTL8187B device, I get the following:

Distance from AP      Indicated rate       Signal       Measured TX rate
      2m                   18 Mb/s         -17 dBm      10 Mb/s
     10m(original)         11 Mb/s         -48 dBm      2.6 Mb/s
     10m(with patch)       11 Mb/s         -43 dBm      4.1 Mb/s

The measured TX rates were obtained using tcpperf. At a distance of 2 m, the
results were the same with and without the patch. At 10 m, the patch went
through 2 exterior walls with drywall, insulation, and stucco. I'm not sure that
the increase from 2.6 to 4.1 Mb/s is reproducible. About all I can say is that
the change did not hurt the performance of the device, which is already pretty bad.

If the OP can post numbers documenting the improvement, I have no objection to
this patch, even though every Realtek driver that I have seen turns "per packet
TX AGC" on for the RTL8187B and turns it off for the RTL8187L.

Larry
