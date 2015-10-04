Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24814 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbJDHXp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 03:23:45 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 01/10] wil6210: fix warning in system power management code
Date: Sun,  4 Oct 2015 10:23:18 +0300
Message-Id: <1443943407-6663-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20151004_092348_838565_3291A577)
In-Reply-To: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix compilation warning where CONFIG_PM defined while
CONFIG_PM_SLEEP is not defined

Report follows:

tree:   git://github.com/kvalo/ath pending
head:   941145fc5e5afbb120271e5dfaf37213ddb55807
commit: df596be39294d9712e5d568063a48448031e0a9f [37/39] wil6210: system power management
config: xtensa-allyesconfig (attached as .config)
reproduce:
  wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
  chmod +x ~/bin/make.cross
  git checkout df596be39294d9712e5d568063a48448031e0a9f
  # save the attached .config to linux build tree
  make.cross ARCH=xtensa

All warnings (new ones prefixed by >>):

>> drivers/net/wireless/ath/wil6210/pcie_bus.c:264:12: warning: 'wil6210_suspend' defined but not used [-Wunused-function]
    static int wil6210_suspend(struct device *dev, bool is_runtime)
               ^
>> drivers/net/wireless/ath/wil6210/pcie_bus.c:291:12: warning: 'wil6210_resume' defined but not used [-Wunused-function]
    static int wil6210_resume(struct device *dev, bool is_runtime)
               ^
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index feff1ef..1a3142c3 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -260,6 +260,7 @@ static const struct pci_device_id wil6210_pcie_ids[] = {
 MODULE_DEVICE_TABLE(pci, wil6210_pcie_ids);
 
 #ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
 static int wil6210_suspend(struct device *dev, bool is_runtime)
 {
@@ -307,7 +308,6 @@ static int wil6210_resume(struct device *dev, bool is_runtime)
 	return rc;
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int wil6210_pm_suspend(struct device *dev)
 {
 	return wil6210_suspend(dev, false);
-- 
2.1.4

