Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:28559 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbYEOOlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 10:41:09 -0400
Received: by fk-out-0910.google.com with SMTP id 18so332650fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2008 07:41:07 -0700 (PDT)
Message-ID: <eb97335b0805150741g252ba49ckbf1b493a46acf762@mail.gmail.com> (sfid-20080515_164114_872147_BF69A300)
Date: Thu, 15 May 2008 10:41:07 -0400
From: "Zack Weinberg" <zackw@panix.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: Getting ath5k driver working with Thinkpad T61 [168c:1014]
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <b6c5339f0805141209p4a8b1b2do1cb2ec1c11de07e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <eb97335b0805141024w6afa864j860b312b072faa8a@mail.gmail.com>
	 <b6c5339f0805141138o5575095du1f12c62624c80630@mail.gmail.com>
	 <eb97335b0805141145v3436e0e3ld7bd2721cbf0d15f@mail.gmail.com>
	 <b6c5339f0805141209p4a8b1b2do1cb2ec1c11de07e8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 14, 2008 at 3:09 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Wed, May 14, 2008 at 2:45 PM, Zack Weinberg <zackw@panix.com> wrote:
>> exactly the same thing happens immediately after cold boot with
>> nothing else having touched the chip.
>
> Interesting...  can you confirm that madwifi also will not start from a cold
> boot?

Yes, madwifi will not start from a cold boot.

> Perhaps the best thing to do is add printks to ath5k_hw_nic_wakeup and see
> where it hangs?

It's not hanging. The very first call to ath5k_hw_set_power(ah,
AR5K_PM_AWAKE, true, 0); from ath5k_hw_nic_wakeup fails with -EIO, and
the driver gives up.

zw
