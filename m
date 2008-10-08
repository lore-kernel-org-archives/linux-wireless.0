Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:39202 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754416AbYJHRD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 13:03:56 -0400
Message-ID: <48ECE7F7.7090401@lwfinger.net> (sfid-20081008_190401_040080_FD229125)
Date: Wed, 08 Oct 2008 10:03:51 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>, Chr <chunkeey@web.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] p54: Fix compilation problem on PPC
References: <48EB7FF1.9060803@lwfinger.net>	 <1223398653.7328.43.camel@johannes.berg> <1223424869.22522.6.camel@dv>
In-Reply-To: <1223424869.22522.6.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> I'm sorry for being late.  I have tested an Xterasys XG-600 (miniPCI) on
> i386 and PowerPC.  The same device is working on i386, but not on
> PowerPC.  There are kernel messages running on the console on PowerPC,
> but I could not capture them yet.  The kernel is the current
> wireless-testing.
> 
> I suspect we should not be mixing little-endian and host-endian
> structures.

Agreed. In data structure "bootrec", there is a data array that gets
used once as be32, once as le16, and several times as though it were
in native CPU order. That has always look funny to me, but as I can
only test on x86_64 architecture, I cannot distinguish le32 from
native CPU.

I will prepare a patch to explicitly use those data as le32 for you to
test.

Thanks,

Larry
