Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:60539 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbZAMAyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 19:54:06 -0500
Date: Tue, 13 Jan 2009 00:54:01 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Werner Almesberger <werner@openmoko.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rfkill: how murderous can it be ?
Message-ID: <20090113005401.GA7565@srcf.ucam.org> (sfid-20090113_015417_327650_2850A9C3)
References: <20090112191514.GA22112@almesberger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090112191514.GA22112@almesberger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 12, 2009 at 05:15:14PM -0200, Werner Almesberger wrote:

> Alternatively, we could just power down the whole WLAN module. That is
> easily done and very reliable. However, MAC state (ESSID, keys, and a
> host of other settings) is obliterated if we do this. A watchful user 
> space (e.g., wpa_supplicant) could then restore the status quo ante.

Some platform rfkill methods will perform a logical PCI hotplug of the 
device, without any means of notifying the driver beforehand. Since this 
will destroy the driver structure, I think we really need to leave state 
restoration up to userspace.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
