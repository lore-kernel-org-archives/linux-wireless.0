Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61324 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365Ab2BNQfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 11:35:00 -0500
Received: by yhoo21 with SMTP id o21so124993yho.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 08:35:00 -0800 (PST)
Message-ID: <4F3A8D30.3040804@lwfinger.net> (sfid-20120214_173507_940129_120ED6F9)
Date: Tue, 14 Feb 2012 10:34:56 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT 0/5] Firmware load change for various wireless drivers
References: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net>  (sfid-20120213_203726_939695_C63C1EE3) <1329217015.3941.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1329217015.3941.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2012 04:56 AM, Johannes Berg wrote:
> On Mon, 2012-02-13 at 13:37 -0600, Larry Finger wrote:
>> These patches change 5 drivers that are now loading firmware from the probe
>> routine. As each of them has the possibility of loading more than one
>> file, the method of using request_firmware_nowait() has some difficulty,
>> as it gets duplicate names in sysfs when the requests are launched in
>> parallel.
>
> Why not simply start off with one, and then when that returns
> successfully request the other ones?

I have code that does that, and it is a reasonable solution when the driver 
loads only two files, or one and an alternate.

>> When the callback routine is used to launch a second request,
>> the structure gets messy, particularly with b43legacy, which loads 4
>> firmware files for some hardware. My solution is to create a delayed work
>> queue that is started in the probe routine with a delay of one second. The
>> routine that is triggered does the normal request_firmware() calls
>> and starts mac80211 when the firmware is available.
>
> I suppose this works, but I'd be a little worried that when the driver
> is built into the kernel it doesn't help much. I'm asking the udev
> people to not answer async loads while in initramfs, but they'd still
> give you a negative answer here, and they won't be able to tell the
> difference between a synchronous request from a work item (which doesn't
> block boot) and a synchronous request from probe (which does block
> booting).

I asked a variant of this question on LKML and the driverdevel ML, but got no 
answer.

Unless I get a definitive answer, I'll have to go back to the chain loading, no 
matter how messy.

Larry
