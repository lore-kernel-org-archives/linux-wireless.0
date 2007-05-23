Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:40474 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755450AbXEWU6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2007 16:58:34 -0400
Message-ID: <4654965D.1020401@linux.intel.com>
Date: Wed, 23 May 2007 12:30:37 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <200705162151.32910.flamingice@sourmilk.net> <46534172.5040106@linux.intel.com> <46537603.6040208@garzik.org> <4653654F.1060708@linux.intel.com> <46537FA4.2040907@garzik.org> <46537536.8070500@linux.intel.com> <465391A5.4090608@garzik.org> <46548538.9080002@linux.intel.com> <46549D08.3010109@garzik.org>
In-Reply-To: <46549D08.3010109@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeff Garzik wrote:
> James Ketrenos wrote:
>> Given the API mac80211 exposes, and how the stack operates, I don't 
>> see how using ifsta->work as the workqueue allows the driver to no 
>> longer evaluate the potential for deadlocks and races.
> 
> For the operations in the workqueue, they are obviously serialized.

And the inverse is also true -- operations not on the workqueue are not serialized.  The driver must handle both.

>> To make the most use of the processing and power resources available, 
>> you must execute in parallel.
> 
> That's some impressive English parsing, but clearly wrong on the face of 
> it.

If you have N cores on a CPU and more than one is up, but only one gets to do anything because you've serialized everything onto a single workqueue, you are wasting CPU resources.  When you waste CPU resources you decrease system efficiency and increase power consumption.  

If you have N cores and only one is up, then the scheduler can decide to run serially if it wants, or wake up a core, or do whatever it wants.  The driver certainly shouldn't dictate policy and force everything to run serially.

> The Linus mantra cited is about MINIMALIZATION.  When you say "to 
> make the most use of..." you are MAXIMIZING something that need not be 
> maximized.

I'm really not following what your point is here.  In an attempt to twist my words, you're now saying we shouldn't maximize system efficiency.

> As repeated many times, there is no NEED to execute this slow path stuff 
> in parallel.  

I must have missed the thread where you said that many times, let alone where you proved that there is no benefit or need to  running "this slow path stuff" (however you are defining that to be) in parallel.

A driver should not be written in a way which suppresses the kernel's ability to optimize execution by forcing serialization of disjointed operations through a single workqueue.

James
