Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:32879 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbcB2IfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 03:35:22 -0500
MIME-Version: 1.0
In-Reply-To: <87mvqyqbqp.fsf@kamboji.qca.qualcomm.com>
References: <87mvqyqbqp.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 29 Feb 2016 09:35:21 +0100
Message-ID: <CAMuHMdWVJ+rC1w_-mHdWhDJ_q++W_hp-Fg4JTjSSSseS1aDd5Q@mail.gmail.com> (sfid-20160229_093547_819320_013E2ED1)
Subject: Re: pull-request: wireless-drivers 2016-02-18
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: David Miller <davem@davemloft.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 18, 2016 at 4:28 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Hi Dave,
>
> I have some important fixes I would like to get 4.5 still, more info in
> the signed tag. Please let me know if you have problems.
>
> Kalle
>
> The following changes since commit f9ead9beef3f44be0db4b542a8c2ce698fb1530e:
>
>   Merge tag 'iwlwifi-for-kalle-2016-01-26_2' of https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes (2016-01-27 14:19:18 +0200)
>
> are available in the git repository at:
>
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2016-02-18
>
> for you to fetch changes up to c699404db182836498bd9d9a36ef044de2cab4fd:
>
>   Merge tag 'iwlwifi-for-kalle-2016-02-15' of https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes (2016-02-16 17:58:30 +0200)
>
> ----------------------------------------------------------------
>
> rtlwifi
>
> * fix broken VHT (802.11ac) support, reported by Linus

That's commit d76d65fd26951498144029c24852c4d54ee512d9

drivers/net/wireless/realtek/rtlwifi/rc.c: In function
‘_rtl_rc_rate_set_series’:
drivers/net/wireless/realtek/rtlwifi/rc.c:144: warning: comparison is
always false due to limited range of data type

                if (sta && sta->vht_cap.vht_supported &&
                    (wireless_mode == WIRELESS_MODE_AC_5G ||
                     wireless_mode == WIRELESS_MODE_AC_24G ||
                     wireless_mode == WIRELESS_MODE_AC_ONLY))
                        rate->flags |= IEEE80211_TX_RC_VHT_MCS;

u8 wireless_mode = 0;

enum wireless_mode {
        ...
        WIRELESS_MODE_AC_ONLY = 0x100,

How is that supposed to work?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
