Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48267 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbaAFPFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 10:05:31 -0500
Received: by mail-wg0-f44.google.com with SMTP id a1so15946043wgh.35
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jan 2014 07:05:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389019739.5891.16.camel@jlt4.sipsolutions.net>
References: <1388869583-2767-1-git-send-email-chaitanya.mgit@gmail.com> <1389019739.5891.16.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 6 Jan 2014 20:35:08 +0530
Message-ID: <CABPxzY+yP1N1xLBHcVvMss_E=+2_3M95bQCEaxbkzvF+wbtnCQ@mail.gmail.com> (sfid-20140106_160534_610292_9874C03F)
Subject: Re: [PATCH] mac80211: Fix the buffer length in debugfs for smps
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 6, 2014 at 8:18 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2014-01-05 at 02:36 +0530, Chaitanya T K wrote:
>> This was blocking sending SMPS action frames
>> through debugfs.
>
> I don't see any issue here, explain.
>
> johannes
>
buflen includes the new line character as well, hence the comparison
strncmp fails for all combiantions.

echo "static" > ieee80211/phyX/netdev\:wlanX/smps
Then

buf=static\n
buflen=7

But the comparison is with "static" which doesn't include "\n"
hence the comparison fails.
