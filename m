Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39129 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab0JDIRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 04:17:13 -0400
Received: by iwn5 with SMTP id 5so6617403iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 01:17:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101004063446.GA16078@vasanth-laptop>
References: <1286125639-15137-1-git-send-email-nbd@openwrt.org>
	<1286125639-15137-2-git-send-email-nbd@openwrt.org>
	<20101004063446.GA16078@vasanth-laptop>
Date: Mon, 4 Oct 2010 16:17:13 +0800
Message-ID: <AANLkTimMSHHL1kp_J14pzP6QQQ2GnEwOr=0TcnvPZtfM@mail.gmail.com>
Subject: Re: [PATCH 2/4] ath9k_hw: merge codepaths that access the cycle
 counter registers
From: Adrian Chadd <adrian@freebsd.org>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 October 2010 14:34, Vasanthakumar Thiagarajan <vasanth@atheros.com> wrote:

>> +
>> +     /* prevent wraparound */
>> +     if (ah->cc.cycles & BIT(31))
>> +             clear = true;
>
> This does not look right, previous if should take care of
> any wrap around.

I was just in this area of the FreeBSD ath HAL code last week.

I wonder why you don't just poll the values periodically and store
them in a history array. Would you need to handle wrap-around if
you're already polling the values every 100ms?


Adrian
