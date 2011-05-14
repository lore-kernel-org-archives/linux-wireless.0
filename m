Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58376 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab1ENSAh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 14:00:37 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat-wireless: libertas lbs_pr_<level> was converted to pr_<level>
Date: Sat, 14 May 2011 20:00:25 +0200
Message-Id: <1305396027-5864-1-git-send-email-hauke@hauke-m.de> (sfid-20110514_200041_680150_D1D69E58)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adapt changes in commit f3a57fd148a4afd3c38f558c5b44972cb29ea8ba
"libertas: Convert lbs_pr_<level> to pr_<level>" to the compat patches.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/24-pcmcia.patch |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/patches/24-pcmcia.patch b/patches/24-pcmcia.patch
index 39f2dc0..ef058b7 100644
--- a/patches/24-pcmcia.patch
+++ b/patches/24-pcmcia.patch
@@ -834,7 +834,7 @@
  	.remove		= __devexit_p(b43_pcmcia_remove),
 --- a/drivers/net/wireless/libertas/if_cs.c
 +++ b/drivers/net/wireless/libertas/if_cs.c
-@@ -773,7 +773,11 @@ static void if_cs_release(struct pcmcia_
+@@ -780,7 +780,11 @@ static void if_cs_release(struct pcmcia_
  
  	lbs_deb_enter(LBS_DEB_CS);
  
@@ -846,7 +846,7 @@
  	pcmcia_disable_device(p_dev);
  	if (card->iobase)
  		ioport_unmap(card->iobase);
-@@ -781,7 +785,7 @@ static void if_cs_release(struct pcmcia_
+@@ -788,7 +792,7 @@ static void if_cs_release(struct pcmcia_
  	lbs_deb_leave(LBS_DEB_CS);
  }
  
@@ -855,8 +855,8 @@
  static int if_cs_ioprobe(struct pcmcia_device *p_dev, void *priv_data)
  {
  	p_dev->resource[0]->flags &= ~IO_DATA_PATH_WIDTH;
-@@ -791,9 +795,39 @@ static int if_cs_ioprobe(struct pcmcia_d
- 		lbs_pr_err("wrong CIS (check number of IO windows)\n");
+@@ -798,9 +802,39 @@ static int if_cs_ioprobe(struct pcmcia_d
+ 		pr_err("wrong CIS (check number of IO windows)\n");
  		return -ENODEV;
  	}
 +#else
@@ -881,7 +881,7 @@
 +
 +	/* IO window settings */
 +	if (cfg->io.nwin != 1) {
-+		lbs_pr_err("wrong CIS (check number of IO windows)\n");
++		pr_err("wrong CIS (check number of IO windows)\n");
 +		return -ENODEV;
 +	}
 +#endif
@@ -895,7 +895,7 @@
  }
  
  static int if_cs_probe(struct pcmcia_device *p_dev)
-@@ -815,7 +849,16 @@ static int if_cs_probe(struct pcmcia_dev
+@@ -822,7 +856,16 @@ static int if_cs_probe(struct pcmcia_dev
  	card->p_dev = p_dev;
  	p_dev->priv = card;
  
@@ -911,8 +911,8 @@
 +#endif
  
  	if (pcmcia_loop_config(p_dev, if_cs_ioprobe, NULL)) {
- 		lbs_pr_err("error in pcmcia_loop_config\n");
-@@ -827,12 +870,26 @@ static int if_cs_probe(struct pcmcia_dev
+ 		pr_err("error in pcmcia_loop_config\n");
+@@ -834,12 +877,26 @@ static int if_cs_probe(struct pcmcia_dev
  	 * a handler to the interrupt, unless the 'Handler' member of
  	 * the irq structure is initialized.
  	 */
@@ -923,7 +923,7 @@
 +	if (p_dev->conf.Attributes & CONF_ENABLE_IRQ) {
 +		ret = pcmcia_request_irq(p_dev, &p_dev->irq);
 +		if (ret) {
-+			lbs_pr_err("error in pcmcia_request_irq\n");
++			pr_err("error in pcmcia_request_irq\n");
 +			goto out1;
 +		}
 +	}
@@ -937,9 +937,9 @@
 +	card->iobase = ioport_map(p_dev->io.BasePort1, p_dev->io.NumPorts1);
 +#endif
  	if (!card->iobase) {
- 		lbs_pr_err("error in ioport_map\n");
+ 		pr_err("error in ioport_map\n");
  		ret = -EIO;
-@@ -846,7 +903,17 @@ static int if_cs_probe(struct pcmcia_dev
+@@ -853,7 +910,17 @@ static int if_cs_probe(struct pcmcia_dev
  	}
  
  	/* Finally, report what we've done */
@@ -957,7 +957,7 @@
  
  	/*
  	 * Most of the libertas cards can do unaligned register access, but some
-@@ -915,7 +982,11 @@ static int if_cs_probe(struct pcmcia_dev
+@@ -922,7 +989,11 @@ static int if_cs_probe(struct pcmcia_dev
  	priv->fw_ready = 1;
  
  	/* Now actually get the IRQ */
@@ -968,8 +968,8 @@
 +#endif
  		IRQF_SHARED, DRV_NAME, card);
  	if (ret) {
- 		lbs_pr_err("error in request_irq\n");
-@@ -988,7 +1059,13 @@ MODULE_DEVICE_TABLE(pcmcia, if_cs_ids);
+ 		pr_err("error in request_irq\n");
+@@ -995,7 +1066,13 @@ MODULE_DEVICE_TABLE(pcmcia, if_cs_ids);
  
  static struct pcmcia_driver lbs_driver = {
  	.owner		= THIS_MODULE,
-- 
1.7.4.1

