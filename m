Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995Ab2BOIrM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 03:47:12 -0500
Date: Wed, 15 Feb 2012 09:46:59 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Nerijus Baliunas <nerijus@users.sourceforge.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwl3945 cannot connect to zd1211rw AP
Message-ID: <20120215084658.GA17573@redhat.com> (sfid-20120215_094715_959496_36DA15AA)
References: <Mahogany-0.68.0-758-20120215-003647.00@nerijus.sat.lt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <Mahogany-0.68.0-758-20120215-003647.00@nerijus.sat.lt>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 15, 2012 at 12:36:47AM +0200, Nerijus Baliunas wrote:
> Hello,
> 
> Client is Intel 3945abg and AP is ZyDAS ZD1211B (3.2.5 Fedora PAE kernel, hostapd 0.7.3).
> When client is WinXP or Linux 3.0.0, I get only:
> hostapd: wlan0: STA 00:18:de... IEEE 802.11: did not acknowledge authentication response
> messages in AP's syslog; when client is Linux kernel 3.1.6 - no messages in AP.
> 
> Other chipsets connect to this AP successfully, and this client can connect to another
> wifi stick on the same AP (rt2800usb).
> 
> Is it a iwl3945 or zd1211rw problem? How can I debug it?

Perhaps know zd1211 bug, we have one fix that I think can address that:
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff;h=e81a7bd55531a77d8c16d44766db4089c2983f1b

We included that commit in the latest fedora kernel 3.2.6, check that out:
http://koji.fedoraproject.org/koji/buildinfo?buildID=299356

Stanislaw
