Return-Path: <SRS0=Fc74=OH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 499F4C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 22:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 170BC21019
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 22:13:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 170BC21019
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbeK2JQa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 04:16:30 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:50360 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbeK2JQa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 04:16:30 -0500
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 2FCF940A5CB
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2018 14:13:21 -0800 (PST)
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: Issue with STBC capability and forcing radio to 1x1 mode.
Organization: Candela Technologies
Message-ID: <2827d468-5bba-61ed-66db-89b670a5330b@candelatech.com>
Date:   Wed, 28 Nov 2018 14:13:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

I notice some weird things while debugging an issue on a 4.16+ kernel with ath10k
radio.

It seems that the 'iw phy info' does not remove the TX-STBC info
when changing the antenna mask _until_ some vdev is brought up.

This makes it difficult to properly create hostapd config files.

[root@lf0313-63e7 lanforge]# iw phy wiphy1 info|grep STB
			TX STBC
			RX STBC 1-stream
			TX STBC
[root@lf0313-63e7 lanforge]# ./local/sbin/iw phy wiphy1 set antenna 1 1
[root@lf0313-63e7 lanforge]# iw phy wiphy1 info|grep STB
			TX STBC
			RX STBC 1-stream
			TX STBC
[root@lf0313-63e7 lanforge]# iw phy wiphy1 info|grep STB
			TX STBC
			RX STBC 1-stream
			TX STBC
[root@lf0313-63e7 lanforge]# ifconfig wlan1 up
[root@lf0313-63e7 lanforge]# iw phy wiphy1 info|grep STB
			RX STBC 1-stream

Any idea on this?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

