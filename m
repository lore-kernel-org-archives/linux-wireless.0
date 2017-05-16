Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:36018 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdEPIHc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 04:07:32 -0400
Received: by mail-io0-f171.google.com with SMTP id o12so88773326iod.3
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 01:07:32 -0700 (PDT)
MIME-Version: 1.0
From: Amritpreet Singh <amritpreetsingh91@gmail.com>
Date: Tue, 16 May 2017 13:37:31 +0530
Message-ID: <CA+DPB_jVVQ3UJLeJ9JQrQNKNEb=3o8=u7XQXqW48cyU5UrGUSQ@mail.gmail.com> (sfid-20170516_100739_944402_2F92772E)
Subject: MAC80211 not able to receive probe response and beacon packets
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am writing a linux wlan driver based on MAC80211 to receive and send
the frames on AXI DMA. I am implementing this on Zynq(ARM) based
board, lower MAC has been implemented on FPGA. I am able to receive
probe requests, beacons, probe responses and data packets till the
driver. But only probe request packets are getting through towards
MAC80211 by ieee80211_rx_irqsafe(hw, skb) API.

By printing these packets in the driver itself i am able to verify
that these beacon and probe response packets are correct, but MAC80211
is not showing any kind of prints for these packets. But it is
transmitting ProbeResp packets for ProbeRequest packets, that means it
is able to receive Probe Requests correctly.

Can anybody please suggest where can be the issue?

-- 
Amritpreet Singh
