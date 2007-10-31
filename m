Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:62080 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbXJaSAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2007 14:00:53 -0400
Received: by py-out-1112.google.com with SMTP id u77so436472pyb
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2007 11:00:52 -0700 (PDT)
Message-ID: <43e72e890710311100t3bd45eecn5814e3c40a0ad65f@mail.gmail.com> (sfid-20071031_180057_078984_CAFE9C99)
Date: Wed, 31 Oct 2007 14:00:52 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: Re: [PATCH 1/7] ath5k: Maintain coding style
In-Reply-To: <43e72e890710311053x2ab9e8a0m492901b91f064c51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071027230425.GA5973@localhost.domain.invalid>
	 <43e72e890710311053x2ab9e8a0m492901b91f064c51@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/07, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On 10/27/07, Nick Kossifidis <mick@madwifi.org> wrote:
>
> > Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> This if for your patches 1-7 and the new descriptor rework. I've
> tested this on x86 and big-endian. Big-endian works well except if you
> use dhclient you won't get an IP address, please use dhcpcd-bin. I
> don't have time to debug dhclient but I'll explain the problem. When
> you run dhclient on your wlan%d you will get in your kernel ring
> buffer:
>
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
>
> This is printed by net/ipv6/addrconf.c when there's the event is a
> NETDEV_CHANGE and dev->qdisc == &noop_qdisc.
>
> Using dhcpcd-bin wlan0, however works well.
>
> Then, we have a problem with ath5k on big endian. Any packet > 1470
> bytes will not be passed through the upper layers on the receiving big
> endian box with ath5k. These new patches are not the culprit though,
> I've tested this before this patch series. We'll have to figure that
> out.

I forgot to mention this problem is on big-endian on this card:

ath5k_pci 0001:11:02.0: Atheros AR5213 chip found: MAC 0x56, PHY: 0x41
ath5k_pci 0001:11:02.0: RF5111 5GHz radio found (0x17)
ath5k_pci 0001:11:02.0: RF2111 2GHz radio found (0x23)

  Luis
