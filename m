Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:45651 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab0F3WCf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 18:02:35 -0400
Subject: Re: [PATCH] ath9k: fix TSF after reset on AR913x
From: Pavel Roskin <proski@gnu.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	=?ISO-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>
In-Reply-To: <4C2A8AD4.8070504@openwrt.org>
References: <4C2A8AD4.8070504@openwrt.org>
Content-Type: text/plain
Date: Wed, 30 Jun 2010 18:02:31 -0400
Message-Id: <1277935351.17170.1.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-30 at 02:07 +0200, Felix Fietkau wrote:
> +	if (AR_SREV_9100(ah) && (ath9k_hw_gettsf64(ah) < tsf)) {
> +		tsf += 1500;

Why 1500?  Is it a magic number?  It is a result of some measurement?
Can we have a define for it, please?

-- 
Regards,
Pavel Roskin
