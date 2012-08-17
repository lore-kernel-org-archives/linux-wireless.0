Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37015 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab2HQWyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2012 18:54:12 -0400
Received: by ialo24 with SMTP id o24so962312ial.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Aug 2012 15:54:11 -0700 (PDT)
Date: Fri, 17 Aug 2012 17:54:06 -0500
From: "Saul St. John" <saul.stjohn@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] bcma: expose cc sprom to sysfs
Message-ID: <20120817225406.GA6510@eris.garyseven.net> (sfid-20120818_005438_114283_76A340FB)
References: <20120816190616.GE6726@eris.garyseven.net>
 <502E4B70.5090900@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <502E4B70.5090900@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 17, 2012 at 03:47:28PM +0200, Arend van Spriel wrote:
[snip]
> 
> Hi Saul,
>
> I was still planning to come back to your reply on August 14. Just
> wanted to reply to this patch as I still feel it is a bad thing to
> open up the sprom as a whole. I can see the use-cases you mentioned
> as useful, but maybe we can get a specific solution for that.
> 
> Gr. AvS
>

Hi Arend!

Apologies for forking the discussion. I just wasn't sure that any more replies
would be forthcoming.

I'm curious why you feel it's a "bad" thing to open up the sprom as a whole. I
see a number of distinct advantages to it; most prominently, that it allows
for the use of existing tools and processes. I can find several examples of 
end-users attempting to modify the sprom on bcma devices using the 
instructions from b43-tools ([1][2][3]), and suggest that it would be 
confusing to those users were the procedures for sprom-modification through 
bcma substantially different than the procedures through ssb.

That said, I do recognize that this functionality is potentially dangerous in
some circumstances. I'd considered hiding it behind a non-default module 
parameter-- would that assuage your concerns? Alternatively, if you have 
specific solutions in mind for the use-cases previously discussed, I'm very
interested in knowing them.

-saul

[1] http://ubuntuforums.org/showthread.php?t=1830739
[2] http://www.tonymacx86.com/network/25669-rebranding-bcm94322mc-based-prasys-guide-what-device-id-8.html#post291328
[3] http://www.tonymacx86.com/network/26904-help-rebrand-broadcom-bcm94322-5.html
