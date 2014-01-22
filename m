Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:41671 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaAVNdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 08:33:15 -0500
Received: by mail-ig0-f175.google.com with SMTP id uq10so13879900igb.2
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 05:33:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140122130924.GA18365@magnum.frso.rivierawaves.com>
References: <1390391564-18481-1-git-send-email-karl.beldan@gmail.com>
	<1390394079.4334.30.camel@jlt4.sipsolutions.net>
	<20140122130924.GA18365@magnum.frso.rivierawaves.com>
Date: Wed, 22 Jan 2014 14:33:14 +0100
Message-ID: <CAGXE3d_V2vST4nkFLUeXgTwbzB_GfPYM3HzBC1QjLuG_=LP2Kw@mail.gmail.com> (sfid-20140122_143318_965505_B537BAFE)
Subject: Re: [PATCH] mac80211: send {add,del}ba on AC_VO like other mgmt
 frames, as per spec
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 22, 2014 at 2:09 PM, Karl Beldan <karl.beldan@gmail.com> wrote:
> On Wed, Jan 22, 2014 at 01:34:39PM +0100, Johannes Berg wrote:
>> Hmm. I guess you're right about the spec, but I vaguely remember races
>> in this with the delBA going out too soon or so?
>>
>
> Indeed, this was intended by cf6bb79 ("Use appropriate TID for sending
> BAR, ADDBA and DELBA frames") and I overlooked it .. will look into it,
> thanks.
> I Cced Helmut who authored the said commit.

You're right. There were some issues with that, but that was 2 years ago :)

Sending ADDBA over AV_VO should be safe.
If a DELBA is sent as AC_VO it might get received before the last AMPDU
of the BlockAck session. So, the pending AMPDUs will get dropped at the
receiver.

In theory this could also be avoided by properly flushing all pending AMPDUs
of the TID in question from the hw queues or by waiting for the tx status
of all pending AMPDUs.

Helmut
