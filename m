Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:46618 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbZIXPMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 11:12:30 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1885330fge.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 08:12:32 -0700 (PDT)
Message-ID: <4ABB8C5E.6070402@tuffmail.co.uk>
Date: Thu, 24 Sep 2009 16:12:30 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Norbert Preining <preining@logic.at>,
	linux-wireless@vger.kernel.org, Mattia Dongili <malattia@linux.it>,
	"Almer S. Tigelaar" <almer@gnome.org>,
	Matthias Welwarsky <matze@welwarsky.de>
Subject: Re: rfkill hard state after booting
References: <20090924130231.GU21590@gamma.logic.tuwien.ac.at>	 <1253801252.3868.108.camel@johannes.local>	 <4ABB89B2.8070302@tuffmail.co.uk> <1253804713.3868.168.camel@johannes.local>
In-Reply-To: <1253804713.3868.168.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2009-09-24 at 16:01 +0100, Alan Jenkins wrote:
>
>   
>> I think it's pretty clear it's in the sony code.  It doesn't call
>> set_hw_state() during init.  I.e. (completely untested):
>>     
>
> Agree, looking at the code this seems reasonable.
>
> Although maybe it should just call sony_nc_rfkill_update() after
> registering all of them?
>
> johannes
>   

That means the initial "add" uevents etc. will contain wrong values (and
then be updated immediately after).  Do we care about that?  It's
unlikely to matter in practice for platform devices which only get
loaded at boot-time, but perhaps it would set a bad example.

Regards
Alan
