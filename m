Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51288 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeE2HSf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 03:18:35 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/14] rtlwifi: support accurate nullfunc frame tx ack report
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180518093007.23594-2-pkshih@realtek.com>
References: <20180518093007.23594-2-pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Message-Id: <20180529071835.128C5605FF@smtp.codeaurora.org> (sfid-20180529_092046_956776_03E3437D)
Date: Tue, 29 May 2018 07:18:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Tzu-En Huang <tehuang@realtek.com>
> 
> In order to realize the keep-alive mechanism in mac80211 stack, reporting
> accurate tx ack status for nullfunc frame is added in this commit.
> 
> If current frame is nullfunc frame, we ask firmware to report by filling
> TX report bit in TX descriptor. After this frame DMA done, TX interrupt is
> triggered but TX status is unknown at this moment, so enqueue this skb
> into tx_report->queue. Finally, C2H report will be received if the frame
> is transmitted successfully or retried over, and then we report to mac80211
> with IEEE80211_TX_STAT_ACK flag only if it's successful. Otherwise, if
> failure or timeout (one second), we report to mac80211 without this flag.
> 
> Signed-off-by: Tzu-En Huang <tehuang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

14 patches applied to wireless-drivers-next.git, thanks.

6acfbb81ab0a rtlwifi: support accurate nullfunc frame tx ack report
faa280065397 rtlwifi: remove CONNECTION_MONITOR flag
c4528686d0ea rtlwifi: remove duplicate rx_packet_type definition
249155973f52 rtlwifi: rename register-based C2H command IDs to V0
7aeb100b7d70 rtlwifi: remove duplicate C2H definition
16e78cb4a571 rtlwifi: remove unused fw C2H command ID
ff77960d62d2 rtlwifi: remove dummy hal_op rx_command_packet from rtl8188ee and rtl8723ae
16cefa449c9c rtlwifi: Add hal_op c2h_ra_report_handler for special process
daf026ae5fbe rtlwifi: remove duplicate C2H handler
23ffab177b1d rtlwifi: remove hal_op rx_command_packet
b4f6ee489cff rtlwifi: remove hal_op c2h_content_parsing
9ae6ed271a60 rtlwifi: use sk_buff to queue C2H commands
9644032e3070 rtlwifi: access skb->data to get C2H data by macro
0a9f8f0a1ba9 rtlwifi: fix btmpinfo timeout while processing C2H_BT_INFO

-- 
https://patchwork.kernel.org/patch/10409171/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
