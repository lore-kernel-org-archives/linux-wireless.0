Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33625 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbbHSL2V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 07:28:21 -0400
Received: by lbbsx3 with SMTP id sx3so1072109lbb.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2015 04:28:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87614ba5du.fsf@kamboji.qca.qualcomm.com>
References: <1439982533-26824-1-git-send-email-michal.kazior@tieto.com>
	<87614ba5du.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 19 Aug 2015 13:28:19 +0200
Message-ID: <CA+BoTQ=GhE4zg-7_VXs8RAHzE-he8iP5kvfmci=5b1snJd+hXQ@mail.gmail.com> (sfid-20150819_132824_322241_433AB5D2)
Subject: Re: [PATCH] ath10k: add missing mutex unlock on failpath
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 August 2015 at 13:23, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Kernel would complain about leaving a held lock
>> after going back to userspace and would
>> subsequently deadlock.
>>
>> Fixes: e04cafbc38c7 ("ath10k: fix peer limit enforcement")
>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> commit e04cafbc38c7 is currently going to 4.3-rc1 (it's in
> wireless-drivers-next currently). I think we should send this to 4.3 as
> well, right?

It does make sense to do so, yes.


Michał
