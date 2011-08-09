Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53356 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1HIOi5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 10:38:57 -0400
Received: by wyg24 with SMTP id 24so35597wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 07:38:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P3p3mqUjJrynivna5Fu4iv8DDdH-rY53Y36tHRVewSSuQ@mail.gmail.com>
References: <1312228017-12061-1-git-send-email-wey-yi.w.guy@intel.com>
	<CALSq=BYkKhJN=GU0RUJ2viibsy5yG78x-D-td0zP+rqWCy=AiQ@mail.gmail.com>
	<4825B8A2C4E264489E57869F0DCFB22344563F4ABE@hasmsx502.ger.corp.intel.com>
	<CALSq=BZ2CoF=+Zw-si5oc8No9MLTP1YoZCzfoT9TX1XEaLnq1A@mail.gmail.com>
	<CALSq=BYY8-fAqATwJaFNvzwpSo4WWXbH=pRXn0oknqKXH=4X2A@mail.gmail.com>
	<1312499702.15170.17.camel@wwguy-huron>
	<20110805225051.435fe1b0@mj>
	<E9954878DD1FB34FAE5187FB88C58A350199604D92@orsmsx506.amr.corp.intel.com>
	<CANUX_P3p3mqUjJrynivna5Fu4iv8DDdH-rY53Y36tHRVewSSuQ@mail.gmail.com>
Date: Tue, 9 Aug 2011 20:08:56 +0530
Message-ID: <CAD2nsn105hyUW0WjN-iggdorxk0wsm7r1EHzN1-MeaMjovQG5A@mail.gmail.com> (sfid-20110809_163901_293109_79BEEE5A)
Subject: Re: [PATCH wireless-3.1] iwlagn: sysfs couldn't find the priv pointer
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Pavel Roskin <proski@gnu.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 7, 2011 at 1:13 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> Can you please try that one ?
> I don't have my machine near me, and don't want to crash it remotely,
> so I didn't test it. I will test in on Sunday.

Hi Emmanuel,

I also got the same kernel panic when unloading the iwlagn module for
my inbuilt laptop card and i tried the attached patch and it seems to
fix it.


>
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c
> b/drivers/net/wireless/iwlwifi/iwl-pci.c
> index 69d4ec4..2fdbffa 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-pci.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
> @@ -478,27 +478,22 @@ out_no_pci:
>        return err;
>  }
>
> -static void iwl_pci_down(struct iwl_bus *bus)
> -{
> -       struct iwl_pci_bus *pci_bus = (struct iwl_pci_bus *) bus->bus_specific;
> -
> -       pci_disable_msi(pci_bus->pci_dev);
> -       pci_iounmap(pci_bus->pci_dev, pci_bus->hw_base);
> -       pci_release_regions(pci_bus->pci_dev);
> -       pci_disable_device(pci_bus->pci_dev);
> -       pci_set_drvdata(pci_bus->pci_dev, NULL);
> -
> -       kfree(bus);
> -}
> -
>  static void __devexit iwl_pci_remove(struct pci_dev *pdev)
>  {
>        struct iwl_priv *priv = pci_get_drvdata(pdev);
> -       void *bus_specific = priv->bus->bus_specific;
> +       struct iwl_bus *bus = priv->bus;
> +       struct iwl_pci_bus *pci_bus = IWL_BUS_GET_PCI_BUS(bus);
> +       struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);
>
>        iwl_remove(priv);
>
> -       iwl_pci_down(bus_specific);
> +       pci_disable_msi(pci_dev);
> +       pci_iounmap(pci_dev, pci_bus->hw_base);
> +       pci_release_regions(pci_dev);
> +       pci_disable_device(pci_dev);
> +       pci_set_drvdata(pci_dev, NULL);
> +
> +       kfree(bus);
>  }
>
>  #ifdef CONFIG_PM
>



-- 
shafi
