Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33292 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbXFYQbW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2007 12:31:22 -0400
Message-ID: <467FE3BE.5040206@redhat.com>
Date: Mon, 25 Jun 2007 17:48:14 +0200
From: Michal Schmidt <mschmidt@redhat.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Matteo Croce <rootkit85@yahoo.it>, linux-wireless@vger.kernel.org
Subject: Re: airo
References: <200706061903.13228.rootkit85@yahoo.it>	 <46693003.8090406@redhat.com> <200706091519.29319.rootkit85@yahoo.it>	 <200706091816.47618.rootkit85@yahoo.it>  <467FD362.8000602@redhat.com> <1182783939.5449.1.camel@xo-13-A4-25.localdomain> <467FDC79.6090102@redhat.com>
In-Reply-To: <467FDC79.6090102@redhat.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Schmidt wrote:
> Dan Williams wrote:
>> Wow, that's somewhat ugly.  Do other drivers just not have this problem,
>> or have they worked around it in similar or different ways?  Just trying
>> to understand if the scope of the issue is wider than just airo.
> 
> For instance, drivers/net/wireless/atmel.c looks very similar, so I
> guess it has the same race. With airo the race is just more visible,
> because of all the long sleeps it does between getting the name with
> dev_alloc_name and finally registering it.
> 
> eepro100.c takes rtnl_lock to avoid the issue. So does ns83820.c - it
> has a big comment about how ugly it is.

A cleaner way would be to do most of the initialization later, from the
->open() method. I'll explore how workable this approach would be.

Michal
