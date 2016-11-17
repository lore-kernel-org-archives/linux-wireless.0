Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37234 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbcKQUXM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 15:23:12 -0500
Received: by mail-wm0-f42.google.com with SMTP id t79so169670373wmt.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2016 12:23:12 -0800 (PST)
Subject: Re: [RFC 0/5] nl80211: add support for g-scan
To: Johannes Berg <johannes@sipsolutions.net>
References: <1479388726-3288-1-git-send-email-arend.vanspriel@broadcom.com>
 <1479393551.1463.11.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Dmitry Shmidt <dimitrysh@google.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <32018e71-4fb0-92db-158e-e1a98d4f7d28@broadcom.com> (sfid-20161117_212316_751851_6D3A5EB9)
Date: Thu, 17 Nov 2016 21:23:09 +0100
MIME-Version: 1.0
In-Reply-To: <1479393551.1463.11.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17-11-2016 15:39, Johannes Berg wrote:
> On Thu, 2016-11-17 at 13:18 +0000, Arend van Spriel wrote:
>> Android employs a Wifi-HAL layer in its wireless frame. It basically
>> abstracts dealing with netlink messages from the framework. For some
>> features it employs nl80211 vendor commands. The goal I set myself is
>> to be able to have a generic nl80211 Wifi-HAL implementation. One of
>> the features currently requiring the vendor commands is g-scan. We
>> can only guess what the 'g' stands for ;-) This series converts the
>> vendor command api into common nl80211 api.
> 
> Hehe :)
> We also have gscan API. If you're interested, you can see it here:
> https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/backport-iwlwifi.git/tree/drivers/net/wireless/intel/iwlwifi/mvm/vendor-cmd.h#n96

I am interested and I did have a look at it when I found out, but I had
already tinkered out a large portion so decided to stick with that.

>> Before making an attempt to explain more about the g-scan
>> functionality first this. While I am still testing the driver
>> implementation resulting in numerous questions Dmitry send the email
>> below to bring a related discussion to the table..eh.. the linux-
>> wireless list. This is probably a good thing as anyone can dive in
>> and share their thoughts.
> 
> 
> Yeah. How does this overlap? Have you looked at it already?

The overlap occurred when Dmitry pointed me to this thread in response
to questions I had regarding gscan :-p Now the similarity is reflected
mainly in terms used for functionality like bss hotlist, batch results,
etc. which are also found in gscan defintions in android wifi hal.

The main difference between the gscan and universal scan is that gscan
specifies everything in a single start request and the universal scan
api can be used to add/remove individual scans, which would be
equivalent with the ability to add/remove buckets in gscan.

I will comment more replying the RFC email from Dmitry.

Regards,
Arend
