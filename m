Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f176.google.com ([209.85.222.176]:57412 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab0BAVcm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 16:32:42 -0500
Received: by pzk6 with SMTP id 6so1014185pzk.23
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2010 13:32:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100201203637.GE4952@tuxdriver.com>
References: <1264905444.10146.9.camel@mj> <43e72e891002011011h4714ecddrb9421a877832bffd@mail.gmail.com>
	<20100201203637.GE4952@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Feb 2010 13:32:22 -0800
Message-ID: <43e72e891002011332g5ee05addp3f140ea23a45e09d@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix access to freed data on unload
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 1, 2010 at 12:36 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Mon, Feb 01, 2010 at 10:11:54AM -0800, Luis R. Rodriguez wrote:
>> On Sat, Jan 30, 2010 at 6:37 PM, Pavel Roskin <proski@gnu.org> wrote:
>> > Calling ath_bus_cleanup() after ieee80211_free_hw() resulted in access
>> > to common->bus_ops, which is already freed as part of the device data.
>> >
>> > Remove the cleanup field in struct ath_bus_ops, as it was never used
>> > properly.  Remove ath_bus_cleanup().  Merge cleanup functions in place
>> > of the ath_bus_cleanup() calls.  Take care not to use any device data
>> > after ieee80211_free_hw().
>> >
>> > Signed-off-by: Pavel Roskin <proski@gnu.org>
>> > ---
>> >
>> > The bug was causing a hang on a kernel with most debugging options
>> > enabled.  I think the fix is important and simple enough for stable
>> > kernels.  I wish I could make the patch smaller, but I didn't want to
>> > leave unused and dangerous fields and functions.
>> >
>> > ath9k was tested on the PCI bus.  ath9k on AHB was compile tested.
>> > ath5k and ar9170 use struct ath_bus_ops, but don't use the cleanup
>> > field, so they are not affected.
>>
>> Thanks, can you please resend with a Cc: stable@kernel.org on the commit log?
>
> Doesn't look to me like the patch even applies to 2.6.33...?

Sorry thought it would have by then.

  Luis
