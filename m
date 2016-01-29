Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:34065 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbcA2UEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 15:04:04 -0500
MIME-Version: 1.0
In-Reply-To: <56ABC0BC.9010202@lwfinger.net>
References: <CA+55aFxe22iWok6UojY=hCoG2k1wNpJ9CfQ0b+STSxq67tb86Q@mail.gmail.com>
	<1453983185.2217.12.camel@sipsolutions.net>
	<CA+55aFya9K4JboNY8kB9cg6zt9otguhdzfHm3jvLmWedxQTSWg@mail.gmail.com>
	<1454013625.2332.9.camel@sipsolutions.net>
	<CA+55aFx73nv9ny-fu5BR6v8wL=f2oFomwrZoLRw=x2kNP76cYA@mail.gmail.com>
	<CA+55aFzF0gWfvmE+6ZcHmjnO4xp-oVAQ5SWxYJhOzns2ocgCsw@mail.gmail.com>
	<1454019155.2332.15.camel@sipsolutions.net>
	<CA+55aFxjpdepHYD_6uU48kW38Z9bmf2wwA8yPZt4ibhkofmfQA@mail.gmail.com>
	<56AAC66C.1080800@lwfinger.net>
	<1454056380.3369.2.camel@sipsolutions.net>
	<CAP71bdVZzUUNwP3py_m1pwU21qMKth=0BmMfLuUb7=B-1840zg@mail.gmail.com>
	<1454084146.2800.0.camel@sipsolutions.net>
	<56ABA73C.1060504@lwfinger.net>
	<CA+55aFysqqp-BCZs1ue6_1tE=h9SOUZTH_o7TwGbsaBnaFvXGA@mail.gmail.com>
	<56ABC0BC.9010202@lwfinger.net>
Date: Fri, 29 Jan 2016 12:04:03 -0800
Message-ID: <CA+55aFz2QbPdFP1u5OWQgs=VkD1N1VcE7RUoeAoA9UAkvpVT4Q@mail.gmail.com> (sfid-20160129_210414_690542_072452C7)
Subject: Re: WARNING at net/mac80211/rate.c:513 ieee80211_get_tx_rates [mac80211]
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	David Miller <davem@davemloft.net>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 29, 2016 at 11:42 AM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
>
> Thanks for testing.
>
> Upon reflection, it really should check the other WIRELESS_MODE_AC_x bits.
> Johannes' patch was indeed correct.

I just retested with this incremental (and whitespace-damaged) patch:

  @@ -139,7 +139,9 @@ static void _rtl_rc_rate_set_series(struct
rtl_priv *rtlpriv,
                       (wireless_mode == WIRELESS_MODE_N_24G)))
                          rate->flags |= IEEE80211_TX_RC_MCS;
                  if (sta && sta->vht_cap.vht_supported &&
  -                   (wireless_mode == WIRELESS_MODE_AC_5G))
  +                   ((wireless_mode == WIRELESS_MODE_AC_5G) ||
  +                    (wireless_mode == WIRELESS_MODE_AC_24G) ||
  +                    (wireless_mode == WIRELESS_MODE_AC_ONLY)))
                          rate->flags |= IEEE80211_TX_RC_VHT_MCS;
          }
   }

which brings it in line with Johannes' patch, and it does indeed still work.

I think marking it for stable is also the right thing to do - the
driver clearly doesn't work well in a wide-channel AC environment
otherwise, and I assume it's going to be more and more common..

                Linus
