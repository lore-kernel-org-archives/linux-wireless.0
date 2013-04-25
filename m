Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:58196 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab3DYUJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Apr 2013 16:09:41 -0400
Date: Thu, 25 Apr 2013 16:09:37 -0400 (EDT)
Message-Id: <20130425.160937.1062961248509351598.davem@davemloft.net> (sfid-20130425_220945_394295_61EE3CF2)
To: linux-nfc@vger.kernel.org
CC: linux-wireless@vger.kernel.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, sameo@linux.intel.com
Subject: NFC cleanup request
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Please do not have object targets in a directory other than the one
the Makefile is in, that is what net/nfc/Makefile is doing with the
stuff under llcp/

It means that you can't do:

	make net/nfc/llcp/sock.o

which I use on pretty much every patch I apply as a quick sanity
check before I fire off a full allmodconfig build.
