Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56170 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab0IITNy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 15:13:54 -0400
Received: by qyk36 with SMTP id 36so6402078qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Sep 2010 12:13:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e23a1b600a18f179fa72d2cadf724d17@localhost>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
	<1283988329-44549-6-git-send-email-steve@cozybit.com>
	<e23a1b600a18f179fa72d2cadf724d17@localhost>
Date: Thu, 9 Sep 2010 12:13:52 -0700
Message-ID: <AANLkTi=r_RdEG-2=gzV7uFNJt1Nynp3qNC-38SQkzhO2@mail.gmail.com>
Subject: Re: [PATCH 5/9] libertas_tf: Moved firmware loading to probe in order
 to fetch MAC address
From: Steve deRosier <steve@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 9, 2010 at 9:38 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Wed,  8 Sep 2010 16:25:25 -0700, Steve deRosier <steve@cozybit.com>
> wrote:
>> mac80211 requires that the MAC address be known and set before calling
>> ieee80211_register_hw().  If this isn't done, we see bad MAC addresses
>> in our packet headers.  In order to make this happen, I had to
> restructure
>> to have if_sdio_probe load the firmware and get the hardware specs.
>>
>> I had to add a if_sdio_update_hw_spec function as if_sdio can't use the
>> standard
>> command as several required variables aren't setup yet.
>> if_sdio_update_hw_spec essentially uses polled io to get the hw spec
>> command response from the card.
>
> You should probably keep this for development purposes, but it will break
> if your code is built into the kernel. The working model we've adopted to
> solve this is to use request_firmware_nowait() in probe, and then only
> continue doing work when the firmware loading returns (and then register
> with mac80211 etc)
>

Johannes,

Before doing any of this stuff (back in patch 1), my driver goes
through and loads the firmware using the request_firmware() calls
anyway. In other words, I haven't changed that part.  Is the problem
specifically with my "get the MAC from the hardware before setting up
mac80211" change, or with waiting on firmware loading?

For fun, I just tried compiling the driver into the kernel.  Mixed
results: with two cards on the system, the first card found failed on
the call to request_firmware() with a -ENOENT, while the second card
came up just fine.  When done as modules, both work fine.  So there's
clearly something to what you're saying. Is it that the filesystem is
not up and available yet when we try to load the firmware for the
first card?

>From looking through the drivers, iwl and ar9170_usb are the only ones
to use the request_firmware_nowait().  I don't know if those are the
only mac80211 cards with firmware or not everyone's following the
model.

Do you have specific pointers of which code I should look at as a
model, or a better way to solve the problem?

In the short term, can we limit libertas_tf to build as module only
via Kconfig, and I can add the request_firmware_nowait() as a new
feature later with a new patch?  Looking at the examples, it looks
like the changes for this would be fairly involved and I would prefer
to break such a change out separately.  I'd like to get
libertas_tf_sdio accepted as a base so I can then do smaller change
sets going forward. Is that a reasonable plan or just plain silly?

BTW, thanks for pointing out this problem.  I hadn't tried this built
into the kernel and it never occurred to me that this would be an
issue.

Thanks,
- Steve
