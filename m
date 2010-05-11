Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:46228 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751635Ab0EKWCH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 18:02:07 -0400
Message-ID: <4BE9D3DB.7040005@dlasys.net>
Date: Tue, 11 May 2010 18:02:03 -0400
From: "David H. Lynch Jr." <dhlii@dlasys.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ar9170-fw II
References: <4BDC001F.9050202@dlasys.net> <4BDD2E05.40203@free.fr> <4BDD5EB3.7020802@dlasys.net> <201005021452.01101.chunkeey@googlemail.com>
In-Reply-To: <201005021452.01101.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/02/2010 08:52 AM, Christian Lamparter wrote:
> Well, then you have two more good reasons why to use carl9170:
>   * carl9170 has the ability to store additional per-frame data.
>     In fact, if you don't need to have a different retry rates
>     you could realloc the 3 * 32 bit "rr" (as in retry rate)
>     array in the carl9170_tx_superdesc and _carl9170_tx_superdesc
>     struct (see wlan.h) for your purposes (storage for your time values).
>
>     And if you fetched all the data, everything will be sent
>     with an ordinary tx status feedback report to the application
>     (add the timer fields into carl9170_tx_status and _carl9170_tx_status
>      struct - see fwcmd.h)
     cmd.h __check() tests for sizeof(carl9170_tx_status) != 2
     is there an assumption somewhere that carl9170_tx_status == 2 ?


-- 
Dave Lynch 					  	    DLA Systems
Software Development:  				         Embedded Linux
717.587.7774 	       dhlii@dlasys.net 	  http://www.dlasys.net
Over 25 years' experience in platforms, languages, and technologies too numerous to list.

"Any intelligent fool can make things bigger and more complex... It takes a touch of genius - and a lot of courage to move in the opposite direction."
Albert Einstein

