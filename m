Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7940 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbXKZJ3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 04:29:13 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH, take 2] libertas: rework event subscription
Date: Mon, 26 Nov 2007 10:29:56 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <200711261007.14828.hs4233@mail.mn-solutions.de>
In-Reply-To: <200711261007.14828.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711261029.56616.hs4233@mail.mn-solutions.de> (sfid-20071126_092920_874113_2D0CC4EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> * fix a bug where it was not possible to disable an event

> The old code also contained this bug:
>
> $ cd /sys/kernel/debug/lbs_wireless/eth1
> $ cat failure_count
> 0 0 0
> $ echo 60 1 1 >failure_count
> $ cat failure_count
> 60 1 1
> $ echo 0 0 0 >failure_count
> $ cat failure_count
> 0 0 1
>
> The new code turns off the proper event bitmask as well, so
> the last "cat" returns "0 0 0".

With "old code" I didn't mean my take 1, I mean the code that is 
right now in drivers/net/wireless/libertas/debugfs.c
