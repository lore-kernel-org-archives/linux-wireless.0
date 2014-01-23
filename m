Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:40839 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbaAWTL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 14:11:56 -0500
Received: by mail-we0-f169.google.com with SMTP id u57so1704859wes.28
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jan 2014 11:11:55 -0800 (PST)
Message-ID: <52E16978.3040602@gmail.com> (sfid-20140123_201206_714657_9B5CC91B)
Date: Thu, 23 Jan 2014 21:11:52 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Petko Manolov <petkan@nucleusys.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi crash with 3.13
References: <20140123091659.GE9077@localhost> <0BA3FCBA62E2DC44AF3030971E174FB303D56D70@HASMSX103.ger.corp.intel.com> <20140123123125.GA3424@localhost> <0BA3FCBA62E2DC44AF3030971E174FB303D57045@HASMSX103.ger.corp.intel.com>
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303D57045@HASMSX103.ger.corp.intel.com>
Content-Type: multipart/mixed;
 boundary="------------080204090707000405030806"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080204090707000405030806
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Ok -  I put the pieces together:

> iwlwifi 0000:01:00.0: loaded firmware version 22.15.8.0 op_mode iwlmvm
> iwlwifi 0000:01:00.0: Detected Intel(R) Wireless N 7260, REV=0x144

This means that your NIC is 2.4GHz only. Dual band NICs print something
else.

Now here come the catch. You seem to have an "old" NIC in a way that the
NVM (EEPROM like) is old. In that NVM, there was a bug that advertised
the A band channels but disabled the A band in SKU cap.

Can you please try the patch attached?
I will prevent the driver from trying to work on A band while the HW
doesn't allow.

emmanuel

--------------080204090707000405030806
Content-Type: text/x-patch;
 name="0001-iwlwifi-mvm-don-t-allow-A-band-if-SKU-forbids-it.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-iwlwifi-mvm-don-t-allow-A-band-if-SKU-forbids-it.patch"

>From dd40219d34426e4f9c7d1b10653ece3dc67588c5 Mon Sep 17 00:00:00 2001
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Thu, 5 Dec 2013 22:42:55 +0200
Subject: [PATCH] iwlwifi: mvm: don't allow A band if SKU forbids it

Change-Id: I920b7c53dc05a41de43ab9762eb7853dc4bed1ed
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 1fce0ec..9600afc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -192,6 +192,10 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 			continue;
 		}
 
+		if (ch_idx >= NUM_2GHZ_CHANNELS &&
+		    !data->sku_cap_band_52GHz_enable)
+			continue;
+
 		channel = &data->channels[n_channels];
 		n_channels++;
 
-- 
1.8.1.msysgit.1


--------------080204090707000405030806--
