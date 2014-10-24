Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52397 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbaJXHtX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 03:49:23 -0400
Received: by mail-wi0-f173.google.com with SMTP id ex7so551062wid.12
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2014 00:49:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANzpp-kV8LzPgeXHq=DHKsLSdTT+-9gjj08RXST4r3-QOtkanw@mail.gmail.com>
References: <CANzpp-=opT==PUf5FhWi_cbB91+RhWk+jB7M4bfUCqh2wzQA2A@mail.gmail.com>
	<CA+BoTQmHGtO+XCRg1_jJstm+wHRQLU9sEpBRJ7U+_xO3nq7_VA@mail.gmail.com>
	<CANzpp-kV8LzPgeXHq=DHKsLSdTT+-9gjj08RXST4r3-QOtkanw@mail.gmail.com>
Date: Fri, 24 Oct 2014 09:49:22 +0200
Message-ID: <CA+BoTQn0iEYEQJ4AdO7xfRSHjX1CfO_uovPaxbtxSWQw0vPS+Q@mail.gmail.com> (sfid-20141024_094932_261301_6FE72E42)
Subject: Re: Change channel bandwidth without iw command
From: Michal Kazior <michal.kazior@tieto.com>
To: Okhwan Lee <ohlee@mwnl.snu.ac.kr>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 October 2014 08:57, Okhwan Lee <ohlee@mwnl.snu.ac.kr> wrote:
> Hi,
>
> Thank you for your answer.
>
>> The panic printout would be most helpful. My best guess is this
>> crashes in ath10k_dbg() at the very beginning of ath10k_config_chan
>> because ar->chandef.chan is NULL. This is probably the case since you
>> use monitor_chandef which is probably "empty" at the point you invoke
>> your code.
>
> First, we confirm that ar->chandef.chan is not NULL.
> We find out the the error occurs when "wait_for_completion_timeout" is called.
> Ath10k is trying to stop vdev (monitor_dev) when change the channel setting.
> We have no idea about the details of function, but it make waiting
> time duration for previous event.
> We also test by replacing wait_for_completion_timeout to
> wait_for_completion (i.e., it use maximum timeout value)
> But the kernel panic is still there.
>
> However, it is not easy to printout the messages when the panic is occurred,
> because the system stop (similar to bluescreen in widnows?).
> After reboot the system, the log messagess from panic is not recored
> in kernel log messages (/var/log/syslog, dmesg, kernel_llog) .

Can you at least do a photo of the panic, post it to an image hosting
site and link it, please?


Michał
