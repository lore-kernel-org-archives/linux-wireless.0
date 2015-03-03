Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:34435 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbbCCKPl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 05:15:41 -0500
Received: by wghn12 with SMTP id n12so39034633wgh.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Mar 2015 02:15:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425375418.2450.27.camel@sipsolutions.net>
References: <1423568924-11895-1-git-send-email-michal.kazior@tieto.com>
 <1425374168.2450.17.camel@sipsolutions.net> <CABPxzY+hcmAHCzn+JvYRurDYO3yZ=_bRkDFODrbRMJ0L75yZ9A@mail.gmail.com>
 <1425375418.2450.27.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 3 Mar 2015 15:45:20 +0530
Message-ID: <CABPxzYLbF-b5DKBBNo2PK5iDn64HuSo9N63mfT2fNfvgLhEFrQ@mail.gmail.com> (sfid-20150303_111546_138439_421B9323)
Subject: Re: [PATCH] mac80211: disable u-APSD queues by default
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 3, 2015 at 3:06 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> >> Cisco 4410N originally forced us to enable VO by
>> >> default only because it treated non-VO ACs as
>> >> legacy.
>
>> Mixed mode (uapsd + legacy) is not really the optimal
>> configuration, where we expect STA to send trigger frames periodically
>> to retrieve the DL packets (especially very first packet).
>>
>> But still if we want power save, i suggest going for
>> All u-apsd (0xF), so that AP will inform us by setting the TIM bit
>> and we can retrieve the first frame.
>> (We have this patch internally and it works well).
>
> Except where it doesn't work, like on the Cisco 4410N - see above.
But for that single AP, we are forced to lose efficient power savings
unless user configured explicitly.
