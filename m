Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35813 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbbCCJdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 04:33:52 -0500
Received: by wivz2 with SMTP id z2so1793315wiv.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Mar 2015 01:33:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425374168.2450.17.camel@sipsolutions.net>
References: <1423568924-11895-1-git-send-email-michal.kazior@tieto.com> <1425374168.2450.17.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 3 Mar 2015 15:03:31 +0530
Message-ID: <CABPxzY+hcmAHCzn+JvYRurDYO3yZ=_bRkDFODrbRMJ0L75yZ9A@mail.gmail.com> (sfid-20150303_103356_579418_6B00FFD8)
Subject: Re: [PATCH] mac80211: disable u-APSD queues by default
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 3, 2015 at 2:46 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2015-02-10 at 12:48 +0100, Michal Kazior wrote:
>> Some APs experience problems when working with
>> U-APSD. Decreasing the probability of that
>> happening by using legacy mode for all ACs but VO
>> isn't enough.
>>
>> Cisco 4410N originally forced us to enable VO by
>> default only because it treated non-VO ACs as
>> legacy.
>>
>> However some APs (notably Netgear R7000) silently
>> reclassify packets to different ACs. Since u-APSD
>> ACs require trigger frames for frame retrieval
>> clients would never see some frames (e.g. ARP
>> responses) or would fetch them accidentally after
>> a long time.
>
> This makes me a little sad, but I've applied this and even added a Cc
> stable tag due to the interoperability issues.
>
Mixed mode (uapsd + legacy) is not really the optimal
configuration, where we expect STA to send trigger frames periodically
to retrieve the DL packets (especially very first packet).

But still if we want power save, i suggest going for
All u-apsd (0xF), so that AP will inform us by setting the TIM bit
and we can retrieve the first frame.
(We have this patch internally and it works well).
