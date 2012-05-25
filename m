Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60730 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899Ab2EYWv7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 18:51:59 -0400
Received: by yhmm54 with SMTP id m54so971911yhm.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 May 2012 15:51:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FC00848.9060901@broadcom.com>
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com> <4FC00848.9060901@broadcom.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Fri, 25 May 2012 15:51:38 -0700
Message-ID: <CAB=NE6XsTtJvmJDVa2toJCsjn1fxH+5cqJ8xkaquNhHcHDgh2A@mail.gmail.com> (sfid-20120526_005204_200196_806C492B)
Subject: Re: [RFC PATCH 0/8] brcm80211: smac: rework regulatory support
To: Arend van Spriel <arend@broadcom.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org, Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 25, 2012 at 3:31 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 04/16/2012 10:17 PM, Seth Forshee wrote:
>> Hi Arnd,
>
> You missed an 'e' ;-)
>
>> Here's the latest update to the brcmsmac regulatory rework that I've
>> been working on. I've broken it up into a series of smaller patches,
>> cleaned things up, and finished what changes I can with the information
>> available to me.
>
> It took a while. There were some discussions and we agreed that your
> changes establish a better integration with the regulatory framework.
> There are some concerns about the content of the crda database, but that
> is another thing outside the scope of your patches.

BTW if you would like to address anything please let me know. If you'd like
to review things in private too that's fine, just let me know. I
should say that the staging area for the next generation regulatory
code is being done through the regulatory simulator:

git://github.com/mcgrof/regsim.git

If you have any early stage idea / changes this is where we should be
reviewing / strategizing on them. I should note that this does let you
use the code for regulatory anywhere, the kernel, firmware, whatever.
Due to synch issues with host / firmware database though my
recommendation is obviously to trust the host with the reg data,
unless you resolve the synch issues.

I suppose one way to deal with synch issues as a temporary stage
(before removing firmware reg stuff) is to send the data structure of
the regdomain to firmware so it can base prepare itself / not have any
issues.

>> I've attempted to maintain the same high-level behavior that the
>> brcmsmac internal regulatory support currently enforces.
>
> Appreciated. We can add/change in subsequent patches. I collected review
> comments internally including mine. I will provide them in response to
> each individual patch.
>
> General comment: you should run 'checkpatch.pl --strict' script over the
> patches. I came across several issues that will probably be flagged by it.

Arend, in the future please trim all hunks that are not relevant to
your replies, that makes review easier.

  Luis
