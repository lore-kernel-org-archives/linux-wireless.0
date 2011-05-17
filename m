Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4931 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab1EQKxv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 06:53:51 -0400
Message-ID: <4DD253B0.8050802@broadcom.com> (sfid-20110517_125355_002257_FB1F79C7)
Date: Tue, 17 May 2011 12:53:36 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Greg KH" <greg@kroah.com>
cc: "Clemens Noss" <cnoss@gmx.de>, "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] staging: brcm80211: fix cast to pointer from
 integer
References: <1305492330-19575-1-git-send-email-cnoss@gmx.de>
 <4DD105FE.9040500@broadcom.com> <20110516203333.GB17698@kroah.com>
In-Reply-To: <20110516203333.GB17698@kroah.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Greg, please also merge this to the staging-linus branch since it
>> might resolve an instability issue.
>
> It "might"?

Correction: I tested it now. Indeed it resolves a problem (segmentation 
fault) upon dissociation on amd64.

> Is this a regression?  Do people see the problem on the .38 kernel as
> well?

People on the .38 kernel see the problem even worse: they experience a 
crash on dissociation on both i386 and amd64.

> It's way too late for anything but severe regressions to be sent to
> Linus at this point in time...

Understood. Since behavior has not regressed, I think this fix does not 
qualify to be sent to Linus. Perhaps we can get it into a 
compat-wireless package.

Thanks, Roland.

