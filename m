Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f195.google.com ([209.85.214.195]:35745 "EHLO
	mail-ob0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289AbcBCCbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 21:31:49 -0500
MIME-Version: 1.0
In-Reply-To: <CAGRGNgWKt3aqas5ZYaYVCLYkB5DOY0uojwO6tcSjTrQ-iytesw@mail.gmail.com>
References: <20160203020139.GA13619@gmail.com>
	<CAGRGNgWKt3aqas5ZYaYVCLYkB5DOY0uojwO6tcSjTrQ-iytesw@mail.gmail.com>
Date: Wed, 3 Feb 2016 11:31:49 +0900
Message-ID: <CAOxTRzojbg7qYK4rPf2ppkVvzpKQC-3yNiNVMgTGaP0i3ncW8g@mail.gmail.com> (sfid-20160203_033217_441974_62B4301B)
Subject: Re: [PATCH 2/2] rtlwifi: Fix reusable codes in core.c
From: ByeoungWook Kim <quddnr145@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

I sent to modify the patch again.
Thanks for your assists!

Regards,
Byeoungwook

2016-02-03 11:06 GMT+09:00 Julian Calaby <julian.calaby@gmail.com>:
> Hi Byeoungwook,
>
> On Wed, Feb 3, 2016 at 1:01 PM, Byeoungwook Kim <quddnr145@gmail.com> wrote:
>> rtl_*_delay() functions were reused same codes about addr variable.
>> So i have converted to rtl_addr_delay() from code about addr variable.
>>
>> Signed-off-by: Byeoungwook Kim <quddnr145@gmail.com>
>> Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
>
> Just a note for the future, you have to explicitly be given a
> reviewed-by, you can't just assume that someone who has made comments
> on a patch has reviewed it.
>
> In this case, I have reviewed it, so formally:
>
> Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
>
> Thanks,
>
> Julian Calaby
>
>
>> ---
>>  drivers/net/wireless/realtek/rtlwifi/core.c | 28 ++++------------------------
>>  1 file changed, 4 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
>> index 05f432c..c1193d1 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/core.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/core.c
>> @@ -63,18 +63,8 @@ EXPORT_SYMBOL(rtl_addr_delay);
>>  void rtl_rfreg_delay(struct ieee80211_hw *hw, enum radio_path rfpath, u32 addr,
>>                      u32 mask, u32 data)
>>  {
>> -       if (addr == 0xfe) {
>> -               mdelay(50);
>> -       } else if (addr == 0xfd) {
>> -               mdelay(5);
>> -       } else if (addr == 0xfc) {
>> -               mdelay(1);
>> -       } else if (addr == 0xfb) {
>> -               udelay(50);
>> -       } else if (addr == 0xfa) {
>> -               udelay(5);
>> -       } else if (addr == 0xf9) {
>> -               udelay(1);
>> +       if (addr >= 0xf9 && addr <= 0xfe) {
>> +               rtl_addr_delay(addr);
>>         } else {
>>                 rtl_set_rfreg(hw, rfpath, addr, mask, data);
>>                 udelay(1);
>> @@ -84,18 +74,8 @@ EXPORT_SYMBOL(rtl_rfreg_delay);
>>
>>  void rtl_bb_delay(struct ieee80211_hw *hw, u32 addr, u32 data)
>>  {
>> -       if (addr == 0xfe) {
>> -               mdelay(50);
>> -       } else if (addr == 0xfd) {
>> -               mdelay(5);
>> -       } else if (addr == 0xfc) {
>> -               mdelay(1);
>> -       } else if (addr == 0xfb) {
>> -               udelay(50);
>> -       } else if (addr == 0xfa) {
>> -               udelay(5);
>> -       } else if (addr == 0xf9) {
>> -               udelay(1);
>> +       if (addr >= 0xf9 && addr <= 0xfe) {
>> +               rtl_addr_delay(addr);
>>         } else {
>>                 rtl_set_bbreg(hw, addr, MASKDWORD, data);
>>                 udelay(1);
>> --
>> 2.5.0
>>
>
>
>
> --
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
