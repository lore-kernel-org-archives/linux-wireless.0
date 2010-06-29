Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35426 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab0F2VkQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 17:40:16 -0400
Received: by iwn7 with SMTP id 7so103358iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 14:40:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikw3l6FIxLtIwxofGaqGQD_b7LO25uu-JV45UL6@mail.gmail.com>
References: <AANLkTilG4qxjX0e5u_BGp0YcPoVBbsqd6Hlb8E0j_S8S@mail.gmail.com>
	<4C29284C.5050707@openwrt.org>
	<AANLkTint2L1xSMughBA5aHCFMRB5KMC8EfwcxJJU5XYW@mail.gmail.com>
	<4C2A1776.2080508@openwrt.org>
	<AANLkTik_d6tIKj3otsgaojVBPfvW1lz9OBRujeZLyv1U@mail.gmail.com>
	<4C2A24D2.4070007@openwrt.org>
	<AANLkTikw3l6FIxLtIwxofGaqGQD_b7LO25uu-JV45UL6@mail.gmail.com>
Date: Tue, 29 Jun 2010 23:40:16 +0200
Message-ID: <AANLkTikQz34vgfweDrzH_9_a-BU4dPXbX2UGR61jtJ9n@mail.gmail.com>
Subject: Re: ath9k: ap tsf seems random and only uses lower 24 bits or so
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/6/29 Björn Smedman <bjorn.smedman@venatech.se>:
> Yes, hw reset is due to reg = 0x01702400 every 4 - 40 seconds or so:
> ...

When the chip is really stuck, does 'reg' (at 'return false') change
over time? If I add a second requirement that ath9k_hw_check_alive()
must fail three times in a row (in different invocations of
ath9k_tasklet()) before we reset the chip the ap seems fine. I
sometimes get several of these reg = 0x01702400 every second but only
one or at the max two in a row.

Under load I sometimes see some reg = 0x00f02400 as well. I also see
an occasional reset now and then (about once a minute) that must be
caused by something else.

Any insight into what these reg values mean? Do you think they can
safely be ignored as per above?

/Björn
