Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48661 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab0LMQEh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 11:04:37 -0500
Received: by ywl5 with SMTP id 5so3336913ywl.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 08:04:36 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19718.17367.708420.358035@gargle.gargle.HOWL>
Date: Mon, 13 Dec 2010 21:33:35 +0530
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: Felix Fietkau <nbd@nbd.name>, Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Sujith.Manoharan@atheros.com
Subject: Re: [PATCH v3 1/8] ath9k_hw: only use the PCIe disable register write sequence for AR5416
In-Reply-To: <20101213134638.GA4622@vmraj-lnx.users.atheros.com>
References: <1292111474-70939-1-git-send-email-nbd@openwrt.org>
	<20101213111207.GA3121@vmraj-lnx.users.atheros.com>
	<31A8EB58-AACD-4660-9C7D-6A077152E7C7@nbd.name>
	<20101213134638.GA4622@vmraj-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> > Because it is only relevant for USB based devices.
> >
> True. This part is also applicable for HTC device like UB91.

Not really, this is not required for USB devices.

ath9k_hw_disablepcie() should probably not be called for USB devices.
We should also remove the useless calls to ath9k_hw_configpcipowersave()
in htc_start() and htc_stop().

Sujith
