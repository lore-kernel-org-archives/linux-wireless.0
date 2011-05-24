Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47893 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab1EXOkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 10:40:18 -0400
Received: by vxi39 with SMTP id 39so4954289vxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 07:40:17 -0700 (PDT)
Message-ID: <4DDBC34A.1090805@lwfinger.net> (sfid-20110524_164023_167859_FF6B7A5C)
Date: Tue, 24 May 2011 09:40:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mike McCormack <mikem@ring3k.org>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/8] rtl8192ce stability improvements
References: <4DDA66D5.2090801@ring3k.org>	<4DDA9016.3090701@lwfinger.net> <BANLkTimC-NndRxtpcL=+iCmmKYbfc0+qQw@mail.gmail.com>
In-Reply-To: <BANLkTimC-NndRxtpcL=+iCmmKYbfc0+qQw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/24/2011 08:35 AM, Mike McCormack wrote:
> On 24 May 2011 01:49, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>
>> Are you using wireless-testing for your patches? There are some patches
>> pending in John's queue, but your patches got offsets and fuzz in files that
>> those patches do not touch. Everything seemed to apply despite the fuzz and
>> everything compiled, but I always get nervous about patches with anything
>> more serious than offsets.
>
> I originally developed these patches against the staging-next tree, then
> ported them over to the wireless-testing tree.  They are on top of this commit:
>
> commit 1e4541b73b33f9918255f36a60bdeacfae4fdb9d
> Author: John W. Linville<linville@tuxdriver.com>
> Date:   Thu May 19 13:54:47 2011 -0400
>
>      Revert "mac80211_hwsim driver support userspace frame tx/rx"
>
>      This reverts commit 444c7896bf5b0c613fd58c8f08e60a8714eb7f05.
>
> I have done a fair bit of work on the rtl8192e driver in Greg KH's staging-next,
> and reused ideas from work I've done there in this series.
>
> Do you think it would be worthwhile to merge rtl8192e support into rtlwifi
> or is there something critical that will prevent that from working well?
>
>> Patches 3, 4, 6 and 8 do modify driver rtlwifi, but patches 1 and 7 change
>> driver rtl8192ce. Similarly, #2 changes rtl8192ce, rtl8192cu, and rtl8192se,
>> and #5 changes rtl8192ce and rtl8192se. The subject line for the patch
>> should indicate the driver that gets modified. I usually do it as "rtlwifi:
>> rtl8192ce: blah-blah", etc. The rtlwifi is included even though it does not
>> get changed by the patch.
>
> OK, I'll try follow your convention with the next series.
>
>> I do not see anything serious in the body of the patches and I expect that I
>> will be giving them an ACK, but I want to test first.
>
> Great.  Should I resend with your Acked-by: ?

Yes, an ACKed-by: would be fine. You should also mark them with a Cc for stable, 
particularly the ones that change the interrupt locking. All of the patches are 
OK, and I have submitted the equivalent ones for rtl8192se. In addition, similar 
changes were folded into the rtl8192de driver that will be submitted soon.

I have not really looked at the driver for the RTL8192E device, other to note 
that rtl8192e and rtl8192se both claim PCI ID 10ec:8192, but different drivers 
are needed. It seems that the only way to distinguish them is from byte 8 
(revisionid) in PCI configuration space. As I just received that information 
this morning, I have not finished thinking it through; however, I expect that we 
will need a shim driver something like b43-pci-bridge (part of ssb) to get the 
proper driver loaded for that ID. Please advise me of any other technique to 
resolve the conflict. I need to fix that for 2.6.40.

As rtl8192e will be needed for some time, we should be looking at two things: 
(1) using rtlwifi for its PCI operations, and (2) switching it from its own 
softmac code to mac80211 so that it can be moved to mainline. Both of these 
tasks will have relatively low priority for me.

I do not have an RTL8192E chip at the moment, but I will get one soon as they 
are ~$10 on E-bay.

Larry
