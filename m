Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9984 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab0BQS7L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 13:59:11 -0500
Subject: Re: [PATCH] v2: rtl8187: micro cleanup
From: Pavel Roskin <proski@gnu.org>
To: okias <d.okias@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <c2673ca61002171038u14c7ab2fnf2d3ce2067bd1fd8@mail.gmail.com>
References: <c2673ca61002171015j375922c0y4c7f61c3d3322bab@mail.gmail.com>
	 <4B7C35C9.30607@lwfinger.net>
	 <c2673ca61002171034q18edf1c2o817ac4e1ff367177@mail.gmail.com>
	 <1266431764.15836.8.camel@jlt3.sipsolutions.net>
	 <c2673ca61002171038u14c7ab2fnf2d3ce2067bd1fd8@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 17 Feb 2010 13:58:58 -0500
Message-Id: <1266433138.9050.27.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-02-17 at 19:38 +0100, okias wrote:
> You have probably right, but when I use my testing program:
> 
> #include <stdio.h>
> main() {
> int a;
> printf("%i\n", a);
> a |= 22;
> printf("%i\n", a);
> }
> 
> Output is:
> 0
> 22
> 
> it look correct to me

That's what I get if compiling for x86_64.  If compiling for i386, I get

1258024948
1258024950

It just happens that 0 is on the stack where the variable is allocated,
perhaps as a leftover from another call that used that area on the
stack.

No C standard says that automatic variables are initialized.  And
indeed, they are not!

gcc will warn about it with -Wall

Please let's stop this discussion now, as it doesn't belong to the
linux-wireless mailing list.

-- 
Regards,
Pavel Roskin
