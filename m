Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:53631 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbZJTPlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 11:41:09 -0400
Received: by ywh40 with SMTP id 40so3613700ywh.33
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 08:41:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910201714.34866.hs4233@mail.mn-solutions.de>
References: <86201b3f0910200710u36557bf8uf5bc014b32b14d33@mail.gmail.com>
	 <200910201714.34866.hs4233@mail.mn-solutions.de>
Date: Tue, 20 Oct 2009 11:41:09 -0400
Message-ID: <86201b3f0910200841w7e512fa3i31012477cbf55d56@mail.gmail.com>
Subject: Re: Rate information in ad-hoc and mesh mode
From: Charles Gordon <digigordo@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am using version 2.6.28 of the kernel.  We are using our own
wireless driver.  However, the problem does not appear to be in the
driver.  The iw utility uses the SIOCGIWRATE ioctl to get rate
information.  This ioctl is handled by the ieee80211_ioctl_giwrate
function in net/mac80211/wext.c in the 2.6.28 version of the kernel.
This function returns immediately if sdata->vif.type !=
NL80211_IFTYPE_STATION, which will be the case for ad-hoc mode.



On Tue, Oct 20, 2009 at 11:14 AM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
>> I notice that the ieee80211_ioctl_giwrate function in wext.c only
>> returns rate information for stations associated to an AP.  It does
>> not return rate information for stations operating in ad-hoc mode or
>> as a mesh point.  Is there a reason this function is not supported in
>> those modes?  Is this a deliberate decision or just an oversight?
>
> You need to give more context. What driver, what kernel?
>
>
> A quick
>
>   ack-grep ieee80211_ioctl_giwrate include/net include/linux \
>                                    net/wireless net/mac80211 \
>                                    drivers/net/wireless
>
> didn't reveal the function you've mentioned, at least not in the
> current wireless-testing kernel.
>
> --
> http://www.holgerschurig.de
>
