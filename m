Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56737 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab1ATLns (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 06:43:48 -0500
Received: by bwz15 with SMTP id 15so441395bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 03:43:46 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: iwl4965: 11n broken
Date: Thu, 20 Jan 2011 12:42:24 +0100
Cc: "Wey-Yi Guy" <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201101201242.24680.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've just updated my workstation to wireless-testing from last
week (2.6.37-wl-default+). When associating to a 11n router the
card only associates as 11g, the assoc request doesn't contain
any HT IEs.

The causing commit is:

commit 21a5b3c6b19a8b8972ccdd55389be28a8b7c9180
Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date:   Wed Nov 10 13:32:59 2010 -0800

    iwlagn: use SKU information in the EEPROM
    
    EEPROM contain the SKU information for the device, use it.
    
    Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>


Seems as if the device eeprom hasn't set EEPROM_SKU_CAP_11N_ENABLE and thus
iwlagn thinks the device is not 11n capable.

Ideas? Should we just revert the 4965 part of the patch and modify 
iwl_eeprom_check_sku to allow overwriting the sku field? Do 4965 devices
exists that are not 11n capable?

Thanks,
Helmut
