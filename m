Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757279Ab1JDOAV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 10:00:21 -0400
Date: Tue, 4 Oct 2011 15:57:59 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Stefan Zwanenburg <stefanhetzwaantje@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: Re: RTL8192SE blank EFUSE readout after suspend resume cycle
Message-ID: <20111004135757.GA6207@redhat.com> (sfid-20111004_160025_980879_553E8146)
References: <4E8AFBCB.8070100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E8AFBCB.8070100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 04, 2011 at 02:27:55PM +0200, Stefan Zwanenburg wrote:
> I recently discussed this with Larry Finger and Chaomin Li, but every
> once in a while, after having resumed from suspending to RAM, my NIC
> (10ec:8172) doesn't work anymore, even after reloading the module. Even
> worse, after reloading the module, my NIC's name gets changed (because
> of udev rules) as a result of the MAC address changing, which means I
> have to temporarily reconfigure whatever I'm using to make a connection
> (wicd in my case).

You might try configure pm-utils to unload module before suspend, by
something like this:

echo 'SUSPEND_MODULES="rtl8192se rtlwifi"' >> /etc/pm/config.d/modules.conf 

Other than that, would be good to try if converting to new PM framework
helps. It can be done quite simply, similar way like in this ath9k commit:

commit f0e94b479c987abef17eb18e5c8e0ed178d00cd4
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Oct 16 00:36:17 2010 +0200

    ath9k: Convert to new PCI PM framework

Stanislaw 
