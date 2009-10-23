Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([78.111.66.105]:35734 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbZJWNYF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 09:24:05 -0400
Message-ID: <4AE1AE74.4020600@wpkg.org>
Date: Fri, 23 Oct 2009 15:24:04 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: linux-wireless@vger.kernel.org, linux-net@vger.kernel.org,
	linux-mips@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: Re: ath5k AP kernel panic when client uses SCP
References: <4AD21AB4.6010208@wpkg.org> <4AE1AC69.7010904@wpkg.org> <69e28c910910230621j2176813dpe7f77b7dff5b1b44@mail.gmail.com>
In-Reply-To: <69e28c910910230621j2176813dpe7f77b7dff5b1b44@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> On Fri, Oct 23, 2009 at 3:15 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>> Bob Copeland wrote:
>>> CONFIG_DEBUG_INFO is the basic switch.  I don't know if MIPS needs
>>> CONFIG_FRAME_POINTER but that could help too.
>> I don't see CONFIG_FRAME_POINTER available.
>> I compiled with CONFIG_DEBUG_INFO; let me know if I should enable some other
>> DEBUG options as well (see below what's enabled and available).
>>
>> Before it oopses, I see lots of order 0 page allocation failures (there are
>> some extra spaces at the end of each line due to the broken konsole in
>> KDE4):
>>
>> http://www1.wpkg.org/oops2.txt

> Is CONFIG_KALLSYMS set?

Good clue:

# zgrep KALL /proc/config.gz
# CONFIG_KALLSYMS is not set

I'll recompile...


-- 
Tomasz Chmielewski
http://wpkg.org

