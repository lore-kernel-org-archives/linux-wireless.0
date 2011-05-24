Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32784 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab1EXN3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 09:29:41 -0400
Received: by bwz15 with SMTP id 15so5626681bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 06:29:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DDABAA2.7030706@lwfinger.net>
References: <4DDA6712.9090309@ring3k.org>
	<4DDABAA2.7030706@lwfinger.net>
Date: Tue, 24 May 2011 22:29:39 +0900
Message-ID: <BANLkTinfHf3jpb15ddi18HJ3xPz6YEk3zg@mail.gmail.com> (sfid-20110524_152944_556662_13A25BA3)
Subject: Re: [PATCH 5/8] rtlwifi: Don't block interrupts in spinlocks
From: Mike McCormack <mikem@ring3k.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 May 2011 04:50, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 05/23/2011 08:54 AM, Mike McCormack wrote:
>>
>> Now power state transitions are not called from an
>> interrupt context, there's no need to block interrupts.
>>
>> This code appears to block interrupts for too long,
>> causing my trackpad to lose sync occasionally.

> Does this patch and the previous one fix the loss of synch with the
> trackpad?

Yes, it appears to. (3 days with no losses of sync or crashes).  I was getting
problems with SATA too, and those have gone away.

I saw a similar problem with rtl8192e (from staging) and applied the
same solution.

thanks,

Mike
