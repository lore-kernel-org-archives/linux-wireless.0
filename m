Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbcB2Xsm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 18:48:42 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 066/113] rtl8xxxu: Call device specific _config_channel()
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
	<1456783551-28315-67-git-send-email-Jes.Sorensen@redhat.com>
	<CAGRGNgW+QS6dgYdvJgWQ+qKjLWHC-U1Ni7LAQUK0VXuJiQu2aA@mail.gmail.com>
Date: Mon, 29 Feb 2016 18:48:39 -0500
In-Reply-To: <CAGRGNgW+QS6dgYdvJgWQ+qKjLWHC-U1Ni7LAQUK0VXuJiQu2aA@mail.gmail.com>
	(Julian Calaby's message of "Tue, 1 Mar 2016 10:12:09 +1100")
Message-ID: <wrfjio17hyco.fsf@redhat.com> (sfid-20160301_004844_837009_B8AFCFF9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:
> Hi Jes,
>
> On Tue, Mar 1, 2016 at 9:05 AM,  <Jes.Sorensen@redhat.com> wrote:
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> Having a version for the newer chips without calling it doesn't do
>> much good.....
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> Should this be squashed into the patch that introduces the new op?

I can start rewriting history, but all that comes out of that is having
to fight patch conflicts rebasing things.

If there was an actual functional reason for it, sure, but in this case
there isn't.

Jes

>
>> ---
>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> index ecd0f59..566eeb5 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> @@ -7348,7 +7348,7 @@ static int rtl8xxxu_config(struct ieee80211_hw *hw, u32 changed)
>>
>>                 rtl8723a_set_tx_power(priv, channel, ht40);
>>
>> -               rtl8723au_config_channel(hw);
>> +               priv->fops->config_channel(hw);
>>         }
>>
>>  exit:
>
> Thanks,
