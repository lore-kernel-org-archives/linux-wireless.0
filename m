Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42058 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1FUIzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 04:55:38 -0400
MIME-Version: 1.0
In-Reply-To: <BLU158-w185CA0272A5A3CC187AF1E876E0@phx.gbl>
References: <BLU158-w185CA0272A5A3CC187AF1E876E0@phx.gbl>
Date: Tue, 21 Jun 2011 14:25:36 +0530
Message-ID: <BANLkTi=B3uZ1qmL6oPyXXQ1n-BCAftND-A@mail.gmail.com> (sfid-20110621_105545_351112_FE8BB652)
Subject: Re: [ath9k-devel] Disabling the third antenna for AR9380 in ath9k
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Fred Matthews <fredmm@hotmail.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net, ath9k-devel@lists.ath9k.org,
	susinder@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 21, 2011 at 2:07 AM, Fred Matthews <fredmm@hotmail.co.uk> wrote:
> Hi all,
> I am installing the AR9380 NIC on laptops, but some only have two UFL
> connectors, and thus I was wondering if using only two of the UFL antenna
> ports will have any negative effect or difference than installing a 2x2 NIC
> (AR9280 for example which has only 2 ports anyway). Please kindly explain
> with references if possible.
> Also for example is there anyway to disable transmission on the third UFL
> port (antenna) from ath9k or otherwise.
> Thank you all very much

you can change the tx/rx chainmask for 3x3 AR9380 to disable
transmission on the third antenna
cd /sys/kernel/debug/ieee80211/phy0/ath9k# echo 0x3 > tx_chainmask
cd /sys/kernel/debug/ieee80211/phy0/ath9k# echo 0x3 > rx_chainmask

after this, ideally it should operate as 2x2 device as per Susinders
comments. but if you got AR9280 please try to use that if 2 antenna is
the constraint.


> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>
>



-- 
shafi
