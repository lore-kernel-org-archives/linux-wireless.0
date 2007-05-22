Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:7367 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756737AbXEVXMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2007 19:12:09 -0400
Message-ID: <4653654F.1060708@linux.intel.com>
Date: Tue, 22 May 2007 14:49:03 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <200705162151.32910.flamingice@sourmilk.net> <46534172.5040106@linux.intel.com> <46537603.6040208@garzik.org>
In-Reply-To: <46537603.6040208@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeff Garzik wrote:
> James Ketrenos wrote:
>> That said -- if the driver can execute in parallel to the stack for 
>> some operations, shouldn't they remain on their own workqueues so the 
>> work can be divided up vs. having *everything* routed through one 
>> singlethread workqueue?
> 
> Just because it -can-, does not mean it should.
> 
> Unless there is a -proven- need for the operations to be parallel, you 
> should avoid the burden of such complexity.

There is no additional complexity by having the driver create its own workqueue; it just calls create_workqueue during probe and destroy_workqueue during remove.

James
