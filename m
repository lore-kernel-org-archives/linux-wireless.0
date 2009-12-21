Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f211.google.com ([209.85.217.211]:62832 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbZLUPIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 10:08:09 -0500
Received: by gxk3 with SMTP id 3so3949204gxk.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 07:08:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200912211340.51229.8an@praha12.net>
References: <1260899813-17585-1-git-send-email-8an@praha12.net>
	 <4B2F4D3A.4050009@thinktube.com> <4B2F50DD.60701@thinktube.com>
	 <200912211340.51229.8an@praha12.net>
Date: Mon, 21 Dec 2009 10:08:08 -0500
Message-ID: <b6c5339f0912210708wa538055s74a7054eef0e77b6@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 4/5] ath5k: Reimplement clock rate to usec
	conversion
From: Bob Copeland <me@bobcopeland.com>
To: 8an@praha12.net
Cc: =?Big5?B?rvzEprdxpKc=?= <tkaiso@thinktube.com>,
	johannes@sipsolutions.net, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/12/21 Lukáš Turek <8an@praha12.net>:
> On 21.12.2009 11:41 海藻敬之 wrote:
>>  In ath5k_hw_write_ofdm_timings(),  comment says
>>       "ALGO: coef = (5 * clock * carrier_freq) / 2) ",
>>  but current code is
>>       "coef_scaled = ((5 * (clock << 24)) / 2) / channel->center_freq;"
>>
>>  Did they match each other ?
>>  I am wondering the the comment is wrong, but I am not sure that either
>> is wrong.
> Good point, it seems the comment is wrong. The calculation would overflow
> 32-bit integer if there was a multiplication instead of a division.
>
> Lukas Turek

The original comment was:

/*
 * ALGO -> coef = 1e8/fcarrier*fclock/40;
 * scaled coef to provide precision for this floating calculation
 */
coef_scaled = clockMhzScaled / chan->channel;

So dividing by the carrier frequency sounds like the right thing,
I guess the comment is wrong.

I reviewed the patch, looks fine to me.  The ATH hal uses a lookup
table to keep it inline but I don't think we have a convenient
index available to do the same.

I'll see what I can find about the pilot tracking to see if that
makes sense here.

-- 
Bob Copeland %% www.bobcopeland.com
