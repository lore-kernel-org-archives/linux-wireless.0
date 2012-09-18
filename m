Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4815 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab2IRQUb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 12:20:31 -0400
Message-ID: <50589F42.9060608@broadcom.com> (sfid-20120918_182035_996595_AE1F37BE)
Date: Tue, 18 Sep 2012 18:20:18 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: remove obselete comment for
 .sched_scan_stop() callback
References: <1347958799-4060-1-git-send-email-arend@broadcom.com>
 <1347964664.4283.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1347964664.4283.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/18/2012 12:37 PM, Johannes Berg wrote:
> On Tue, 2012-09-18 at 10:59 +0200, Arend van Spriel wrote:
>> The kerneldoc comment for .sched_scan_stop() callback describes a
>> driver_initiated flag, but the interface does not hold such a flag.
>>
>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---
>> Hi Johannes,
>>
>> Was working on scheduled scan support for brcmfmac and got a little
>> confused about .sched_scan_stop() documentation. Not sure if this
>> was stale documentation.
>
> Yes I believe this was some sort of circular call that we removed
> (driver calls stop, cfg80211 tells driver it itself stopped??)

I can come up with a scenario, where scheduled scan related cleanup is 
done in sched_scan_stop and needs different behaviour when initiated by 
driver as opposed to user-space initiated. However, it feels awkward so 
good riddance.

> I'll apply this (and fix the typo ("obsolete") in the subject)
>
> johannes

Thanks (and thanks for fixing the subject ;-) ).

Gr. AvS


