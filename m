Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52937 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab1KDBKC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 21:10:02 -0400
Received: by ggnb2 with SMTP id b2so1933370ggn.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2011 18:10:02 -0700 (PDT)
Message-ID: <4EB33B67.6080806@lwfinger.net> (sfid-20111104_021013_807068_A5373433)
Date: Thu, 03 Nov 2011 20:09:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: A new driver is going to be released
References: <CAMG6FYiNW-1ijghpgQ6R_9HujVEp8d53DQ-vjfJrw_hZamM8Jw@mail.gmail.com>
In-Reply-To: <CAMG6FYiNW-1ijghpgQ6R_9HujVEp8d53DQ-vjfJrw_hZamM8Jw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2011 05:40 PM, Dmitry Tarnyagin wrote:
> Hi,
>
> I'm about to release cw1200 driver to the community (more or less
> latest code is available here:
> http://www.igloocommunity.org/gitweb/?p=kernel/igloo-kernel.git;a=shortlog;h=refs/heads/linux-3.0-ux500
> as well).
>
> Technical question: how is it usually done in terms of commit history?
> Should I preserve the history and release all the changes in the
> driver separately or should I squash everything to a single commit
> or...?

The details of what it took to get your driver to this point are not going to be 
of much interest in the future. The "official" history starts with acceptance 
into the kernel. Two things to keep in mind: (1) the kernel source must compile 
at each step of the way to allow for bisection, thus any changes to Kconfig and 
Makefile must be in the last patch, and (2) each commit should be small enough 
that it is relatively easy to review.

As I do not know the complexity of the driver, it is a little difficult to make 
suggestions; however, one way to accomplish the above is to add each source file 
in a separate patch. The maintainer may submit the final version as a single 
commit, but that is their choice.

Your sending this mail to the wireless ML indicates that you plan to submit the 
driver to the drivers/net/wireless/ part of the source tree. As long as the 
driver employs mac80211, that is appropriate. The other option is 
drivers/staging/. Drivers for that section of the source tree usually are not 
held to standards as high as the wireless section.

Please be certain that all code submitted passes all tests cleanly including 
checkpatch, sparse including endianess, and smatch.

Good luck,

Larry
