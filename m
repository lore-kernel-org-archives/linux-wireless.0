Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2044 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab1GRWYH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 18:24:07 -0400
Message-ID: <4E24B27B.2020004@broadcom.com> (sfid-20110719_002414_176307_7CF263E8)
Date: Mon, 18 Jul 2011 15:23:55 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Pavel Roskin" <proski@gnu.org>
cc: "Dan Carpenter" <error27@gmail.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 12/19] staging: brcm80211: remove code for
 unsupported chip
References: <1310999405-10062-1-git-send-email-arend@broadcom.com>
 <1310999405-10062-13-git-send-email-arend@broadcom.com>
 <20110718194215.GD4010@shale.localdomain>
 <4E24A313.3080800@broadcom.com> <4E24A6E3.8070700@gnu.org>
In-Reply-To: <4E24A6E3.8070700@gnu.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/18/2011 2:34:27 PM, Pavel Roskin <proski@gnu.org> wrote:
> On 07/18/2011 05:18 PM, Franky Lin wrote:
>
>> No, i didn't. Thank you for pointing out this. I missed it when I
>> rebased my local branch. It didn't break any thing because
>> brcmf_mmc_suspend is a global variable. Is it ok to keep the patch like
>> this? I will prepare another patch to put it back and put the variable
>> in a structure instead of using a global.
>
> Broken commits are bad for bisecting.  "git bisect" is used to search
> for a revision that introduces a bug.  "git bisect" selects a commit
> between the known working and the known broken revision.  If the commit
> selected by "git commit" suffers from additional breakage, this could
> lead to wasted time and possibly to a failure to find the commit
> responsible for the original problem.
>
> Please don't submit known broken commits.  You can always send another
> version of the series.  If you are using stgit, see "stg mail --help".
>

Thanks Pavel. We will send out a v2 to fix this.

