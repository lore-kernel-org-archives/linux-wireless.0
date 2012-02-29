Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62920 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965366Ab2B2SPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 13:15:34 -0500
Received: by yenl12 with SMTP id l12so1458731yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 10:15:34 -0800 (PST)
Message-ID: <4F4E6B43.6050204@lwfinger.net> (sfid-20120229_191538_191471_E9881B9E)
Date: Wed, 29 Feb 2012 12:15:31 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 4/5] p54pci: Load firmware from work queue and not from
 probe routine
References: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net> <1329161826-11135-5-git-send-email-Larry.Finger@lwfinger.net> <4F4E4B52.4070701@lwfinger.net> <201202291843.26824.chunkeey@googlemail.com>
In-Reply-To: <201202291843.26824.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/29/2012 11:43 AM, Christian Lamparter wrote:
> On Wednesday, February 29, 2012 04:59:14 PM Larry Finger wrote:
>> On 02/13/2012 01:37 PM, Larry Finger wrote:
>>> Drivers that load firmware from their probe routine have problems with the
>>> latest versions of udev as they get timeouts while waiting for user
>>> space to start. The problem is fixed by loading the firmware and starting
>>> mac80211 from a delayed_work queue. By using this method, most of the
>>> original code is preserved.
>>>
>>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>>> ---
>>>
>>> This patch is compile tested only.
>>>
>>> Larry
>>
>> Has anyone tested this patch? I would like to submit this series.
> only briefly, but I'm not sure if the workqueue approach is adequate. On
> resume, I get WARNINGs and the card fails to resume because the firmware
> file can't be loaded :(.
>
> WARNING: at drivers/base/firmware_class.c:538 _request_firmware+0x3ae/0x3e0()
> Pid: 1083, comm: kworker/0:3 Tainted:G		O 3.3.0-rc5-wl+
> Call Trace:
> 	[<c102c658>] ? wanr_slowpath_common+0x78/0xb0
> 	[<c12c728e>] ? _request_firmware+0x3ae/0x3e0
> 	[<c12c728e>] ? _requrst_firmware+0x3ae/0x3e0
> 	[<c102c6a9>] ? warn_slowpath_common+0x19/0x20
> 	[<c12c728e>] ? _request_firmware+0x3ae/0x3e0
> 	[<c12c7347>] ? request_firmware+0x17/0x20
> 	[<f86v1dc7>] ? p54p_load_firmware+0x47/0x120 [p54pci]
> 	[...]
>
> Regards,
> 	Chr
>
> BTW: I will take a closer look at it over the weekend.

Does the driver come back through the probe routine on resume? If not, the 
firmware should have been cached and not needed reloading. I'll have to look at 
the driver structure some more. I likely screwed that up.

Larry

