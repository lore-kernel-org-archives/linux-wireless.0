Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:34860 "EHLO
	mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbcGaXtw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jul 2016 19:49:52 -0400
Received: by mail-vk0-f67.google.com with SMTP id x130so5152450vkc.2
        for <linux-wireless@vger.kernel.org>; Sun, 31 Jul 2016 16:48:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87zipt1kco.fsf@kamboji.qca.qualcomm.com>
References: <1463489221-24989-1-git-send-email-michal.kazior@tieto.com>
 <1467201146-6844-1-git-send-email-michal.kazior@tieto.com> <87zipt1kco.fsf@kamboji.qca.qualcomm.com>
From: Roman Yeryomin <leroi.lists@gmail.com>
Date: Mon, 1 Aug 2016 02:35:36 +0300
Message-ID: <CACiydb+yNc-UKVRFR-UxTq-YFBDpEDsa1qWNBGCHpe=_zv8o7g@mail.gmail.com> (sfid-20160801_014956_052597_EBCAB58F)
Subject: Re: [PATCH] ath10k: disable wake_tx_queue for older devices
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "michal.kazior@tieto.com" <michal.kazior@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 July 2016 at 19:30, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Ideally wake_tx_queue should be used regardless as
>> it is a requirement for reducing bufferbloat and
>> implementing airtime fairness in the future.
>>
>> However some setups (typically low-end platforms
>> hosting QCA988X) suffer performance regressions
>> with the current wake_tx_queue implementation.
>> Therefore disable it unless it is really
>> beneficial with current codebase (which is when
>> firmware supports smart pull-push tx scheduling).
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> I think it's too late to send this to 4.7 anymore (and this due to my
> vacation). So I'm planning to queue this to 4.8, but if the feedback is
> positive we can always send this to a 4.7 stable release.
>

Sorry guys, drowned.
So, yes, applying this patch does the job. That is gets me to the
results similar to
https://lists.openwrt.org/pipermail/openwrt-devel/2016-May/041448.html

Going to try latest code on same system...

Regards,
Roman
