Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47717 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab1ICTkg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Sep 2011 15:40:36 -0400
Received: by pzk37 with SMTP id 37so6318014pzk.1
        for <linux-wireless@vger.kernel.org>; Sat, 03 Sep 2011 12:40:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1315076463-11222-4-git-send-email-zajec5@gmail.com>
References: <1315076463-11222-1-git-send-email-zajec5@gmail.com>
	<1315076463-11222-4-git-send-email-zajec5@gmail.com>
Date: Sat, 3 Sep 2011 21:40:36 +0200
Message-ID: <CACna6rzVXL4DWY_O+28iGz1OHGisSSnJwahiivNZS6REh6Ukdw@mail.gmail.com> (sfid-20110903_214039_030869_BCB0C97A)
Subject: Re: [PATCH 3/3] b43: LCN-PHY: load TX gain table on init
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 3 września 2011 21:01 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> Values and ops were taken from MMIO dump of wl. struct was copied from
> brcmsmac.

To get table I've simply used vim and RegExp plus find&replace:

:%s/phy_write(0x0455) <- 0x....\n phy_read(0x0456) -> 0x....\n
phy_read(0x0457) -> 0x....\n\(.*\n.*\n.*\n\)/\1\r/
:%s/phy_write(0x0455) <- 0x....\nphy_write(0x0457) <-
0x\(....\)\nphy_write(0x0456) <- 0x\(....\)/0x\1\2/
:%s/0x\(..\)\(..\)\(..\)\(..\)\n0x\(.\)\(..\).....\n/\t{ 0x\4, 0x\3,
0x\2, 0x\5, 0x\6 },/

-- 
Rafał
