Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34918 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab3LOUNj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Dec 2013 15:13:39 -0500
Message-ID: <52AE0D63.9090309@openwrt.org> (sfid-20131215_211358_197209_CB1E0DE8)
Date: Sun, 15 Dec 2013 21:13:23 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Fix interrupt handling for the AR9002 family
References: <1387030293-7928-1-git-send-email-sujith@msujith.org>
In-Reply-To: <1387030293-7928-1-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-12-14 15:11, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> This patch adds a driver workaround for a HW issue.
> 
> A race condition in the HW results in missing interrupts,
> which can be avoided by a read/write with the ISR register.
> All chips in the AR9002 series are affected by this bug - AR9003
> and above do not have this problem.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Please don't apply this patch just yet, it seems to be causing interrupt
storms. I'm currently looking into it.

- Felix
