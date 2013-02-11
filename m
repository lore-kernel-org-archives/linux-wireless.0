Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:47199 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab3BKHzF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 02:55:05 -0500
Received: by mail-we0-f170.google.com with SMTP id z53so4702695wey.29
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2013 23:55:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360250827.8038.10.camel@jlt4.sipsolutions.net>
References: <7384f4ddc838247a0f467708d66baa8c@posedge.com> <1360225230.8038.1.camel@jlt4.sipsolutions.net>
 <CABPxzYLnWjxtN_c1sFXpA3Ye9ZNvQgV1dU0z=59j0WqgM-rUpg@mail.gmail.com>
 <1360228991.8038.3.camel@jlt4.sipsolutions.net> <CABPxzYLwEfzwS9b8dAGjbqT2MLo9FdTKkRwWKDvzxp82ObB-9Q@mail.gmail.com>
 <5113B42A.4020708@openwrt.org> <1360246653.8038.9.camel@jlt4.sipsolutions.net>
 <CABPxzYJG3xP0_Wy-1HMjWx-YoHp5WmhrfBH5vBvOJ4WQ_7Nzrg@mail.gmail.com>
 <5113C5E0.5050509@openwrt.org> <1360250827.8038.10.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 11 Feb 2013 13:24:42 +0530
Message-ID: <CABPxzYLY5-MmePjUUGedC4rT88b328u7AKOeHREuF11BuOjYGA@mail.gmail.com> (sfid-20130211_085517_681941_152A0488)
Subject: Re: [RFC] mac80211: Add support for Tx-AMSDU viz debugfs.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>, chaitanyatk@posedge.com,
	linux-wireless@vger.kernel.org, maheshp@posedge.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 7, 2013 at 8:57 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2013-02-07 at 16:18 +0100, Felix Fietkau wrote:
>
>> > But whats the use of sending an AMSDU if we are not connected?
>> > First check in the code is to check for a connection.
>> I mentioned cooked monitor because putting the hw in monitor mode may
>> not always be desirable, and cooked monitor bypasses that.
>
> You can pass "flags none" on the iw command line and it shouldn't change
> much then, but yeah, still might do a few other things. Anyway cooked
> should work fine.

Even in the cooked monitor case, the setting of qos_header is done
in the ieee80211_xmit(), so we still need to have some flag to know
if its an AMSDU/Not based, even if we set the bit in the user space
this will overwrite that.
