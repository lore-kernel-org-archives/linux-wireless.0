Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44534 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759331AbcCDQH7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 11:07:59 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Matti Gottlieb <matti.gottlieb@intel.com>
Subject: Re: [PATCH 2/2] iwlwifi: mvm: Fix paging memory leak
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA41983@hasmsx107.ger.corp.intel.com>
	<1456433829-20285-2-git-send-email-emmanuel.grumbach@intel.com>
Date: Fri, 04 Mar 2016 18:07:51 +0200
In-Reply-To: <1456433829-20285-2-git-send-email-emmanuel.grumbach@intel.com>
	(Emmanuel Grumbach's message of "Thu, 25 Feb 2016 22:57:09 +0200")
Message-ID: <87povaw7jc.fsf@kamboji.qca.qualcomm.com> (sfid-20160304_170807_491559_11D5E267)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:

> From: Matti Gottlieb <matti.gottlieb@intel.com>
>
> If the opmode is stopped and started again we did not free
> the paging buffers. Fix that.
> In addition when freeing the firmware's paging download
> buffer, set the pointer to NULL.
>
> Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Nitpicking while writing the pull request for Dave:

What does "opmode is stopped" mean? Important bug fixes should have a
clear bug description from user's point of view. Using driver internal
jargon is gibberish to most people.

I investigated this myself and apparently "opmode" is stopped when the
module is unloaded or the PCI device is removed. So just say that in the
commit log and everyone understand much better.

(No actions needed, just for future reference.)

-- 
Kalle Valo
