Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:63218 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758645Ab3CIPdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 10:33:21 -0500
Received: by mail-wg0-f45.google.com with SMTP id dq12so3631297wgb.12
        for <linux-wireless@vger.kernel.org>; Sat, 09 Mar 2013 07:33:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87obesly7c.fsf@kamboji.qca.qualcomm.com>
References: <1362732148-26384-1-git-send-email-rmani@qca.qualcomm.com>
	<87obesly7c.fsf@kamboji.qca.qualcomm.com>
Date: Sat, 9 Mar 2013 07:33:20 -0800
Message-ID: <CAJ-Vmonyh36n4_N9Yx_mHo4ycp+kPuDQY35K=kOrEJHvMT966g@mail.gmail.com> (sfid-20130309_163326_314897_4D1C3BE0)
Subject: Re: [PATCH] ath6kl: Add rx workqueue for SDIO
From: Adrian Chadd <adrian@freebsd.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Raja Mani <rmani@qca.qualcomm.com>, linux-wireless@vger.kernel.org,
	Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>,
	ath6kl-devel@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 March 2013 01:27, Kalle Valo <kvalo@qca.qualcomm.com> wrote:

> I think to fix the race the queue should be consumed something like
> this (pseudo code):
>
> lock()
> while (!list_empty()) {
>       entry = list_first_entry()
>       unlock()
>
>       do_stuff()
>
>       lock()
> }

Well, sure, but you should then re-check all the state that may have
changed when you reacquire that lock. :-)

Another way of doing it is:

init temp list
lock()
copy list to temp list
unlock()
while (! temp list empty) {
    do_stuff()
}

That way you don't have that constant unlock/relock going on.


Adrian
