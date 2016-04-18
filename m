Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbcDRQTP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 12:19:15 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: [PATCH 00/16] rtl8xxxu prepare for splitting into multiple files
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
	<57150569.5090009@lwfinger.net>
Date: Mon, 18 Apr 2016 12:19:14 -0400
In-Reply-To: <57150569.5090009@lwfinger.net> (Larry Finger's message of "Mon,
	18 Apr 2016 11:03:53 -0500")
Message-ID: <wrfjk2juhou5.fsf@redhat.com> (sfid-20160418_181919_017930_47299911)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 04/18/2016 10:49 AM, Jes.Sorensen@redhat.com wrote:
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> Hi,
>>
>> This is the last set of patches I have in my queue for the rtl8xxxu
>> driver, as of today :)
>>
>> Since the driver has grown to support quite a number of different
>> chips, I want to split it into multiple files. This will make it
>> easier to maintain and also eaiser to add support for more chips
>> without having to constantly touch the core files.
>>
>> This set renames a bunch of functions to indicate that they are
>> generic rather than chip specific. I will look at doing the actual
>> moving around in a set right after the current merge window closes.
>>
>> Please keep the test reports coming!
>
> I like the renaming of the routines to match the chip generation, but
> there should be some comments stating the gen to which each
> device/version belongs. Such comments are not needed now, but could be
> included when the files are split.

Larry,

I like that idea - I thought I did that when I pushed the enum for chip
versions in ba17d824783805235f317f79f2871b17bd679956 but somehow it
didn't get further than my head.

I have been thinking of putting some of it down in writing - probably in
rtl8xxxu.h or a README

Note the gen1/gen2 categorization is completely made up by me, it may be
that this is really gen6/gen7 within Realtek. Roughly I consider
8191su/8192su to be gen0, 8188cu/8188ru/8192cu/8723au as gen1, and
8192eu/8723bu/8812/8821 as gen2. I haven't looked closely enough at
8188eu and 8192du yet to determine where they really fit in.

Top priority on my list post splitting the driver into multiple files is
adding 8188eu and beacon support. If only there was 30 hours in a day...

Cheers,
Jes
