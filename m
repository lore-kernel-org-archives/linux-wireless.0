Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2720 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab1EOTyl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2011 15:54:41 -0400
Message-ID: <4DD02F72.3070905@broadcom.com> (sfid-20110515_215444_043618_BD0F0BA4)
Date: Sun, 15 May 2011 21:54:26 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "Clemens Noss" <cnoss@gmx.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>
Subject: Re: [PATCH] staging: brcm80211: fix cast to pointer from
 integer
References: <1305479060-22755-1-git-send-email-cnoss@gmx.de>
 <4DD01708.3000603@hauke-m.de>
In-Reply-To: <4DD01708.3000603@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/15/2011 08:10 PM, Hauke Mehrtens wrote:
> On 05/15/2011 07:04 PM, Clemens Noss wrote:
>> bcm_pktq_flush and related functions only ever get 0 or a pointer for
>> arg, so make it a pointer.
>>
>> This might fix a crash on 64bit.
>>
>> Signed-off-by: Clemens Noss<cnoss@gmx.de>
>> ---
> Why don't you use the correct pointer type here instead of casting then
> around and the parameter names are meaningless too.
>
> static bool cb_del_ampdu_pkt(struct sk_buff *mpdu, struct
> cb_del_ampdu_pars *ampdu_pars)
>
> The signature of dma_cb_fn_ampdu(void *txi, void *arg_a) should be
> changed too.
Actually this is a generic callback mechanism in which an additional 
parameter can be passed, which can be of *any* type hence a void pointer 
seems justified here and a meaningless name is used. I do agree that the 
txi parameter will always be a struct sk_buff and should be indicated as 
such.

Apart from that: good catch. This indeed may cause issues on 64-bit systems.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


