Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36082 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab3AZXsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 18:48:00 -0500
Message-ID: <1359244101.9086.8.camel@jlt4.sipsolutions.net> (sfid-20130127_004811_031456_5F556B2B)
Subject: Re: [PATCH v2] mac80211: dynamic short slot time for MBSSs
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Sun, 27 Jan 2013 00:48:21 +0100
In-Reply-To: <CAG6hwVNFbuQLGhLECpjoFVevf+SunUY62RNAxmJSum34XGH+gw@mail.gmail.com> (sfid-20130127_003645_161477_2208DDCC)
References: <1359232645-10563-1-git-send-email-thomas@cozybit.com>
	 <1359241463.9086.4.camel@jlt4.sipsolutions.net>
	 <CAG6hwVNFbuQLGhLECpjoFVevf+SunUY62RNAxmJSum34XGH+gw@mail.gmail.com>
	 (sfid-20130127_003645_161477_2208DDCC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-01-26 at 15:36 -0800, Thomas Pedersen wrote:

> Huh, that's actually pretty nice. 

:)

> I don't really get why the
> for_each_set_bit() is broken on big endian 64-bit systems, but hey
> this approach takes care of that concern :)

Because then you're taking the address of a 32-bit variable, and
treating it as an unsigned long (64 bits), so if you iterate its 64 bits
then you'll get some random other stuff from the stack (on both big and
little endian actually, I thought you were limiting it to n_bitrates
then it would work on little endian)

johannes

