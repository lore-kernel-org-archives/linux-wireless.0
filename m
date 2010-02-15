Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 26.mail-out.ovh.net ([91.121.27.225]:57931 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756101Ab0BOWGe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 17:06:34 -0500
Message-ID: <4B79C565.1050701@free.fr>
Date: Mon, 15 Feb 2010 23:06:29 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: jirislaby@gmail.com, mickflemm@gmail.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: Fix TX/RX padding for all frames
References: <1266190577-2423-1-git-send-email-benoit.papillault@free.fr> <b6c5339f1002151215y4c7d2f33yfd32916e0500b55c@mail.gmail.com>
In-Reply-To: <b6c5339f1002151215y4c7d2f33yfd32916e0500b55c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland a écrit :
> On Sun, Feb 14, 2010 at 6:36 PM, Benoit Papillault
> <benoit.papillault@free.fr> wrote:
>   
>> Instead of computing the padding size based on the IEEE 802.11 header length,
>> we directly compute the padding position first and then the padding size next.
>> We have changed some functions to pass them the padding size directly. It has
>> been tested using a monitor interface in TX and RX against a different chipset
>> (zd1211rw to name it)
>>     
>
> Can you tell what the functional difference is between the old code and new
> code?  E.g. a padding that would be incorrectly computed from before?
>
>   
Correct. On some frames padding is incorrect. This patch is more for 
completeness since incorrect padding is only found by sending every kind 
of frames using a monitor interface. Moreover, since monitor interface 
are sometimes used to debug other issues, it's better not to have bugs here.

Regards,
Benoit
