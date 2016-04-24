Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from erley.org ([97.107.129.9]:58759 "EHLO remote.erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbcDXGhB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2016 02:37:01 -0400
Subject: Re: [PATCH 23/43] iwlwifi: remove support for fw older than -16.ucode
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org
References: <1459346667.4731.9.camel@intel.com>
 <1459346715-7954-23-git-send-email-emmanuel.grumbach@intel.com>
Cc: Sara Sharon <sara.sharon@intel.com>
From: Pat Erley <pat-lkml@erley.org>
Message-ID: <571C681B.2090604@erley.org> (sfid-20160424_083752_167028_72FDB842)
Date: Sat, 23 Apr 2016 23:30:51 -0700
MIME-Version: 1.0
In-Reply-To: <1459346715-7954-23-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch broke ucode loading on iwl6050 hardware.

[   12.666080] iwlwifi 0000:03:00.0: Direct firmware load for 
iwlwifi-6050-exp.ucode failed with error -2
[   12.672318] iwlwifi 0000:03:00.0: Driver unable to support your 
firmware API. Driver supports v5, firmware is v689702145.
[   12.676429] iwlwifi 0000:03:00.0: Driver unable to support your 
firmware API. Driver supports v5, firmware is v164168705.
[   12.676631] iwlwifi 0000:03:00.0: no suitable firmware found!

My guess is this block:

 >
> -	if (fw_has_api(&drv->fw.ucode_capa, IWL_UCODE_TLV_API_NEW_VERSION))
> -		api_ver = drv->fw.ucode_ver;
> -	else
> -		api_ver = IWL_UCODE_API(drv->fw.ucode_ver);
> +	api_ver = drv->fw.ucode_ver;
>


is still required for some devices on DVM?

After reverting this patch:

[ 2947.082256] iwlwifi 0000:03:00.0: Direct firmware load for 
iwlwifi-6050-exp.ucode failed with error -2
[ 2947.082880] iwlwifi 0000:03:00.0: loaded firmware version 41.28.5.1 
build 33926 op_mode iwldvm
[ 2947.095203] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG enabled
[ 2947.095207] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[ 2947.095211] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[ 2947.095214] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) 
Advanced-N + WiMAX 6250 AGN, REV=0x84
[ 2947.095557] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[ 2947.117923] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'

Everything is working.
