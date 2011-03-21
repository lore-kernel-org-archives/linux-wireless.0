Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51718 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab1CUHyc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 03:54:32 -0400
Received: by eyx24 with SMTP id 24so1429956eyx.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 00:54:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300340306.11073.5784.camel@wimaxnb.nmp.nokia.com>
References: <1300309434-15491-1-git-send-email-eliad@wizery.com>
	<1300340306.11073.5784.camel@wimaxnb.nmp.nokia.com>
Date: Mon, 21 Mar 2011 09:54:31 +0200
Message-ID: <AANLkTik8DYUn7SuM_L2ciNnuBCK5TobOEcRBPm+gRnyw@mail.gmail.com>
Subject: Re: [PATCH] wl12xx: set the actual tid instead of the ac
From: Eliad Peller <eliad@wizery.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 17, 2011 at 7:38 AM, Juuso Oikarinen
<juuso.oikarinen@nokia.com> wrote:
> On Wed, 2011-03-16 at 23:03 +0200, ext Eliad Peller wrote:
>> When passing a tx frame, the driver incorrectly set desc->tid
>> with the ac instead of the actual tid.
>>
>> It has some serious implications when using 802.11n + QoS,
>> as the fw starts a BlockAck with the wrong tid (which finally
>> cause beacon loss and disconnection / some fw crash)
>>
>> Fix it by using the actual tid stored in skb->priority.
>
> How will the firmware handle the TIDs larger than 3, as currently to the
> firmware it appears only TID's 0-3 are configured, and the rest are
> whatever values happen to be there default?
>
that's a good question.
according to the fw guys, the fw auto-maps the tid to the correct ac.
the confusing thing is that ACX_TID_CFG actually gets AC as its input
(in the queue_id param) rather than TID.
thus, only 0-3 (ACs, not TIDs) are configured.

Eliad.
