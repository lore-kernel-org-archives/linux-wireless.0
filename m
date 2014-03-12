Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42643 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbaCLJvs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2014 05:51:48 -0400
Message-ID: <53202E16.9060601@openwrt.org> (sfid-20140312_105151_491981_0F36D028)
Date: Wed, 12 Mar 2014 10:51:18 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com
Subject: Re: [PATCH] ath9k: Fix sequence number assignment for non-data frames
References: <1394617075-24664-1-git-send-email-helmut.schaa@googlemail.com>
In-Reply-To: <1394617075-24664-1-git-send-email-helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-03-12 10:37, Helmut Schaa wrote:
> Since commit 558ff225de80ac95b132d3a115ddadcd64498b4f (ath9k: fix
> ps-poll responses under a-mpdu sessions) non-data frames would have
> gotten a sequence number from a TIDs sequence counter instead of
> using the global sequence counter.
> 
> This can lead to instable connections.
> 
> To fix this only select the correct TID if we are processing a
> data frame. Furthermore, prevent non-data frames to get a sequence
> number from a TID sequence counter by adding a check to
> ath_tx_setup_buffer.
> 
> Cc: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Felix Fietkau <nbd@openwrt.org>
