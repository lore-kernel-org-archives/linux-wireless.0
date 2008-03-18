Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:38069 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbYCSTzC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:55:02 -0400
Received: by ti-out-0910.google.com with SMTP id 28so278640tif.23
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2008 12:55:01 -0700 (PDT)
Message-ID: <f6ca9fed0803181232n4ac188ev5d10e7c68aad57aa@mail.gmail.com> (sfid-20080319_195600_512020_66012D22)
Date: Tue, 18 Mar 2008 20:32:29 +0100
From: drago01 <drago01@gmail.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [ipw3945-devel] iwl3945 rfkill regression
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"Dan Williams" <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <D936D925018D154694D8A362EEB0892003A7F599@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0801221204j71ad2137l19555363e46a7e45@mail.gmail.com>
	 <C07C4589BE74A34981C3C3525EE1F8010338CB35@hasmsx412.ger.corp.intel.com>
	 <f6ca9fed0801221212k709f04dbx1f81cab4c724996a@mail.gmail.com>
	 <C07C4589BE74A34981C3C3525EE1F8010338CB49@hasmsx412.ger.corp.intel.com>
	 <f6ca9fed0801221224u7ddf1569qa29860466ac27d86@mail.gmail.com>
	 <f6ca9fed0801261100j7939056dke661a422ec507fce@mail.gmail.com>
	 <1ba2fa240801261411x7bb437c9s31aea593537afeba@mail.gmail.com>
	 <47B29F63.6050605@gmail.com>
	 <D936D925018D154694D8A362EEB0892003A7F599@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 13, 2008 at 5:48 PM, Chatre, Reinette
<reinette.chatre@intel.com> wrote:
>
> On Tuesday, February 12, 2008 11:42 PM, drago01  wrote:
>
>  > Tomas Winkler wrote:
>  >> On Jan 26, 2008 9:00 PM, drago01 <drago01@gmail.com> wrote:
>  >>
>  >>> On Jan 22, 2008 9:24 PM, drago01 <drago01@gmail.com> wrote:
>  >>>
>  >>>> On Jan 22, 2008 9:21 PM, Winkler, Tomas
>  > <tomas.winkler@intel.com> wrote:
>  >>>>
>  >>>>>
>  >>>>>> -----Original Message-----
>  >>>>>> From: drago01 [mailto:drago01@gmail.com]
>  >>>>>> Sent: Tuesday, January 22, 2008 10:12 PM
>  >>>>>> To: Winkler, Tomas
>  >>>>>>
>  >>>>>> Cc: ipw3945-devel; Cahill, Ben M; Zhu, Yi; linux-wireless
>  >>>>>> Subject: Re: [ipw3945-devel] iwl3945 rfkill regression
>  >>>>>>
>  >>>>>> On Jan 22, 2008 9:07 PM, Winkler, Tomas <tomas.winkler@intel.com>
>  >>>>>>
>  >>>>> wrote:
>  >>>>>
>  >>>>>>> I believe it's delaying uCode load to mac_start - still need to
>  >>>>>>> be polished.
>  >>>>>>>
>  >>>>>> ok, thx for the quick reply.
>  >>>>>> If you have any potential fixes I would be happy to test them ;)
>  >>>>>>
>  >>>>> Can you get me the sequence it is happening? RF kill switch is off
>  >>>>> before you power up the laptop or after, during association or in
>  >>>>> unassociated state..etc Thanks
>  >>>>>
>  >>>> I boot with rf kill off = device on
>  >>>> acciotate using NM
>  >>>> kill the card by pressing the rfkill (ie. setting it to on)
>  >>>> card is dead (like described in my first mail), until I relaod the
>  >>>> module the rfkill switch  does not have any effect at this time.
>  >>>>
>  >>>>
>  >>> OK, I investigated a bit and it seems to be the "disable interrupt
>  >>> when device goes down" is the problem.
>  >>> In my case NetworkManager detected the rfkill and brought the device
>  >>> down, which caused the interrupt to be disabled. Now after pressing
>  >>> the rfkill again nothing happend. But if I bring the device back up
>  >>> the interrupt is enabled again and rfkill and the card is back to
>  >>> live. So in short disabling the interrupt in mac_stop breaks the hw
>  >>> rfkill while the interface is down.
>  >>>
>  >>>
>  >>
>  >> Thanks for investigating this, still didn't have to time to dig into
>  >> it.
>  >>
>  >>
>  > ping?
>
>  We are working on this.
>
>  Reinette
>

OK, it seems not to be the irq (only) seems to be something else too.
I tryed the attached patch (not to disable the irq in down when hw
rfkill is set) but it was still the same.
The driver does not update the sysfs file when the rfkill is back off
(device on), so hal and NM still think that the rfkill is on while its
off.

Patch (hack) tested:

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 093b863..70e5e25 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6545,6 +6545,9 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)

 	IWL_DEBUG_MAC80211("enter\n");

+	if(!atomic_read(&priv->pci_dev->enable_cnt))
+		goto device_open;
+
 	if (pci_enable_device(priv->pci_dev)) {
 		IWL_ERROR("Fail to pci_enable_device\n");
 		return -ENODEV;
@@ -6559,6 +6562,7 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 		goto out_disable_msi;
 	}

+device_open:
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&priv->mutex);

@@ -6640,11 +6644,13 @@ static void iwl3945_mac_stop(struct ieee80211_hw *hw)

 	iwl3945_down(priv);

-	flush_workqueue(priv->workqueue);
-	free_irq(priv->pci_dev->irq, priv);
-	pci_disable_msi(priv->pci_dev);
-	pci_save_state(priv->pci_dev);
-	pci_disable_device(priv->pci_dev);
+	if(!test_bit(STATUS_RF_KILL_HW, &priv->status) &&
!test_bit(STATUS_IN_SUSPEND, &priv->status)) {
+		flush_workqueue(priv->workqueue);
+		free_irq(priv->pci_dev->irq, priv);
+		pci_disable_msi(priv->pci_dev);
+		pci_save_state(priv->pci_dev);
+		pci_disable_device(priv->pci_dev);
+	}

 	IWL_DEBUG_MAC80211("leave\n");
 }
