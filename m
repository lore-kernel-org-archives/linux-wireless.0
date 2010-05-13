Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:2885 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932503Ab0EMUD2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 16:03:28 -0400
Message-ID: <4BEC5B0D.9060900@gmail.com>
Date: Thu, 13 May 2010 22:03:25 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 1/4] rt2x00: Fix failed SLEEP->AWAKE and AWAKE->SLEEP
 	transitions.
References: <1273778166-3833-1-git-send-email-gwingerde@gmail.com>	 <1273778166-3833-2-git-send-email-gwingerde@gmail.com> <AANLkTilccqteZvPru-_q1tRqcDLpAqE2DjIdMoUC0Ij_@mail.gmail.com>
In-Reply-To: <AANLkTilccqteZvPru-_q1tRqcDLpAqE2DjIdMoUC0Ij_@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/13/10 21:30, Ivo Van Doorn wrote:
> On Thu, May 13, 2010 at 9:16 PM, Gertjan van Wingerde
> <gwingerde@gmail.com> wrote:
>> (Based on a patch created by Ondrej Zary)
>>
>> In some circumstances the Ralink devices do not properly go to sleep
>> or wake up, with timeouts occurring.
>> Fix this by retrying telling the device that it has to wake up or
>> sleep.
>>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> 
> Nice catch, I think the legacy drivers also did this, but not too sure
> about that.
> Does this mean we can reenable the flag to enable powersaving by default?
> 

Not sure of that yet. There's one more thing that is on my TODO list on powersaving,
namely to not go to sleep if there are still active entries in the TX queues. This is
also done by the legacy, so we should check for that as well. The only issue is how to
make the device go to sleep once the TX queues are empty, as mac80211 will not inform
us again that we need to sleep.

---
Gertjan.
