Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45282 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1GSFqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 01:46:25 -0400
Received: by wyg8 with SMTP id 8so2534098wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jul 2011 22:46:24 -0700 (PDT)
Date: Tue, 19 Jul 2011 08:44:30 +0300
From: Dan Carpenter <error27@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Franky Lin <frankyl@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 12/19] staging: brcm80211: remove code for unsupported
 chip
Message-ID: <20110719054430.GE4010@shale.localdomain> (sfid-20110719_074629_213283_9D584498)
References: <1310999405-10062-1-git-send-email-arend@broadcom.com>
 <1310999405-10062-13-git-send-email-arend@broadcom.com>
 <20110718194215.GD4010@shale.localdomain>
 <4E24A313.3080800@broadcom.com>
 <4E24A6E3.8070700@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E24A6E3.8070700@gnu.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 18, 2011 at 05:34:27PM -0400, Pavel Roskin wrote:
> On 07/18/2011 05:18 PM, Franky Lin wrote:
> 
> >No, i didn't. Thank you for pointing out this. I missed it when I
> >rebased my local branch. It didn't break any thing because
> >brcmf_mmc_suspend is a global variable. Is it ok to keep the patch like
> >this? I will prepare another patch to put it back and put the variable
> >in a structure instead of using a global.
> 
> Broken commits are bad for bisecting.  "git bisect" is used to
> search for a revision that introduces a bug.  "git bisect" selects a
> commit between the known working and the known broken revision.  If
> the commit selected by "git commit" suffers from additional
> breakage, this could lead to wasted time and possibly to a failure
> to find the commit responsible for the original problem.
> 

This commit doesn't break anything.  He explained that.
brcmf_mmc_suspend is already initialized to false here because it is
a static variable.

Don't send a v2 of the patchset.

regards,
dan carpenter

PS: Franky, if you already know the answer then you can just tell us.
You don't need to ask for permission.
