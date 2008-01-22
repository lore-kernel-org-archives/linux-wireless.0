Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:40524 "EHLO
	ccerelbas01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbYAVSer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 13:34:47 -0500
Date: Tue, 22 Jan 2008 10:16:26 -0800
To: "Volodymyr G. Lukiianyk" <volodymyrgl@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] WEXT: Correct the size of the buffer to be copied to user-space in standard GET WE ioctls.
Message-ID: <20080122181626.GC11873@bougret.hpl.hp.com> (sfid-20080122_183454_239934_37EDD1A3)
Reply-To: jt@hpl.hp.com
References: <4793935F.2000102@gmail.com> <43e72e890801201104o5d2e395du558037179156e80b@mail.gmail.com> <4794C341.2020300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4794C341.2020300@gmail.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 21, 2008 at 06:07:29PM +0200, Volodymyr G. Lukiianyk wrote:
> 
> Please, ignore this patch. I didn't notice that the driver's handler should set
> iwr->u.data.length appropriately. But is there any possibility for compiler to
> temporarily save the value of this field in the register and not re-read it after
> handler call?
> 

	If the kernel is compiled without -fno-strict-aliasing, I've
seen similar things happening. But, I thought that using
-fno-strict-aliasing would cure that issue.

	Good luck...

	Jean
