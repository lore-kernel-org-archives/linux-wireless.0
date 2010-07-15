Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35546 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933320Ab0GOQ7g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jul 2010 12:59:36 -0400
Received: by pwi5 with SMTP id 5so352340pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jul 2010 09:59:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C3F0AA3.4050706@marvell.com>
References: <4C3F0AA3.4050706@marvell.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 15 Jul 2010 09:59:01 -0700
Message-ID: <AANLkTiljhQpDh_20zEf8HjYnk82BpUi4Gctu9G90aqpS@mail.gmail.com>
Subject: Re: [RFC] mac80211: indicate BA window size with IEEE80211_AMPDU_TX_OPERATIONAL
	drv_ampud_action
To: yogeshp <yogeshp@marvell.com>
Cc: linville@tuxdriver.com, Nishant Sarmukadam <nishants@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 15, 2010 at 6:18 AM, yogeshp <yogeshp@marvell.com> wrote:
> BA window size for a successful BA setup is not made available to the driver by
> mac80211. The patch below gets the BA window size from addba response and
> indicates it to driver through IEEE80211_AMPDU_TX_OPERATIONAL drv_ampdu_action.

But why do you want that? Your patch and commit log do not mention why
you need this. Also your patch does not address changing all of the
other drivers, and breaks compilation so NACK, WTF!

When I compile mac80211 with your patch it fails compilation:

  CHECK   net/mac80211/main.c
net/mac80211/main.c:617:9: error: invalid bitfield width, -1.
  CC [M]  net/mac80211/main.o
In file included from net/mac80211/driver-ops.h:7,
                 from net/mac80211/main.c:29:
net/mac80211/driver-trace.h: In function ‘trace_drv_ampdu_action’:
net/mac80211/driver-trace.h:731: warning: passing argument 7 of ‘(void
(*)(void *, struct ieee80211_local *, struct ieee80211_sub_if_data *,
enum ieee80211_ampdu_mlme_action,  struct ieee80211_sta *, u16,  u16,
u16 *))it_func’ makes integer from pointer without a cast
net/mac80211/driver-trace.h:731: note: expected ‘u16’ but argument is
of type ‘u16 *’
net/mac80211/driver-trace.h:731: error: too few arguments to function
‘(void (*)(void *, struct ieee80211_local *, struct
ieee80211_sub_if_data *, enum ieee80211_ampdu_mlme_action,  struct
ieee80211_sta *, u16,  u16,  u16 *))it_func’
make[1]: *** [net/mac80211/main.o] Error 1
make: *** [_module_net/mac80211] Error 2

When I compile ath9k and ath9k_htc with this patch I also get:

  CHECK   drivers/net/wireless/ath/ath9k/main.c
drivers/net/wireless/ath/ath9k/main.c:2068:31: warning: incorrect type
in initializer (incompatible argument 6 (different base types))
drivers/net/wireless/ath/ath9k/main.c:2068:31:    expected int (
*ampdu_action )( ... )
drivers/net/wireless/ath/ath9k/main.c:2068:31:    got int ( static
[toplevel] *<noident> )( ... )
  CC [M]  drivers/net/wireless/ath/ath9k/main.o
drivers/net/wireless/ath/ath9k/main.c:2068: warning: initialization
from incompatible pointer type

  CC [M]  drivers/net/wireless/ath/ath9k/htc_drv_txrx.o
  CHECK   drivers/net/wireless/ath/ath9k/htc_drv_main.c
drivers/net/wireless/ath/ath9k/htc_drv_main.c:1846:31: warning:
incorrect type in initializer (incompatible argument 6 (different base
types))
drivers/net/wireless/ath/ath9k/htc_drv_main.c:1846:31:    expected int
( *ampdu_action )( ... )
drivers/net/wireless/ath/ath9k/htc_drv_main.c:1846:31:    got int (
static [toplevel] *<noident> )( ... )
  CC [M]  drivers/net/wireless/ath/ath9k/htc_drv_main.o
drivers/net/wireless/ath/ath9k/htc_drv_main.c:1846: warning:
initialization from incompatible pointer type

In fact I'm surprised this even compiles with your patch. If you want
to submit this make sure you use both checkpatch.pl to test your patch
and also use sparse to compile test. You can get sparse from:

git://git.kernel.org/pub/scm/devel/sparse/chrisl/sparse.git

I recommend to use use the v0.4.2 tag:

git checkout -b rel42 v0.4.2
make
make install

Then when compiling to test your patch use C=1 to use sparse.

make C=1 M=drivers/net/wireless/ath/ath9k/

> Signed-off-by: yogeshp@marvell.com
> Signed-off-by: nishants@marvell.com

Please read the Developer's Certificate of Origin 1.1, on
Documentation/SubmittingPatches.

Also please read:

http://wireless.kernel.org/en/developers/Documentation

  Luis
