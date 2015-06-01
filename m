Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:36013 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbbFAXsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 19:48:54 -0400
Received: by ieclw1 with SMTP id lw1so26107283iec.3
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 16:48:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433190860.3505.16.camel@sipsolutions.net>
References: <1433187498-15124-1-git-send-email-cfliu.tw@gmail.com> <1433190860.3505.16.camel@sipsolutions.net>
From: "Liu CF/TW" <cfliu.tw@gmail.com>
Date: Mon, 1 Jun 2015 16:48:13 -0700
Message-ID: <CAG5N3qFDTJW3-YmpCLKXeniZGtWYpHo7Bmpn+u2sxoAs7S0t4w@mail.gmail.com> (sfid-20150602_014857_820253_30E91B15)
Subject: Re: [PATCH] mac80211: support IEEE80211_KEY_FLAG_RESERVE_TAILROOM for
 CCMP and TKIP.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes, yes indeed you are right. This change is indeed not required/right.
It's the special sw crypto path I'm working on in ath10k that resulted
in the ieee80211_key_enable_hw_accel() code being skipped.
I will fix this in ath10k driver internally.

Thanks
David

On Mon, Jun 1, 2015 at 1:34 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2015-06-01 at 12:38 -0700, David Liu wrote:
>> The change reserves neccessary tailroom in CCMP and TKIP if required by
>> drivers that sets IEEE80211_KEY_FLAG_RESERVE_TAILROOM. For example,
>> ath10k HW engine in raw Tx/Rx encap mode requires SW reserve MIC/ICV space.
>
> I don't think this makes all that much sense. The flag is already
> honoured today to actually leave enough tailroom in the SKB, and the
> remainder of the code can very easily be done in the driver (in fact, if
> you have a half-decent DMA engine, it's far more efficient to *not* set
> this flag!)
>
> You're also breaking other drivers with your change. Just do it in the
> driver.
>
> johannes
>
