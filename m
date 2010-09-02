Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47945 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab0IBO5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 10:57:25 -0400
Received: by gwj17 with SMTP id 17so173690gwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Sep 2010 07:57:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100902131828.GA6802@tuxdriver.com>
References: <AANLkTiko4XRM=xQWHy2H5WUMbYBzRE+NfUeqS20S2D_S@mail.gmail.com> <20100902131828.GA6802@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 2 Sep 2010 07:57:04 -0700
Message-ID: <AANLkTik5Ybr1311Q=-vbF6RSC15ixAshU4WBd7fQaxC7@mail.gmail.com>
Subject: Re: WARNING: at net/mac80211/tx.c:653 ieee80211_tx_h_rate_ctrl+0x460
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 2, 2010 at 6:18 AM, John W. Linville <linville@tuxdriver.com> wrote:
> On Wed, Sep 01, 2010 at 04:45:46PM -0700, Luis R. Rodriguez wrote:
>> Just hit this
>>
>>         /*
>>          * Lets not bother rate control if we're associated and cannot
>>          * talk to the sta. This should not happen.
>>          */
>>         if (WARN(test_bit(SCAN_SW_SCANNING, &tx->local->scanning) &&
>>                  (sta_flags & WLAN_STA_ASSOC) &&
>>                  !rate_usable_index_exists(sband, &tx->sta->sta),
>>                  "%s: Dropped data frame as no usable bitrate found while "
>>                  "scanning and associated. Target station: "
>>                  "%pM on %d GHz band\n",
>>                  tx->sdata->name, hdr->addr1,
>>                  tx->channel->band ? 5 : 2))
>>                 return TX_DROP;
>
> Also seeing that here:
>
>        https://bugzilla.redhat.com/show_bug.cgi?id=606393
>
> "I surmise that the device is exiting dynamic power saving mode and
> attempting to transmit a frame to notify the AP that it is awake.
> Instead, it is hitting this check in ieee80211_tx_h_rate_ctrl". -- me

I also see the no usable low bitrate warning but I am testing roaming,
I am starting to suspect the wrong sband might be pegged to a peer
when roaming between 5 GHZ down to 2.4 GHz.

  Luis
