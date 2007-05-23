Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:36621 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbXEWT7K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2007 15:59:10 -0400
Message-ID: <46549D08.3010109@garzik.org>
Date: Wed, 23 May 2007 15:59:04 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: James Ketrenos <jketreno@linux.intel.com>
CC: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <200705162151.32910.flamingice@sourmilk.net> <46534172.5040106@linux.intel.com> <46537603.6040208@garzik.org> <4653654F.1060708@linux.intel.com> <46537FA4.2040907@garzik.org> <46537536.8070500@linux.intel.com> <465391A5.4090608@garzik.org> <46548538.9080002@linux.intel.com>
In-Reply-To: <46548538.9080002@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

James Ketrenos wrote:
> Given the API mac80211 exposes, and how the stack operates, I don't see 
> how using ifsta->work as the workqueue allows the driver to no longer 
> evaluate the potential for deadlocks and races.

For the operations in the workqueue, they are obviously serialized.


> The second argument you made:
> 
>    "And then there is the Linus mantra:  do what you must, and no more.  
> No need for additional workqueues has been demonstrated."
> 
> To make the most use of the processing and power resources available, 
> you must execute in parallel.

That's some impressive English parsing, but clearly wrong on the face of 
it.  The Linus mantra cited is about MINIMALIZATION.  When you say "to 
make the most use of..." you are MAXIMIZING something that need not be 
maximized.

As repeated many times, there is no NEED to execute this slow path stuff 
in parallel.  Though yes, I agree parallel execution maximized power drain.

	Jeff


