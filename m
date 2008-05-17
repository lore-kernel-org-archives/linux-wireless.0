Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:56843 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756859AbYEQV4Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2008 17:56:16 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JxUNv-0007BR-NE
	for linux-wireless@vger.kernel.org; Sat, 17 May 2008 21:56:13 +0000
Received: from cpc1-cwma5-0-0-cust137.swan.cable.ntl.com ([80.4.12.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2008 21:56:11 +0000
Received: from sitsofe by cpc1-cwma5-0-0-cust137.swan.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2008 21:56:11 +0000
To: linux-wireless@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: rt61pci breaks after hibernate
Date: Sat, 17 May 2008 22:54:33 +0100
Message-ID: <g0nk9b$n7v$1@ger.gmane.org> (sfid-20080517_235622_744063_9E58896C)
References: <g0mqn8$56h$1@ger.gmane.org> <200805171651.56973.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<posted & mailed>

Rafael J. Wysocki wrote:

> On Saturday, 17 of May 2008, Sitsofe Wheeler wrote:
>> After resuming from a hibernate to disk network packets are no longer
>> sent and NetworkManager shows that there is no signal. Doing ifconfig
>> wlan1 down && ifconfig wlan1 up results in the error message
>> "SIOCSIFFLAGS: No such device" being printed.
> 
> Is this a regression or did it work before?

It's not a regression. It turns out I was wrong in my other comment - this
never worked. Userspace was working around the problem by unloading the
driver before hibernation and loading it back in on resume (I switched to
module free kernel a few days ago). Building a kernel that prevents module
unloading shows similar results all the way back to 2.6.25 (although the
error switches to "SIOCSIFFLAGS: No buffer space available".

-- 
Sitsofe | http://sucs.org/~sits/

