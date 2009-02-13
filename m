Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:31798 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbZBMIPz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 03:15:55 -0500
Received: by qw-out-2122.google.com with SMTP id 5so589699qwi.37
        for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 00:15:54 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 13 Feb 2009 11:15:54 +0300
Message-ID: <1925ef8a0902130015o6df0c962n3fe05ec420d0aef@mail.gmail.com> (sfid-20090213_091559_529558_FEC9F291)
Subject: compat-wireless with CONFIG_MAC80211disabled
From: Vitja Makarov <vitja.makarov@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I was trying to build compat wireless for my arm board.
First of all I disabled CONFIG_MAC80211 in my kernel, and successfully
built compat-wireless.

Then at runtime I get kernel panic.
Then I found that sk_buff in 2.6.28 depends on CONFIG_MAC80211, so
enabling it solves my problem.

Shouldn't compat-wireless Makefile check kernel dot config for this
option as well as for wireless extension?

Thanks,
vitja.
