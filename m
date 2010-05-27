Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39438 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542Ab0E0S0p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 14:26:45 -0400
Received: by pwi7 with SMTP id 7so177778pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 May 2010 11:26:44 -0700 (PDT)
Message-ID: <4BFEB968.9040204@lwfinger.net>
Date: Thu, 27 May 2010 13:26:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>, Greg KH <greg@kroah.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Conversion of driver for Realtek 8192SU
References: <4BFE9A22.5040005@lwfinger.net> <1274983581.3669.60.camel@jlt3.sipsolutions.net>
In-Reply-To: <1274983581.3669.60.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/27/2010 01:06 PM, Johannes Berg wrote:
> On Thu, 2010-05-27 at 11:13 -0500, Larry Finger wrote:
> 
>> I know that the size of pointers changes from 32- to 54-bit
>> architecture, as does the size of longs. I have been through the code
>> many times, and I think those have been fixed. Are there any other types
>> of objects that change size? Does anyone have any suggestions on what to
>> look for?
> 
> Alignment _might_ be different, though I think it isn't actually as long
> as we're talking about x86_64 (amd64) only.
> 
> If the driver uses wireless extensions (likely), it might have issues
> with that too, since they are not very 32/64-bit compat happy (unless
> you're using 64-bit userspace exclusively obviously)
> 
> I can't think of anything else right now.

Thanks. The problem I had with the scan channel was with WEXT. It seems
likely that this problem is somewhere in there.

Larry
