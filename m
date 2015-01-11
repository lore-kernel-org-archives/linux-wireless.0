Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:57365 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbbAKKWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2015 05:22:50 -0500
MIME-Version: 1.0
In-Reply-To: <87vbkfga32.fsf@kamboji.qca.qualcomm.com>
References: <1420394427-19509-1-git-send-email-me@mortis.eu>
	<1420659525-22975-1-git-send-email-me@mortis.eu>
	<1420659525-22975-2-git-send-email-me@mortis.eu>
	<87vbkfga32.fsf@kamboji.qca.qualcomm.com>
Date: Sun, 11 Jan 2015 12:22:49 +0200
Message-ID: <CAB3XZEcm4+=dYC-8_m_7YRdET_wPkWUYHcDuy9mCKdxkCFEnQA@mail.gmail.com> (sfid-20150111_112255_443189_BE2AE950)
Subject: Re: [PATCH RESEND 2/2] wlcore: align member-assigns in a
 structure-copy block
From: Eliad Peller <eliad@wizery.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Giel van Schijndel <me@mortis.eu>,
	LKML <linux-kernel@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>,
	"open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 9, 2015 at 7:03 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Giel van Schijndel <me@mortis.eu> writes:
>
>> This highlights the differences (e.g. the bug fixed in the previous
>> commit).
>>
>> Signed-off-by: Giel van Schijndel <me@mortis.eu>
>> ---
>>  drivers/net/wireless/ti/wlcore/acx.c | 22 +++++++++++-----------
>>  1 file changed, 11 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
>> index f28fa3b..93a2fa8 100644
>> --- a/drivers/net/wireless/ti/wlcore/acx.c
>> +++ b/drivers/net/wireless/ti/wlcore/acx.c
>> @@ -1715,17 +1715,17 @@ int wl12xx_acx_config_hangover(struct wl1271 *wl)
>>               goto out;
>>       }
>>
>> -     acx->recover_time = cpu_to_le32(conf->recover_time);
>> -     acx->hangover_period = conf->hangover_period;
>> -     acx->dynamic_mode = conf->dynamic_mode;
>> -     acx->early_termination_mode = conf->early_termination_mode;
>> -     acx->max_period = conf->max_period;
>> -     acx->min_period = conf->min_period;
>> -     acx->increase_delta = conf->increase_delta;
>> -     acx->decrease_delta = conf->decrease_delta;
>> -     acx->quiet_time = conf->quiet_time;
>> -     acx->increase_time = conf->increase_time;
>> -     acx->window_size = conf->window_size;
>> +     acx->recover_time               = cpu_to_le32(conf->recover_time);
>> +     acx->hangover_period            = conf->hangover_period;
>> +     acx->dynamic_mode               = conf->dynamic_mode;
>> +     acx->early_termination_mode     = conf->early_termination_mode;
>> +     acx->max_period                 = conf->max_period;
>> +     acx->min_period                 = conf->min_period;
>> +     acx->increase_delta             = conf->increase_delta;
>> +     acx->decrease_delta             = conf->decrease_delta;
>> +     acx->quiet_time                 = conf->quiet_time;
>> +     acx->increase_time              = conf->increase_time;
>> +     acx->window_size                = conf->window_size;
>
> I would like to get an ACK from one of the wlcore developers if I should
> apply this (or not).
>
I don't have a strong opinion here.
However, it looks pretty much redundant to take a random blob (which
was just fixed by a correct patch) and re-indent it.
The rest of the file doesn't follow this style, so i don't see a good
reason to apply it here.

I agree such indentation have some benefit, but it won't help with the
more common use case (of copy-paste error) of copying the wrong field
(i.e. D->a = S->b instead of D->a = S->a).
For these cases the macros suggested by Arend and Johannes will do the
trick. However i usually dislike such macros, as they tend to break
some IDE features (e.g. auto completion).
Maybe we can come up with some nice spatch to catch these cases.

Just my 2c.

Eliad.
