Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0103.outbound.protection.outlook.com ([104.47.41.103]:44484
	"EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932114AbcGGWUx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2016 18:20:53 -0400
From: "Zhang, Eniac" <eniac-xw.zhang@hp.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Intel 3168 AC regulatory domain question
Date: Thu, 7 Jul 2016 22:05:39 +0000
Message-ID: <AT5PR84MB01622AB7501E5DBEDD1F4F12BB3B0@AT5PR84MB0162.NAMPRD84.PROD.OUTLOOK.COM> (sfid-20160708_002057_610403_3FAFD184)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks,

While testing Intel 3168 card.  I hit this problem where the driver can't set regulatory domain properly.

The iwlmvm driver first tries to get regulatory domain from kernel (iwl_mvm_get_current_regdomain()), and then from bios.  Below are the relevant code from nvm.c, with my debug lines:

886         regd = iwl_mvm_get_current_regdomain(mvm, NULL);
887         if (IS_ERR_OR_NULL(regd))
888                 return -EIO;
889
890         IWL_INFO(mvm, "eniacz: regd from kernel=%s\n", regd->alpha2);
891
892         IWL_INFO(mvm, "eniacz: mcc supported=%d\n", iwl_mvm_is_wifi_mcc_supported(mvm));
893         IWL_INFO(mvm, "eniacz: IWL_UCODE_TLV_API_WIFI_MCC_UPDATE=%d\n", fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_WIFI_MCC_UPDATE));
894         IWL_INFO(mvm, "eniacz: IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC=%d\n", fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC));
895         if (iwl_mvm_is_wifi_mcc_supported(mvm) &&
896             !iwl_mvm_get_bios_mcc(mvm, mcc)) {
897                 kfree(regd);
898                 regd = iwl_mvm_get_regdomain(mvm->hw->wiphy, mcc,
899                                              MCC_SOURCE_BIOS, NULL);
900                 if (IS_ERR_OR_NULL(regd))
901                         return -EIO;
902                 IWL_INFO(mvm, "eniacz: regd from bios=%s\n", regd->alpha2);
903         }
904
905         retval = regulatory_set_wiphy_regd_sync_rtnl(mvm->hw->wiphy, regd);
906         kfree(regd);
907         return retval;

The first problem is line 890 always returns 00, regardless of what I have set in cfg80211. 

The second problem is that iwlwifi-3168-21.ucode doesn't support MCC, even though Intel claim 3168 support it.  iwlwifi-8000C-14.ucode does support MCC but that only work with 8260 modules.  When I compile code from HEAD, I found it is requesting version 23 of the firmware (4.6.0 requests 21).  But I can't find v23 firmware anywhere.

My question is how can do I enforce regulatory domain settings on a 3168 module.  Either cfg80211 or bios approach will work for me but right now neither of them is.

Regards/Eniac

