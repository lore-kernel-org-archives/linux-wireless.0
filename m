Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:55904 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1HKLDI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 07:03:08 -0400
Received: by iye16 with SMTP id 16so1092276iye.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 04:03:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312986698.2407.668.camel@cumari>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	<1312881233-9366-19-git-send-email-eliad@wizery.com>
	<1312986698.2407.668.camel@cumari>
Date: Thu, 11 Aug 2011 14:03:06 +0300
Message-ID: <CAB3XZEcOEE3=1a5zHcAPxFTya0rhTeZHaDtGRCEm=7fMbe8ZAQ@mail.gmail.com> (sfid-20110811_130312_385886_DD12A1F1)
Subject: Re: [PATCH 18/40] wl12xx: replace dummy_join with ROC/CROC commands
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 10, 2011 at 5:31 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote:
>> The ROC command asks the fw stay on the channel of the given
>> hlid. it currently has 2 primary functions:
>>
>> 1. Allow tx/rx from the device role.
>>
>> In order to tx/rx packets while the stations is not associated
>> (e.g. auth req/resp), the device role has to be used, along
>> with ROC on its link.
>>
>> Keep the logic similiar to the one used in dummy_join. However,
>> since we can't scan while we ROC, we add CROC before starting
>> a scan, and ROC again (if needed) on scan complete.
>>
>> 2. Keeping the antenna for a specific link.
>>
>> We ROC until the connection was completed (after EAPOLs exchange)
>> in order to prevent BT coex operations from taking the antenna
>> and failing the connection (after this stage, psm can be used).
>>
>> During association, we ROC on the station role, and then CROC
>> the device role, thus assuring being ROC during all the connection
>> process.
>
> Nice explanations.  I was wondering if we should have this somewhere in
> the code too, so that it's easier to figure out what is going on without
> digging into git logs...
>
>
>> Replace the WL1271_FLAG_JOINED with a new WL1271_FLAG_ROC,
>> indicating the fw was configured to ROC. Add a roc bitmap
>> to indicate what roles are currently ROCed.
>
> Is it really possible to be ROCed in more than one role? They could be
> running on different channels, so how could we physically ROC more than
> once at the same time?
>
we can do multiple ROCs on the same channel (for different roles).
e.g. during connection, we ROC (concurrently) on the device and station roles.

>
>> Add wl1271_roc/croc functions in order to wrap the roc/croc
>> commands while taking care of the roc bitmap.
>>
>> The current ROC/CROC state-machine is a bit complicated. In
>> the future we'll probably want to use wpa_supplicant to control
>> the ROC during connection.
>
> But when we have multirole, we may have several instances of
> wpa_supplicant/hostap running, so there may be some conflicts of
> interest there.  I think it's better to keep ROCing in a centralized
> place (ie. the driver).
>
still, some of the logic (i.e. ROC until connection) should be in the
supplicant.
of course the driver will have to organize it all (e.g. return -EBUSY).

Eliad.
