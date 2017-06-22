Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:32768 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750932AbdFVMk6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 08:40:58 -0400
Received: by mail-ua0-f196.google.com with SMTP id z34so2136574uab.0
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jun 2017 05:40:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgWE8fbhg1+ccm9U7azioMQ-6bDUqYtUQkHcAq_Za9jurA@mail.gmail.com>
References: <20170622111655.GA4891@symbol-HP-ZBook-15> <CAGRGNgWE8fbhg1+ccm9U7azioMQ-6bDUqYtUQkHcAq_Za9jurA@mail.gmail.com>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Thu, 22 Jun 2017 18:10:56 +0530
Message-ID: <CAFqt6zb-y-W2b_188LYr8259K8PyZX4xp4nc2Cf0cbiy0TwMZg@mail.gmail.com> (sfid-20170622_144101_661403_B22AF72A)
Subject: Re: [PATCH] rtlwifi: Remove unnecessary conditions
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

On Thu, Jun 22, 2017 at 6:03 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi Souptick,
>
> On Thu, Jun 22, 2017 at 9:16 PM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
>> As wmm_enable is initialized to false, hence the else condition never
>> execute and boundary is assigned with TX_PAGE_BOUNDARY. So the if-else
>> condition can be removed and boundary will be assigned with TX_PAGE_BOUNDARY.
>>
>> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
>> ---
>>  drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c | 6 ------
>>  1 file changed, 6 deletions(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
>> index f95a645..e9c5f6a 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
>> @@ -845,13 +845,7 @@ static int _rtl92cu_init_mac(struct ieee80211_hw *hw)
>>                 pr_err("Failed to init power on!\n");
>>                 return err;
>>         }
>> -       if (!wmm_enable) {
>>                 boundary = TX_PAGE_BOUNDARY;
>
> Firstly this isn't indented properly.
>
> Secondly, can this be moved up to where boundary is defined?

Sure. I will modify it and send in v2.

>
> Thanks,
>
> --
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/

-Souptick
