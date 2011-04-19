Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:52887 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab1DSHvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 03:51:12 -0400
Date: Tue, 19 Apr 2011 09:54:04 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Nishant Sarmukadam <nishants@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Pradeep Nemavat <pnemavat@marvell.com>
Subject: Re: [PATCH 2/4] mwl8k: Add timestamp information for tx packets
Message-ID: <20110419075404.GK1897@wantstofly.org>
References: <1303191772-4299-1-git-send-email-nishants@marvell.com>
 <1303191772-4299-2-git-send-email-nishants@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303191772-4299-2-git-send-email-nishants@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 19, 2011 at 11:12:50AM +0530, Nishant Sarmukadam wrote:

> From: Pradeep Nemavat <pnemavat@marvell.com>
> 
> Timestamp tx packets using a HW micro-second timer.
> This timestamp will be compared to the current timestamp
> in the hardware and if the difference is greater than 500ms,
> the packet will be dropped.

Why don't you do this entirely in the firmware?

When a packet is put into the TX ring by the host, give it a timestamp
of zero.

When the firmware gets a TX interrupt, have it walk the TX ring from
the last TX entry where a timestamp was written to (i.e. keep a separate
index for this), and timestamp all TX ring entries that are marked as
being FW OWNED but don't have a timestamp yet (and update your index).

Then when the time comes to process the TX packet (i.e. it has reached
the head of the TX queue), compare the timestamp with the current time.

As an added bonus, this'll also work over USB/SPI/whatever other bus
type where you cannot read some H/W microsecond timestamp register
directly like you can on PCI(e) -- which sticks out like a sore thumb
because it goes around the clean command / ring based host<->firmware
interface.
