Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:55114 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbXJaRx2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2007 13:53:28 -0400
Received: by py-out-1112.google.com with SMTP id u77so432262pyb
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2007 10:53:25 -0700 (PDT)
Message-ID: <43e72e890710311053x2ab9e8a0m492901b91f064c51@mail.gmail.com> (sfid-20071031_175405_155359_7C0665AE)
Date: Wed, 31 Oct 2007 13:53:25 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: Re: [PATCH 1/7] ath5k: Maintain coding style
In-Reply-To: <20071027230425.GA5973@localhost.domain.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071027230425.GA5973@localhost.domain.invalid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/27/07, Nick Kossifidis <mick@madwifi.org> wrote:

> Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

This if for your patches 1-7 and the new descriptor rework. I've
tested this on x86 and big-endian. Big-endian works well except if you
use dhclient you won't get an IP address, please use dhcpcd-bin. I
don't have time to debug dhclient but I'll explain the problem. When
you run dhclient on your wlan%d you will get in your kernel ring
buffer:

ADDRCONF(NETDEV_UP): wlan0: link is not ready

This is printed by net/ipv6/addrconf.c when there's the event is a
NETDEV_CHANGE and dev->qdisc == &noop_qdisc.

Using dhcpcd-bin wlan0, however works well.

Then, we have a problem with ath5k on big endian. Any packet > 1470
bytes will not be passed through the upper layers on the receiving big
endian box with ath5k. These new patches are not the culprit though,
I've tested this before this patch series. We'll have to figure that
out.

So, for patches 1-7 and

[PATCH] ath5k: Remove fill_tx_desc
[PATCH] ath5k: 4word tx descriptor setup doesn't set BUF_LEN

The last one by Ulrich Meis.

Acked-by: Luis R. Rodriguez <mcgrof@gmail.com>

  Luis
