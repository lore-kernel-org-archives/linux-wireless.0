Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:15679 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbYLaOdx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 09:33:53 -0500
Message-ID: <495B82CB.6050205@tuffmail.co.uk> (sfid-20081231_153411_950713_34DE3FEE)
Date: Wed, 31 Dec 2008 14:33:47 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	linux-pm@lists.linux-foundation.org,
	USB list <linux-usb@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
References: <348894.23448.qm@web23108.mail.ird.yahoo.com>
In-Reply-To: <348894.23448.qm@web23108.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> --- On Tue, 30/12/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>   
>> Alan Jenkins wrote:
>>     
>>> That won't fix hibernation though.  The disconnect
>>>       
>> method can still get
>>     
>>> called in resume from hibernation, before the
>>>       
>> workqueue gets unfrozen. 
>>     
>>> To be honest, I'm far more interested in
>>>       
>> suspend-to-disk than
>>     
>>> suspend-to-ram.
>>>       
>> Does this patch fix your problem? It works here, but I only
>> did one
>> test. The patch is for wireless-testing.
>>
>> Larry
>>     
>
> My test is that STD works alright, but STR still does not work. I haven't tried STD for a long time - I mostly use STR with SUSPEND_MODULES -, so I have no idea if STD works before the patch or not. With the patch, I can suspend to RAM (removing my SUSPEND_MODULES workaround temporarily), but it would not "defrost - this is similiar to  my failed attempt at fixing this - adding some skeleton _suspend()/_resume() routines can get the driver to STR, but it won't defrost. Without any _suspend()/_resume() routines, it won't even suspend, but just spend ages trying to suspend.
>
> I'll post your patch to http://bugzilla.kernel.org/show_bug.cgi?id=11887  as a work-in-progress...
>
> Hin-Tak

Thanks for the patch.  I tested STD too, and it doesn't seem to hang
anymore.  I even tested removing the adaptor while the system was
hibernated.  However, after resume the interface is useless.

I get a kernel error message, which repeats regularly (something like
every 5 or 10 seconds):

    phy0: Reset timeout!

and it doesn't work:

    # iwlist wlan0 scan
    wlan0     Interface doesn't support scanning : Network is down

    # ifconfig wlan0 up
    SIOCSIFFLAGS: Connection timed out

I have to re-plug the adaptor, and then it works again.

Regards
"Alan J"
