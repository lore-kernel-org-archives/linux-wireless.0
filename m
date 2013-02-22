Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55715 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757453Ab3BVQNt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 11:13:49 -0500
Message-ID: <51279938.6030807@openwrt.org> (sfid-20130222_171352_852435_5858A353)
Date: Fri, 22 Feb 2013 17:13:44 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] carl9170: fix frame drop and WARN due to minstrel_ht
 change
References: <201302220130.45434.chunkeey@googlemail.com>
In-Reply-To: <201302220130.45434.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-22 1:30 AM, Christian Lamparter wrote:
> With "mac80211/minstrel_ht: add support for using CCK rates"
> minstrel_ht selects legacy CCK rates as viable rates for
> outgoing frames which might be sent as part of an A-MPDU
> [IEEE80211_TX_CTL_AMPDU is set].
> 
> This behavior triggered the following WARN_ON in the driver:
>> WARNING: at carl9170/tx.c:995 carl9170_op_tx+0x1dd/0x6fd
> The driver assumed that the rate control algorithm made a
> mistake and dropped the frame.
> 
> This patch removes the noisy warning altogether and allows
> said A-MPDU frames with CCK sample and/or fallback rates to
> be transmitted seamlessly.
Shouldn't it prevent aggregation of frames with CCK in the fallback rate
chain? I don't think transmitting an A-MPDU with a CCK rate works.

- Felix
