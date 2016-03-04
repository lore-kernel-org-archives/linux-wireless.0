Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41043 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbcCDP3d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 10:29:33 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Miller <davem@davemloft.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Larry.Finger@lwfinger.net
Subject: Re: pull-request: wireless-drivers 2016-02-18
References: <87mvqyqbqp.fsf@kamboji.qca.qualcomm.com>
	<CAMuHMdWVJ+rC1w_-mHdWhDJ_q++W_hp-Fg4JTjSSSseS1aDd5Q@mail.gmail.com>
Date: Fri, 04 Mar 2016 17:29:25 +0200
In-Reply-To: <CAMuHMdWVJ+rC1w_-mHdWhDJ_q++W_hp-Fg4JTjSSSseS1aDd5Q@mail.gmail.com>
	(Geert Uytterhoeven's message of "Mon, 29 Feb 2016 09:35:21 +0100")
Message-ID: <87y49yw9be.fsf@kamboji.qca.qualcomm.com> (sfid-20160304_162938_056504_4749AEF2)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Adding Larry)

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> On Thu, Feb 18, 2016 at 4:28 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>
>> rtlwifi
>>
>> * fix broken VHT (802.11ac) support, reported by Linus
>
> That's commit d76d65fd26951498144029c24852c4d54ee512d9
>
> drivers/net/wireless/realtek/rtlwifi/rc.c: In function
> ‘_rtl_rc_rate_set_series’:
> drivers/net/wireless/realtek/rtlwifi/rc.c:144: warning: comparison is
> always false due to limited range of data type
>
>                 if (sta && sta->vht_cap.vht_supported &&
>                     (wireless_mode == WIRELESS_MODE_AC_5G ||
>                      wireless_mode == WIRELESS_MODE_AC_24G ||
>                      wireless_mode == WIRELESS_MODE_AC_ONLY))
>                         rate->flags |= IEEE80211_TX_RC_VHT_MCS;
>
> u8 wireless_mode = 0;
>
> enum wireless_mode {
>         ...
>         WIRELESS_MODE_AC_ONLY = 0x100,
>
> How is that supposed to work?

I have no idea what could be the difference, for example, between AC_5G
and AC_ONLY. Maybe AC_ONLY mode is not really used in normal setups and
that's why the bug doesn't break anything? Larry, do you know?

Anyway, Larry has a patch for this but I'm planning to send it to 4.6 as
I didn't think it as that urgent:

rtlwifi: Fix size of wireless mode variable

https://patchwork.kernel.org/patch/8425191/

-- 
Kalle Valo
