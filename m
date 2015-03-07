Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:38534 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbbCGVaj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 16:30:39 -0500
Received: by obcuz6 with SMTP id uz6so637045obc.5
        for <linux-wireless@vger.kernel.org>; Sat, 07 Mar 2015 13:30:39 -0800 (PST)
Message-ID: <54FB6DFC.3040509@lwfinger.net> (sfid-20150307_223045_227059_D18081CE)
Date: Sat, 07 Mar 2015 15:30:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
References: <1425680126-25928-1-git-send-email-Jes.Sorensen@redhat.com> <1425680126-25928-2-git-send-email-Jes.Sorensen@redhat.com>
In-Reply-To: <1425680126-25928-2-git-send-email-Jes.Sorensen@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2015 04:15 PM, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> This is an alternate driver for the Realtek 8723AU (rtl8723au) written
> from scratch utilizing the mac80211 stack.
>
> After spending months cleaning up the vendor provided rtl8723au
> driver, which comes with it's own 802.11 stack included, I decided to
> rewrite this driver from the bottom up.
>
> Many thanks to Johannes Berg for 802.11 insights and help and Larry
> Finger for help with the vendor driver.
>
> The full git log for the development of this driver can be found here:
> git git://git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git
>      branch rtl8723au-mac80211
>
> This driver is still experimental, but has proven to be rather stable
> for me. It lacks some features found in the staging driver, such as
> power management, AMPDU, and 40MHz channel support. In addition there
> is no AP and monitor support at this point.
>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Quilt reports the following when this patch is refreshed:

Warning: trailing whitespace in lines 2862,3273,3492,3521 of 
drivers/net/wireless/rtl8xxxu.c

I have not analyzed all the temporary manipulations of rtl8xxxu_debug to see 
what you are doing; however, I suggest that you add a module parameter so that 
debugging can be enabled without rebuilding the module. That way a user who is 
using a distro binary can enable debugging without the hassle of a full kernel 
rebuild.

Because this driver is under drivers/net, checkpatch.pl adds additional tests 
that may not be used in other trees. For instance, it complains when it finds a 
block comment that starts with a bare "/*". What is usually done is to use "/**" 
instead.

I think I understand why some of the "#if 0" blocks are present, but others are 
not clear. For example, I see no value of keeping code that is labelled "only 
for PCIe". Is it your intention to add the RTL8723AE to this driver?

Running checkpatch.pl on this patch results in total of 24 errors, 99 warnings, 
and 105 checks. From your mail exchange with Joe Perches, I understand that you 
will not wish to fix all of these; however, the errors should be handled. The 
fewer of the warnings or checks that are left, the better, if only to prevent 
interference from the script kiddies.

I like the clean look of the code. That is particularly impressive given the 
look of the original. I wish I had the hardware on which to test it. Perhaps I 
can wedge it into a kernel version that builds and runs on my Radxa Rock,

Larry

