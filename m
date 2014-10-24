Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:49262 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbaJXLin convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 07:38:43 -0400
Received: by mail-wg0-f49.google.com with SMTP id x12so875802wgg.8
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2014 04:38:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <etPan.544a384b.74b0dc51.8406@Mac-Pro.local>
References: <CANzpp-=opT==PUf5FhWi_cbB91+RhWk+jB7M4bfUCqh2wzQA2A@mail.gmail.com>
	<CA+BoTQmHGtO+XCRg1_jJstm+wHRQLU9sEpBRJ7U+_xO3nq7_VA@mail.gmail.com>
	<CANzpp-kV8LzPgeXHq=DHKsLSdTT+-9gjj08RXST4r3-QOtkanw@mail.gmail.com>
	<CA+BoTQn0iEYEQJ4AdO7xfRSHjX1CfO_uovPaxbtxSWQw0vPS+Q@mail.gmail.com>
	<etPan.544a384b.74b0dc51.8406@Mac-Pro.local>
Date: Fri, 24 Oct 2014 13:38:42 +0200
Message-ID: <CA+BoTQkxX1fhQVGx7jUkoG6NRz+EP+ZWJwAvNwqHDNv5Fw4COA@mail.gmail.com> (sfid-20141024_133847_729364_7DDB4BEB)
Subject: Re: Change channel bandwidth without iw command
From: Michal Kazior <michal.kazior@tieto.com>
To: Okhwan Lee <ohlee@mwnl.snu.ac.kr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 October 2014 13:30, Okhwan Lee <ohlee@mwnl.snu.ac.kr> wrote:
>  Hi,
>
> This linked images are the printed error messages when the kernel is in panic.
> http://www.mwnl.snu.ac.kr/~ohlee/1.jpg
> http://www.mwnl.snu.ac.kr/~ohlee/2.jpg

Thanks.

Panic doesn't seem to include anything directly related to ath10k
which suggests this may be some nasty memory corruption issue. You
might want to enable memory debugging when building kernel (Kernel
Hacking) - hopefully it'll get some extra info before the panic.

How did you come to a conclusion that ath10k's monitor vdev stopping
and wait_for_completion_timeout() are involved?


Michał
