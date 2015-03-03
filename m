Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34071 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbbCCLU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 06:20:26 -0500
Received: by wghn12 with SMTP id n12so39375807wgh.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Mar 2015 03:20:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQnTvqYB6VS=bzk8bcV1xHPAZtyq0oJa0C2oe0Gd0wj+NQ@mail.gmail.com>
References: <1423568924-11895-1-git-send-email-michal.kazior@tieto.com>
 <1425374168.2450.17.camel@sipsolutions.net> <CABPxzY+hcmAHCzn+JvYRurDYO3yZ=_bRkDFODrbRMJ0L75yZ9A@mail.gmail.com>
 <1425375418.2450.27.camel@sipsolutions.net> <CABPxzYLbF-b5DKBBNo2PK5iDn64HuSo9N63mfT2fNfvgLhEFrQ@mail.gmail.com>
 <CA+BoTQnTvqYB6VS=bzk8bcV1xHPAZtyq0oJa0C2oe0Gd0wj+NQ@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 3 Mar 2015 16:50:05 +0530
Message-ID: <CABPxzYJHmLpXesY2iNiosF2fN+fyJM_jYRUuXidV__YHzQMsvA@mail.gmail.com> (sfid-20150303_122030_678624_A750CD84)
Subject: Re: [PATCH] mac80211: disable u-APSD queues by default
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 3, 2015 at 3:58 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 3 March 2015 at 11:15, Krishna Chaitanya <chaitanya.mgit@gmail.com> wrote:
>> On Tue, Mar 3, 2015 at 3:06 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>>>
>>>> >> Cisco 4410N originally forced us to enable VO by
>>>> >> default only because it treated non-VO ACs as
>>>> >> legacy.
>>>
>>>> Mixed mode (uapsd + legacy) is not really the optimal
>>>> configuration, where we expect STA to send trigger frames periodically
>>>> to retrieve the DL packets (especially very first packet).
>>>>
>>>> But still if we want power save, i suggest going for
>>>> All u-apsd (0xF), so that AP will inform us by setting the TIM bit
>>>> and we can retrieve the first frame.
>>>> (We have this patch internally and it works well).
>>>
>>> Except where it doesn't work, like on the Cisco 4410N - see above.
>> But for that single AP, we are forced to lose efficient power savings
>> unless user configured explicitly.
>
> Correct me if I'm wrong, but u-APSD makes sense only if you have
> userspace apps aware of it. I don't know any. VoIP traffic uses and it
> works just because it generate bi-directional traffic in most cases so
> you have implicit trigger frames generated when you Tx, but that's
> probably as far as the practical use-case goes, no? You'd still need
> netfilter rules to reclassify your traffic anyway, wouldn't you? If
> you mainly wait for data you need to send trigger frames periodically
> and only userspace app knows what Rx latency is tolerated (that's why
> relying on driver/firmware auto-trigger generation doesn't cut it).

Agree u-apsd is tightly coupled with the applications. But there is a
provision in the protocol to deliver buffered frames without sending
explicit triggers (which is quite waste of tx power). So it might be
optimized for each application, but overall it will not break the
functionality for those drivers who do not send explicit triggers
frames periodically.

Even for unidirectional protocol has a provison when All AC's are
delivery enabled, it will still set the TIM bit, so using which we can
start sending trigger frames. So either disabling/enabling u-apsd is
fine aslong as we do it for all AC's together, mixed mode is useless.

>
> Anyway I don't think you can ask users to do the opposite (i.e.
> disable u-APSD if they experience problems with APs). Wi-Fi should
> Just Work. Joys of IOT..
May be in utopia ;-).




-- 
Thanks,
Regards,
Chaitanya T K.
