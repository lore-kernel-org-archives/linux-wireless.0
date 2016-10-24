Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33725 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941046AbcJXUPQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 16:15:16 -0400
Received: by mail-wm0-f65.google.com with SMTP id d128so11444659wmf.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 13:14:57 -0700 (PDT)
Subject: Re: compex wle900vx (ath10k) problem on 4.4.24 / armv7
To: Matthias Klein <matthias.klein@optimeas.de>,
        Michal Kazior <michal.kazior@tieto.com>
References: <em1c0906d6-d30a-4f2c-bafb-bfec0d18a58d@nb-mak>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Oliver Zemann <oliver.zemann@gmail.com>
Message-ID: <45bffe7d-8f27-ef26-b7f9-78709e52652f@gmail.com> (sfid-20161024_221521_887311_A04E07C7)
Date: Mon, 24 Oct 2016 22:14:55 +0200
MIME-Version: 1.0
In-Reply-To: <em1c0906d6-d30a-4f2c-bafb-bfec0d18a58d@nb-mak>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> Can you try cherry-picking it into your 4.4.24 and see if it helps?
I created a patch which should work for 4.4.24 (at least for arch linux 
arm it applied successful)

diff --git a/drivers/pci/pcie/portdrv_core.c 
b/drivers/pci/pcie/portdrv_core.c
index 88122dc..f2caf38 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -8,6 +8,7 @@

  #include <linux/module.h>
  #include <linux/pci.h>
+#include <linux/pm_runtime.h>
  #include <linux/kernel.h>
  #include <linux/errno.h>
  #include <linux/pm.h>
@@ -350,6 +351,8 @@ static int pcie_device_init(struct pci_dev *pdev, 
int service, int irq)
          return retval;
      }

+        pm_runtime_no_callbacks(device);
+
      return 0;
  }

diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index be35da2..1624cc3 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -93,6 +93,28 @@ static int pcie_port_resume_noirq(struct device *dev)
      return 0;
  }

+static int pcie_port_runtime_suspend(struct device *dev)
+{
+    return to_pci_dev(dev)->bridge_d3 ? 0 : -EBUSY;
+}
+
+static int pcie_port_runtime_resume(struct device *dev)
+{
+    return 0;
+}
+
+static int pcie_port_runtime_idle(struct device *dev)
+{
+    /*
+     * Assume the PCI core has set bridge_d3 whenever it thinks the port
+     * should be good to go to D3.  Everything else, including moving
+     * the port to D3, is handled by the PCI core.
+     */
+    return to_pci_dev(dev)->bridge_d3 ? 0 : -EBUSY;
+}
++
+
+
  static const struct dev_pm_ops pcie_portdrv_pm_ops = {
      .suspend    = pcie_port_device_suspend,
      .resume        = pcie_port_device_resume,
@@ -101,6 +123,9 @@ static const struct dev_pm_ops pcie_portdrv_pm_ops = {
      .poweroff    = pcie_port_device_suspend,
      .restore    = pcie_port_device_resume,
      .resume_noirq    = pcie_port_resume_noirq,
+    .runtime_suspend = pcie_port_runtime_suspend,
+    .runtime_resume    = pcie_port_runtime_resume,
+    .runtime_idle    = pcie_port_runtime_idle,
  };

  #define PCIE_PORTDRV_PM_OPS    (&pcie_portdrv_pm_ops)
@@ -139,11 +164,39 @@ static int pcie_portdrv_probe(struct pci_dev *dev,
       * it by default.
       */
      dev->d3cold_allowed = false;
+
+    /*
+     * Prevent runtime PM if the port is advertising support for PCIe
+     * hotplug.  Otherwise the BIOS hotplug SMI code might not be able
+     * to enumerate devices behind this port properly (the port is
+     * powered down preventing all config space accesses to the
+     * subordinate devices).  We can't be sure for native PCIe hotplug
+     * either so prevent that as well.
+     */
+    if (!dev->is_hotplug_bridge) {
+        /*
+         * Keep the port resumed 100ms to make sure things like
+         * config space accesses from userspace (lspci) will not
+         * cause the port to repeatedly suspend and resume.
+         */
+        pm_runtime_set_autosuspend_delay(&dev->dev, 100);
+        pm_runtime_use_autosuspend(&dev->dev);
+        pm_runtime_mark_last_busy(&dev->dev);
+        pm_runtime_put_autosuspend(&dev->dev);
+        pm_runtime_allow(&dev->dev);
+    }
+
      return 0;
  }

  static void pcie_portdrv_remove(struct pci_dev *dev)
  {
+    if (!dev->is_hotplug_bridge) {
+        pm_runtime_forbid(&dev->dev);
+        pm_runtime_get_noresume(&dev->dev);
+        pm_runtime_dont_use_autosuspend(&dev->dev);
+    }
+
      pcie_port_device_remove(dev);
  }

Just compiling the kernel... lets see what happens
