Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34331 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbcAGQ3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 11:29:40 -0500
Received: by mail-io0-f177.google.com with SMTP id 1so210616106ion.1
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2016 08:29:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <568E913D.7050301@candelatech.com>
References: <CALnQHM3C=DVaTf58XDyh+rttVs-FSpc4ghozg9HJktEonq7w-g@mail.gmail.com>
	<568E913D.7050301@candelatech.com>
Date: Thu, 7 Jan 2016 09:29:39 -0700
Message-ID: <CALnQHM1mzqFbprQqujB7BWncOa=D9uAxLQ0paiv-21vrx+hFvw@mail.gmail.com> (sfid-20160107_172943_615070_E61C6D5B)
Subject: Re: lost connectivity until "wpa_cli reassociate" is issued
From: David Mosberger <davidm@egauge.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben,

On Thu, Jan 7, 2016 at 9:24 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 01/07/2016 08:19 AM, David Mosberger wrote:
>>
>> We are seeing a curious issue where WLAN connectivity sometimes
>> gets stuck until a "wpa_cli reassociate" command is issued.
>>
>> At the WPA level, everything appears to be working fine)
>> (see thread starting at
>> http://lists.infradead.org/pipermail/hostap/2016-January/034454.html).
>
> I don't remember seeing you mention the driver and NIC you are using.
>
> I think this is likely a driver bug, so please provide that info.

Sure, we're using rtl8192cu.  I started out suspecting a driver bug as
well, but since we're processing management frames during those
"stuck" periods just fine (see
debug output in
http://lists.infradead.org/pipermail/hostap/2016-January/034459.html),
I'm not so sure anymore.  Like mac80211, we have patched rtl8192cu
driver with current
bug-fixes already.

  --david
-- 
eGauge Systems LLC, http://egauge.net/, 1.877-EGAUGE1, fax 720.545.9768
