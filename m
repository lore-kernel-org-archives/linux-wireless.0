Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:46817 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbZEOLSH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 07:18:07 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: ar9170 deadlock report
Date: Fri, 15 May 2009 13:18:06 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <1242384642.5799.48.camel@johannes.local>
In-Reply-To: <1242384642.5799.48.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200905151318.06411.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 May 2009 12:50:42 Johannes Berg wrote:
> [  328.121951] =======================================================
> [  328.122169] [ INFO: possible circular locking dependency detected ]
> [  328.122339] 2.6.30-rc5-wl-23310-ge0995c7-dirty #54
> [  328.122468] -------------------------------------------------------
> [  328.122636] pm-hibernate/7289 is trying to acquire lock:
> [  328.122779]  (&(&ar->tx_status_janitor)->work){+.+...}, at: [<c00000000007eb14>] .wait_on_work+0x3c/0x194
> [  328.123058] 
> [  328.123059] but task is already holding lock:
> [  328.123216]  (&ar->mutex){+.+...}, at: [<d0000000015c29a4>] .ar9170_op_stop+0x60/0x120 [ar9170usb]
> [  328.123482] 
> [  328.123482] which lock already depends on the new lock.
> [  328.123484] 
> [  328.123702] 
> [  328.123703] the existing dependency chain (in reverse order) is:
> [  328.123903] 
> [  328.123904] -> #1 (&ar->mutex){+.+...}:
> [  328.124066]        [<c00000000009ee40>] .check_prev_add+0x3d4/0x5f8
> [  328.124242]        [<c00000000009f7b0>] .validate_chain+0x74c/0x930
> [  328.128871]        [<c0000000000a01a0>] .__lock_acquire+0x80c/0x8f4
> [  328.133531]        [<c0000000000a03d4>] .lock_acquire+0x14c/0x19c
> [  328.138139]        [<c0000000004cb0f0>] .mutex_lock_nested+0xa8/0x504
> [  328.142769]        [<d0000000015c414c>] .ar9170_tx_status_janitor+0x58/0x114 [ar9170usb]
> 
> 
> [  328.156599] -> #0 (&(&ar->tx_status_janitor)->work){+.+...}:
> [  328.156604]        [<c00000000009eb2c>] .check_prev_add+0xc0/0x5f8
> [  328.156609]        [<c00000000009f7b0>] .validate_chain+0x74c/0x930
> [  328.156614]        [<c0000000000a01a0>] .__lock_acquire+0x80c/0x8f4
> [  328.156618]        [<c0000000000a03d4>] .lock_acquire+0x14c/0x19c
> [  328.156623]        [<c00000000007eb54>] .wait_on_work+0x7c/0x194
> [  328.156627]        [<c00000000007ed50>] .__cancel_work_timer+0xe4/0x164
> [  328.156632]        [<c00000000007ee00>] .cancel_delayed_work_sync+0x30/0x48
> [  328.156636]        [<d0000000015c29b0>] .ar9170_op_stop+0x6c/0x120 [ar9170usb]
> 
> Don't cancel a work under a lock that it needs!
> 
> johannes
> 
do you have the module this time?

Regards,
	Chr
