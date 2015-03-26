Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58544 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbbCZQGH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 12:06:07 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Jean-Pierre TOSONI" <jp.tosoni@acksys.fr>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: DFS ETSI conformance for weather channels (again)
References: <773DB8A82AB6A046AE0195C68612A319019FF0E8@sbs2003.acksys.local>
Date: Thu, 26 Mar 2015 18:05:55 +0200
In-Reply-To: <773DB8A82AB6A046AE0195C68612A319019FF0E8@sbs2003.acksys.local>
	(Jean-Pierre TOSONI's message of "Thu, 26 Mar 2015 11:58:40 +0100")
Message-ID: <87619nagm4.fsf@kamboji.qca.qualcomm.com> (sfid-20150326_170611_560310_75AE76DA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Jean-Pierre TOSONI" <jp.tosoni@acksys.fr> writes:

> Hi list,
>
> I just stumbled on this patch that IMHO was rejected for a bad reason:
>
>   [PATCH v3 4/4] cfg80211: DFS use 10 minutes CAC when weather channels
>   At http://www.spinics.net/lists/linux-wireless/msg115296.html
>
> The reason given is the "unachievable" requirement in the ETSI norm of
> 99.99% detection success. It was even considered disabling the weather
> channels.
>
> *But the norm (ETSI EN 301 893 V1.7.1) does not say this.* It states
> that 99.99% is the target performance:
>
>  - during conformance tests only, (5.3.8.1.1 paragraph 5)
>  - specifically *not* a requirement with specific real life radars,
> (5.3.8.1.1 paragraph 5)
>  - on a limited series of 20 tests, (5.3.8.2.1.2 item g)
>  - with a pulse power at +10dB above other pulse detection tests,
> (5.3.8.2.1.2 item f)
>  - with some patterns excluded from the test. (5.3.8.2.1.2 item g)
>
> Hence it is very possible that existing products can achieve the
> conformance test target.
>
> That being said, would it be possible to reexamine that dropped patch
> and apply it?

Don't we support this by getting the CAC time in the regulatory
database?

commit 31559f35c5724976fd975e5d7e90cdb693b8dd27
Author: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Date:   Fri Feb 21 19:46:13 2014 +0100

    cfg80211: DFS get CAC time from regulatory database
    
    Send Channel Availability Check time as a parameter
    of start_radar_detection() callback.
    Get CAC time from regulatory database.
    
    Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

-- 
Kalle Valo
