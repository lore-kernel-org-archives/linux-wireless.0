Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:14876 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757779AbXKTXr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 18:47:29 -0500
Received: by py-out-1112.google.com with SMTP id u77so6836553pyb
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2007 15:47:28 -0800 (PST)
Message-ID: <43e72e890711201547y4639017bl989ace61bd0318d8@mail.gmail.com> (sfid-20071120_234732_420072_AE1D04FA)
Date: Tue, 20 Nov 2007 18:47:28 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Kyle McMartin" <kyle@mcmartin.ca>
Subject: Re: [PATCH] ath5k: avoid oops when ah_capabilities.cap_mode not set
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071120232558.GA8093@fattire.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1192647780430-git-send-email-linville@tuxdriver.com>
	 <43e72e890710171436s2e18a19ene70d3b058c835a96@mail.gmail.com>
	 <20071120232558.GA8093@fattire.cabal.ca>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 20, 2007 6:25 PM, Kyle McMartin <kyle@mcmartin.ca> wrote:
>
> On Wed, Oct 17, 2007 at 05:36:33PM -0400, Luis R. Rodriguez wrote:
> > On 10/17/07, John W. Linville <linville@tuxdriver.com> wrote:
> > > ah_capabilities.cap_mode doesn't get set for some cards, causing the
> > > kernel to oops when these unknown/unsupported cards are inserted.
> > > Add some NULL checks to avoid this.
> > >
> > > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> >
> > Acked-by: Luis R. Rodriguez <mcgrof@gmail.com>
> >
>
> has this been dropped on the floor? I spotted it while going through
> Fedora 7 kernel patches...

Nope, just the first hunk:

mcgrof@shelby:~/devel/wireless-2.6$ git-show
7364ee74beb763bbf3c450e5b5e189d3128a3164


commit 7364ee74beb763bbf3c450e5b5e189d3128a3164
Author: John W. Linville <linville@tuxdriver.com>
Date:   Tue Oct 23 13:41:37 2007 -0400

    [PATCH] ath5k: undo overzealous hunk of "ath5k: avoid oops when..."

    The first hunk of "ath5k: avoid oops when ah_capabilities.cap_mode not
    set" was ill-advised.  It can cause its loop to abort prematurely.

    Signed-off-by: John W. Linville <linville@tuxdriver.com>

diff --git a/drivers/net/wireless/ath5k/base.c
b/drivers/net/wireless/ath5k/base.c
index c38adab..e764fd3 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1991,9 +1991,6 @@ static int ath5k_getchannels(struct ieee80211_hw *hw)
                }

                hw_rates = ath5k_hw_get_rate_table(ah, mode->mode);
-               if (!hw_rates)
-                       return -EINVAL;
-
                mode->num_rates    = ath5k_copy_rates(mode->rates, hw_rates,
                        max_r);
                mode->num_channels = ath5k_copy_channels(ah, mode->channels,
