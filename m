Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37659 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab2J3Mni (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 08:43:38 -0400
Message-ID: <508FCB77.9000303@openwrt.org> (sfid-20121030_134342_384636_690E5192)
Date: Tue, 30 Oct 2012 13:43:35 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	sven@narfation.org, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] ath9k: apply coverage class on slottime too
References: <1351598855-21427-1-git-send-email-siwu@hrz.tu-chemnitz.de>
In-Reply-To: <1351598855-21427-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-30 1:07 PM, Simon Wunderlich wrote:
> From: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
> 
> According to 802.11-2007 17.3.8.6 (slot time), the slot time should
> be increased by 3 us * coverage class. The code only increased the
> ack timeout, which is fixed by this patch.
> 
> We have noticed in our long shot scenario that we see less collisions
> with this patch.
At some point I had the slot time increase in the driver, but noticed a
massive throughput degradation on 10-20 km links. Leaving the slot time
alone and changing only the ACK timeout fixed this. What distances did
you test?

- Felix

