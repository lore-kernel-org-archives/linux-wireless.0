Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:37928 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155AbaCTTs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2014 15:48:26 -0400
Message-ID: <532B4606.3030303@lwfinger.net> (sfid-20140320_204850_487088_556BE92D)
Date: Thu, 20 Mar 2014 14:48:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Peter Wu <peter@lekensteyn.nl>,
	John W Linville <linville@tuxdriver.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Chaoming_Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	lekensteyn@gmail.com
Subject: Re: [PATCH 0/3] rtlwifi (and staging rtl8821ae) cleanups
References: <1395341544-21464-1-git-send-email-peter@lekensteyn.nl>
In-Reply-To: <1395341544-21464-1-git-send-email-peter@lekensteyn.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/2014 01:52 PM, Peter Wu wrote:
> Hi,
>
> The first patch of these series was NAKed some weeks ago because it would
> conflict with the new rtl8723be driver. Since those changes are in wireless-next
> now, I have adjusted that patch to take care of rtl8723be.
>
> The other two patches to the staging driver is similar to the rtlwifi changes.
> I am not sure who to send these two patches to. Greg is the staging maintainer,
> but John takes wireless patches, so I have included both of you.
>
> All patches are compile-tested on top of v3.14-rc2-938-g67b3bd4.
>
> I also found the following (unrelated to my patches) warning while compiling the
> staging driver, perhaps it needs a closer look?

Peter,

Your Patch 1/3 applies cleanly and I think it is OK, but if you are going to do 
cleanups on the wireless tree, you should be working from the latest version of 
wireless-testing git repo. We are on 3.14-rc7 and there are several recent 
commits that might have conflicted.

As for the changes to staging/rtl8821ae (No. 2 & 3), once Linus starts the merge 
that will precede the release of 3.15-rc2, the entire code for rtl8821ae will be 
replaced. A cleaned-up version was nearly ready for the regular wireless tree in 
time to make 3.15, but it did not get enough testing. As a result, that driver 
will be in testing for one more cycle. By 3.16, it should reside in the regular 
tree and be out of staging.

Pushing patches that affect both the regular tree and staging is complicated and 
should be avoided whenever possible.

Larry



