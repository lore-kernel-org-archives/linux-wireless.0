Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbbCHKk4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2015 06:40:56 -0400
Date: Sun, 8 Mar 2015 11:37:14 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Giedrius =?utf-8?Q?Statkevi=C4=8Dius?=
	<giedrius.statkevicius@gmail.com>
Cc: helmut.schaa@googlemail.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rt2x00: use rt2x00queue_flush_queues() instead of
 implementing the same action
Message-ID: <20150308103713.GA1890@redhat.com> (sfid-20150308_114123_430832_BC703C03)
References: <1425753950-15624-1-git-send-email-giedrius.statkevicius@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1425753950-15624-1-git-send-email-giedrius.statkevicius@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 07, 2015 at 08:45:50PM +02iee80211_ops00, Giedrius Statkevičius wrote:
> Use rt2x00queue_flush_queues() in rt2x00mac_flush() instead of
> reimplementing the same actions the second time. Also, now it flushes
> the rx queue aswell which it didn't before and that makes it completely
> do what it's supposed to do according to struct iee80211_ops: flush()
> must flush all queues.

NACK, RX queue should not be flushed, mac80211 flush is about TX queues
only.

Stanislaw
