Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44667 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752511AbYL3Ppc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 10:45:32 -0500
Date: Tue, 30 Dec 2008 10:45:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
cc: linux-wireless@vger.kernel.org,
	<linux-pm@lists.linux-foundation.org>,
	USB list <linux-usb@vger.kernel.org>
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
In-Reply-To: <495A1DC8.1050609@tuffmail.co.uk>
Message-ID: <Pine.LNX.4.44L0.0812301043290.2292-100000@iolanthe.rowland.org> (sfid-20081230_164542_151666_5A5F9AE7)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 30 Dec 2008, Alan Jenkins wrote:

> Ok, I think I got it.
> 
> The hang is in ieee80211_unregister_hw(), on this line:
> 
> destroy_workqueue(local->hw.workqueue);
> 
> 
> local->hw.workqueue is created using create_freezeable_workqueue().  So
> presumably destroy_workqueue() deadlocks because the workqueue has
> already been frozen.
> 
> Is it possible to fix this without suspend support in mac80211?  If not,
> I vote we change rtl8187 (and zd_usb) to prevent suspend.  I.e. set USB
> suspend callbacks which return an error.

It certainly should be possible to fix this.  For instance, why 
unregister anything during suspend?  If ieee80211_unregister_hw() 
weren't called then this problem would go away, right?

Alan Stern

