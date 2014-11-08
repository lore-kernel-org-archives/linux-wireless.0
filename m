Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:17869 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbaKHOHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2014 09:07:52 -0500
Message-ID: <545E23B6.1060004@broadcom.com> (sfid-20141108_150756_713973_17CCFDA7)
Date: Sat, 8 Nov 2014 15:07:50 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH 2/3] ath: use seq_file api for ath9k debugfs files
References: <1414498752-9746-1-git-send-email-arend@broadcom.com> <1414498752-9746-3-git-send-email-arend@broadcom.com> <20141107190522.GA4694@kroah.com> <545E1E45.9040204@broadcom.com>
In-Reply-To: <545E1E45.9040204@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/14 14:44, Arend van Spriel wrote:
> On 11/07/14 20:05, Greg Kroah-Hartman wrote:
>> On Tue, Oct 28, 2014 at 01:19:11PM +0100, Arend van Spriel wrote:
>>> The debugfs files that are defined in debug.c which are read-only
>>> and using a simple_open as .open file operation have been modified
>>> to use the single_open seq_file API. This simplifies the read
>>> functions defining the file contents.
>>>
>>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>>> Acked-by: John W. Linville<linville@tuxdriver.com>
>>> ---
>>> drivers/net/wireless/ath/ath9k/debug.c | 425
>>> +++++++++++++--------------------
>>> drivers/net/wireless/ath/ath9k/debug.h | 3 +-
>>> 2 files changed, 173 insertions(+), 255 deletions(-)
>>
>> I can't take patch 1/3 right now, but even if I could, this one doesn't
>> apply to 3.18-rc3 :(

driver-core/driver-core-next branch is not on 3.18-rc3. Should I rebase 
the series on driver-core/master? As this is for 3.19 I figured it 
needed to go on some -next branch.

Regards,
Arend

> Yep, I noticed some patches going in hitting the same area. As patch 1
> needs rework I will rebase all.
>
> Thanks,
> Arend
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

