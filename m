Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.235]:54080 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbYBXS6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 13:58:10 -0500
Received: by wx-out-0506.google.com with SMTP id h31so1142813wxd.4
        for <linux-wireless@vger.kernel.org>; Sun, 24 Feb 2008 10:58:09 -0800 (PST)
Message-ID: <40f31dec0802241058h5b37a471s5092dd370a4f2a48@mail.gmail.com> (sfid-20080224_190144_227014_EFA1281F)
Date: Sun, 24 Feb 2008 20:58:09 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Fixes for PCI-E cards
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
In-Reply-To: <20080224175933.GA4360@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080224042851.GE4426@makis.domain.invalid>
	 <40f31dec0802232045v2902d76dg8ee1c4a4685862fe@mail.gmail.com>
	 <20080224175933.GA4360@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/24, Bob Copeland <me@bobcopeland.com>:
> On Sun, Feb 24, 2008 at 06:45:33AM +0200, Nick Kossifidis wrote:
>  > >  +       /* Identify PCI-E cards */
>  > >  +       if((srev >= AR5K_SREV_VER_AR2424 && srev <= AR5K_SREV_VER_AR5424) ||
>  > >  +       srev >= AR5K_SREV_VER_AR5416) {
>  > >  +               ah->ah_pcie = true;
>  > >  +       } else {
>  > >  +               ah->ah_pcie = false;
>  > >  +       }
>
>
> This won't work, because reset is called before we ever set ah_pcie.
>  Moving the set before the first call to wakeup (patch below) does the
>  trick.  Then it works at least as well as I had it working (still with
>  random calibration failures, but I am again sending this mail using the
>  driver).
>
>  Thanks!
>
>  From f59b2bc93059e7f1bd504714ca22654f4242d78d Mon Sep 17 00:00:00 2001
>  From: Bob Copeland <me@bobcopeland.com>
>  Date: Sun, 24 Feb 2008 10:30:50 -0500
>  Subject: [PATCH] Grab srev before resetting card.
>
>  Setting ah_pcie variable must be done before the first call to
>  ath5k_hw_nic_wakeup.
>  ---
>   drivers/net/wireless/ath5k/hw.c |   20 ++++++++++----------
>   1 files changed, 10 insertions(+), 10 deletions(-)
>
>
>  diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
>
> index adcce6f..71cdbd9 100644
>
> --- a/drivers/net/wireless/ath5k/hw.c
>  +++ b/drivers/net/wireless/ath5k/hw.c
>
> @@ -178,13 +178,21 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
>         else if (ah->ah_version <= AR5K_AR5211)
>                 ah->ah_proc_rx_desc = ath5k_hw_proc_old_rx_status;
>
>  +       /* Get MAC, PHY and RADIO revisions */
>  +       srev = ath5k_hw_reg_read(ah, AR5K_SREV);
>  +       /* Identify PCI-E cards */
>
> +       if((srev >= AR5K_SREV_VER_AR2424 && srev <= AR5K_SREV_VER_AR5424) ||
>  +       srev >= AR5K_SREV_VER_AR5416) {
>  +               ah->ah_pcie = true;
>  +       } else {
>  +               ah->ah_pcie = false;
>  +       }
>  +
>
>         /* Bring device out of sleep and reset it's units */
>         ret = ath5k_hw_nic_wakeup(ah, AR5K_INIT_MODE, true);
>         if (ret)
>                 goto err_free;
>
>  -       /* Get MAC, PHY and RADIO revisions */
>  -       srev = ath5k_hw_reg_read(ah, AR5K_SREV);
>         ah->ah_mac_srev = srev;
>         ah->ah_mac_version = AR5K_REG_MS(srev, AR5K_SREV_VER);
>         ah->ah_mac_revision = AR5K_REG_MS(srev, AR5K_SREV_REV);
>  @@ -214,14 +222,6 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
>
>                 ah->ah_single_chip = false;
>         }
>
>  -       /* Identify PCI-E cards */
>  -       if((srev >= AR5K_SREV_VER_AR2424 && srev <= AR5K_SREV_VER_AR5424) ||
>  -       srev >= AR5K_SREV_VER_AR5416) {
>  -               ah->ah_pcie = true;
>  -       } else {
>  -               ah->ah_pcie = false;
>  -       }
>  -
>         /* Single chip radio */
>         if (ah->ah_radio_2ghz_revision == ah->ah_radio_5ghz_revision)
>                 ah->ah_radio_2ghz_revision = 0;
>

Thanx, just plz put a new line here ->

+	/* Get MAC, PHY and RADIO revisions */
+	srev = ath5k_hw_reg_read(ah, AR5K_SREV);
+
+	/* Identify PCI-E cards */
+	if((srev >= AR5K_SREV_VER_AR2424 && srev <= AR5K_SREV_VER_AR5424) ||
+	srev >= AR5K_SREV_VER_AR5416) {
+		ah->ah_pcie = true;
+	} else {
+		ah->ah_pcie = false;
+	}
+

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
