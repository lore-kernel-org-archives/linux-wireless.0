Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:52415 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664AbXERWum (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 18:50:42 -0400
Message-ID: <464E2DB2.9010802@garzik.org>
Date: Fri, 18 May 2007 18:50:26 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: James Ketrenos <jketreno@linux.intel.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
References: <464B7B7C.5080800@linux.intel.com> <20070516203505.556df4f9.randy.dunlap@oracle.com> <464E0DB5.5010802@linux.intel.com> <464E233A.6060209@garzik.org> <464E1B4A.8050105@linux.intel.com>
In-Reply-To: <464E1B4A.8050105@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

James Ketrenos wrote:
> Are you OK with us marking the driver as not working on big endian for 
> now and getting this one fixed over time?

No.

Getting this right is a key merge requirement for all drivers.

Getting this right has also, in the past, been a proven way to find 
hidden bugs in your driver that wanted fixing anyway.


> I tried reading through the thread.  From what I gathered, it sounds 
> like if I want to read a value from a memory location where the adapter 
> could be writing to it I would just call rmb() before I access the 
> memory?  And when writing to a value, call wmb() immediately after I 
> write to it?  And expunge 'volatile' from my vocabulary.

MMIO - no.  Accessors handle that for you in most cases.  For rare cases 
you might need mmiowb() or whatnot, but that is unlikely.

DMA, generally that's what people do, but it's not perfect.

	Jeff


