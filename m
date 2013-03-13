Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms.dension.com ([195.56.193.33]:46764 "EHLO ms.dension.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab3CMPLZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 11:11:25 -0400
Date: Wed, 13 Mar 2013 16:11:21 +0100
From: "Patrik, Kluba" <pkluba@dension.com>
To: "Patrik, Kluba" <pkluba@dension.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: bug: deadlock in rtl8192cu
Message-ID: <20130313161121.210ff4fd.pkluba@dension.com> (sfid-20130313_161128_887623_DD588C22)
In-Reply-To: <20130313152505.7dc3466c.pkluba@dension.com>
References: <20130312163020.67f9532b.pkluba@dension.com>
	<513F5931.6040509@lwfinger.net>
	<20130313152505.7dc3466c.pkluba@dension.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 13 Mar 2013 15:25:05 +0100
"Patrik, Kluba" <pkluba@dension.com> wrote:

> According to http://lwn.net/Articles/37889/ no sleeping functions
> should be called inside an rcu_read_lock() region. No sleeping can
> not be guaranteed for USB transfers.

To correct myself: for synchronous USB transfers. usb_submit_urb() and
friends are safe. Rewriting things in rtlwifi to do async transfers is
a tremendous job, and might not help at all as the termination of the
callback has still be waited under RCU. 

But how about something like this?


rcu_read_lock();
sta = ...
increase_reference_count();
rcu_read_unlock();

... do all the might-sleeping things here ...

decrease_reference_count_and_call_callback_if_necessary();



I have found an example for rcu_read_lock() + kref_get() here:
https://lists.open-mesh.org/pipermail/b.a.t.m.a.n/2011-February/004234.html

Regards,
Patrik

-- 
Patrik KLUBA
Software Developer at

DENSION Audio Systems Ltd.
H-1116 Budapest, Sztregova u. 1
Phone: +36 1 463 0470
Fax:   +36 1 463 0479
Web:   www.dension.com
