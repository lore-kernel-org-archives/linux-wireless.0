Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48275 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab1EJOtV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 10:49:21 -0400
MIME-Version: 1.0
In-Reply-To: <4DC9072D.4030103@colin.guthr.ie>
References: <ip6j66$o5f$1@dough.gmane.org> <1304930195.3475.17.camel@jlt3.sipsolutions.net>
 <4DC81FC7.9040503@colin.guthr.ie> <20110509171144.GA7194@srcf.ucam.org> <4DC9072D.4030103@colin.guthr.ie>
From: =?UTF-8?B?S2VuZy1Zw7wgTGlu?= <keng-yu.lin@canonical.com>
Date: Tue, 10 May 2011 16:48:57 +0200
Message-ID: <BANLkTinVwnSei_VobfKtgzrwSP+cJSvxaQ@mail.gmail.com> (sfid-20110510_164928_639315_A40540DE)
Subject: Re: [Regression] Problem with rfkill on 2.6.38
To: Colin Guthrie <mageia@colin.guthr.ie>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	Thomas Backlund <tmb@mageia.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 10, 2011 at 11:36 AM, Colin Guthrie <mageia@colin.guthr.ie> wrote:
> 'Twas brillig, and Matthew Garrett at 09/05/11 18:11 did gyre and gimble:
>> On Mon, May 09, 2011 at 06:09:27PM +0100, Colin Guthrie wrote:
>>
>>> Just a quick (non-compile) followup from my last email... blacklisting
>>> the dell-laptop module works around the issue, so I think the commit
>>> previously mentioned is indeed the culprit (as it's the only recent
>>> commit and does fiddle with the rfkill stuff).
>>>
>>> Not sure what the best track forward is, but it's certainly a
>>> regression, so should probably be fixed or reverted until a more
>>> complete fix is found.
>>
>> If you can confirm that with a build then I'll do that.
>
> ACK. Reverting that commit and unblacklisting the dell_laptop module
> restores the previous, working functionality. I've flipped rfkill a few
> times and it's always worked fine.
>

May I have the model of your Dell laptop?

dell_latop has a debugfs node in /sys/kernel/debug/dell_latop/rfkill,
can you attach the logs at both the moment when the radio devices are
enabled and disabled? the output of the command `rfkill list` at both
moments will helpful too.

In my experience that different models of Dell laptop may have
different reaction/behaviour on the rfkill handling. Reverting the
patch may make your laptop working, but can cause others non-working.

It should make sense and be appreciated that you attach more debug
information for investigation on the bug.

  Thanks,
-kengyu
