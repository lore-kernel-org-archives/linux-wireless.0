Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51954 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab1FXM3y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 08:29:54 -0400
MIME-Version: 1.0
In-Reply-To: <4E046CD5.2070709@colin.guthr.ie>
References: <ip6j66$o5f$1@dough.gmane.org> <1304930195.3475.17.camel@jlt3.sipsolutions.net>
 <4DC81FC7.9040503@colin.guthr.ie> <20110509171144.GA7194@srcf.ucam.org>
 <4DC9072D.4030103@colin.guthr.ie> <BANLkTinVwnSei_VobfKtgzrwSP+cJSvxaQ@mail.gmail.com>
 <4E046CD5.2070709@colin.guthr.ie>
From: =?UTF-8?B?S2VuZy1Zw7wgTGlu?= <kengyu@canonical.com>
Date: Fri, 24 Jun 2011 20:29:33 +0800
Message-ID: <BANLkTimxgk=8S4bEsXgNjMj-2FsNjzauCg@mail.gmail.com> (sfid-20110624_142958_848354_CC0A2314)
Subject: Re: [Regression] Problem with rfkill on 2.6.38
To: Colin Guthrie <gmane@colin.guthr.ie>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	Thomas Backlund <tmb@mageia.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for the late reply.

After looking into this a bit I agree with you the patch should be reverted.

On Fri, Jun 24, 2011 at 6:54 PM, Colin Guthrie <gmane@colin.guthr.ie> wrote:
> 'Twas brillig, and Keng-Yü Lin at 10/05/11 15:48 did gyre and gimble:
>> On Tue, May 10, 2011 at 11:36 AM, Colin Guthrie <mageia@colin.guthr.ie> wrote:
>>> 'Twas brillig, and Matthew Garrett at 09/05/11 18:11 did gyre and gimble:
>>>> On Mon, May 09, 2011 at 06:09:27PM +0100, Colin Guthrie wrote:
>>>>
>>>>> Just a quick (non-compile) followup from my last email... blacklisting
>>>>> the dell-laptop module works around the issue, so I think the commit
>>>>> previously mentioned is indeed the culprit (as it's the only recent
>>>>> commit and does fiddle with the rfkill stuff).
>>>>>
>>>>> Not sure what the best track forward is, but it's certainly a
>>>>> regression, so should probably be fixed or reverted until a more
>>>>> complete fix is found.
>>>>
>>>> If you can confirm that with a build then I'll do that.
>>>
>>> ACK. Reverting that commit and unblacklisting the dell_laptop module
>>> restores the previous, working functionality. I've flipped rfkill a few
>>> times and it's always worked fine.
>
> Just wondering if there was any progress on this. I ACKed a regression
> but it was not reverted.... I thought the standard practice was to
> revert until a fuller fix was found.
>
> I appreciate some other users will not get their fix but I was still
> under the impression that this was the policy?
>
> I don't see any relevant changes in the 2.6.39 kernel:
>
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.39.y.git;a=history;f=drivers/platform/x86/dell-laptop.c;h=de301aa8e5c3799620ff5a06372b5e1942c2dab2;hb=HEAD
>
> nor in Linus' 2.6 tree (which I presume is actually for 3.0 these days?):
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=history;f=drivers/platform/x86/dell-laptop.c;h=d3841de6a8cf199ec08b24bd85f50a0af0490d37;hb=HEAD
>
>
>> May I have the model of your Dell laptop?
> snip....
>
> I supplied all this info before here:
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/68758
>
> Anything else I can do to move this forward?
>

I am happy to form the revert patch if necessary.
