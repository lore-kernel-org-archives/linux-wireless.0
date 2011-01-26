Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42003 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab1AZT2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 14:28:53 -0500
Received: by qyj19 with SMTP id 19so6103246qyj.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 11:28:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinx1Tpp10ToiVB-VuGt01iwDFhWrmw0Tf3o9BVu@mail.gmail.com>
References: <1295929904-11806-1-git-send-email-me@bobcopeland.com>
	<20110125135249.GA2610@redhat.com>
	<20110126015034.GA8600@hash.localnet>
	<AANLkTinx1Tpp10ToiVB-VuGt01iwDFhWrmw0Tf3o9BVu@mail.gmail.com>
Date: Wed, 26 Jan 2011 14:28:52 -0500
Message-ID: <AANLkTi=2csN2V0tBFSVfXJsvg7UDh9U-i9fStJS6Gv_T@mail.gmail.com>
Subject: Re: [PATCH 1/2] ath5k: fix error handling in ath5k_hw_dma_stop
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Bruno Randolf <br1@einfach.org>,
	jirislaby@gmail.com, lrodriguez@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 26, 2011 at 12:06 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2011/1/26 Bob Copeland <me@bobcopeland.com>:
>>
>> As a side note, we still quit when the first error is encountered.
>> Maybe we should try stopping all of the queues anyway if one fails?
>> On the other hand we could spend a lot of time polling the registers
>> if the card is truly hosed, so I think this is best for now.
>
> It's better to continue with hw reset if a queue fails to stop, it
> usually means the dma unit needs reset.

Yeah, I thought that may be the case.  So the code as it stands plus
this patch from the thread will do what we want -- continue reset as
soon as any queue exhibits problems.

-- 
Bob Copeland %% www.bobcopeland.com
