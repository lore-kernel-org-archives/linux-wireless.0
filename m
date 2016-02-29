Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbcB2Xr5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 18:47:57 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 064/113] rtl8xxxu: Set RX boundary for 8723bu
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
	<1456783551-28315-65-git-send-email-Jes.Sorensen@redhat.com>
	<CAGRGNgU6_O4+YaLxzJAj50Xhh16hZWtwNCALoGd2mTjkF7-NEw@mail.gmail.com>
Date: Mon, 29 Feb 2016 18:47:54 -0500
In-Reply-To: <CAGRGNgU6_O4+YaLxzJAj50Xhh16hZWtwNCALoGd2mTjkF7-NEw@mail.gmail.com>
	(Julian Calaby's message of "Tue, 1 Mar 2016 10:11:08 +1100")
Message-ID: <wrfjmvqjhydx.fsf@redhat.com> (sfid-20160301_004800_553969_4897F182)
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
>> Set the correct TRXFF boundary for 8723bu.
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>> ---
>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> index 3a7fd2c..835eca8 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> @@ -6182,7 +6182,10 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
>>         /*
>>          * Set RX page boundary
>>          */
>> -       rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x27ff);
>> +       if (priv->rtlchip == 0x8723b)
>> +               rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x3f7f);
>> +       else
>> +               rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x27ff);
>
> Is this likely to be different for other chipsets in the future? If
> so, would it make sense to stuff it into the fops structure?

Happens in a later patch

Jes
