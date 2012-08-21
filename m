Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48416 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2HUFOz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 01:14:55 -0400
Received: by ialo24 with SMTP id o24so3095455ial.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Aug 2012 22:14:55 -0700 (PDT)
Message-ID: <5033194A.6030308@lwfinger.net> (sfid-20120821_071459_096310_1ED386B7)
Date: Tue, 21 Aug 2012 00:14:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Missing firmware iwlwifi-2030-5.ucode
References: <502D0C72.2050207@lwfinger.net> <1345459509.4459.5.camel@jlt3.sipsolutions.net> <50325D89.9080209@lwfinger.net> <1345478494.4459.30.camel@jlt3.sipsolutions.net> <CA+XFjiqyqAiZGcBZB6u13FquBbkgBLDbDFAMLnHRMiK6P0Heww@mail.gmail.com>
In-Reply-To: <CA+XFjiqyqAiZGcBZB6u13FquBbkgBLDbDFAMLnHRMiK6P0Heww@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/20/2012 11:55 PM, Gábor Stefanik wrote:
> On Mon, Aug 20, 2012 at 6:01 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Mon, 2012-08-20 at 10:53 -0500, Larry Finger wrote:
>>
>>> I'm still concerned about the bigger picture. I can understand that the -5
>>> version was experimental, but why was a driver released that needed a firmware
>>> version that could never be obtained? If any driver version needs a particular
>>> firmware, the fw must be available as long as anyone might be using that driver.
>>> To me, that means forever.
>>
>> Well, yes. That firmware, however, never was never available publicly.
>> The fact that the driver was released anyway is due to us working on the
>> driver upstream while working with the experimental internal firmware.
>>
>> johannes
>
> Perhaps we should add a Kconfig option to disable internal development
> hardware - with that option unchecked, support for hardware that is
> not on the market is disabled, with a printk warning to upgrade the
> driver in case a user tries to use a driver with a card that it thinks
> is internal-only. This way, users will get a meaningful error message,
> rather than a misleading "missing firmware" one.
> The Kconfig option should also come with a big warning of "Say N
> unless you are an Intel employee". Maybe it should even be marked
> BROKEN, like N-PHY was in b43 before it became usable.

Your suggestion would handle the case where hardware that is only supposed to be 
available internally has somehow been leaked to the public. In the case of the 
2030, it is a device that was intended to be available to the public, and I 
suspect that Windows and OS X drivers were available with built-in firmware.

My feeling is that the reviewers will need to watch the situation. I certainly 
plan to monitor every Intel patch for a firmware change, and I will NACK every 
instance for which that firmware file is not already in linux-firmware. John 
might not honor my NACK; however, I will be on record. At least Ben Hutchings 
caught the attempt to delete the older version of the firmware for the 6205. His 
diligence saved some users of older kernels from having to scramble to find 
firmware not in the firmware repo.

Larry


