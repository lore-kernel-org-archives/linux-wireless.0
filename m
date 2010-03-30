Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:24633 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab0C3WCF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 18:02:05 -0400
Subject: Re: Problem with IW5300
From: reinette chatre <reinette.chatre@intel.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>,
	"lee_matheson@hotmail.com" <lee_matheson@hotmail.com>
In-Reply-To: <4BB25756.2040201@lwfinger.net>
References: <4BB25756.2040201@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 15:01:59 -0700
Message-ID: <1269986519.2446.3467.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

On Tue, 2010-03-30 at 12:56 -0700, Larry Finger wrote:
> His problem is that the wireless keeps getting a microcode error and is dropping
> and remaking the connection about every 40 seconds. It logs the following:

How severe is the impact of this restart? Does "remake the connection"
mean that a reassociation is needed?

> [  652.749175] iwlagn 0000:04:00.0: Microcode SW error detected.  Restarting
> 0x2000000.
> [  652.749201] iwlagn 0000:04:00.0: Start IWL Error Log Dump:
> [  652.749207] iwlagn 0000:04:00.0: Status: 0x000212E4, count: 5
> [  652.749346] iwlagn 0000:04:00.0: Desc                               Time
>   data1      data2      line
> [  652.749356] iwlagn 0000:04:00.0: NMI_INTERRUPT_WDG            (#04)
> 1197632519 0x00000002 0x07030000 3664
> [  652.749361] iwlagn 0000:04:00.0: blink1  blink2  ilink1  ilink2
> [  652.749367] iwlagn 0000:04:00.0: 0x005AA 0x006E8 0x008B2 0x0CF76

This is the firmware watchdog timer kicking in because something is
hanging in firmware or maybe just talking too long. Unfortunately quite
a few of these have been popping up recently, so far I have recorded six
bug reports with the same line number you are reporting here.

You could try the patches accompanying
https://bugzilla.kernel.org/show_bug.cgi?id=15374 ... that will not make
the firmware error go away, but should help with cleanup when it does
occur and hopefully enable the connection to recover without user
noticing ... although I am not sure about that if this error is hit so
often.

Reinette


