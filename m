Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33306 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935057AbcJGAQ5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Oct 2016 20:16:57 -0400
Received: by mail-wm0-f68.google.com with SMTP id i130so342341wmg.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2016 17:16:56 -0700 (PDT)
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: johannes.berg@intel.com
Cc: emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        linux-wireless@vger.kernel.org
Subject: Non-fatal errors when disabling WiFi - Intel 7260
Message-ID: <9bf978c3-17eb-a172-50b1-01ffb47490f4@gmail.com> (sfid-20161007_021736_500101_36067504)
Date: Fri, 7 Oct 2016 02:16:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

since commit b7a08b284dcf ("iwlwifi: pcie: extend device reset delay")
I get the following errors when I disable the WiFi:

[   66.702845] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
[   66.737893] iwlwifi 0000:02:00.0: Failed to wake NIC for hcmd
[   66.737927] iwlwifi 0000:02:00.0: Error sending TXPATH_FLUSH: enqueue_hcmd failed: -5
[   66.737933] iwlwifi 0000:02:00.0: Failed to send flush command (-5)
[   66.772678] iwlwifi 0000:02:00.0: Failed to wake NIC for hcmd
[   66.772698] iwlwifi 0000:02:00.0: Error sending REMOVE_STA: enqueue_hcmd failed: -5
[   66.772699] iwlwifi 0000:02:00.0: Failed to remove station. Id=2
[   66.772701] iwlwifi 0000:02:00.0: Failed sending remove station
[   66.807518] iwlwifi 0000:02:00.0: Failed to wake NIC for hcmd
[   66.807531] iwlwifi 0000:02:00.0: Error sending BINDING_CONTEXT_CMD: enqueue_hcmd failed: -5
[   66.807533] iwlwifi 0000:02:00.0: Failed to send binding (action:3): -5
[   66.842413] iwlwifi 0000:02:00.0: Failed to wake NIC for hcmd
[   66.842430] iwlwifi 0000:02:00.0: Error sending MAC_PM_POWER_TABLE: enqueue_hcmd failed: -5
[   66.877120] iwlwifi 0000:02:00.0: Failed to wake NIC for hcmd
[   66.877150] iwlwifi 0000:02:00.0: Error sending MAC_CONTEXT_CMD: enqueue_hcmd failed: -5
[   66.877153] iwlwifi 0000:02:00.0: Failed to remove MAC context: -5
[   66.911995] iwlwifi 0000:02:00.0: Failed to wake NIC for hcmd
[   66.912015] iwlwifi 0000:02:00.0: Error sending SCD_QUEUE_CFG: enqueue_hcmd failed: -5
[   66.912019] iwlwifi 0000:02:00.0: Failed to disable queue 8 (ret=-5)
[   66.947134] iwlwifi 0000:02:00.0: Failed to wake NIC for hcmd
[   66.947163] iwlwifi 0000:02:00.0: Error sending TXPATH_FLUSH: enqueue_hcmd failed: -5
[   66.947165] iwlwifi 0000:02:00.0: Failed to send flush command (-5)

Other than these, there seems to be no noticeable issue, I can
re-enable the WiFi and use it normally.

Reverting the commit on top of 4.8 get rids of the errors.

My laptop has an Intel Corporation Wireless 7260 (rev 6b),
the firmware currently used is 17.352738.0.

Regards,
Gabriele
