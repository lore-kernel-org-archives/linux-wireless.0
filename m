Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:35693 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbcAGQ7H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 11:59:07 -0500
Received: by mail-qk0-f173.google.com with SMTP id n135so187108466qka.2
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2016 08:59:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALnQHM3O6Z3E2wSkVLirDHCdT8vQqvQbqVEcSs8mfsfGs9KFyg@mail.gmail.com>
References: <CALnQHM3C=DVaTf58XDyh+rttVs-FSpc4ghozg9HJktEonq7w-g@mail.gmail.com>
 <568E913D.7050301@candelatech.com> <CALnQHM1mzqFbprQqujB7BWncOa=D9uAxLQ0paiv-21vrx+hFvw@mail.gmail.com>
 <CABPxzYKaMPY6bz=Nr+W2wG5y_bV_wFN=7AMNUNcZNJBeVyYVJA@mail.gmail.com> <CALnQHM3O6Z3E2wSkVLirDHCdT8vQqvQbqVEcSs8mfsfGs9KFyg@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 7 Jan 2016 22:28:46 +0530
Message-ID: <CABPxzY+Me1ocZQYPtw83Wa_0ti+eOiOf1d1srHqtf_nsu-ON9w@mail.gmail.com> (sfid-20160107_175911_536979_AD86B739)
Subject: Re: lost connectivity until "wpa_cli reassociate" is issued
To: David Mosberger <davidm@egauge.net>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 7, 2016 at 10:17 PM, David Mosberger <davidm@egauge.net> wrote:
> On Thu, Jan 7, 2016 at 9:32 AM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:
>
>> Management frames use a different queue (VO)
>> from the logs it looks like a data path issue in driver/FW.
>>
>> The re-association might be clearing/triggering TX in driver
>> solving the issue.
>
> That sounds plausible to me.  Is there an easy way to see the queues?
> I haven't tried debugfs yet.
We can check pending packets per queue at mac80211, but first
we need some info from driver level. Someone familiar with RTL
should help.

cat /sys/kernel/debug/ieee80211/phy*/queues

If you see non-zero packets here (or) if the queue is stopped
that might explain this behavior...
