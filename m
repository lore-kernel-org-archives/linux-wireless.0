Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:53258 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759306Ab3FCW4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 18:56:38 -0400
Message-ID: <51AD1F22.2080004@wwwdotorg.org> (sfid-20130604_005657_672536_8350776E)
Date: Mon, 03 Jun 2013 16:56:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Hante Meuleman <meuleman@broadcom.com>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Regression in 9390ace brcmfmac: free net device when registration
 fails
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(John, note that this commit is part of the pull request you sent to
Dave today)

Arend,

Commit 9390ace "brcmfmac: free net device when registration fails"
causes a regression.

I had the BCM4330 firmware present in my root fs, whereas my HW is a
BCM4329. With this patch applied, I get a kernel panic on boot. With it
reverted, I see that no issues of that nature. This is true in
next-20130531 (and also 5/30 and 6/1 but not earlier). A bisect of
Linus's tree followed by a merge of John's wireless pull request from
today pointed at this same commit.

Related: Since the two hardware require different firmware, I wonder why
the driver doesn't use a firmware filename that encodes the HW device ID
instead of using the same name for all HW. This means that when I move
my SD card between development systems, I have to copy different
firmware over the top. That's a little painful...
