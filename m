Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48490 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYJHSmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 14:42:45 -0400
Received: from sapphire.tuxdriver.com ([70.61.120.61] helo=localhost)
	by smtp.tuxdriver.com with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1Kndzg-0005kq-CE
	for linux-wireless@vger.kernel.org; Wed, 08 Oct 2008 14:42:44 -0400
Date: Wed, 8 Oct 2008 14:42:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] rtl8187: do not report ACKs if USB Tx status is
	non-zero
Message-ID: <20081008184205.GB32472@tuxdriver.com> (sfid-20081008_204248_923727_D1D1261F)
References: <1223407098-23060-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223407098-23060-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 07, 2008 at 03:18:18PM -0400, John W. Linville wrote:
> The vendor-supplied driver treats a USB Tx failure as an un-ACKed frame.
> I don't see why we shouldn't do the same thing -- hopefully this makes
> rate-scaling algorithms behave sanely with the rtl8187 driver.
> 
> Thanks to Felix Fietkau <nbd@openwrt.org> for suggesting this as an
> option.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> This is currently untested -- anyone with rtl8187 bored enough to try
> it? :-)
 
AFAICT, this doesn't actually trigger -- at least, the device can
go into its typical failure mode (no frames ACKed until you force a
lower rate) without ever hitting the "assume ACK not received" clause.

I'll keep looking at it -- there are a couple of 'secrets' still
buried in the vendor driver (if I can stomach to keep looking at it)...

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
