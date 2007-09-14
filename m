Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:54162 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbXINU1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2007 16:27:18 -0400
Received: by py-out-1112.google.com with SMTP id u77so1959134pyb
        for <linux-wireless@vger.kernel.org>; Fri, 14 Sep 2007 13:27:17 -0700 (PDT)
Message-ID: <43e72e890709141327j4128c9e1ye8d5e8ea465a863@mail.gmail.com>
Date: Fri, 14 Sep 2007 16:27:16 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 3/3] Internalize Atheros Turbo modes and Turbo modulation
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <46EA46F5.1050906@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_4414_4542415.1189801636281"
References: <43e72e890709131706p565bd955m1b9820198cafa7fa@mail.gmail.com>
	 <46EA46F5.1050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_4414_4542415.1189801636281
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 9/14/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> Luis R. Rodriguez napsal(a):
> > This patch:
> >
> > * Internalizes Atheros Turbo modes (MODE_ATHEROS_TURBO, MODE_ATHEROS_TURBOG)
> >
> > * Internatizes Turbo modulation (MODULATION_TURBO)
> >
> > * Adds documention for Atheros Turbo modes (MODE_ATHEROS_TURBO,
> > MODE_ATHEROS_TURBOG), Turbo modulation (MODULATION_TURBO) and XR
> > modulation (MODULATION_XR)
> >
> > This patch is intended for the ath5k branch of wireless-dev after a
> > pull from origin/everything once
> > 01-remove-atheros-turbo-from-mac80211.diff is applied.
> >
> > drivers/net/wireless/ath5k_base.c |    2 +-
> > 1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > Changes-licensed-under: BSD
> > Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
> >
> > drivers/net/wireless/ath5k.h    |   86 +++++++++++++++++++++++++++++++++------
> > drivers/net/wireless/ath5k_hw.c |    4 +-
> > 2 files changed, 76 insertions(+), 14 deletions(-)
> >
> > Changes-licensed-under: ISC
> > Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
> >
> > Cc: Zhu Yi <yi.zhu@intel.com>
> > Cc: Jiri Slaby <jirislaby@gmail.com>
> > Cc: Michael Wu <flamingice@sourmilk.net>
> > CC: Johannes Berg <johannes@sipsolutions.net
>
> Just a question if it doesn't affect somehow supp_rates/basic_rates, which
> has up to NUM_IEEE80211_MODES pointers.

These are accessed through a mac80211 mode as its index so so long as
the driver doesn't add a mode of its own to pass down to mac8021 we
are good.

For example, util.c ieee80211_prepare_rates() access these as follows:

                if (local->supp_rates[mode->mode]) {
                        if (!rate_list_match(local->supp_rates[mode->mode],
                                             rate->rate))
                                continue;
                }

Or in ieee80211_ioctl.c ieee80211_ioctl_set_rate_sets() called when
PRISM2_HOSTAPD_SET_RATE_SETS is received and accesses these as
follows:

        prev = local->supp_rates[mode];
        local->supp_rates[mode] = supp;
        kfree(prev);

        prev = local->basic_rates[mode];
        local->basic_rates[mode] = basic;
        kfree(prev);

To be safe we can apply the attached patch to test if the driver
passed an invalid mode on ieee80211_register_hwmode().

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>

 net/mac80211/ieee80211.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

  Luis

------=_Part_4414_4542415.1189801636281
Content-Type: text/x-patch; name="mac80211-check-mode-on-register.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="mac80211-check-mode-on-register.diff"
X-Attachment-Id: f_f6l54sf4

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9pZWVlODAyMTEuYyBiL25ldC9tYWM4MDIxMS9pZWVl
ODAyMTEuYwppbmRleCAwMzEzMDhmLi4wYmY1NzU2IDEwMDY0NAotLS0gYS9uZXQvbWFjODAyMTEv
aWVlZTgwMjExLmMKKysrIGIvbmV0L21hYzgwMjExL2llZWU4MDIxMS5jCkBAIC0xMzc1LDYgKzEz
NzUsNyBAQCBpbnQgaWVlZTgwMjExX3JlZ2lzdGVyX2h3bW9kZShzdHJ1Y3QgaWVlZTgwMjExX2h3
ICpodywKIAlzdHJ1Y3QgaWVlZTgwMjExX3JhdGUgKnJhdGU7CiAJaW50IGk7CiAKKwlCVUdfT04o
bW9kZSA+PSBOVU1fSUVFRTgwMjExX01PREVTKTsKIAlJTklUX0xJU1RfSEVBRCgmbW9kZS0+bGlz
dCk7CiAJbGlzdF9hZGRfdGFpbCgmbW9kZS0+bGlzdCwgJmxvY2FsLT5tb2Rlc19saXN0KTsKIAo=

------=_Part_4414_4542415.1189801636281--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
