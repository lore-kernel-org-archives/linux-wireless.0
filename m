Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43860 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945AbbEVIAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 04:00:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2015-05-21
References: <1432237819.26813.4.camel@intel.com>
Date: Fri, 22 May 2015 11:00:25 +0300
In-Reply-To: <1432237819.26813.4.camel@intel.com> (Emmanuel Grumbach's message
	of "Thu, 21 May 2015 19:50:19 +0000")
Message-ID: <87y4kh59eu.fsf@kamboji.qca.qualcomm.com> (sfid-20150522_100041_575748_FA9E947D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> I am aware that this pull request is quite large for 4.1, but I really
> think that all these patches are really justified. A few of them fix
> 3165 and 8260 which will be supported starting from 4.1. Other patches
> fix random bugs that were discovered just now.

There are few problematic ones which I want to comment just for the
future:

iwlwifi: nvm: force mac from otp in case nvm mac is reserved
iwlwifi: mvm: BT Coex - duplicate the command if sent ASYNC

The commit log for these two above don't really describe the bug they
are fixing and leave me guessing. I would feel much safer to pull if
there's a clear description of the user visible bug.

iwlwifi: pcie: don't disable the busmaster DMA clock for family 8000

I feel that this is a bit borderline at this stage (we are in practise
rc5/rc6 phase which is very late), it's not really fixing any crashers
or other major functionality problems. But as it's a small patch I guess
it's ok.

> Note that my availability is limited in the next week, but I'll try to
> handle any issues you may have ASAP.
>
> The following changes since commit e7afe89fd67d40a7f5fff8130c5f925d99a94b1f:
>
>   iwlwifi: mvm: force quota update update after FW restart (2015-04-28 15:02:25 +0300)
>
> are available in the git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2015-05-21

Thanks, pulled.

-- 
Kalle Valo
