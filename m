Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:8240 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752139AbdATPOG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 10:14:06 -0500
Subject: Re: [RFC 2/2] ath9k: Add frame corruption simulator
To: Kalle Valo <kvalo@codeaurora.org>
References: <1484922570-23659-1-git-send-email-Wojciech.Dubowik@neratec.com>
 <1484922570-23659-3-git-send-email-Wojciech.Dubowik@neratec.com>
 <8760l9n51q.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
From: Wojciech Dubowik <wojciech.dubowik@neratec.com>
Message-ID: <48429e44-f5b2-f100-408b-c1fe5b50adac@neratec.com> (sfid-20170120_161409_930914_6E21F895)
Date: Fri, 20 Jan 2017 16:13:35 +0100
MIME-Version: 1.0
In-Reply-To: <8760l9n51q.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 20/01/17 16:07, Kalle Valo wrote:
>> +config ATH9K_FRAME_LOSS_SIMULATOR
>> +	bool "Atheros ath9k frame loss simulator"
>> +	depends on ATH9K && ATH9K_DEBUGFS && DEBUG_FS
>> +	default n
>> +	---help---
>> +	  Say N. This option should be used only to test fail paths
>> +          and timeouts by inverting fcs field of selected frames to
>> +	  be transmitted.
>> +	  Which frames are corrupted is marked by bitfield in
>> +	  corrupt_fcs_frame_mask debug entry and probability of
>> +	  of corruption in corrupt_fcs_prob (0-255). Zero means
>> +	  disabled and writing 255 makes all selected frames fail.
>> +	  Management, EAPOL, and Null function frames are
>> +	  supported.
> Why a separate Kconfig option? Does this significantly increase memory
> consumption or something? I ask because we should be conservative when
> adding new Kconfig options.
It shouldn't so I could drop it.
Wojtek
>
