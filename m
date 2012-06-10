Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60534 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab2FJQxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2012 12:53:11 -0400
Received: by wibhm6 with SMTP id hm6so2675266wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jun 2012 09:53:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338933307-13446-8-git-send-email-hauke@hauke-m.de>
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
	<1338933307-13446-8-git-send-email-hauke@hauke-m.de>
Date: Sun, 10 Jun 2012 18:53:10 +0200
Message-ID: <CACna6rwbS9YTM7gqX14T71Lart2HbUsFo4su8h6HEhv91C_9XA@mail.gmail.com> (sfid-20120610_185337_631921_E1EAC165)
Subject: Re: [PATCH 7/8] bcma: add bcma_pmu_spuravoid_pllupdate()
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, b43-dev@lists.infradead.org,
	arend@broadcom.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/6/5 Hauke Mehrtens <hauke@hauke-m.de>:
> This function is needed by brcmsmac. This code is based on code from
> the Broadcom SDK.

This is already implemented in b43/phy_n.c:

/* http://bcm-v4.sipsolutions.net/802.11/PmuSpurAvoid */
static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)

I guess we should replace b43 code with a call to introduced function.

-- 
Rafał
