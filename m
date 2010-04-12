Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:40945 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab0DLOD7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 10:03:59 -0400
Received: by qyk9 with SMTP id 9so210776qyk.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 07:03:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19394.52061.869979.530453@gargle.gargle.HOWL>
References: <1270911923-5783-1-git-send-email-tom.leiming@gmail.com>
	 <19394.52061.869979.530453@gargle.gargle.HOWL>
Date: Mon, 12 Apr 2010 22:03:58 +0800
Message-ID: <r2md82e647a1004120703pab24f9c5t6d2fe6980e8e2b2e@mail.gmail.com>
Subject: Re: [PATCH 3/3] ath9k-htc: pass cacheline aligned buffer to usb hcd
	in register out path
From: Ming Lei <tom.leiming@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/4/12 Sujith <Sujith.Manoharan@atheros.com>:
> tom.leiming@gmail.com wrote:
>> This patch copies skb->data of register out command to kmalloced buffer,
>> which is cacheline aligned(dma safe) and passed into usb hcd. Since the
>> data in register out command is not very much, we can ignore the
>> performance loss caused by the copy.
>
> Actually, the current code is correct, though a bit sub-optimal.
> The inital dev_alloc_skb() in ath9k_wmi_cmd() allocates a headroom
> for WMI header + HTC header. The headers are then pushed as the packet
> moves down through HTC. Finally, skb->data is passed to submit_urb().
>
> To take care of cacheline alignment, you can just replace the dev_alloc_skb()
> with alloc_skb(). A patch is welcome. :-)

OK, clever idea, I'll submit a new version.

-- 
Lei Ming
