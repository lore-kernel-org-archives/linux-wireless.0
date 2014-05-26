Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:65247 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaEZFs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 01:48:58 -0400
Received: by mail-wi0-f181.google.com with SMTP id n15so3710984wiw.2
        for <linux-wireless@vger.kernel.org>; Sun, 25 May 2014 22:48:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400850209.4358.31.camel@jlt4.sipsolutions.net>
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-4-git-send-email-michal.kazior@tieto.com>
	<87oayovr1m.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmJTsh3Kcwmqx19WAzoBhYrhkQaPT_S=JFVPptkVaaKyw@mail.gmail.com>
	<87bnuovq6x.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQn_V5zGA18qGMNrWYy_-fBQzBi1=EmzMs=0SLvk1LBVJQ@mail.gmail.com>
	<1400850209.4358.31.camel@jlt4.sipsolutions.net>
Date: Mon, 26 May 2014 07:48:56 +0200
Message-ID: <CA+BoTQmmYJ8Mjv1=w=ZijFzZ-FB+PyEV5SKtzvVW7A8_kirueg@mail.gmail.com> (sfid-20140526_074901_869359_5BB0370C)
Subject: Re: [PATCH v2 3/5] ath10k: drain tx before restarting hw
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 May 2014 15:03, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-05-23 at 11:06 +0200, Michal Kazior wrote:
>
>> There's nothing wrong with other thread holding it. Actually that's
>> the reason for this very check.
>>
>> The point is to prevent ath10k_drain_tx() being called while caller
>> (current thread) holds conf_mutex. If it were to hold conf_mutex then
>> cancel_work_sync() can deadlock as both workers it tries to stop try
>> to get a hold of the lock too.
>
> That seems pointless - lockdep would warn you about that *anyway*
> because cancel_work_sync() and friends have proper annotations. Try it
> sometime :)

Does it splat every time or just by chance or after a deadlock?


Michał
