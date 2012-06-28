Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28433 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab2F1BKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 21:10:50 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20459.44752.250946.856086@gargle.gargle.HOWL> (sfid-20120628_031053_697129_3F249B33)
Date: Thu, 28 Jun 2012 06:39:36 +0530
To: <linville@tuxdriver.com>
CC: Tom Hughes <tom@compton.nu>, <linux-wireless@vger.kernel.org>,
	<ath9k-devel@lists.ath9k.org>, <rodrigue@qca.qualcomm.com>,
	<jouni@qca.qualcomm.com>, <vthiagar@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>
Subject: [PATCH] ath9k: fix panic caused by returning a descriptor we have queued for reuse
In-Reply-To: <1340817675-26911-1-git-send-email-tom@compton.nu>
References: <1340817675-26911-1-git-send-email-tom@compton.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tom Hughes wrote:
> Commit 3a2923e83c introduced a bug when a corrupt descriptor
> is encountered - although the following descriptor is discarded
> and returned to the queue for reuse the associated frame is
> also returned for processing. This leads to a panic:
> 
> BUG: unable to handle kernel NULL pointer dereference at 000000000000003a

John, can you queue this regression fix for 3.5 ? And the patch that fixes a
WEP regression is required too (bed3d9c0b71f9afbfec905cb6db3b9f16be29d4d).

thanks,
Sujith
