Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33179 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959Ab0C3XJT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:19 -0400
Received: by gwaa18 with SMTP id a18so5002859gwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 16:09:18 -0700 (PDT)
Message-ID: <4BB2849C.8060105@lwfinger.net>
Date: Tue, 30 Mar 2010 18:09:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	"lee_matheson@hotmail.com" <lee_matheson@hotmail.com>
Subject: Re: Problem with IW5300
References: <4BB25756.2040201@lwfinger.net> <1269986519.2446.3467.camel@rchatre-DESK>
In-Reply-To: <1269986519.2446.3467.camel@rchatre-DESK>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/2010 05:01 PM, reinette chatre wrote:
> Hi Larry,
> 
> On Tue, 2010-03-30 at 12:56 -0700, Larry Finger wrote:
>> His problem is that the wireless keeps getting a microcode error and is dropping
>> and remaking the connection about every 40 seconds. It logs the following:
> 
> How severe is the impact of this restart? Does "remake the connection"
> mean that a reassociation is needed?
> 
>> [  652.749175] iwlagn 0000:04:00.0: Microcode SW error detected.  Restarting
>> 0x2000000.
>> [  652.749201] iwlagn 0000:04:00.0: Start IWL Error Log Dump:
>> [  652.749207] iwlagn 0000:04:00.0: Status: 0x000212E4, count: 5
>> [  652.749346] iwlagn 0000:04:00.0: Desc                               Time
>>   data1      data2      line
>> [  652.749356] iwlagn 0000:04:00.0: NMI_INTERRUPT_WDG            (#04)
>> 1197632519 0x00000002 0x07030000 3664
>> [  652.749361] iwlagn 0000:04:00.0: blink1  blink2  ilink1  ilink2
>> [  652.749367] iwlagn 0000:04:00.0: 0x005AA 0x006E8 0x008B2 0x0CF76
> 
> This is the firmware watchdog timer kicking in because something is
> hanging in firmware or maybe just talking too long. Unfortunately quite
> a few of these have been popping up recently, so far I have recorded six
> bug reports with the same line number you are reporting here.
> 
> You could try the patches accompanying
> https://bugzilla.kernel.org/show_bug.cgi?id=15374 ... that will not make
> the firmware error go away, but should help with cleanup when it does
> occur and hopefully enable the connection to recover without user
> noticing ... although I am not sure about that if this error is hit so
> often.

>From what I see in the git log for mainline 2.6.34, these patches are already
there. If that is correct, the OP's problem should go away as I think the next
Milestone release of openSUSE should switch to 2.6.34-rcX.

Thanks for the response.

Larry

