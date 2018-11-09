Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734D7C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 13:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37AE720827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 13:10:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37AE720827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbeKIWvH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 17:51:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43332 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727662AbeKIWvH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 17:51:07 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E40530A4CB3;
        Fri,  9 Nov 2018 13:10:33 +0000 (UTC)
Received: from localhost (unknown [10.43.2.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 324C6600CD;
        Fri,  9 Nov 2018 13:10:31 +0000 (UTC)
Date:   Fri, 9 Nov 2018 14:10:29 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/5] mt76x02: initalize mutli bss mode by default
Message-ID: <20181109131028.GA8054@redhat.com>
References: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
 <1541758814-2046-3-git-send-email-sgruszka@redhat.com>
 <20181109112651.GF4174@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109112651.GF4174@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 09 Nov 2018 13:10:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Nov 09, 2018 at 12:26:51PM +0100, Lorenzo Bianconi wrote:
> > @@ -52,9 +52,6 @@ static int mt76x2u_add_interface(struct ieee80211_hw *hw,
> >  	struct mt76x02_dev *dev = hw->priv;
> >  	unsigned int idx = 8;
> >  
> > -	if (!ether_addr_equal(dev->mt76.macaddr, vif->addr))
> > -		mt76x02_mac_setaddr(dev, vif->addr);
> > -
> 
> I think this is a regression since you will able to change device mac address
> in this way. Do you agree?

I don't think it works currently, because we have already created
vif interface when set mac address via ieee80211_change_mac().

The only thing, I suppose could work is set MAC, del vif and
add vif. But this does not seems to work either , below is
example from unpached kernel:

[root@dhcp-27-155 ~]# iw dev
phy#1
	Interface wlan1
		ifindex 10
		wdev 0x100000001
		addr 2c:4d:54:cb:d8:04
		type managed
[root@dhcp-27-155 ~]# ip link set addres  b0:6e:bf:a5:31:90  wlan1
[root@dhcp-27-155 ~]# iw dev wlan1 del
[root@dhcp-27-155 ~]# iw phy phy0 interface  add wlan0 type station
command failed: No such file or directory (-2)
[root@dhcp-27-155 ~]# iw phy phy1 interface  add wlan0 type station
[root@dhcp-27-155 ~]# iw dev 
phy#1
	Interface wlan0
		ifindex 11
		wdev 0x100000002
		addr 2c:4d:54:cb:d8:04
		type managed
[root@dhcp-27-155 ~]# ethtool -i wlan0
driver: mt76x2u
version: 4.20.0-rc1+
firmware-version: 0.0.00-b1
bus-info: 1-1.2:1.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no

Anyway I think, to support MAC address change, we should not filter
based on MAC address, but maybe only on BSSID ? 

Thanks
Stanislaw
