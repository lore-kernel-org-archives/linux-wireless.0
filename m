Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.fenrir.org.uk ([81.168.115.223]:33008 "EHLO mx.fenrir.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865AbYDUOTO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 10:19:14 -0400
Received: from [62.189.241.202] (helo=[10.104.10.102])
	(TLSv1:AES256-SHA:256)
	by mx.fenrir.org.uk with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1JnwrQ-0005iu-UF
	for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 15:19:13 +0100
Message-ID: <480CA260.70506@fenrir.org.uk> (sfid-20080421_162006_486515_D95FEC5E)
Date: Mon, 21 Apr 2008 15:19:12 +0100
From: Brian Morrison <bdm@fenrir.org.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [ipw3945-devel] iwl3945: Disabled channels
References: <fuhkfp$mnk$1@ger.gmane.org>  <480C5AFF.5020005@fenrir.org.uk>	 (sfid-20080421_101455_395583_495A4EE6) <1208785818.26186.101.camel@johannes.berg>
In-Reply-To: <1208785818.26186.101.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>> If you're in the EU, I contributed a fix that has not yet made it into 
>> the iwlwifi code as it is under review (the whole regulatory aspect is 
>> difficult, there are so many caveats!).
> 
> Technically, it's cfg80211 code; the reason that it's not in yet is that
> I'm unsure about the legal situation of the ETSI and the national
> bodies, it seems to me that the ultimate decision is done by the
> national bodies and last I heard France had quite different restrictions
> than Germany, for example.


OK, sorry about the naming mixup, you are, of course, correct. I have 
not really got to grips with how all these different sub-systems fit 
together. I also see that the mac80211 and cfg80211 changes that are in 
Fedora have not made it into mainline 2.6.25, so I assume it will go 
into 2.6.26?

> 
> Does anyone have that info? I can dig up the info for Germany easily
> (the "Frequenznutzungsplan" is available on the regulatory agency web
> site as pdf)

Here is a link that came from the Wikipedia page I mentioned in my post:

http://www.arcep.fr/index.php?id=8571&L=1&tx_gsactualite_pi1%5Buid%5D=232&tx_gsactualite_pi1%5Bannee%5D=2003&tx_gsactualite_pi1%5Btheme%5D=0&tx_gsactualite_pi1%5Bmotscle%5D=&tx_gsactualite_pi1%5BbackID%5D=2122&cHash=a558568045

This document applies to the list of 58 departements shown. It says that 
with these departments all channels may be used indoors at +20dBm 
(100mW). Outdoors +10dBm (10mW) is allowed on all channels but below 
2454MHz +20dBm (100mW) is allowed. Another quick check shows that there 
are 100 departements in France. Also note that this dates from 2002 and 
states that new lists of departements will be published in 2003 and 
2004, so presumably the number of departements will have increased by now.

I can't imagine how this regulatory mess is enforceable or how any other 
OS/hardware combination does it. I'll have to say that I work for a 
company that produces Wi-Fi chips and products based on them and that we 
find the whole regulatory situation worldwide just as confusing as 
everyone else does.

A complete country/regulatory map is going to be very difficult to 
research and implement, I assume that we can't go far wrong if we used 
something like the Intel EEPROM contents as a guide to what can be done? 
I assume that local infrastructure will comply with local restrictions, 
so it's mainly IBSS use that needs controlling. And power output, which 
could be difficult if we need to know whether we're outdoors or not.

Comments folks?

-- 

Brian
