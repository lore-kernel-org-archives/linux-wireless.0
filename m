Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:56184 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757436AbXEVXA0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2007 19:00:26 -0400
Message-ID: <46537603.6040208@garzik.org>
Date: Tue, 22 May 2007 19:00:19 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: James Ketrenos <jketreno@linux.intel.com>
CC: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <200705162151.32910.flamingice@sourmilk.net> <46534172.5040106@linux.intel.com>
In-Reply-To: <46534172.5040106@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

James Ketrenos wrote:
> That said -- if the driver can execute in parallel to the stack for some 
> operations, shouldn't they remain on their own workqueues so the work 
> can be divided up vs. having *everything* routed through one 
> singlethread workqueue?

Just because it -can-, does not mean it should.

Unless there is a -proven- need for the operations to be parallel, you 
should avoid the burden of such complexity.

	Jeff


