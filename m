Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41491 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757011Ab1DXAaE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Apr 2011 20:30:04 -0400
Message-ID: <4DB36EBD.7060907@hauke-m.de>
Date: Sun, 24 Apr 2011 02:28:45 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Andreas Hartmann <andihartmann@01019freenet.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: building compat-wireless-2011-04-23 fails with 2.6.38.4
References: <4DB352B3.9060807@01019freenet.de>
In-Reply-To: <4DB352B3.9060807@01019freenet.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2011 12:29 AM, Andreas Hartmann wrote:
> Hello,
> 
> I got the following erros compiling compat-wireless-2011-04-23:
> 
> CC [M]  /Downloads/compat-wireless-2011-04-23/compat/main.o
> In file included from
> /Downloads/compat-wireless-2011-04-23/include/linux/compat-2.6.h:34:0,from
> <command-line>:0:
> /Downloads/compat-wireless-2011-04-23/include/linux/compat-2.6.39.h:103:32:
> error: redefinition of ‘kstrtoul’
> /usr/src/linux-2.6.38.4-1/include/linux/kernel.h:197:32: note: previous
> definition of ‘kstrtoul’ was here
...
> 
> 
> Could you please take a look at this problem?
> 
> 
> Thank you,
> Andreas

Hi Andreas,

in kernel 2.6.38.4 kstrto* was integrated into it, but compat-wireless
assumes that it is not there, because kernel <= 2.6.38.3 do not have it.
This should be fixed in compat-wireless, but there are some people with
older versions of the 2.6.38 kernel series out there like the users of
Ubuntu Natty 11.04. It will result in many bug reports if
compat-wireless does not work with the recent Ubuntu version. I will try
to find a solution to make it work with all versions of 2.6.38 tomorrow.

Hauke
