Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f179.google.com ([209.85.210.179]:35438 "EHLO
        mail-wj0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753362AbcLMUJW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 15:09:22 -0500
Received: by mail-wj0-f179.google.com with SMTP id v7so112550589wjy.2
        for <linux-wireless@vger.kernel.org>; Tue, 13 Dec 2016 12:09:21 -0800 (PST)
Subject: Re: [RFC V3 01/11] nl80211: add reporting of gscan capabilities
To: Johannes Berg <johannes@sipsolutions.net>
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
 <1481543997-24624-2-git-send-email-arend.vanspriel@broadcom.com>
 <1481645701.20412.39.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend@broadcom.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ee7475ce-7346-a0f1-1587-caf69b9498fb@broadcom.com> (sfid-20161213_211232_120608_110D1341)
Date: Tue, 13 Dec 2016 21:02:21 +0100
MIME-Version: 1.0
In-Reply-To: <1481645701.20412.39.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 13-12-2016 17:15, Johannes Berg wrote:
> 
>> +	case 14:
>> +		if (!rdev->wiphy.gscan) {
>> +			/* done */
>> +			state->split_start = 0;
>> +			break;
>> +		}
>>
> 
> Nit, but I'm not really happy with this - this assumes that case 14 is
> the last case, if anyone ever adds one we break this code but it would
> still work if the device has gscan. Move the gscan stuff into a new
> function and make that return immediately if gscan is NULL or so?

Agree. When coding this piece I was aware that this would need to change
when 'case 15' would be added, which is probably too easy to overlook. I
will change it.

Regards,
Arend
