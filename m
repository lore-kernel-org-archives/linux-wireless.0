Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:47147 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbYF0KnZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 06:43:25 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KCBQE-000092-MG
	for linux-wireless@vger.kernel.org; Fri, 27 Jun 2008 10:43:18 +0000
Received: from lst-amand-152-33-14-15.w82-127.abo.wanadoo.fr ([82.127.45.15])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jun 2008 10:43:18 +0000
Received: from fabien by lst-amand-152-33-14-15.w82-127.abo.wanadoo.fr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jun 2008 10:43:18 +0000
To: linux-wireless@vger.kernel.org
From: Fabien Crespel <fabien@crespel.net>
Subject: Re: [PATCH v2] iwl3945: fix up rfkill kconfig and input
Date: Fri, 27 Jun 2008 12:47:48 +0200
Message-ID: <4864C554.905@crespel.net> (sfid-20080627_124329_546225_183F0D6A)
References: <f6ca9fed0806261455j17848d17pa011ae47246a32@mail.gmail.com>	 <200806270015.00301.IvDoorn@gmail.com>	 <f6ca9fed0806261527q75df34d4scbe36e2f63cec275@mail.gmail.com>	 <200806270045.50169.IvDoorn@gmail.com>	 <4666621.1214520962096.JavaMail.oracle@acsmt301.oracle.com> <1214558514.14590.380.camel@debian.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Randy Dunlap
	<public-randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@ciao.gmane.org>,
	drago01 <public-drago01-Re5JQEeQqe8AvxtiuMwx3w@ciao.gmane.org>,
	Ivo van Doorn
	<public-ivdoorn-Re5JQEeQqe8AvxtiuMwx3w@ciao.gmane.org>,
	Abhijeet Kolekar
	<public-abhijeet.kolekar-ral2JQCrhuEAvxtiuMwx3w@ciao.gmane.org>,
	"John W. Linville"
	<public-linville-2XuSBdqkA4R54TAoqtyWWQ@ciao.gmane.org>,
	Henrique de Moraes Holschuh
	<public-hmh-N3TV7GIv+o9fyO9Q7EP/yw@ciao.gmane.org>
In-Reply-To: <1214558514.14590.380.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

After looking at these patches about rfkill for iwlwifi, I fail to see 
the use of the input layer. To me, it seems the input device is 
allocated, registered, and eventually unregistered. But not used at all.

Furthermore, the only key bit set is the KEY_WLAN one, and a wireless 
device driver should NOT issue such events, according to the rfkill 
documentation:

"Most wireless communication device drivers implementing rfkill 
functionality MUST NOT generate these events, and have no reason to 
register themselves with the input layer.  Doing otherwise is a common 
misconception.  There is an API to propagate rfkill status change 
information, and it is NOT the input layer."

So the only drivers that should register to the input layer for such 
events are the laptop platform drivers (thinkpad-acpi, asus-laptop, etc.)

Therefore I would recommend removing the input device completely from 
iwlwifi, and of course the dependency on CONFIG_INPUT.

- Fabien.

