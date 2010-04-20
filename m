Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48683 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab0DTHqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 03:46:40 -0400
Received: by pwj9 with SMTP id 9so4001355pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Apr 2010 00:46:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19405.19620.199172.233574@gargle.gargle.HOWL>
References: <1271691883-13133-1-git-send-email-tom.leiming@gmail.com>
	 <19405.11838.119234.371361@gargle.gargle.HOWL>
	 <y2ud82e647a1004192259nec8aad6dy836b76b2211b6a40@mail.gmail.com>
	 <19405.19620.199172.233574@gargle.gargle.HOWL>
Date: Tue, 20 Apr 2010 15:46:38 +0800
Message-ID: <w2wd82e647a1004200046gecfbc655y889759c27caad557@mail.gmail.com>
Subject: Re: [PATCH] ath9k-htc: speedup disconnect handling
From: Ming Lei <tom.leiming@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/4/20 Sujith <Sujith.Manoharan@atheros.com>:
> Ming Lei wrote:
>> If ATH_DBG_RESET is enabled, you will find the debug messages
>> below[1] during disconnecting.  From the messages, the short hang should
>> be caused by the 'RTC stuck in MAC reset'. Once the patch is applied,
>> no such issue will happen.
>
> I take it that you didn't have ATH_DBG_WMI in your debug mask.
> A simpler way to fix this issue is to deny all WMI commands once
> the target has been unplugged - something like the attached patch.
>
> Can you check if it fixes your issue ?

Yes,  the patch does fix the issue.

Thanks,

-- 
Lei Ming
