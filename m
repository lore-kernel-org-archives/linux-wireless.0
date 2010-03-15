Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f198.google.com ([209.85.216.198]:57294 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410Ab0COXZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 19:25:36 -0400
Received: by pxi36 with SMTP id 36so2374006pxi.21
        for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 16:25:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100315214338.GB4000@tux>
References: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
	<20100315214338.GB4000@tux>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 15 Mar 2010 16:25:14 -0700
Message-ID: <43e72e891003151625t795b8ecdr2ce2e6927e8632a4@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] ath9k_hw: complete support for AR9271
To: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Sujith <Sujith.Manoharan@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 15, 2010 at 2:43 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Fri, Mar 12, 2010 at 09:46:44PM -0800, Luis R. Rodriguez wrote:
>>   * I spotted a check added to bail out for tweaking the ACK/CTS
>>     time out values -- this check should no longer be required
>>     since Felix sent a proper fix for this recenlty. I removed that
>>     hunk:
>>
>> @@ -1210,6 +1195,9 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
>>               REG_WRITE(ah, AR_PCU_MISC,
>>                         REG_READ(ah, AR_PCU_MISC) | ah->misc_mode);
>>
>> +     if (AR_SREV_9271(ah))
>> +             return;
>> +
>>       if (conf->channel && conf->channel->band == IEEE80211_BAND_5GHZ)
>>               sifstime = 16;
>>       else
>> --
>
> Turns out this hunk is required... but the rf changes are not (patch 4/12)
> so I'll just respin and send a new series out.
>
> We should look for a better way to address this issue instead of the above hunk
> otherwise we will be skipping all changes to the slot time from mac80211.
> Right now ath9k_htc does not support this (BSS_CHANGED_ERP_SLOT) or a
> set_coverage_class() callback.

We'll need to support at least BSS_CHANGED_ERP_SLOT in case the AP
switches to compatibility mode.

  Luis
