Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f51.google.com ([209.85.128.51]:34231 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3J1MmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 08:42:20 -0400
Received: by mail-qe0-f51.google.com with SMTP id q19so3945578qeb.10
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 05:42:20 -0700 (PDT)
Message-ID: <526E5C93.6040706@gmail.com> (sfid-20131028_134224_034619_EB3B398A)
Date: Mon, 28 Oct 2013 08:46:11 -0400
From: Rick Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>,
	Ben Hutchings <ben@decadent.org.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] carl9170: new firmware for linux-firmware.git
References: <1542665.mhS5oZO9DU@debian64>
In-Reply-To: <1542665.mhS5oZO9DU@debian64>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10/25/2013 07:15 PM, Christian Lamparter wrote:
> Hi Ben,
> 
> I'm currently updating the carl9170 firmware to the latest
> version (1.9.9). I've already pushed out the sources and
> updated the binaries over at our wiki (for the last time,
> all future update will be via linux-firmware.git).
> 
> Now, the last item on my check off list is:
> [ ]     new firmware for linux-firmware.git
> 
> Last time - when this topic came up - we had a short brainstorm
> about how to handle updates in the future: 
> <http://marc.info/?l=linux-wireless&m=136115736909708>
> 
> So, I've now prepared some options: 
> 
> 1. Reorganize carl9170 by creating a new subdirectory "carl9170"
>    and move everything in it.
>    * A carl9170fw-x.y.z.tar.xz with the source is generated for
>      each release and placed under carl9170/source/.
> 
>    * new firmware binaries are placed in carl9170/.
>      (The firmware file name will include the version e.g. 
>      carl9170-1.9.9.fw, it won't clash with a previous release.)
> 
>    * A symlink from the linux-firmware.git root to the latest 
>      carl9170-1.fw in the carl9170 subfolder is added/updated for
>      each release.

Why do we need multiple files at all?  Why do they all need to be named
carl9170-1.fw?  imho if the files are compatible then we only need one,
and if they are not compatible then it is insane that they are all
recognized as "carl9170-1.fw" as that makes it impossible for a user to
know "which carl9170-1.fw" they need for a given kernel.

Thanks,
Zero
> 
>    For a preview see: [1]
>    116 files changed, 3 insertions(+), 26313 deletions(-)
>    
> 2. Simply replace code and firmware binary
>    * The code is simply dumped from the carl9170 firmware repository
>      into the existing carl9170fw directory.
> 
>    * The old firmware binary "carl9170-1.fw" file is replaced by the
>      new version.
> 
>    For a preview see: [2]
>    70 files changed, 2479 insertions(+), 4560 deletions(-)
> 
> I would prefer to go with option 1 and move everything into a carl9170
> subdirectory. This way has the advantage that we can have multiple 
> firmware binaries and sources coexisting in one place. However, I'm 
> also aware of the additional "space and bandwidth" cost in this case. 
> 
> Please tell me which option you like best or if it should be done
> differently. I've prepared a few RFCs (see links), but once we 
> settled for the process, I'll make a proper announcement + patches.
> 
> Regards
> 
> Christian
> 
> [1] <https://drive.google.com/folderview?id=0BwOU1CguSZuBdGYxVVlTWnpXSm8>
> [2] <https://drive.google.com/folderview?id=0BwOU1CguSZuBT1V2V0s2Smp0UmM>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
