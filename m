Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:59754 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbaJXLaW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 07:30:22 -0400
Received: by mail-pd0-f180.google.com with SMTP id fp1so1312827pdb.11
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2014 04:30:22 -0700 (PDT)
Date: Fri, 24 Oct 2014 20:30:19 +0900
From: Okhwan Lee <ohlee@mwnl.snu.ac.kr>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"=?utf-8?Q?ath10k=40lists.infradead.org?="
	<ath10k@lists.infradead.org>
Message-ID: <etPan.544a384b.74b0dc51.8406@Mac-Pro.local> (sfid-20141024_133026_517873_67D15D72)
In-Reply-To: <CA+BoTQn0iEYEQJ4AdO7xfRSHjX1CfO_uovPaxbtxSWQw0vPS+Q@mail.gmail.com>
References: <CANzpp-=opT==PUf5FhWi_cbB91+RhWk+jB7M4bfUCqh2wzQA2A@mail.gmail.com>
 <CA+BoTQmHGtO+XCRg1_jJstm+wHRQLU9sEpBRJ7U+_xO3nq7_VA@mail.gmail.com>
 <CANzpp-kV8LzPgeXHq=DHKsLSdTT+-9gjj08RXST4r3-QOtkanw@mail.gmail.com>
 <CA+BoTQn0iEYEQJ4AdO7xfRSHjX1CfO_uovPaxbtxSWQw0vPS+Q@mail.gmail.com>
Subject: Re: Change channel bandwidth without iw command
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Hi, 

This linked images are the printed error messages when the kernel is in panic. 
http://www.mwnl.snu.ac.kr/~ohlee/1.jpg
http://www.mwnl.snu.ac.kr/~ohlee/2.jpg

Thank you for your help.

Okhwan


--  
Okhwan Lee
Sent with Airmail  

켜짐 2014년 10월 24일 에서 오후 4:49:23, Michal Kazior (michal.kazior@tieto.com(mailto:michal.kazior@tieto.com)) 작성됨:

> On 23 October 2014 08:57, Okhwan Lee wrote:
> > Hi,
> >
> > Thank you for your answer.
> >
> >> The panic printout would be most helpful. My best guess is this
> >> crashes in ath10k_dbg() at the very beginning of ath10k_config_chan
> >> because ar->chandef.chan is NULL. This is probably the case since you
> >> use monitor_chandef which is probably "empty" at the point you invoke
> >> your code.
> >
> > First, we confirm that ar->chandef.chan is not NULL.
> > We find out the the error occurs when "wait_for_completion_timeout" is called.
> > Ath10k is trying to stop vdev (monitor_dev) when change the channel setting.
> > We have no idea about the details of function, but it make waiting
> > time duration for previous event.
> > We also test by replacing wait_for_completion_timeout to
> > wait_for_completion (i.e., it use maximum timeout value)
> > But the kernel panic is still there.
> >
> > However, it is not easy to printout the messages when the panic is occurred,
> > because the system stop (similar to bluescreen in widnows?).
> > After reboot the system, the log messagess from panic is not recored
> > in kernel log messages (/var/log/syslog, dmesg, kernel_llog) .
>  
> Can you at least do a photo of the panic, post it to an image hosting
> site and link it, please?
>  
>  
> Michał

