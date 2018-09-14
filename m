Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:42269 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727649AbeINPuN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Sep 2018 11:50:13 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id aa7e5a89
        for <linux-wireless@vger.kernel.org>;
        Fri, 14 Sep 2018 10:19:13 +0000 (UTC)
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 64604364 (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128:NO)
        for <linux-wireless@vger.kernel.org>;
        Fri, 14 Sep 2018 10:19:13 +0000 (UTC)
Received: by mail-ot1-f53.google.com with SMTP id v10-v6so4099112otk.7
        for <linux-wireless@vger.kernel.org>; Fri, 14 Sep 2018 03:36:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9oBQqT5B9cnY530czZ53hoqyMsXeAf7OURhrX=wZv1Qvw@mail.gmail.com>
In-Reply-To: <CAHmME9oBQqT5B9cnY530czZ53hoqyMsXeAf7OURhrX=wZv1Qvw@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 14 Sep 2018 12:36:00 +0200
Message-ID: <CAHmME9oCoZ+1O-QOdkQYp_tCw1zDa3--9RVenJON4Uud60oYhw@mail.gmail.com> (sfid-20180914_123623_972950_14698CA9)
Subject: Re: disconnection regression in 4.17?
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

I can confirm that this issue is still present in 4.18. I'm receiving
very frequent disconnections:

[  304.707603] wlan0: deauthenticated from <> (Reason:
6=CLASS2_FRAME_FROM_NONAUTH_STA)

The last working kernel was in the 4.16 series. Any ideas?

Jason



On Mon, Jul 30, 2018 at 2:17 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hello,
>
> I'm seeing quite frequent but fairly irregular disconnections in 4.17
> that I was not seeing in 4.16, even when sitting directly next to the
> AP. Below is a debug log; let me know if there's a better way to debug
> this.
>
> Thanks,
> Jason
>
> ----------------8<----------------------------------
>
> Thinkpad P50
>
> 02:00.0 Network controller: Intel Corporation Wireless 8260 (rev 3a)
>        Subsystem: Intel Corporation Wireless 8260
>        Flags: bus master, fast devsel, latency 0, IRQ 141
>        Memory at d4300000 (64-bit, non-prefetchable) [size=8K]
>        Capabilities: <access denied>
>        Kernel driver in use: iwlwifi
>        Kernel modules: iwlwifi
>
> Jul 30 03:19:23 thinkpad kernel: wlan0: deauthenticated from
> re:po:rt:re:mo:ve (Reason: 6=CLASS2_FRAME_FROM_NONAUTH_STA)
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_mac_ctxt_cmd_sta DTIM TBTT is 0x393ca3039/0x894808f0, offset 0
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_PM_POWER_TABLE
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_drain_sta Frames for staid 0 will drained in fw
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command TXPATH_FLUSH
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command TXPATH_FLUSH
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command TXPATH_FLUSH
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_drain_sta Frames for staid 0 will drained in fw
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_drain_sta Frames for staid 0 will drained in fw
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command TXPATH_FLUSH
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command TXPATH_FLUSH
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command TXPATH_FLUSH
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_drain_sta Frames for staid 0 will drained in fw
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA_KEY
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA_KEY
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA_KEY
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_drain_sta Frames for staid 0 will drained in fw
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command TXPATH_FLUSH
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command TXPATH_FLUSH
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command TXPATH_FLUSH
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_drain_sta Frames for staid 0 will drained in fw
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command STATISTICS_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command STATISTICS_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command STATISTICS_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command REMOVE_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REMOVE_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REMOVE_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command TIME_QUOTA_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command TIME_QUOTA_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command TIME_QUOTA_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_PM_POWER_TABLE
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> BINDING_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> BINDING_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> BINDING_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_PM_POWER_TABLE
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> PHY_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> PHY_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> PHY_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCAN_REQ_UMAC
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCAN_REQ_UMAC
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCAN_REQ_UMAC
> Jul 30 03:19:23 thinkpad wpa_supplicant[446]: wlan0:
> CTRL-EVENT-DISCONNECTED bssid=re:po:rt:re:mo:ve reason=6
> Jul 30 03:19:23 thinkpad wpa_supplicant[446]: wlan0: SME: Trying to
> authenticate with re:po:rt:re:mo:ve (SSID='neato-burrito-network'
> freq=5220 MHz)
> Jul 30 03:19:23 thinkpad kernel: wlan0: authenticate with re:po:rt:re:mo:ve
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> PHY_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> PHY_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> PHY_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> BINDING_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> BINDING_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> BINDING_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_PM_POWER_TABLE
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> PHY_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> PHY_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> PHY_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_sta_send_to_fw ADD_STA PASSED
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command TIME_EVENT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command TIME_EVENT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command TIME_EVENT_CMD
> Jul 30 03:19:23 thinkpad kernel: wlan0: send auth to re:po:rt:re:mo:ve (try 1/3)
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_sta_send_to_fw ADD_STA PASSED
> Jul 30 03:19:23 thinkpad kernel: wlan0: authenticated
> Jul 30 03:19:23 thinkpad kernel: wlan0: associate with
> re:po:rt:re:mo:ve (try 1/3)
> Jul 30 03:19:23 thinkpad wpa_supplicant[446]: wlan0: Trying to
> associate with re:po:rt:re:mo:ve (SSID='neato-burrito-network'
> freq=5220 MHz)
> Jul 30 03:19:23 thinkpad kernel: wlan0: RX AssocResp from
> re:po:rt:re:mo:ve (capab=0x511 status=0 aid=1)
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command LQ_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command LQ_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command LQ_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_sta_send_to_fw ADD_STA PASSED
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_mac_ctxt_cmd_sta DTIM TBTT is 0x38feeb039/0x856c87bc, offset 0
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command STATISTICS_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command STATISTICS_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command STATISTICS_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command TIME_QUOTA_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command TIME_QUOTA_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command TIME_QUOTA_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command TIME_EVENT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command TIME_EVENT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command TIME_EVENT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_PM_POWER_TABLE
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> PHY_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> PHY_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> PHY_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: wlan0: associated
> Jul 30 03:19:23 thinkpad wpa_supplicant[446]: wlan0: Associated with
> re:po:rt:re:mo:ve
> Jul 30 03:19:23 thinkpad wpa_supplicant[446]: wlan0:
> CTRL-EVENT-SUBNET-STATUS-UPDATE status=0
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_sta_send_to_fw ADD_STA PASSED
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA_KEY
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA_KEY
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA_KEY
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA_KEY
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA_KEY
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA_KEY
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_mac_ctxt_cmd_sta DTIM TBTT is 0x38feeb039/0x856c87bc, offset 0
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_PM_POWER_TABLE
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_sta_send_to_fw ADD_STA PASSED
> Jul 30 03:19:23 thinkpad wpa_supplicant[446]: wlan0: WPA: Key
> negotiation completed with re:po:rt:re:mo:ve [PTK=CCMP GTK=CCMP]
> Jul 30 03:19:23 thinkpad wpa_supplicant[446]: wlan0:
> CTRL-EVENT-CONNECTED - Connection to re:po:rt:re:mo:ve completed [id=0
> id_str=]
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:23 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:24 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:24 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:24 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:28 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:19:28 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:28 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:28 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:28 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:28 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:28 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_sta_send_to_fw ADD_STA PASSED
> Jul 30 03:19:28 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_mac_ctxt_cmd_sta DTIM TBTT is 0x3a562e039/0x9ae0c11b, offset 0
> Jul 30 03:19:28 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_CONTEXT_CMD
> Jul 30 03:19:28 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:19:28 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:19:29 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:29 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:29 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:29 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:19:29 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:29 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:19:29 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:29 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:29 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:29 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_sta_send_to_fw ADD_STA PASSED
> Jul 30 03:19:30 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:19:30 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:19:30 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
>
>
> Jul 30 03:21:19 thinkpad kernel: wlan0: deauthenticated from
> re:po:rt:re:mo:ve (Reason: 6=CLASS2_FRAME_FROM_NONAUTH_STA)
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_mac_ctxt_cmd_sta DTIM TBTT is 0x3a562e039/0x9ae0c11b, offset 0
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_PM_POWER_TABLE
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_drain_sta Frames for staid 0 will drained in fw
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command TXPATH_FLUSH
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command TXPATH_FLUSH
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command TXPATH_FLUSH
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_drain_sta Frames for staid 0 will drained in fw
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_drain_sta Frames for staid 0 will drained in fw
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command TXPATH_FLUSH
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command TXPATH_FLUSH
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command TXPATH_FLUSH
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_drain_sta Frames for staid 0 will drained in fw
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA_KEY
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA_KEY
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA_KEY
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_drain_sta Frames for staid 0 will drained in fw
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command TXPATH_FLUSH
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command TXPATH_FLUSH
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command TXPATH_FLUSH
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_drain_sta Frames for staid 0 will drained in fw
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command STATISTICS_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command STATISTICS_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command STATISTICS_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command REMOVE_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REMOVE_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REMOVE_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command TIME_QUOTA_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command TIME_QUOTA_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command TIME_QUOTA_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_PM_POWER_TABLE
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> BINDING_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> BINDING_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> BINDING_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_PM_POWER_TABLE
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> PHY_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> PHY_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> PHY_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCAN_REQ_UMAC
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCAN_REQ_UMAC
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCAN_REQ_UMAC
> Jul 30 03:21:19 thinkpad kernel: wlan0: authenticate with re:po:rt:re:mo:ve
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> PHY_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> PHY_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> PHY_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> BINDING_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> BINDING_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> BINDING_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_PM_POWER_TABLE
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:21:19 thinkpad wpa_supplicant[446]: wlan0:
> CTRL-EVENT-DISCONNECTED bssid=re:po:rt:re:mo:ve reason=6
> Jul 30 03:21:19 thinkpad wpa_supplicant[446]: wlan0: SME: Trying to
> authenticate with re:po:rt:re:mo:ve (SSID='neato-burrito-network'
> freq=5220 MHz)
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> PHY_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> PHY_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> PHY_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_sta_send_to_fw ADD_STA PASSED
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command TIME_EVENT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command TIME_EVENT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command TIME_EVENT_CMD
> Jul 30 03:21:19 thinkpad kernel: wlan0: send auth to re:po:rt:re:mo:ve (try 1/3)
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_sta_send_to_fw ADD_STA PASSED
> Jul 30 03:21:19 thinkpad kernel: wlan0: authenticated
> Jul 30 03:21:19 thinkpad wpa_supplicant[446]: wlan0: Trying to
> associate with re:po:rt:re:mo:ve (SSID='neato-burrito-network'
> freq=5220 MHz)
> Jul 30 03:21:19 thinkpad kernel: wlan0: associate with
> re:po:rt:re:mo:ve (try 1/3)
> Jul 30 03:21:19 thinkpad kernel: wlan0: RX AssocResp from
> re:po:rt:re:mo:ve (capab=0x511 status=0 aid=1)
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command LQ_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command LQ_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command LQ_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_sta_send_to_fw ADD_STA PASSED
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_mac_ctxt_cmd_sta DTIM TBTT is 0x3a562e039/0x9ae0c11b, offset 0
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command STATISTICS_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command STATISTICS_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command STATISTICS_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command TIME_QUOTA_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command TIME_QUOTA_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command TIME_QUOTA_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command TIME_EVENT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command TIME_EVENT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command TIME_EVENT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_PM_POWER_TABLE
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> PHY_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> PHY_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> PHY_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: wlan0: associated
> Jul 30 03:21:19 thinkpad wpa_supplicant[446]: wlan0: Associated with
> re:po:rt:re:mo:ve
> Jul 30 03:21:19 thinkpad wpa_supplicant[446]: wlan0:
> CTRL-EVENT-SUBNET-STATUS-UPDATE status=0
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_sta_send_to_fw ADD_STA PASSED
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA_KEY
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA_KEY
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA_KEY
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA_KEY
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA_KEY
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA_KEY
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_mac_ctxt_cmd_sta DTIM TBTT is 0x3a562e039/0x9ae0c11b, offset 0
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_PM_POWER_TABLE
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_PM_POWER_TABLE
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> REPLY_BEACON_FILTERING_CMD
> Jul 30 03:21:19 thinkpad wpa_supplicant[446]: wlan0: WPA: Key
> negotiation completed with re:po:rt:re:mo:ve [PTK=CCMP GTK=CCMP]
> Jul 30 03:21:19 thinkpad wpa_supplicant[446]: wlan0:
> CTRL-EVENT-CONNECTED - Connection to re:po:rt:re:mo:ve completed [id=0
> id_str=]
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_sta_send_to_fw ADD_STA PASSED
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:19 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:24 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:21:24 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:24 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:24 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:24 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:24 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:24 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_sta_send_to_fw ADD_STA PASSED
> Jul 30 03:21:24 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_mac_ctxt_cmd_sta DTIM TBTT is 0x3ac4a1039/0xa1c7f44d, offset 0
> Jul 30 03:21:24 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command
> MAC_CONTEXT_CMD
> Jul 30 03:21:24 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:21:24 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command
> MAC_CONTEXT_CMD
> Jul 30 03:21:25 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command SCD_QUEUE_CFG
> Jul 30 03:21:25 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:25 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCD_QUEUE_CFG
> Jul 30 03:21:25 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:25 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:25 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:25 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_mvm_sta_send_to_fw ADD_STA PASSED
> Jul 30 03:21:25 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:25 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:25 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:25 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
> Jul 30 03:21:25 thinkpad kernel: iwlwifi 0000:02:00.0: U
> iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
> Jul 30 03:21:25 thinkpad kernel: iwlwifi 0000:02:00.0: I
> iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
