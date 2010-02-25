Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:46784 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932905Ab0BYR7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 12:59:55 -0500
Received: by fxm27 with SMTP id 27so1272938fxm.28
        for <linux-wireless@vger.kernel.org>; Thu, 25 Feb 2010 09:59:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b6c5339f1002250951q7ad35de6g2a15f7c77e454b9a@mail.gmail.com>
References: <6b5e31691002250640k154a1f22xa46bac547c69b250@mail.gmail.com>
	 <b6c5339f1002250951q7ad35de6g2a15f7c77e454b9a@mail.gmail.com>
Date: Thu, 25 Feb 2010 12:59:50 -0500
Message-ID: <6b5e31691002250959o576e203ena04858c8c9a76486@mail.gmail.com>
Subject: Re: Ath5k and Retransmissions (Retries)
From: Andrew Blaich <ablaich@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The main file I focused on was net/mac80211/rc80211minstrel.c, but I
have tried forcing retry values through the other portions of the
code.

I have tried setting the counts in the MRR array (ar[i].count) in the
minstrel_get_rate function, but that hasn't appeared to work,
additionally I tried limiting the max retry count.  I have had luck in
altering the rate used by changing the index value fed into ar[i].idx.
 Maybe my issue is with the MRR array.

 If I want the driver to try the packet once and only once , if it
fails (no ack) then give up, what would be the changes to make to the
MRR array.

 My understanding is I would set the ar[0].idx value the index for the
rate I want (this is not an issue), but then setting the ar[0].count,
do I set it to 1 to try and send it once, or is count simply the
number of retries to do after the initial send.  Also, if I set the
next entry in the MRR array ar[1].idx=-1 so as to not try any rate,
and then the count to 0 does this disable the rest of the MRR array,
or is it possible the hardware is populating the array with other
values?

-Andrew



On Thu, Feb 25, 2010 at 12:51 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Thu, Feb 25, 2010 at 9:40 AM, Andrew Blaich <ablaich@gmail.com> wrote:
>> Hi everyone,
>>
>>   I have been attempting, unsuccessfully, to alter the number
>> retransmissions any particular transmission rate uses.  My card is
>> reported as an AR5414 (Atheros) and the ath5k driver is being loaded.
>
> What exactly are you changing?  The MRR array determines how many
> retries there are for a given packet (hint, each packet has a
> set of 4 different rates and each rate has its own retry count).
> The driver also tells mac80211 the max number of retries.
>
> --
> Bob Copeland %% www.bobcopeland.com
>
