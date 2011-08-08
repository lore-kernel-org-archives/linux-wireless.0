Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55999 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab1HHOck (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 10:32:40 -0400
Date: Mon, 8 Aug 2011 10:27:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH wireless-3.1] iwlagn: sysfs couldn't find the priv pointer
Message-ID: <20110808142744.GA21103@tuxdriver.com> (sfid-20110808_163245_767356_F3859D60)
References: <CALSq=BYkKhJN=GU0RUJ2viibsy5yG78x-D-td0zP+rqWCy=AiQ@mail.gmail.com>
 <4825B8A2C4E264489E57869F0DCFB22344563F4ABE@hasmsx502.ger.corp.intel.com>
 <CALSq=BZ2CoF=+Zw-si5oc8No9MLTP1YoZCzfoT9TX1XEaLnq1A@mail.gmail.com>
 <CALSq=BYY8-fAqATwJaFNvzwpSo4WWXbH=pRXn0oknqKXH=4X2A@mail.gmail.com>
 <1312499702.15170.17.camel@wwguy-huron>
 <20110805225051.435fe1b0@mj>
 <E9954878DD1FB34FAE5187FB88C58A350199604D92@orsmsx506.amr.corp.intel.com>
 <CANUX_P3p3mqUjJrynivna5Fu4iv8DDdH-rY53Y36tHRVewSSuQ@mail.gmail.com>
 <4825B8A2C4E264489E57869F0DCFB22344564A2C19@hasmsx502.ger.corp.intel.com>
 <E9954878DD1FB34FAE5187FB88C58A350199604E03@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <E9954878DD1FB34FAE5187FB88C58A350199604E03@orsmsx506.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sure, that sounds great.

On Sat, Aug 06, 2011 at 11:21:42PM -0700, Guy, Wey-Yi W wrote:
> I will like to combine the patches if it's ok for John.
> 
> Wey
> 
> -----Original Message-----
> From: Grumbach, Emmanuel
> Sent: Sunday, August 07, 2011 8:09 AM
> To: Grumbach, Emmanuel; Emmanuel Grumbach; Guy, Wey-Yi W
> Cc: Pavel Roskin; Daniel Halperin; linville@tuxdriver.com; linux-wireless@vger.kernel.org
> Subject: RE: [PATCH wireless-3.1] iwlagn: sysfs couldn't find the priv pointer
> 
> FWIW, the patch below solved the problem on my system.
> Dan, please confirm you are happy with it.
> 
> The bug was introduced by the patch that fixed the sysfs issue.
> 
> Wey, John, do you think it would be better to revert my previous fix and send a combined patch that solves the sysfs issue and doesn't add the bug ? Or another patch on top of the buggy sysfs fix ?
> 
> Thanks,
>        Emmanuel
> 
> 
> > -----Original Message-----
> > From: Grumbach, Emmanuel
> > Sent: Saturday, August 06, 2011 10:46 PM
> > To: Emmanuel Grumbach; Guy, Wey-Yi W
> > Cc: Pavel Roskin; Daniel Halperin; linville@tuxdriver.com; linux-
> > wireless@vger.kernel.org
> > Subject: RE: [PATCH wireless-3.1] iwlagn: sysfs couldn't find the priv
> > pointer
> >
> > On top of my previous patch of course (which actually fixed the previous
> > bug, but added the one you are facing now...).
> >
> > Thanks,
> >        Emmanuel
> >
> >
> > > -----Original Message-----
> > > From: Emmanuel Grumbach [mailto:egrumbach@gmail.com]
> > > Sent: Saturday, August 06, 2011 10:44 PM
> > > To: Guy, Wey-Yi W
> > > Cc: Pavel Roskin; Grumbach, Emmanuel; Daniel Halperin;
> > > linville@tuxdriver.com; linux-wireless@vger.kernel.org
> > > Subject: Re: [PATCH wireless-3.1] iwlagn: sysfs couldn't find the priv
> > > pointer
> > >
> > > Can you please try that one ?
> > > I don't have my machine near me, and don't want to crash it remotely, so
> > I
> > > didn't test it. I will test in on Sunday.
> > >
> > >
> > > diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c
> > > b/drivers/net/wireless/iwlwifi/iwl-pci.c
> > > index 69d4ec4..2fdbffa 100644
> > > --- a/drivers/net/wireless/iwlwifi/iwl-pci.c
> > > +++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
> > > @@ -478,27 +478,22 @@ out_no_pci:
> > >     return err;
> > >  }
> > >
> > > -static void iwl_pci_down(struct iwl_bus *bus) -{
> > > -   struct iwl_pci_bus *pci_bus = (struct iwl_pci_bus *) bus-
> > > >bus_specific;
> > > -
> > > -   pci_disable_msi(pci_bus->pci_dev);
> > > -   pci_iounmap(pci_bus->pci_dev, pci_bus->hw_base);
> > > -   pci_release_regions(pci_bus->pci_dev);
> > > -   pci_disable_device(pci_bus->pci_dev);
> > > -   pci_set_drvdata(pci_bus->pci_dev, NULL);
> > > -
> > > -   kfree(bus);
> > > -}
> > > -
> > >  static void __devexit iwl_pci_remove(struct pci_dev *pdev)  {
> > >     struct iwl_priv *priv = pci_get_drvdata(pdev);
> > > -   void *bus_specific = priv->bus->bus_specific;
> > > +   struct iwl_bus *bus = priv->bus;
> > > +   struct iwl_pci_bus *pci_bus = IWL_BUS_GET_PCI_BUS(bus);
> > > +   struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);
> > >
> > >     iwl_remove(priv);
> > >
> > > -   iwl_pci_down(bus_specific);
> > > +   pci_disable_msi(pci_dev);
> > > +   pci_iounmap(pci_dev, pci_bus->hw_base);
> > > +   pci_release_regions(pci_dev);
> > > +   pci_disable_device(pci_dev);
> > > +   pci_set_drvdata(pci_dev, NULL);
> > > +
> > > +   kfree(bus);
> > >  }
> > >
> > >  #ifdef CONFIG_PM
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
