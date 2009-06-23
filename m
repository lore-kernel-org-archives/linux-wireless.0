Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-gw51.mailanyone.net ([208.70.128.77]:58157 "EHLO
	smtp-gw51.mailanyone.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbZFWCi2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 22:38:28 -0400
Message-ID: <4A404024.3040903@cheek.com>
Date: Mon, 22 Jun 2009 22:38:28 -0400
From: Joseph Cheek <joseph@cheek.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: rootkit85@yahoo.it, parag.warudkar@gmail.com,
	gaurav.jauhar@atheros.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: [ath9k-devel] Pending ath9k bugs June, 2009
References: <43e72e890906220847u4faaeb2paa15365360c3c080@mail.gmail.com>	<4A3FD26C.4070503@cheek.com> <4A4013FD.7030004@cheek.com>
In-Reply-To: <4A4013FD.7030004@cheek.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok I have some debug information.  I have a machine set up as a
multimedia file server and as soon as I get 3 minutes into a video or
so, poof, the connection gets dropped. I stream over http but it happens
when I scp a file too.

I have a watchdog that checks the connection constantly and if pings
fail, it brings wlan0 down (rmmoding everything from ath9k to led_class)
and brings it back up again. It's a pain, but at least I can keep the
server up for weeks at a time that way.

With the attached log, the problems seems to start at 21:31:33 when I
get lots of problems I don't understand followed by lots of "receive
FIFO overrun interrupt" and then later more and more
"AR_INTR_SYNC_LOCAL_TIMEOUT". By 21:32:03, my watchdog has noticed no
pings are getting through and by 21:32:13 it has cycled the interface.
The log gets noticeably smaller then, as the http file transfer has
timed out.

the log is at
http://joseph.cheek.com/sites/default/files/ath9k.jun22.21.31+32.log_.bz2
and the hwinfo is at
http://joseph.cheek.com/sites/default/files/hwinfo.ath9k.  I have a blog
entry with a little more info at http://joseph.cheek.com/node/7.

Let me know if you need more info or want me to file a kernel.org bug. 
The kernel is today's wireless-testing git tree.

Thanks!

Joseph Cheek

Joseph Cheek wrote:
> ok, today's git tip is significantly better!  I get failed pings about
> once every hour, down from several times an hour with the last stable
> wireless-testing I could boot.  I'll get a log with modprobe ath9k
> debug=0xfffffffff and send the log again.
>
> Thanks!
>
> Joseph
>
> Joseph Cheek wrote:
>   
>> I will attempt to repro my xmit hangs bugs on today's wireless testing. 
>> I haven't submitted a kernel.org bug on it, just mentioned it on the
>> ath9k list several times.  I can submit a kernel.org bug for it tho,
>> assuming it repros (I've had it ever since Christmas, but who knows?).
>>
>> Joseph Cheek
>>
>> Luis R. Rodriguez wrote:
>>   
>>     
>>> We're down to 2 kernel.org bug reports for ath9k:
>>>
>>> http://bugzilla.kernel.org/show_bug.cgi?id=13581
>>> "ath9k doesn't work with newer kernels"
>>> This is a regression between 2.6.29 and 2.6.30, someone needs to look at this.
>>>
>>> http://bugzilla.kernel.org/show_bug.cgi?id=13141
>>> "AR5008/DWA-552 - Very slow"
>>> Patches have been supplied, needs user feedback.
>>>
>>> If you are aware of any other issues please do report.
>>>
>>>   Luis
>>> _______________________________________________
>>> ath9k-devel mailing list
>>> ath9k-devel@lists.ath9k.org
>>> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>>>
>>>   
>>>     
>>>       
>>   
>>     
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>   
