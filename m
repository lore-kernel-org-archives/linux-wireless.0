Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A734C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 13:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2818620825
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 13:31:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2818620825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbeKIXMR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 18:12:17 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38995 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727784AbeKIXMQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 18:12:16 -0500
Received: by mail-wm1-f67.google.com with SMTP id u13-v6so1949442wmc.4
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 05:31:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6B7YQd7qSXKpDgQliMPsv2lOQw1j1W/bVhxCe0JYLjQ=;
        b=HLpxIM3KYhrU1WXW0lRMDoj3XzWY9umAkqHtB+eodZvllF8RgD+bZf6smQknorIcc1
         fa3RExPIcK7e79HbtalDPVAc6Y/SKIeBdeIfCzyYhnmQun86dFGpnqMeBTIMQQbiI9yy
         jGQHI+EYHU0EXPTgjWBcPBEUgiFZ8w784t859hT4GeesCKhqWb7xu9+9684dC901IVM4
         ZQJGdIIZ/UeXZFxb09pZDJA1roTrzUBbXlmt+aS0FUAwhM40hH778ar6mo7tGq/EtDas
         P5uyZX2KBWlmK/Yg6WflNS8swt4iplInCzFWhpm2msEiX1AvmWV0N2udBqUxHAGwEK/H
         yu4w==
X-Gm-Message-State: AGRZ1gK/LCSGjl89zZTe4hZm/45drFsnweZ4bzj80lTFKcIgC5HAFjQy
        6TGQJJrCMn23coC0Sg8iMvOlp8468Fs=
X-Google-Smtp-Source: AJdET5d9ctlLM8K899njd27dOMmiGblJIAy3x5l9kLbUdj/uoMMWVSovQ7DbFXLqU2N//8EDUxM0Xg==
X-Received: by 2002:a1c:650b:: with SMTP id z11-v6mr4822751wmb.28.1541770296536;
        Fri, 09 Nov 2018 05:31:36 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y13-v6sm8901393wrq.13.2018.11.09.05.31.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Nov 2018 05:31:35 -0800 (PST)
Date:   Fri, 9 Nov 2018 14:31:31 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/5] mt76x02: initalize mutli bss mode by default
Message-ID: <20181109133130.GA9453@localhost.localdomain>
References: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
 <1541758814-2046-3-git-send-email-sgruszka@redhat.com>
 <20181109112651.GF4174@localhost.localdomain>
 <20181109131028.GA8054@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109131028.GA8054@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> [root@dhcp-27-155 ~]# iw dev
> phy#1
> 	Interface wlan1
> 		ifindex 10
> 		wdev 0x100000001
> 		addr 2c:4d:54:cb:d8:04
> 		type managed
> [root@dhcp-27-155 ~]# ip link set addres  b0:6e:bf:a5:31:90  wlan1
> [root@dhcp-27-155 ~]# iw dev wlan1 del
> [root@dhcp-27-155 ~]# iw phy phy0 interface  add wlan0 type station
> command failed: No such file or directory (-2)
> [root@dhcp-27-155 ~]# iw phy phy1 interface  add wlan0 type station
> [root@dhcp-27-155 ~]# iw dev 
> phy#1
> 	Interface wlan0
> 		ifindex 11
> 		wdev 0x100000002
> 		addr 2c:4d:54:cb:d8:04
> 		type managed
> [root@dhcp-27-155 ~]# ethtool -i wlan0
> driver: mt76x2u
> version: 4.20.0-rc1+
> firmware-version: 0.0.00-b1
> bus-info: 1-1.2:1.0
> supports-statistics: yes
> supports-test: no
> supports-eeprom-access: no
> supports-register-dump: no
> supports-priv-flags: no
> 
> Anyway I think, to support MAC address change, we should not filter
> based on MAC address, but maybe only on BSSID ? 
> 
> Thanks
> Stanislaw

You can create the interface with a given mac address

# iw phy phy0 interface add wlp0s4u1 type managed addr 00:11:22:33:44:55
# iw dev
phy#0
        Interface wlp0s4u1
                ifindex 9
                wdev 0x2
                addr 00:11:22:33:44:55
                type managed
                txpower 3.00 dBm

# ip link show dev wlp0s4u1
9: wlp0s4u1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DORMANT group default qlen 1000
    link/ether 00:11:22:33:44:55 brd ff:ff:ff:ff:ff:ff

Regards,
Lorenzo

