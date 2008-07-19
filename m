Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:38340 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYGSEBl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 00:01:41 -0400
Received: by an-out-0708.google.com with SMTP id d40so270303and.103
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2008 21:01:41 -0700 (PDT)
Date: Sat, 19 Jul 2008 00:01:38 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 5/4] rfkill: query EV_SW states when rfkill-input
	connects to a input device
Message-ID: <20080719040138.GB29551@anvil.corenet.prv> (sfid-20080719_060145_026450_46131DF3)
References: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br> <1216331814-31802-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1216331814-31802-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henrique,

On Thu, Jul 17, 2008 at 06:56:54PM -0300, Henrique de Moraes Holschuh wrote:
> Every time a new input device that is capable of one of the rfkill EV_SW
> events (currently only SW_RFKILL_ALL) is connected to rfkill-input, we must
> check the switch state and take action.
> 
> Otherwise, we will ignore the initial switch state.
> 

I think this task is more suited for the ->start() method of the input
handler. This way, if userspace grabs the switch input device and then
releases it rfkill will get a chance to re-synchronize with the switch
state.

Also I think it would be a good idea to take input_dev->event_lock
while scheduling the state change so that the switch state does not
change underneath you.

-- 
Dmitry
