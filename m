Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28017 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbYEIFVv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2008 01:21:51 -0400
Subject: Re: BUG: loading iwl4965 lockup CPU
From: Zhu Yi <yi.zhu@intel.com>
To: Oleg Lyashko <tomcatuser.13@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <d4a53e120805082120h33f7dfaes303a6c8fc69cab4e@mail.gmail.com>
References: <d4a53e120805082120h33f7dfaes303a6c8fc69cab4e@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-kiMNSF8hME8RGc8q1M0n"
Date: Fri, 09 May 2008 13:21:11 +0800
Message-Id: <1210310471.2506.84.camel@debian.sh.intel.com> (sfid-20080509_072045_929560_1CA78C8B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kiMNSF8hME8RGc8q1M0n
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2008-05-09 at 08:20 +0400, Oleg Lyashko wrote:
> 
> attempt to load iwl4965 crash laptop:
> 
> # modprobe iwl4965
> BUG: soft lockup - CPU#1 stuck for 11s! [modprobe:14501]
> BUG: soft lockup - CPU#1 stuck for 11s! [modprobe:14501]

This is fixed here. Please use the attached patch for compat-wireless.
http://marc.info/?l=linux-wireless&m=120995431612344&w=2

Thanks,
-yi

--=-kiMNSF8hME8RGc8q1M0n
Content-Disposition: attachment; filename=iwlwifi-spinlock-cw-fix.patch
Content-Type: text/x-patch; name=iwlwifi-spinlock-cw-fix.patch; charset=GB2312
Content-Transfer-Encoding: 7bit

diff -urp compat-wireless-2008-05-07/drivers/net/wireless/iwlwifi/iwl4965-base.c new/drivers/net/wireless/iwlwifi/iwl4965-base.c
--- compat-wireless-2008-05-07/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-05-07 12:11:10.000000000 +0800
+++ new/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-05-09 13:18:06.000000000 +0800
@@ -7102,6 +7102,7 @@ static int iwl4965_pci_probe(struct pci_
 	IWL_DEBUG_INFO("*** LOAD DRIVER ***\n");
 	priv->cfg = cfg;
 	priv->pci_dev = pdev;
+	spin_lock_init(&priv->lock);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	iwl_debug_level = priv->cfg->mod_params->debug;
diff -urp compat-wireless-2008-05-07/drivers/net/wireless/iwlwifi/iwl-core.c new/drivers/net/wireless/iwlwifi/iwl-core.c
--- compat-wireless-2008-05-07/drivers/net/wireless/iwlwifi/iwl-core.c	2008-05-07 12:11:10.000000000 +0800
+++ new/drivers/net/wireless/iwlwifi/iwl-core.c	2008-05-09 13:16:51.000000000 +0800
@@ -580,7 +580,6 @@ static int iwlcore_init_drv(struct iwl_p
 	priv->retry_rate = 1;
 	priv->ibss_beacon = NULL;
 
-	spin_lock_init(&priv->lock);
 	spin_lock_init(&priv->power_data.lock);
 	spin_lock_init(&priv->sta_lock);
 	spin_lock_init(&priv->hcmd_lock);

--=-kiMNSF8hME8RGc8q1M0n--

