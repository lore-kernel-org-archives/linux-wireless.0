Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D4DC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9DF62147C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:23:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="ET1ke0Sf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfBGOXx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:23:53 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:47724 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727512AbfBGOXk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 09:23:40 -0500
Received: from [192.168.1.47] (104-235-164-208.evrt.wa.frontiernet.net [104.235.164.208])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id D96E840C7D4;
        Thu,  7 Feb 2019 06:23:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail2.candelatech.com D96E840C7D4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1549549417;
        bh=VmPqzukjqqQEPxj2MMqLAjBI20FfoXHP/vrt/o1Em5E=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=ET1ke0Sffe2pBh8N4/b3uOy2YKJK0EYf1l4ZHeURAVETJ13GqGZjTEHOFyclTtJRF
         E83QWbFr6lMp+Qwyv67jBdTWVfXTnsEStYOOB1Ir09P6nfdNMvBS9KYYKTl4U554+8
         jWwpL327ZfFbvggI+Wj9fUEY/6MLTdxgQLtTYcJ4=
Subject: Re: [PATCH] ath10k: implement set_base_macaddr to fix rx-bssid mask
 in multiple APs conf
To:     Kalle Valo <kvalo@codeaurora.org>,
        Christian Lamparter <chunkeey@gmail.com>
References: <20190114153558.972-1-chunkeey@gmail.com>
 <87tvhjd0c7.fsf@kamboji.qca.qualcomm.com> <4891660.4ehrp1WKpm@debian64>
 <87womb8yw1.fsf@kamboji.qca.qualcomm.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <bd92e361-f6f3-cfd9-090d-6381134edfdb@candelatech.com>
Date:   Thu, 7 Feb 2019 06:23:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <87womb8yw1.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 02/07/2019 06:19 AM, Kalle Valo wrote:
> Christian Lamparter <chunkeey@gmail.com> writes:
>
>> On Monday, February 4, 2019 4:45:12 PM CET Kalle Valo wrote:
>>> Christian Lamparter <chunkeey@gmail.com> writes:
>>>
>>>> @@ -8885,6 +8904,7 @@ static const struct wmi_ops wmi_ops = {
>>>>
>>>>  	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
>>>>  	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
>>>> +	.gen_pdev_set_base_macaddr = ath10k_wmi_op_gen_pdev_set_base_macaddr,
>>>>  	.gen_pdev_set_rd = ath10k_wmi_op_gen_pdev_set_rd,
>>>>  	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
>>>>  	.gen_init = ath10k_wmi_op_gen_init,
>>>> @@ -8960,6 +8980,7 @@ static const struct wmi_ops wmi_10_1_ops = {
>>>>
>>>>  	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
>>>>  	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
>>>> +	.gen_pdev_set_base_macaddr = ath10k_wmi_op_gen_pdev_set_base_macaddr,
>>>>  	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
>>>>  	.gen_stop_scan = ath10k_wmi_op_gen_stop_scan,
>>>>  	.gen_vdev_create = ath10k_wmi_op_gen_vdev_create,
>>>> @@ -9032,6 +9053,7 @@ static const struct wmi_ops wmi_10_2_ops = {
>>>>
>>>>  	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
>>>>  	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
>>>> +	.gen_pdev_set_base_macaddr = ath10k_wmi_op_gen_pdev_set_base_macaddr,
>>>>  	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
>>>>  	.gen_stop_scan = ath10k_wmi_op_gen_stop_scan,
>>>>  	.gen_vdev_create = ath10k_wmi_op_gen_vdev_create,
>>>
>>> These are in practise obsolete WMI interfaces so not sure if it makes it
>>> worth to support this parameter in them. But on the other hand it won't
>>> hurt either, so dunno.
>>
>> Ok. I looked what firmware interfaces (wmi_cmd_map) supported the
>> pdev_set_base_macaddr_cmdid and all did (including the old and tlv)
>> so I added the line everywhere I could.
>> As far as the support for the old firmwares goes: I don't think
>> anybody with a current ath10k is willingly still stuck on the 10.1,
>> 10.2 firmware. So, I might as well just remove those for 10_2, 10_1 and MAIN.
>
> Yeah, that's the best. BTW I'm planning (or better hoping) to remove
> 10.1, 10.2 and main WMI interfaces altogether. They are just making
> these unnecessary complex.

My wave-1 firmware uses the 10.1 interface and it is used by a fair number of people,
so please leave that one in place.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
