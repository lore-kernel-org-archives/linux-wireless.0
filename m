Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43872 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbZBGEmq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 23:42:46 -0500
Subject: Re: location of binaries and libraries of new wifi tools
From: Dan Williams <dcbw@redhat.com>
To: Daniel Mierswa <impulze@impulze.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <498CC07F.3080800@impulze.org>
References: <498CC07F.3080800@impulze.org>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 23:41:11 -0500
Message-Id: <1233981671.3652.6.camel@localhost> (sfid-20090207_054251_020424_C56C7082)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-02-06 at 23:58 +0100, Daniel Mierswa wrote:
> Hey list, I was wondering where to put binaries for the new
> wireless-stack based tools. Most default installations put libnl, crypto
> and gcrypt into /usr. Applications like iw, wpa_supplicant and crda need
> those to run, yet they do not link statically. So if the default
> location for the new binaries is /sbin or /bin and the libraries it
> links against are default installed somewhere into /usr things will
> break. I wonder now what to do for consistency. Either statically link
> libraries that are default installed into /usr, put those libs into /lib
> or install the binaries into /usr aswell. I'd appreciate any comments on
> that. :) Thanks and have a nice weekend.

Stuff in /bin or /sbin can certainly link to stuff in /usr without
breaking.  The only time it breaks is when you're using network
mounted /usr and you need the wireless stack to boot the machine and
mount /usr.  But then you have to ask yourself, why are you using a
network mounted /usr over wifi?  That seems odd.  Somebody turns on a
microwave or starts to use a cordless phone and you're hosed.

Dan


