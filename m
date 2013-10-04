Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:35811 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab3JDOS3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 10:18:29 -0400
Date: Fri, 4 Oct 2013 16:19:51 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	stable@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH v2 1/4] rt2x00: rt2800lib: fix VGC
 adjustment for RT5592
Message-ID: <20131004141951.GA7842@localhost.localdomain> (sfid-20131004_161833_401576_520C4B58)
References: <1380823243-11149-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380823243-11149-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 03, 2013 at 08:00:40PM +0200, Gabor Juhos wrote:
> In commit 3d81535ea5940446510a8a5cee1c6ad23c90c753
> (rt2800: 5592: add chip specific vgc calculations)
> the rt2800_link_tuner function has been modified to
> adjust VGC level for the RT5592 chipset.
> 
> On the RT5592 chipset, the VGC level must be adjusted
> only if rssi is greater than -65. However the current
> code adjusts the VGC value by 0x10 regardless of the
> actual chipset if the rssi value is between -80 and
> -65.
> 
> Fix the broken behaviour by reordering the if-else
> statements.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
