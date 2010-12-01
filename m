Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41625 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab0LAPDo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 10:03:44 -0500
Received: by wwa36 with SMTP id 36so7486511wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 07:03:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201012011540.45031.helmut.schaa@googlemail.com>
References: <1291202302-9698-1-git-send-email-helmut.schaa@googlemail.com>
	<AANLkTi=_61HVmSBR-9v3ukVw-mpouoaFwYE8cpfa96wH@mail.gmail.com>
	<201012011540.45031.helmut.schaa@googlemail.com>
Date: Wed, 1 Dec 2010 20:33:41 +0530
Message-ID: <AANLkTikxF4MA04-rTikiFuKr4eVX=CQ1xvd4xhFnjyKF@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Update last_tx_rate only for data frames
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 1, 2010 at 8:10 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Hi,
>
> Am Mittwoch 01 Dezember 2010 schrieb Mohammed Shafi:
>> On Wed, Dec 1, 2010 at 4:48 PM, Helmut Schaa
>> <helmut.schaa@googlemail.com> wrote:
>> > The last_tx_rate field was also updated for non-data frames that are
>> > often sent with a lower rate (for example management frames at 1 Mbps).
>> > This is confusing when the data rate is actually much higher.
>> >
>> > Hence, only update the last_tx_rate field with tx rate information
>> > gathered from the last data frames.
>>
>> Hi Helmut,
>>             I have a doubt,ideally should not this be taken care by the driver ?
>
> Sorry, I don't get your point. How should that be handled by the driver? Could
> you please elaborate?

Thanks for your reply.I don't know really ,just asked  , but saw in
ath9k "ath_tx_status"(call back to mac80211) which might be taking
care of it

static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
                          struct ieee80211_sta *sta, void *priv_sta,
                          struct sk_buff *skb)
{
........
        for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
                struct ieee80211_tx_rate *rate = &tx_info->status.rates[i];
                if (!rate->count)
                        break;

                final_ts_idx = i;
                long_retry = rate->count - 1;
        }

        if (!priv_sta || !ieee80211_is_data(fc))
                return;
....etc

>
> last_tx_rate is part of the sta_info struct and is documented as:
>
> 207  * @last_tx_rate: rate used for last transmit, to report to userspace as
> 208  *      "the" transmit rate
>
> So, the fields sole purpose is to report the "current" tx rate to user space.
> A normal user (IMO) would like to see the current tx rate that is used for
> data frames and not occasionally a 1Mbps because a management frame was the
> last sent frame.
>
> Helmut
>
