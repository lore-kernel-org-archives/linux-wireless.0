Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1786 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab1FJJxD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 05:53:03 -0400
Message-ID: <4DF1E973.1030709@broadcom.com> (sfid-20110610_115308_959221_38BDE1D7)
Date: Fri, 10 Jun 2011 11:52:51 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jonas Gorski" <jonas.gorski@gmail.com>
cc: "Roland Vossen" <rvossen@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 12/21] staging: brcm80211: use __BIG_ENDIAN macro in
 dma.c
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
 <1307630701-9170-13-git-send-email-rvossen@broadcom.com>
 <BANLkTi=GGsW4eja0QunMAc5vqqFkmvNxNA@mail.gmail.com>
In-Reply-To: <BANLkTi=GGsW4eja0QunMAc5vqqFkmvNxNA@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/10/2011 01:53 AM, Jonas Gorski wrote:
> On 9 June 2011 16:44, Roland Vossen<rvossen@broadcom.com>  wrote:
>> From: Arend van Spriel<arend@broadcom.com>
>>
>> The source file dma.c used a macro definition that indicated a big endian
>> platform. The linux tree has its own macro determined by architecture and/or
>> kernel configuration. This byteorder macro is __BIG_ENDIAN. This is now used
>> in dma.c.
> While this replacement is technically correct, the check itself is
> wrong and should be fixed instead. Currently it assumes that __mips__
> means Broadcom MIPS; but if it isn't, then there's likely no
> SI_SDRAM_SWAPPED and any access there will in best case do nothing
> (but more like hang the system).
>
> Use either CONFIG_BCM47XX or CONFIG_BCM63XX to check for the BMIPS
> platforms this is probably intended for (I'm not 100% sure if BCM63XX
> has the swapped memory space - better check with your xDSL people ;-).

Hi Jonas,

You are right as with previous mips related patches. Consider this a 
first step which does not change functionality but aims to use the 
proper linux provided macros instead of our own incarnations. You can be 
assured that your feedback is on our work list.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


