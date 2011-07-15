Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr19.hinet.net ([168.95.4.119]:37735 "EHLO msr19.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab1GORNT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 13:13:19 -0400
From: Ali Bahar <ali@internetdog.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Ali Bahar <ali@internetdog.org>
Subject: [PATCH 0/2] staging: r8712u: Most return-values changed from -1 to
Date: Sat, 16 Jul 2011 01:11:14 +0800
Message-Id: <1310749876-32632-1-git-send-email-ali@internetDog.org> (sfid-20110715_191324_170977_A04276E7)
In-Reply-To: <20110703010605.GA3736@internetdog.org>
References: <20110703010605.GA3736@internetdog.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Correcting most of the -1 return-values that this driver's ioctl handlers
return. They have been changed to the closest corresponding errno macro.


Unfortunately, very few of these could be tested! Often, wext does not care
about the specifics of the failure; it just checks for a negative
return-value. So these bugs do not propagate to the user.

Without instrumenting the code (of the driver, or of wext), this left
very few testables! eg the following (note the ampersand)
  iwlist wlan2 scan & iwconfig wlan2 ap any
was the only way of triggering one of the failures. 
Prior to the tests, I spent a lot of time on verifying the call chains.

The git-log of this file includes a few other such corrections to the
return values. So this patch should fit-in well.

Ali Bahar (2):
  staging: r8712u: Most return-values changed from -1 to proper errno
    macros.
  staging: r8712u: checkpatch errors: trailing whitespace on 2 lines.

 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |  121 +++++++++++++++++++++----
 1 files changed, 105 insertions(+), 16 deletions(-)

-- 
1.7.6

