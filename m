Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:37794 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbdBXAEV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 19:04:21 -0500
Received: by mail-it0-f52.google.com with SMTP id 203so4790753ith.0
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2017 16:03:00 -0800 (PST)
Received: from mail-it0-f45.google.com (mail-it0-f45.google.com. [209.85.214.45])
        by smtp.gmail.com with ESMTPSA id o191sm2434366iod.11.2017.02.23.16.02.59
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Feb 2017 16:02:59 -0800 (PST)
Received: by mail-it0-f45.google.com with SMTP id h10so4145632ith.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2017 16:02:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <484d045e-d4ca-2073-9a16-8d3556027d75@uni-rostock.de>
References: <20170223120211.22358-1-andrew.zaborowski@intel.com>
 <20170223120211.22358-2-andrew.zaborowski@intel.com> <484d045e-d4ca-2073-9a16-8d3556027d75@uni-rostock.de>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Fri, 24 Feb 2017 01:02:58 +0100
Message-ID: <CAOq732JfGKgdtVtjew5EXua+4mkyO+DZttSG-8F2q3yyxy_M2g@mail.gmail.com> (sfid-20170224_010424_640787_467D61B9)
Subject: Re: [PATCH 2/2][RFC] mac80211_hwsim: Report radio addresses in NEW_RADIO/GET_RADIO
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 February 2017 at 20:01, Benjamin Beichler
<Benjamin.Beichler@uni-rostock.de> wrote:
>> Add a HWSIM_ATTR_RADIO_ADDR attribute to those to events/response so
>> that a userspace medium can query the list of addresses in the
>> simulator.
>>
>> When a userspace medium needs to handle a broadcast frame it can't
>> easily implement the equivalent of what the default kernel medium does
>> because it doesn't know who to forward the frame to.  The
>> HWSIM_CMD_GET_RADIO command is a little useless in this respect.
>> Userspace needs to use HWSIM_CMD_GET_RADIO, then cross-reference the
>> radio names with wiphy names using NL80211_CMD_GET_WIPHY dump, map the
>> wiphy names to wiphy indexes (those are more useful than wiphy names
>> because they don't change -- a wiphy name change doesn't generate an
>> event so this can't be easily tracked), and use the
>> NL80211_CMD_GET_INTERFACES dump to obtain the wiphy_idx to mac address
>> mapping.
> I'm a bit confused, I think the medium should always know by its
> internal knowledge base, which node would be reachable by a broadcast.

So it depends on your architecture really, you can have a setup where
one userspace program creates all of the radios and registers as a
medium.  In this case the program will know what nodes exist, but it
still won't have the hardware addresses to use in
HWSIM_ATTR_ADDR_RECEIVER because there's no way to query them through
netlink (?).  Unless you assume that each consecutive radio gets
42:00:00:00:<n>:00 assigned.  That would only work if no radios have
been created before your program started because you <n> values could
be off.

But you might also want to do your testing from a script that first
creates the radios using one utility program and runs the medium as a
separate program.  In that case that program can't do the equivalent
of what the kernel medium does.

>
> We are also working on the MAC-Management of hwsim, which especially got
> weird, if you try to manage many nodes within one kernel. But I don't
> understand how this array with addresses could help to improve. When
> these addresses do not exactly match to the preconfigured MACs of hwsim,
> the frames would not be delivered, since they are only checked against
> the internal ones (or you may add a check against your list).

Those addresses I try to expose are exactly the preconfigured MACs.

Looking at this some more I found you can retrieve those addresses
from /sys/class/ieee80211/<wiphy>/addresses (there seems to be no
nl80211 API for this) since those are always in sync with the hwsim
addresses, the only issue would be mapping radios to wiphys by name.

>
> I test to use a internal hashmap, which maps a receiver MAC-Address of a
> Frame to a corresponding wiphy node to efficiently deliver frames.
> Additionally it would allow to add VIF with different MAC-Addresses (see
> corresponding Callback for this) and update the hashmap according to
> this. I believe you want to do something similar, but in the userspace.

Yes, either use a lookup table for unicast frames, or deliver all
frames (unicast or multicast) to all radios same as the kernel radio
does.

Best regards
