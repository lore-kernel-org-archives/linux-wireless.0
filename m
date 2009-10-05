Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:51490 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbZJEQV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2009 12:21:59 -0400
MIME-Version: 1.0
In-Reply-To: <200910050052.09085.rjw@sisk.pl>
References: <200910050052.09085.rjw@sisk.pl>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 5 Oct 2009 16:21:02 +0000
Message-ID: <43e72e890910050921q7f516c67ofe17603d6d873c4@mail.gmail.com>
Subject: Re: [PATCH] Wireless / ath5k: Simplify suspend and resume callbacks
To: "Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org
Cc: ath5k-devel@lists.ath5k.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	LKML <linux-kernel@vger.kernel.org>,
	pm list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 4, 2009 at 10:52 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Simplify the suspend and resume callbacks of ath5k by converting the
> driver to struct dev_pm_ops and allowing the PCI PM core to do the
> PCI-specific suspend/resume handling.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Do you happen to know if the new dev_pm_ops thing handle WOL / WoW [1]?

[1] http://wireless.kernel.org/en/users/Documentation/WoW

>  #ifdef CONFIG_PM
> -static int
> -ath5k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
> +static int ath5k_pci_suspend(struct device *dev)
>  {
> -       struct ieee80211_hw *hw = pci_get_drvdata(pdev);
> +       struct ieee80211_hw *hw = pci_get_drvdata(to_pci_dev(dev));
>        struct ath5k_softc *sc = hw->priv;
>
>        ath5k_led_off(sc);
> -
> -       pci_save_state(pdev);
> -       pci_disable_device(pdev);

For WoW right here we'd do

pci_prepare_to_sleep(pdev) and bail out.

> -       pci_set_power_state(pdev, PCI_D3hot);

And here we'd call something like this:

pci_wake_from_d3(pdev, !!sc->wow_triggers_enabled);

> -
>        return 0;
>  }

Are all drivers being converted?

It'll be a while before we get WoW enabled on ath5k but it is
technically possible, the work was tested for ath9k back in July [2]
but I never submitted this to be merged due to some inconsistent
issues I was noticing with the hardware.

[2] http://kernel.org/pub/linux/kernel/people/mcgrof/patches/wow-07-21.patch

  Luis
