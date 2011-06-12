Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55858 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1FLTHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jun 2011 15:07:48 -0400
Received: by qwk3 with SMTP id 3so1928346qwk.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jun 2011 12:07:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110612204859.37e7aed5@maggie>
References: <1307891513-6812-1-git-send-email-zajec5@gmail.com>
	<20110612182916.6afc781a@maggie>
	<BANLkTikVLH8xApD4e5uNW-3Eg6kaMXipBg@mail.gmail.com>
	<20110612204859.37e7aed5@maggie>
Date: Sun, 12 Jun 2011 21:07:47 +0200
Message-ID: <BANLkTi=uMqA0LTVnRKtqmgBapokj3GiFdQ@mail.gmail.com> (sfid-20110612_210751_690747_CD5D3CF9)
Subject: Re: [RFC][PATCH] b43: do not try sending packets when ring can be full
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	francesco.gringoli@ing.unibs.it
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 12 czerwca 2011 20:48 użytkownik Michael Büsch <m@bues.ch> napisał:
> On Sun, 12 Jun 2011 20:15:53 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>> Well, as I said, we may be unable to transmit the first element of the
>> queue, but 2nd/3rd/... may be for different ring (qos) (we can
>> transmit).
>>
>> Looping through the whole queue every time, just to find packets we
>> may transmit, sounds surely as a bad idea.
>
> I don't think so. It's not that this is an actual queue anyway. It just acts
> as a buffer to queue up one or two packets in the small race window of
> actually filling up the DMA rings and stopping the mac80211 queue.
> (It also acts as a context dispatcher in the first place, though).
>
> So the "looping through the queue" just means checking if one or two packets
> can be transmitted now.

Ouch, I didn't though about stopping queue. Yeah, length of that queue
should not reach big sizes...

-- 
Rafał
