Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1676 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538Ab2AETjn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 14:39:43 -0500
Message-ID: <4F05FC76.5070509@broadcom.com> (sfid-20120105_203946_144950_A00C9C08)
Date: Thu, 5 Jan 2012 11:39:34 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Stephen Hemminger" <shemminger@vyatta.com>
cc: "Arend Van Spriel" <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] brcmfmac: use existing net_device_stats
References: <20120105183947.295358582@vyatta.com>
 <20120105184000.572918423@vyatta.com> <4F05F60C.5030406@broadcom.com>
 <20120105111554.57f411d0@nehalam.linuxnetplumber.net>
In-Reply-To: <20120105111554.57f411d0@nehalam.linuxnetplumber.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2012 11:15 AM, Stephen Hemminger wrote:
> On Thu, 5 Jan 2012 20:12:12 +0100
> "Arend van Spriel"<arend@broadcom.com>  wrote:
>
>> On 01/05/2012 07:39 PM, Stephen Hemminger wrote:
>>> Minor space savings. Compile tested only.
>>>
>>
>> This is actually not going to work. The struct brcmf_if represents
>> individual interfaces which each have their own device statistics.
>>
>
> Why not, if you  look it is only used during the aggregation and return
> of netdevice stats.
>

We only support one primary interface at the moment. But we have plan to 
add P2P support using virtual interfaces. It would be better to have 
individual stats for different interfaces.

Thanks,
Franky

