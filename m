Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33719 "EHLO
	mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbcHDMDP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2016 08:03:15 -0400
Received: by mail-it0-f68.google.com with SMTP id d65so19521303ith.0
        for <linux-wireless@vger.kernel.org>; Thu, 04 Aug 2016 05:02:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACiydb+PfbS+Hc79My2HFqdacFtik7_H8d3kFsrST6m1GnSAgA@mail.gmail.com>
References: <1463489221-24989-1-git-send-email-michal.kazior@tieto.com>
 <1467201146-6844-1-git-send-email-michal.kazior@tieto.com>
 <87zipt1kco.fsf@kamboji.qca.qualcomm.com> <CACiydb+yNc-UKVRFR-UxTq-YFBDpEDsa1qWNBGCHpe=_zv8o7g@mail.gmail.com>
 <CAA93jw6j0pBKnm3Fs=D7V1CUsBnhZKKymbk4=UQuFWKuEAs-+Q@mail.gmail.com> <CACiydb+PfbS+Hc79My2HFqdacFtik7_H8d3kFsrST6m1GnSAgA@mail.gmail.com>
From: Dave Taht <dave.taht@gmail.com>
Date: Thu, 4 Aug 2016 14:02:23 +0200
Message-ID: <CAA93jw6OBQg2NwJGU6kJLM6oc=8zHRR3qgknjNo=8vHETtcU_Q@mail.gmail.com> (sfid-20160804_140321_556815_414BA8C8)
Subject: Re: [PATCH] ath10k: disable wake_tx_queue for older devices
To: Roman Yeryomin <leroi.lists@gmail.com>
Cc: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"michal.kazior@tieto.com" <michal.kazior@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 4, 2016 at 12:07 PM, Roman Yeryomin <leroi.lists@gmail.com> wrote:
> On 1 August 2016 at 12:04, Dave Taht <dave.taht@gmail.com> wrote:
>> On Mon, Aug 1, 2016 at 1:35 AM, Roman Yeryomin <leroi.lists@gmail.com> wrote:
>>> On 7 July 2016 at 19:30, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
>>>> Michal Kazior <michal.kazior@tieto.com> writes:
>>>>
>>>>> Ideally wake_tx_queue should be used regardless as
>>>>> it is a requirement for reducing bufferbloat and
>>>>> implementing airtime fairness in the future.
>>>>>
>>>>> However some setups (typically low-end platforms
>>>>> hosting QCA988X) suffer performance regressions
>>>>> with the current wake_tx_queue implementation.
>>>>> Therefore disable it unless it is really
>>>>> beneficial with current codebase (which is when
>>>>> firmware supports smart pull-push tx scheduling).
>>>>>
>>>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>>>
>>>> I think it's too late to send this to 4.7 anymore (and this due to my
>>>> vacation). So I'm planning to queue this to 4.8, but if the feedback is
>>>> positive we can always send this to a 4.7 stable release.
>>>>
>>>
>>> Sorry guys, drowned.
>>> So, yes, applying this patch does the job. That is gets me to the
>>> results similar to
>>> https://lists.openwrt.org/pipermail/openwrt-devel/2016-May/041448.html
>>>
>>> Going to try latest code on same system...
>>
>> Can you try increasing the quantum to 1514, and reducing the codel
>> target to 5ms? (without this patch?)
>>
>
> So it was 1514 already...

based on some testing of 20, codel target should be 5ms and isn't.

https://github.com/torvalds/linux/commit/5caa328e3811b7cfa33fd02c93280ffa622deb0e

> Regards,
> Roman
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k



-- 
Dave Täht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
