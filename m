Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52861 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab1EXNfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 09:35:13 -0400
Received: by bwz15 with SMTP id 15so5630985bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 06:35:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DDA9016.3090701@lwfinger.net>
References: <4DDA66D5.2090801@ring3k.org>
	<4DDA9016.3090701@lwfinger.net>
Date: Tue, 24 May 2011 22:35:12 +0900
Message-ID: <BANLkTimC-NndRxtpcL=+iCmmKYbfc0+qQw@mail.gmail.com> (sfid-20110524_153518_524766_B688D996)
Subject: Re: [PATCH 0/8] rtl8192ce stability improvements
From: Mike McCormack <mikem@ring3k.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 May 2011 01:49, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Are you using wireless-testing for your patches? There are some patches
> pending in John's queue, but your patches got offsets and fuzz in files that
> those patches do not touch. Everything seemed to apply despite the fuzz and
> everything compiled, but I always get nervous about patches with anything
> more serious than offsets.

I originally developed these patches against the staging-next tree, then
ported them over to the wireless-testing tree.  They are on top of this commit:

commit 1e4541b73b33f9918255f36a60bdeacfae4fdb9d
Author: John W. Linville <linville@tuxdriver.com>
Date:   Thu May 19 13:54:47 2011 -0400

    Revert "mac80211_hwsim driver support userspace frame tx/rx"

    This reverts commit 444c7896bf5b0c613fd58c8f08e60a8714eb7f05.

I have done a fair bit of work on the rtl8192e driver in Greg KH's staging-next,
and reused ideas from work I've done there in this series.

Do you think it would be worthwhile to merge rtl8192e support into rtlwifi
or is there something critical that will prevent that from working well?

> Patches 3, 4, 6 and 8 do modify driver rtlwifi, but patches 1 and 7 change
> driver rtl8192ce. Similarly, #2 changes rtl8192ce, rtl8192cu, and rtl8192se,
> and #5 changes rtl8192ce and rtl8192se. The subject line for the patch
> should indicate the driver that gets modified. I usually do it as "rtlwifi:
> rtl8192ce: blah-blah", etc. The rtlwifi is included even though it does not
> get changed by the patch.

OK, I'll try follow your convention with the next series.

> I do not see anything serious in the body of the patches and I expect that I
> will be giving them an ACK, but I want to test first.

Great.  Should I resend with your Acked-by: ?

thanks,

Mike
