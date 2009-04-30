Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:45783 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824AbZD3N4U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 09:56:20 -0400
Received: by bwz7 with SMTP id 7so1817512bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 30 Apr 2009 06:56:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <557754.25367.qm@web51403.mail.re2.yahoo.com>
References: <557754.25367.qm@web51403.mail.re2.yahoo.com>
Date: Thu, 30 Apr 2009 14:56:18 +0100
Message-ID: <efe7343f0904300656g127e83e1ge0b21060d6a69955@mail.gmail.com>
Subject: Re: rt73usb Access point status
From: Luis Correia <luis.f.correia@gmail.com>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joerg,

On Thu, Apr 30, 2009 at 14:41, Joerg Pommnitz <pommnitz@yahoo.com> wrote:
>
>> Based on that information, I have removed the "Yes (under development)"
>> note from the driver page since it doesn't really support it... In fact,
>> I'm surprised it works even with that hack since hostapd usually polls
>> the station with nullfunc frames and waits for an ack.
>
> Reading the mail from Ivo (http://sourceforge.net/mailarchive/message.php?msg_id=200808082059.11968.IvDoorn%40gmail.com)
> I gather that the ACK in question is not from the peer but from the local
> hardware indicating that the frame was actually sent and not lost due to
> some local error.
> --
> Regards
> Joerg

According to Ivo, we cannot be totally sure that the device has sent
the frame into the air, so no actual ACK is reported back to mac80211.

The hostapd hack works, as long as the stations are not very far from
the AP, and thus not 'too many retries' need to be sent.

AFAIK, this is not optimal at all, so I don't go around and say 'it
works'. It may or may not work in your case.
If possible, test and report back your findings.


Luis Correia
rt2x00 project admin
