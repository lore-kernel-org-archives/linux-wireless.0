Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:32846 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933265Ab2EOSaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 14:30:35 -0400
Received: by wibhj8 with SMTP id hj8so3155798wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 11:30:34 -0700 (PDT)
References: <1336652854-16163-1-git-send-email-gwingerde@gmail.com> <20120515122257.1e58ee43@north>
In-Reply-To: <20120515122257.1e58ee43@north>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=utf-8
Message-Id: <0D1E4D3E-3811-4026-8F33-495D31112E84@gmail.com> (sfid-20120515_203045_845033_58819F13)
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
	"<users@rt2x00.serialmonkey.com>" <users@rt2x00.serialmonkey.com>,
	=?utf-8?Q?AlexVillac=C3=AD=C2=ADs_Lasso?=
	<a_villacis@palosanto.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: Add support for RT5360 based PCI devices.
Date: Tue, 15 May 2012 20:30:33 +0200
To: Jakub Kicinski <kubakici@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jakub,

On 15 mei 2012, at 12:22, Jakub Kicinski <kubakici@wp.pl> wrote:

> Hi,
> 
> On Thu, 10 May 2012 14:27:33 +0200 Gertjan van Wingerde <gwingerde@gmail.com> wrote:
>> From: Alex Villací­s Lasso <a villacis@palosanto.com>
>> 
>> This chip is used at least by the D-Link DWA-525 adapter.
> 
> I have some concerns regarding this patch. 
> 
> First of all Gertjan, I think you removed define of RF5360 and it
> doesn't compile now ;-)

Ouch. Don't know what happened here, as I have compile tested it and tested it with an actual card. Probably something went wrong when merging in the tree that I use to generate and send patches.
Will send a v2 tomorrow, when I return home.

> 
> Secondly looking at legacy driver, 5360 is just another PCI ID of 5390
> family, do we really need to add all these cases? I think maybe adding
> PCI ID, as Zero Lin did recently with 539b will be sufficient? 

This is really needed. For some reason Ralink are separating the RF definitions here, even though they are all programmed the same.
I do own the D-Link card I mentioned in the commit message, and testing has shown these cases are needed.
Apparently it is not needed for the 539b.

---
Gertjan