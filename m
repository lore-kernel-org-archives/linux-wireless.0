Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52888 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab1DETAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 15:00:24 -0400
Received: by vws1 with SMTP id 1so525082vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 12:00:23 -0700 (PDT)
Message-ID: <4D9B66C2.5000200@lwfinger.net>
Date: Tue, 05 Apr 2011 14:00:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Henry Ptasinski <henryp@broadcom.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>
Subject: Re: [PATCH 2/3] linux-firmware: Removed codeversion from brcm firmware
 filenames.
References: <1302015522-20601-1-git-send-email-henryp@broadcom.com> <1302015522-20601-3-git-send-email-henryp@broadcom.com> <4D9B3679.10509@lwfinger.net> <4D9B5684.6020304@broadcom.com>
In-Reply-To: <4D9B5684.6020304@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/05/2011 12:51 PM, Henry Ptasinski wrote:
> On 04/05/2011 08:34 AM, Larry Finger wrote:
>> I also endorse removing the version number from the firmware name; however, I
>> see a fundamental flaw in the present submission. Both brcmsmac and its
>> predecessor brcm80211 have been included in mainline and compat-wireless, have
>> been widely distributed, and have a number of users. This change will break the
>> system of every one of them - including mine.
>
> Hmm. Sounds like you've got the firmware installed with it's original name, and
> are using symlinks. Is that correct? A lot of installations (including at least
> one major distro) rename the files, and skip the whole symlink approach.
>
> That's we decided to dump the version number appendage. However, if there are a
> mix of installation approaches, we should take a somewhat different approach on
> the fix.
>
>  > My proposed solution is to do the
>> rename as done in this patch, but also include links to the new name from every
>> name used in any distributed version.
>
> The brcm80211/brcmsmac driver has always looked for "brcm/bcm43xx-0.fw". It
> never looked for the version info on the filename. So I don't quite understand
> what you mean by "from every name used in any distributed version", as the only
> name used in all distributed versions of the driver is exactly the name we're
> trying to give to the firmware file. Could you clarify?

You are right. Sorry for the noise. Having one name for the firmware in 
linux-firmware and a different one in the driver got me confused. The current 
patches will fix that.

My distro is openSUSE, which does make a symlink between the name with version 
info and what the driver actually loads.

Larry
