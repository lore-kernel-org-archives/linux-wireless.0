Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:45406 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab3DSUnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 16:43:15 -0400
Received: by mail-oa0-f52.google.com with SMTP id k18so4177884oag.39
        for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 13:43:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5168A9FE.7070506@lwfinger.net>
References: <1365703360-19982-1-git-send-email-shenhan@google.com>
	<1365705330.1929.30.camel@joe-AO722>
	<51671663.3070707@lwfinger.net>
	<CACkGtri5R2sgFZd9-M+UCNJ1NOwFS769NJqHUTgWUgtgRnDWow@mail.gmail.com>
	<5168A9FE.7070506@lwfinger.net>
Date: Fri, 19 Apr 2013 13:43:14 -0700
Message-ID: <CACkGtrg9bUFTQOMCK671a26A=tznMHrswQc8qDSMAcB29xy-xA@mail.gmail.com> (sfid-20130419_224319_761938_97732333)
Subject: Re: [PATCH] Fix uninitialized-variable warnings.
From: =?GB2312?B?SGFuIFNoZW4oyfK6rSk=?= <shenhan@google.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
	chaoming_li@realsil.com.cn
Content-Type: text/plain; charset=GB2312
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry, thanks. I've prepared below (simple) patch just adding
initialization list and what Joe's patch does.

Is this ok?

H.

Signed-off-by: Han Shen  (shenhan@google.com)
---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
index b793a65..34150de 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -669,7 +669,7 @@ static void
rtl92c_dm_txpower_tracking_callback_thermalmeter(struct ieee80211_hw
  u8 thermalvalue, delta, delta_lck, delta_iqk;
  long ele_a, ele_d, temp_cck, val_x, value32;
  long val_y, ele_c = 0;
- u8 ofdm_index[2], ofdm_index_old[2], cck_index_old = 0;
+ u8 ofdm_index[2], ofdm_index_old[2] = {0, 0}, cck_index_old = 0;
  s8 cck_index = 0;
  int i;
  bool is2t = IS_92C_SERIAL(rtlhal->version);
@@ -717,7 +717,7 @@ static void
rtl92c_dm_txpower_tracking_callback_thermalmeter(struct ieee80211_hw
  for (i = 0; i < OFDM_TABLE_LENGTH; i++) {
  if (ele_d == (ofdmswing_table[i] &
     MASKOFDM_D)) {
-
+ ofdm_index_old[1] = (u8) i;
  RT_TRACE(rtlpriv, COMP_POWER_TRACKING,
  DBG_LOUD,
  "Initial pathB ele_d reg0x%x = 0x%lx, ofdm_index=0x%x\n",
--
1.8.2.1

On Fri, Apr 12, 2013 at 5:42 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 04/12/2013 05:20 PM, Han Shen(Éòº­) wrote:
>>
>> Hi, Joe's patch (the 1-line fix) does not work for me. The assignment
>> is in a conditional block, when refer to this ofdm_index_old later, I
>> still get error -
>>
>>
>> /mnt/host/source/src/third_party/kernel/files/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:771:31:
>> error: 'ofdm_index_old[1]' may be used uninitialized in this function
>> [-Werror=maybe-uninitialized]
>>       rtlpriv->dm.ofdm_index[i] = ofdm_index_old[i];
>>
>> (I'm working on 3.4 branch.)
>
>
> I would get rid of the -Werror=maybe-unitialized. Sometimes gcc generates a
> false warning, and you really should not error the build in that case.
>
> The correct patch needs to initialize the array to 0, and set the element
> the way Joe's patch does.
>
> Larry
>
>



-- 
Han Shen |  Software Engineer |  shenhan@google.com |  +1-650-440-3330
