Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:41830 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab2KTH5g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 02:57:36 -0500
From: Kalle Valo <kvalo@adurom.com>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Fengguang Wu" <fengguang.wu@intel.com>,
	"Franky Lin" <frankyl@broadcom.com>
Subject: Re: [PATCH] brcmfmac: check return from kzalloc in brcmf_fweh_process_event
References: <1353340412-22757-1-git-send-email-linville@tuxdriver.com>
	<50AA6EBF.9050001@broadcom.com>
Date: Tue, 20 Nov 2012 09:57:31 +0200
In-Reply-To: <50AA6EBF.9050001@broadcom.com> (Arend van Spriel's message of
	"Mon, 19 Nov 2012 18:39:11 +0100")
Message-ID: <87y5hwwvtg.fsf@purkki.adurom.net> (sfid-20121120_085739_139064_D0099997)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Arend van Spriel" <arend@broadcom.com> writes:

> On 11/19/2012 04:53 PM, John W. Linville wrote:
>> From: "John W. Linville" <linville@tuxdriver.com>
>>
>> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>> Reported-by: Fengguang Wu <fengguang.wu@intel.com>

[...]

>>   	event = kzalloc(sizeof(*event) + datalen, alloc_flag);
>> +	if (!event)
>
> My fix included a debug statement about the discarded event from firmware.

Someone once suggested that memory allocation errors should not be
printed by the drivers as the memory subsystem does that anyway. No idea
if that's a good advice or not, but I try to follow it.

-- 
Kalle Valo
