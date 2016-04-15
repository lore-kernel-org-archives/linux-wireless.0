Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55370 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbcDOOlW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 10:41:22 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>,
	David Miller <davem@davemloft.net>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2016-04-12
References: <1460448889.2630.12.camel@intel.com>
Date: Fri, 15 Apr 2016 17:41:16 +0300
In-Reply-To: <1460448889.2630.12.camel@intel.com> (Emmanuel Grumbach's message
	of "Tue, 12 Apr 2016 08:14:48 +0000")
Message-ID: <87oa9borxv.fsf@kamboji.qca.qualcomm.com> (sfid-20160415_164126_206647_707FC0DB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> I have here a pull request for 4.6. There is patch in this pull request
> that has been sent to -next already but should really have been
> included in the current cycle. Sorry for the mess.
>
> The commit appears in -next as:
>
> commit a0b09f13036cedfd67c9cb4b9d05138e7022723d
> Author: Ayala Beker <ayala.beker@intel.com>
> Date:   Wed Feb 3 15:36:52 2016 +0200
>
>     iwlwifi: mvm: update GSCAN capabilities
>     
>     Gscan capabilities were updated with new capabilities supported
>     by the device. Update GSCAN capabilities TLV.
>
> I modified the commit message to better emphasis the need to have it in
> the current release. You'll see it in this pull request as:
>
> commit cd49727e1a2bccc4ff008dde24c2f8430dd9e368
> Author: Ayala Beker <ayala.beker@intel.com>
> Date:   Wed Feb 3 15:36:52 2016 +0200
>
>     iwlwifi: mvm: avoid to WARN about gscan capabilities
>     
>     Gscan capabilities were updated with new capabilities supported
>     by the device. Update GSCAN capabilities TLV and avoid to WARN
>     if the firmware does not have the new capabilities.

I feel uneasy having the same commit on both trees, but that might just
me. Dave, how do you suggest to handle cases like this when we want to
get a fix from -next to the current release -rc release?

This is the version I have in wireless-drivers-next:

https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=a0b09f13036cedfd67c9cb4b9d05138e7022723d

And this is what Emmanuel wants to have in 4.6:

https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/iwlwifi-fixes.git/commit/?id=cd49727e1a2bccc4ff008dde24c2f8430dd9e368

Luckily the patch is simple but still I would like hear Dave's opinion
about this. And at least the commit log in iwlwifi-fixes should mention
that it's cherry picked from iwlwifi-next.

-- 
Kalle Valo
