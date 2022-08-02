Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 115B8C00140
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Aug 2022 18:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237312AbiHBSCv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Aug 2022 14:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236991AbiHBSCd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Aug 2022 14:02:33 -0400
X-Greylist: delayed 497 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 02 Aug 2022 11:02:19 PDT
Received: from relay.memeplex.com (inbound.memeplex.com [35.162.238.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2DA93DFAC
        for <linux-wireless@vger.kernel.org>; Tue,  2 Aug 2022 11:02:18 -0700 (PDT)
Received: from mail.memeplex.com ([35.162.238.239])
        by relay.memeplex.com (Postfix) with ESMTPS id D11D84075F
        for <linux-wireless@vger.kernel.org>; Tue,  2 Aug 2022 17:54:00 +0000 (UTC)
Message-ID: <0cdbbf6f-5003-946b-7910-dbfbb83ee31b@memeplex.com>
Date:   Tue, 2 Aug 2022 10:53:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-Language: en-US
To:     linux-wireless@vger.kernel.org
From:   Andrew than <linux_kernel_aathan@memeplex.com>
Subject: Terrible performance form Lenovo Ideapad using RTL8852AE 802.11ax on
 5.17 kernel (ubuntu)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello all:

Please direct me on what additional information I can provide.

I recently added a Lenovo Ideapad to my wifi network. Two mac hosts on 
that network experience no issue whatsoever with the network (desktop + 
macpro laptop).

A simple scp test between the desktop & macpro vs desktop & lenovo 
yields a 50% difference in throughput.

Interactive performance of ssh is horrible vs the lenovo. I looked but 
didn't find any TCP_NODELAY / Nagel's related settings for sshd. 
However, the scp performance leads me to believe that's not the issue.

I've seen other reports of slow performance of these cards/drivers (e.g. 
https://github.com/lwfinger/rtw89/issues/36)

Any ideas?



   *-network
        description: Wireless interface
        product: RTL8852AE 802.11ax PCIe Wireless Network Adapter
        vendor: Realtek Semiconductor Co., Ltd.
        physical id: 0
        bus info: pci@0000:03:00.0
        logical name: wlo1
        version: 00
        serial: 14:5a:fc:01:c2:xx
        width: 64 bits
        clock: 33MHz
        capabilities: pm msi pciexpress bus_master cap_list ethernet 
physical wireless
        configuration: broadcast=yes driver=rtw89_pci 
driverversion=5.17.0-1014-oem firmware=N/A ip=192.168.x.x latency=0 
link=yes multicast=yes wireless=IEEE 802.11
        resources: irq:64 ioport:2000(size=256) memory:d1600000-d16fffff

