Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:32835 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab0LULek (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 06:34:40 -0500
Subject: Re: [PATCH 2/4] b43: N-PHY: implement radio 2056 init steps
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
In-Reply-To: <1292928622-27651-2-git-send-email-zajec5@gmail.com> (sfid-20101221_115045_163491_FFFFFFFFB31FEB6B)
References: <1292928622-27651-1-git-send-email-zajec5@gmail.com>
	 <1292928622-27651-2-git-send-email-zajec5@gmail.com>
	 (sfid-20101221_115045_163491_FFFFFFFFB31FEB6B)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 12:34:33 +0100
Message-ID: <1292931273.13493.2.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-21 at 11:50 +0100, Rafał Miłecki wrote: 
> +static void b43_radio_init2056_post(struct b43_wldev *dev)
> +{
> +	b43_radio_set(dev, B2056_SYN_COM_CTRL, 0xB);
> +	b43_radio_set(dev, B2056_SYN_COM_PU, 0x2);
> +	b43_radio_set(dev, B2056_SYN_COM_RESET, 0x2);
> +	mdelay(1);

Please don't use mdelay() ever. The driver is fully preemptible.
Use msleep() instead.

-- 
Greetings Michael.

