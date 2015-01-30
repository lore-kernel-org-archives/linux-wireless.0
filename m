Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39714 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbbA3NGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:06:09 -0500
Received: by mail-wi0-f177.google.com with SMTP id r20so2549301wiv.4
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 05:06:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422622694.1919.17.camel@sipsolutions.net>
References: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
	<1422621086-28970-1-git-send-email-michal.kazior@tieto.com>
	<1422621086-28970-3-git-send-email-michal.kazior@tieto.com>
	<1422622694.1919.17.camel@sipsolutions.net>
Date: Fri, 30 Jan 2015 14:06:08 +0100
Message-ID: <CA+BoTQkVuDqZVCVUB6pkDKp2tZ1sgnezju6Kg48JvnS4a_LZyA@mail.gmail.com> (sfid-20150130_140621_385051_2BA65BD6)
Subject: Re: [PATCH v2 2/7] ath10k: implement chanctx API
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 January 2015 at 13:58, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>
>> @@ -277,6 +282,7 @@ struct ath10k_vif {
>>       dma_addr_t beacon_paddr;
>>
>>       struct ath10k *ar;
>> +     struct ath10k_chanctx *arctx;
>
> you also have vif->chanctx_conf pointer, which you could use
>
> ultimately it's a software architecture decision - personally I wouldn't
> want to duplicate all that data and the lists etc. in the driver when
> mac80211 has them, but that's just my opinion. :)

I'm a bit reluctant to freely use mac80211 owned structures out of
mac80211_ops callback context, i.e. from a tasklet fearing
inconsistencies. Or am I worrying unnecessarily? If so I guess I'll
redo this and use mac80211's structures directly :-)


Michał
