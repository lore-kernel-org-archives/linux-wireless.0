Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59485 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab1HMDjk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 23:39:40 -0400
Received: by ywf7 with SMTP id 7so2368039ywf.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 20:39:40 -0700 (PDT)
Message-ID: <4E45F1AB.3060701@gmail.com> (sfid-20110813_053942_999880_565FFDF8)
Date: Fri, 12 Aug 2011 23:38:19 -0400
From: Roman Krylov <volyrkr@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: rtl8192* wifi driver
References: <4E45A973.6060305@gmail.com> <4E45AF82.5040407@lwfinger.net> <4E45D65F.6000306@gmail.com> <4E45DCB2.5020905@lwfinger.net> <4E45EA54.5010500@gmail.com> <4E45EF30.3070103@lwfinger.net>
In-Reply-To: <4E45EF30.3070103@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> What is your ESSID? Two lines up, I see 'Auto bhn 310' and one line up I see 
> 'bhn 310'. Based on my logs, those two should be the same. I'll set one of my 
> APs to the first ESSID and see if I can connect.
The first one 'Auto bhn 310' is NetworkManager's alias, the essid is 'bhn 310'.
> I found the problem in the driver you sent. One needs to add
>
> #include <linux/interrupt.h>
>
> to file include/osdep_service.h. Once I did that, it built and works.
This is probably due some changes in 3.1 since 3.0.1.
