Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56347 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761277Ab2DLH3O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 03:29:14 -0400
Message-ID: <4F868445.1030209@qca.qualcomm.com> (sfid-20120412_092918_215296_033E31CA)
Date: Thu, 12 Apr 2012 10:29:09 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Checkpatch warnings with pr_fmt()
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

due to checkpatch warnings in ath6kl, from a recent pr_fmt() addition, I
had to update checkpatch and now I get lots of useless warnings like this:

drivers/net/wireless/ath/ath6kl/common.h:28: CHECK: Don't begin block
comments with only a /* line, use /* comment...
drivers/net/wireless/ath/ath6kl/bmi.h:233: CHECK: No space is necessary
after a cast

IMHO they are wrong, at least the style I have tried to enforce in
ath6kl is totally opposite (I have "/*\n" on multiline comments and a
space after a cast). And at least CodingStyle seems to recommend my
style for the multiline comments.

Would you consider removing these two warnings? Or maybe add a new check
level so that I can easily disable them?

As I get a lot of patches from people not familiar with the Linux coding
style checkpatch is a valuable tool for me, I cannot spot all the style
issues by just reviewing the patches. But now checkpatch is useless for
me as the real warnings get buried within the noise.

Kalle
