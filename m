Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36202 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab0DMSge (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 14:36:34 -0400
To: Bob Copeland <me@bobcopeland.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl1251: register platform_device to pass board data
References: <1271110918-18599-1-git-send-email-notasas@gmail.com>
	<87k4sbnvgo.fsf@purkki.valot.fi>
	<g2lb6c5339f1004131056v597857c0qf0da0dd093d6dbfa@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 13 Apr 2010 21:36:30 +0300
In-Reply-To: <g2lb6c5339f1004131056v597857c0qf0da0dd093d6dbfa@mail.gmail.com> (Bob Copeland's message of "Tue\, 13 Apr 2010 13\:56\:08 -0400")
Message-ID: <877hobnqs1.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> On Tue, Apr 13, 2010 at 12:55 PM, Kalle Valo <kvalo@adurom.com> wrote:
>>> However there is no way to pass this data through SDIO subsystem, so
>>> this patch registers dummy platform_device to allow that.
>
> No objection to the patch, platforms like android want this so
> you can set the gpio for irq handling instead of using the
> SDIO interrupts.

I talked with TI about the interrupts. They say SDIO interrupt should
not be used, instead we should always the external gpio line for the
interrupt.

> But maybe we should invent a way to send it through the SDIO
> subsystem?

I agree, that is the best option.

> My hope was that device trees on ARM would solve the issue
> eventually.

But no luck yet?

-- 
Kalle Valo
