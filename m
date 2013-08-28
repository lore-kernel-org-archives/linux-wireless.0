Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:44931 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3H1Kyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 06:54:47 -0400
Received: by mail-bk0-f47.google.com with SMTP id mx12so2077271bkb.34
        for <linux-wireless@vger.kernel.org>; Wed, 28 Aug 2013 03:54:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87txiajveo.fsf@kamboji.qca.qualcomm.com>
References: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
	<1377507205-5386-1-git-send-email-michal.kazior@tieto.com>
	<1377507205-5386-2-git-send-email-michal.kazior@tieto.com>
	<87txiajveo.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 28 Aug 2013 12:54:46 +0200
Message-ID: <CA+BoTQmW8F+e3YqLSoCWbYRSzZAM=Wy2GvGfbbW7iwVHtaesOQ@mail.gmail.com> (sfid-20130828_125451_506036_39506104)
Subject: Re: [PATCH v2 1/4] ath10k: synchronize tx/rx reporting to mac80211
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 August 2013 06:23, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> According to mac80211 docs tx and rx reporting
>> routines must not run concurrently unless they are
>> _irqsafe variants.
>>
>> This doesn't fix any visible bug but is apparently
>> the right thing to do as per the documentation.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> I had a quick chat with Johannes and Sujith about this. The concurrency
> requirements are for the STA PS race in AP mode (see
> ieee80211_handle_filtered_frame()).
>
> I think we should drop this frame, revisit later and properly analyse
> how to fix the race. But it would be good add this to the todo list:
>
> http://wireless.kernel.org/en/users/Drivers/ath10k#TODO

I've added this to the TODO list.

I'm worried this PS stuff is broken on ath10k anyway because ath10k
modifies tx skbuffs for QoS workaround (QoS Control must be removed
before submitting to FW).


Michał.
