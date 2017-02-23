Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:34948 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbdBWI4d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 03:56:33 -0500
Received: by mail-wm0-f41.google.com with SMTP id v186so164833470wmd.0
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2017 00:56:14 -0800 (PST)
Subject: Re: [Outreachy kernel] Re: [PATCH v2] staging: wilc1000: renames
 struct tstrRSSI and its members u8Index, u8Full
To: Julia Lawall <julia.lawall@lip6.fr>,
        Tahia Khan <tahia.khan@gmail.com>
References: <20170222171403.GA20626@coolbox>
 <838d3e67-646d-b2d3-ef7d-5812675db6db@broadcom.com>
 <20170223035400.GA9378@coolbox> <alpine.DEB.2.20.1702230804410.2203@hadrien>
Cc: outreachy-kernel@googlegroups.com, aditya.shankar@microchip.com,
        ganesh.krishna@microchip.com, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, devel@driverdev.osusl.org,
        linux-kernel@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1ffdd756-aaa4-5e1e-b72f-3e5d1f2daeb2@broadcom.com> (sfid-20170223_095710_767497_60ED51CB)
Date: Thu, 23 Feb 2017 09:56:11 +0100
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1702230804410.2203@hadrien>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23-2-2017 8:08, Julia Lawall wrote:
>> Thanks for the feedback Arend, I really appreciate it. I've decided to go with
>> these changes in my follow-up patch request:
>>
>> - rename tstrRSSI to 'rssi_history_buffer' as Aren suggested since it makes the
>> purpose of the struct clear
>> - remove Hungarian notation from all tstrRSSI members' names
>> - change type of u8Full to bool since it's only ever 1 or 0
>> - change name of as8RSSI to 'samples' since this buffer is only ever used to
>> compute an average, and the "rssi" prefix is implied by the struct's name
>> - rename str_rssi to rssi_history in the network_info struct for clarity
>>
>> Since my reasoning for these changes deviates from just "renaming to
>> avoid camel casing" (as in the original checkpatch.pl warning), would it still
>> make sense to submit all this in a single patch? I know my commit message
>> needs to change but I wonder if this is too much detail.
> 
> I would strongly suggest not to do it all in a single patch.  Even if these
> changes are not very complicated conceptually, there is always a chance of
> doing things wrong.  Taking the problems one by one will improve the chance
> that the result is correct.  Also, the results will be easier for you and
> others to review if each patch only does one thing.  And easier to revert
> if needed later if something goes wrong.

It is all related to cleaning up stuff in a single struct which I
consider "one thing" here. To me it looks a bit silly if you rename one
struct member when it is obvious that the other two need to be renamed
as well. The only somewhat sensible split I see here is: 1) rename the
struct itself, 2) rename the struct members, and 3) rename str_rssi
member in struct network_info.

Regards,
Arend
