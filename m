Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:26031 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbYAVAUx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 19:20:53 -0500
Received: by an-out-0708.google.com with SMTP id d31so484774and.103
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jan 2008 16:20:51 -0800 (PST)
Message-ID: <40f31dec0801211620u2c1f7354vf572ad3ffd280bdd@mail.gmail.com> (sfid-20080122_002105_208367_65591F37)
Date: Tue, 22 Jan 2008 02:20:51 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath5k: reset key cache after resume
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1200947765-12012-2-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1200947765-12012-1-git-send-email-linville@tuxdriver.com>
	 <1200947765-12012-2-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/1/21, John W. Linville <linville@tuxdriver.com>:
> Otherwise it may be impossible to connected to an open network after a
> resume.
>
> This is a modified version of an original patch by
> Alex Eskin <alexeskin@yahoo.com>:
>
>         https://bugzilla.redhat.com/show_bug.cgi?id=425950#c8
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/ath5k/base.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 75e5970..6ab4746 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -604,7 +604,7 @@ ath5k_pci_resume(struct pci_dev *pdev)
>  {
>         struct ieee80211_hw *hw = pci_get_drvdata(pdev);
>         struct ath5k_softc *sc = hw->priv;
> -       int err;
> +       int i, err;
>
>         err = pci_set_power_state(pdev, PCI_D0);
>         if (err)
> @@ -628,6 +628,16 @@ ath5k_pci_resume(struct pci_dev *pdev)
>                 ath5k_hw_set_gpio(sc->ah, sc->led_pin, 0);
>         }
>
> +       /*
> +        * Reset the key cache since some parts do not
> +        * reset the contents on initial power up or resume.
> +        *
> +        * FIXME: This may need to be revisited when mac80211 becomes
> +        *        aware of suspend/resume.
> +        */
> +       for (i = 0; i < AR5K_KEYTABLE_SIZE; i++)
> +               ath5k_hw_reset_key(sc->ah, i);
> +
>         return 0;
>  }
>  #endif /* CONFIG_PM */
> --
> 1.5.3.3
>

Thanx John ;-)

Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
