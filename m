Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41085 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab1CIUew (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 15:34:52 -0500
Received: by qwd7 with SMTP id 7so706338qwd.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2011 12:34:52 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1299687684-19638-3-git-send-email-linville@tuxdriver.com>
References: <1299687684-19638-1-git-send-email-linville@tuxdriver.com>
	<1299687684-19638-3-git-send-email-linville@tuxdriver.com>
Date: Wed, 9 Mar 2011 21:34:51 +0100
Message-ID: <AANLkTi=3x1thf4O6Gv=W3AvVMzCy0Xs-xCBCS3XWENCM@mail.gmail.com>
Subject: Re: [PATCH 3/3] ath5k: implement ieee80211_ops->{get,set}_ringparam
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bloat-devel@lists.bufferbloat.net,
	me@bobcopeland.com, mickflemm@gmail.com,
	=?UTF-8?Q?Dave_T=C3=A4ht?= <d@taht.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 9, 2011 at 5:21 PM, John W. Linville <linville@tuxdriver.com> wrote:
> set_ringparam only allows changes to tx ring at this time.
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---

Yay, a step forward what concerns ath5k and debloat-testing!

Tested against linux-next (next-20110309) with [1] and [2,3,4].

- Sedat -

[1] https://patchwork.kernel.org/patch/619631/
[2] https://patchwork.kernel.org/patch/621791/
[3] https://patchwork.kernel.org/patch/621771/
[4] https://patchwork.kernel.org/patch/621781/

P.S.: My investigations...

# lspci -nnvv | grep -i ath
02:02.0 Ethernet controller [0200]: Atheros Communications Inc. AR5212
802.11abg NIC [168c:1014] (rev 01)
        Kernel driver in use: ath5k

# ethtool -G wlan0 tx 1

# ethtool -g wlan0
Ring parameters for wlan0:
Pre-set maximums:
RX:             40
RX Mini:        0
RX Jumbo:       0
TX:             50
Current hardware settings:
RX:             40
RX Mini:        0
RX Jumbo:       0
TX:             1
- EOT -
