Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.239]:38856 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbXKAV3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 17:29:36 -0400
Received: by wr-out-0506.google.com with SMTP id 36so390098wra
        for <linux-wireless@vger.kernel.org>; Thu, 01 Nov 2007 14:29:35 -0700 (PDT)
Date: Thu, 1 Nov 2007 17:29:26 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: RFC: Reproducible oops with lockdep on count_matching_names()
Message-ID: <20071101212926.GA4182@pogo> (sfid-20071101_212946_772124_7278AEB6)
References: <20071101191716.GA3201@pogo> <20071101194909.GF14943@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071101194909.GF14943@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 01, 2007 at 03:49:09PM -0400, John W. Linville wrote:
> On Thu, Nov 01, 2007 at 03:17:16PM -0400, Luis R. Rodriguez wrote:
> 
> > So I started reviewing the probes on each driver and came up with this
> > patch because Documenation/pci.txt has:
> > 
> > "The device driver needs to call pci_request_region() to verify
> > no other device is already using the same address resource.
> > Conversely, drivers should call pci_release_region() AFTER
> > calling pci_disable_device(). The idea is to prevent two devices 
> > colliding on the same address range"
> 
> No idea off the top of my head if this relates to the problem or not...
> 
> > --- a/drivers/net/wireless/ath5k/base.c
> > +++ b/drivers/net/wireless/ath5k/base.c
> > @@ -602,10 +602,10 @@ err_free:
> >  	ieee80211_free_hw(hw);
> >  err_map:
> >  	pci_iounmap(pdev, mem);
> > -err_reg:
> > -	pci_release_region(pdev, 0);
> >  err_dis:
> >  	pci_disable_device(pdev);
> > +err_reg:
> > +	pci_release_region(pdev, 0);
> >  err:
> >  	return ret;
> >  }
> 
> If you do this, don't you need to change any "goto err_reg" to "goto
> err_dis" as well?
> 
> > --- a/drivers/net/wireless/ipw2200.c
> > +++ b/drivers/net/wireless/ipw2200.c
> > @@ -11756,10 +11756,10 @@ static int ipw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >  	priv->workqueue = NULL;
> >        out_iounmap:
> >  	iounmap(priv->hw_base);
> > -      out_pci_release_regions:
> > -	pci_release_regions(pdev);
> >        out_pci_disable_device:
> >  	pci_disable_device(pdev);
> > +      out_pci_release_regions:
> > +	pci_release_regions(pdev);
> >  	pci_set_drvdata(pdev, NULL);
> >        out_free_ieee80211:
> >  	free_ieee80211(priv->net_dev);
> 
> Same as last comment, but for out_pci_release_regions and
> out_pci_disable_device.

Yeah, you're right, duh, here it is with some more changes. Anyway
this still doesn't fix it but it does address the documenation.

Any more ideas?

Changes to base.c
Changes-licensed-under: 3-clause-BSD

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 15ae868..cea17ce 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -453,14 +453,15 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	ret = pci_enable_device(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "can't enable device\n");
-		goto err;
+		return ret;
 	}
 
 	/* XXX 32-bit addressing only */
 	ret = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 	if (ret) {
 		dev_err(&pdev->dev, "32-bit DMA not available\n");
-		goto err_dis;
+		pci_disable_device(pdev);
+		return ret;
 	}
 
 	/*
@@ -498,14 +499,15 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	ret = pci_request_region(pdev, 0, "ath5k");
 	if (ret) {
 		dev_err(&pdev->dev, "cannot reserve PCI memory region\n");
-		goto err_dis;
+		pci_disable_device(pdev);
+		return ret;
 	}
 
 	mem = pci_iomap(pdev, 0, 0);
 	if (!mem) {
 		dev_err(&pdev->dev, "cannot remap PCI memory region\n") ;
 		ret = -EIO;
-		goto err_reg;
+		goto err_dis;
 	}
 
 	/* 
@@ -602,11 +604,9 @@ err_free:
 	ieee80211_free_hw(hw);
 err_map:
 	pci_iounmap(pdev, mem);
-err_reg:
-	pci_release_region(pdev, 0);
 err_dis:
 	pci_disable_device(pdev);
-err:
+	pci_release_region(pdev, 0);
 	return ret;
 }
 
@@ -621,8 +621,8 @@ ath5k_pci_remove(struct pci_dev *pdev)
 	free_irq(pdev->irq, sc);
 	pci_disable_msi(pdev);
 	pci_iounmap(pdev, sc->iobase);
-	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
+	pci_release_region(pdev, 0);
 	ieee80211_free_hw(hw);
 }
 
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 54f44e5..7f2ea6d 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -11611,8 +11611,7 @@ static int ipw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	net_dev = alloc_ieee80211(sizeof(struct ipw_priv));
 	if (net_dev == NULL) {
-		err = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	priv = ieee80211_priv(net_dev);
@@ -11628,8 +11627,8 @@ static int ipw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	mutex_init(&priv->mutex);
 	if (pci_enable_device(pdev)) {
-		err = -ENODEV;
-		goto out_free_ieee80211;
+		free_ieee80211(priv->net_dev);
+		return -ENODEV;
 	}
 
 	pci_set_master(pdev);
@@ -11639,14 +11638,14 @@ static int ipw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
 	if (err) {
 		printk(KERN_WARNING DRV_NAME ": No suitable DMA available.\n");
-		goto out_pci_disable_device;
+		goto out_pci_disable_device_end;
 	}
 
 	pci_set_drvdata(pdev, priv);
 
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err)
-		goto out_pci_disable_device;
+		goto out_pci_disable_device_end;
 
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
 	 * PCI Tx retries from interfering with C3 CPU state */
@@ -11660,7 +11659,7 @@ static int ipw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	base = ioremap_nocache(pci_resource_start(pdev, 0), length);
 	if (!base) {
 		err = -ENODEV;
-		goto out_pci_release_regions;
+		goto out_pci_disable_device;
 	}
 
 	priv->hw_base = base;
@@ -11756,14 +11755,15 @@ static int ipw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->workqueue = NULL;
       out_iounmap:
 	iounmap(priv->hw_base);
-      out_pci_release_regions:
-	pci_release_regions(pdev);
       out_pci_disable_device:
 	pci_disable_device(pdev);
+	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
-      out_free_ieee80211:
 	free_ieee80211(priv->net_dev);
-      out:
+	return err;
+      out_pci_disable_device_end: /* We don't release regions here */
+	pci_disable_device(pdev);
+	free_ieee80211(priv->net_dev);
 	return err;
 }
 
@@ -11824,8 +11824,8 @@ static void ipw_pci_remove(struct pci_dev *pdev)
 
 	free_irq(pdev->irq, priv);
 	iounmap(priv->hw_base);
-	pci_release_regions(pdev);
 	pci_disable_device(pdev);
+	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
 	free_ieee80211(priv->net_dev);
 	free_firmware();
