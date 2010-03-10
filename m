Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57056 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439Ab0CJXpE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 18:45:04 -0500
Received: by pvb32 with SMTP id 32so2273525pvb.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Mar 2010 15:45:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100310201609.GB3093@tuxdriver.com>
References: <19336.46643.733555.555640@gargle.gargle.HOWL>
	<20100310201609.GB3093@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 10 Mar 2010 15:44:43 -0800
Message-ID: <43e72e891003101544g46b1731fu9bb3dc1329b7d591@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath9k_htc: Add ath9k_htc driver
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Sujith <Sujith.Manoharan@atheros.com>,
	linux-wireless@vger.kernel.org, Vasanth.Thiagarajan@atheros.com,
	Senthilkumar.Balasubramanian@atheros.com,
	luis.rodrigues@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 10, 2010 at 12:16 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Sat, Feb 27, 2010 at 11:35:39AM +0530, Sujith wrote:
>> Support for AR9271 chipset.
>>
>> Features:
>>
>>  * Station mode
>>  * IBSS mode
>>  * Monitor mode
>>  * Legacy support
>>  * HT support
>>  * TX/RX 11n Aggregation
>>  * HW encryption
>>  * LED
>>
>> For more information: http://wireless.kernel.org/en/users/Drivers/ath9k_htc
>>
>> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
>> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
>> Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>

I should note Senthil sent out the new revised series today. I just
revised it and it addresses the issues I saw, but does not make ath9k
itself use the new common helpers, which is fine, I suppose that can
be done on a separate patch...

> So I got the impression from another thread that Atheros is hoping
> to get this merged into the 2.6.34 stream, presumably under the
> idea that this is a new driver.

Your call, it did seem worth it to enable users of 2.6.34 with new
hardware. I can explain the patches further in detail to help you
better assess whether or not this is 2.6.34 material.

> But this doesn't just add files,
> it makes a few changes to existing ath9k files (i.e. not just Kconfig
> and/or Makefile).

Just a tad few changes, yes.

> Are you hoping to see this in 2.6.34?

Its your call, but I think its worth it if indeed this can't regress
any existing ath9k code, to enable users of that kernel with new
hardware.

>  Why don't those other bits matter?  How can you be sure that they don't destabilize ath9k for
> _anyone_?

So there are 3 patches. Let me review them in careful detail with
regards to how it would change anything specific to the existing ath9k
code. I'll leave out specifics which deal with brand new code, which
is irrelevant to this discussion.

The first patch, add ath9k_htc
==================

The first patch just adds the driver itself and only modifies existing
code to *add* new code and a few structures and defines which are not
used by the old code. From the diff stat on the ath9k_htc patch the
stuff which touches the old ath9k stuff is:

 drivers/net/wireless/ath/ath9k/common.c         |  421 ++++++
 drivers/net/wireless/ath/ath9k/common.h         |   17 +

This just adds common helpers, not used by ath9k, only used by
ath9k_htc. Not sure why the "common" helpers were not made to be used
by ath9k, but whatever I can talk to you about that on IRC...

 drivers/net/wireless/ath/ath9k/mac.h            |   26 +

This adds the ath_htc_rx_status, that's it.

 drivers/net/wireless/ath/debug.h                |    1 +

This adds an entry to enable debugging for WMI specific stuff, ATH_DBG_WMI.


The second patch, few hardware fixes for ath9k_hw for ath9k_htc
=======================================

ath9k_htc adds support for the first USB HTC device, ar9271. I had
added the original hardware code support for ar9271, this patch
sprinkles new branches to handle ar9271 a little differently here and
there and also makes some fixes against the old hardware code based on
our latest HAL. This entire patch should not regress as the matches
for AR9271 checks would only be for the new hardware which has the
AR9271 chip revision. The checks for AR9271 are done with the checks
like:

AR_SREV_9271(ah)

There is one change which I asked to be dropped but wasn't even on the
latest series by Senthil, which is small enough it doesn't matter, it
is just a new line added on calib.h:

--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -114,6 +114,7 @@ struct ath9k_nfcal_hist {
 };

 #define MAX_PACAL_SKIPCOUNT 8
+
 struct ath9k_pacal_info{
        int32_t prev_offset;    /* Previous value of PA offset value */
        int8_t max_skipcount;   /* Max No. of times PACAL can be skipped */

If you want that can be dropped :)

Apart from this there is also initialization values, but all those are
specific to ar9271 as well.

IMHO this patch should have been split up to individual patches, each
addressing specific hardware fixes for ar9271 but since ar9271 never
actually had a driver core to support it anyway or claim the device I
think its reasonable to piggy them back all together in one. Still not
my preference.

Third patch - ath9k: Fix HW deinit
====================

This one should have been Cc stable IMHO so it is 2.6.34 material anyway.

-------

Hope that helps you assess whether or not this is 2.6.34 material.

  Luis
