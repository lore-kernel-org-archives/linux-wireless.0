Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:52789 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbYL1NGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 08:06:55 -0500
Date: Sun, 28 Dec 2008 13:06:50 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 3/3] mac80211: implement dynamic power save
Message-ID: <20081228130650.GA9083@srcf.ucam.org> (sfid-20081228_140735_045252_C4895D36)
References: <20081218211532.6842.88104.stgit@tikku> <20081218211712.6842.98402.stgit@tikku> <20081224132432.GA27658@srcf.ucam.org> <87wsdkmp54.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87wsdkmp54.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 28, 2008 at 02:59:35PM +0200, Kalle Valo wrote:
> Matthew Garrett <mjg59@srcf.ucam.org> writes:
> 
> > Are we able to estimate the worst-case latency that will be introduced 
> > by this? If so, it would be helpful to tie it into the pm_qos framework.
> 
> I'm not familiar with pm_qos framework, unfortunately, but there's
> some work to do still to get mac80211 client power save implemention
> into shape and I would like get the basics implemented first. After
> that is done, we could start looking at the pm_qos framework and see
> if it makes sense to use it.

It allows userspace applications to register their latency requirements. 
There's a notifier chain that then allows drivers (or subsystems) to be 
notified of the current requirements, the idea being that they can then 
limit their deepest power saving mode to one that still satisfies the 
userspace constraints. But yeah, it's not really worth worrying about 
until the code works :)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
