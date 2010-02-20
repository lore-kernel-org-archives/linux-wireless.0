Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f200.google.com ([209.85.210.200]:64546 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab0BTS73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Feb 2010 13:59:29 -0500
Received: by yxe38 with SMTP id 38so1201285yxe.4
        for <linux-wireless@vger.kernel.org>; Sat, 20 Feb 2010 10:59:28 -0800 (PST)
Message-ID: <4B80310D.2060302@lwfinger.net>
Date: Sat, 20 Feb 2010 12:59:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Kalle Valo <kalle.valo@iki.fi>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Frederic Leroy <fredo@starox.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] staging: rtl8192su: fix compile error from wireless-testing
 commit
References: <20100218002526.01d1de5f@houba>	<20100219195215.GL4950@tuxdriver.com> <871vgfhi7n.fsf@purkki.valot.fi>
In-Reply-To: <871vgfhi7n.fsf@purkki.valot.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2010 12:31 PM, Kalle Valo wrote:
> "John W. Linville" <linville@tuxdriver.com> writes:
> 
>> Since I've got the 'offending' commit in my tree, I'll carry this
>> staging fixup as well...
> 
> And I was the one who broke this, sorry. What's the general rule for
> this, should I also start compile testing staging drivers when
> changing something?

As someone else that was hit by this problem, I think that is a good idea. I
realize that staging drivers are a special case, but it is likely easier for the
person changing the ABI to fix any breakage. In addition, if the fixes are
entered at the same time as the original change, there will not be any build
breakage during bisection, and any questions of which coordinator to use will be
avoided.

Larry
