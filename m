Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:51090 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaKTOuA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 09:50:00 -0500
Message-ID: <546DFF95.6030804@openwrt.org> (sfid-20141120_155005_406493_E2DD0D1D)
Date: Thu, 20 Nov 2014 15:49:57 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless@vger.kernel.org
CC: thomas@net.t-labs.tu-berlin.de, adrian@freebsd.org
Subject: Re: [RFC 2/3] ath9k: add TX power per-rate per-chain tables
References: <1416490300-6451-1-git-send-email-lorenzo.bianconi83@gmail.com> <1416490300-6451-3-git-send-email-lorenzo.bianconi83@gmail.com>
In-Reply-To: <1416490300-6451-3-git-send-email-lorenzo.bianconi83@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-11-20 14:31, Lorenzo Bianconi wrote:
> Add TX power per-rate per-chain tables for different MIMO modes (e.g STBC) in
> order to cap the maximum TX power value per-rate in the TX descriptor path.
> Cap TX power for self generated frames (ACK, RTS/CTS).
> Currently TPC is supported just by AR9003 based chips
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
I think you should make the ah->txpower array one-dimensional and store
it for the current chainmask only - this will simplify the code.
The chainmask cannot be changed while the interface is up, so there's no
need to make this dynamically switchable.

- Felix
