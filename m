Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:33948 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbZGGBfO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 21:35:14 -0400
Received: by yxe26 with SMTP id 26so6214849yxe.33
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jul 2009 18:35:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6c354a1a0907050513x3a3c91b3vb4b9de7196da1a14@mail.gmail.com>
References: <6c354a1a0906301524m389d49a9sfd812e1ea4740ff5@mail.gmail.com>
	 <6c354a1a0906301550g70fbd9ddkecd09fc0e98dd1ef@mail.gmail.com>
	 <b6c5339f0907020836n6162e8b8k3c1a7a24c335ac41@mail.gmail.com>
	 <6c354a1a0907050513x3a3c91b3vb4b9de7196da1a14@mail.gmail.com>
Date: Mon, 6 Jul 2009 21:35:16 -0400
Message-ID: <6c354a1a0907061835g438d65daw38b08b9d55081f43@mail.gmail.com>
Subject: Re: kernel .30 BROKE ATH5K with my AR5212 atheros.
From: Jasin Colegrove <j.wholesalesupply@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have found the bad commit.

$ git bisect good
1e3e6e8fe2f422f75619b1110f78bb638ae905b9 is first bad commit
commit 1e3e6e8fe2f422f75619b1110f78bb638ae905b9
Author: Nick Kossifidis <mick@madwifi-project.org>
Date:   Mon Feb 9 06:15:42 2009 +0200

    ath5k: Disable BMISS interrupts

     * Don't enable BMISS interrupts as we don't handle them yet

     Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

    Signed-off-by: John W. Linville <linville@tuxdriver.com>

:040000 040000 4a52fc89878d63cdb5da78e78d1ee17a6b5694c0
ff6f1d15f33d1dd3547e03fa191a779b50ad9ed4 M        drivers

Do you still think it would be wise to file a bug report for this
issue. I have yet to try the latest compat-wireless.

On Sun, Jul 5, 2009 at 8:13 AM, Jasin
Colegrove<j.wholesalesupply@gmail.com> wrote:
> Thanks bob for the reply. I did not mean to shout, but someone else
> told me that I should make it very clear that I was not subscribed.
> But, now I am so it doesn't matter :)
>
> I guess I will just wait to file a bug after I get through the bisect
> process and test out the newest compat-wireless drivers. Then I should
> have a more clear picture of the issue and maybe enough technical
> details to file a proper bug report. Thanks again for your time,
> greatly appreciated.
>
> On Thu, Jul 2, 2009 at 11:36 AM, Bob Copeland<me@bobcopeland.com> wrote:
>> On Tue, Jun 30, 2009 at 6:50 PM, Jasin
>> Colegrove<j.wholesalesupply@gmail.com> wrote:
>>> I AM NOT A SUBSCRIBER. Please reply to me directly at this e-mail
>>> address j.wholesalesupply@gmail.com
>>
>> No need to shout -- also common etiquette on Linux kernel lists is
>> to "reply-all" anyway :)
>>
>>> Then I decided to see if it the card was working, So I tried to iwlist
>>> wlan0 scan, it returned the expected results.
>>
>>> I would be glad to offer up as much
>>> information as I can, but I don't have the slightest on how to debug
>>> this issue?
>>
>> So to summarize:
>>
>> 2.6.29 works, 2.6.30 doesn't, ath9k works, ath5k doesn't, userspace
>> setup is unchanged.  ath5k can get scan results (which means RX is
>> working at least some of the time) but dhcp does not.
>>
>> You said you are comfortable with the command line, in that case the
>> easiest way to debug the change is to just bisect the ath5k changes
>> using git.  There were only 50 or so patches since 2.6.29 so you will
>> likely only need to compile the kernel 5 or 6 times.  You can do
>> something like:
>>
>> $ git bisect start v2.6.30 v2.6.29 -- drivers/net/wireless/ath5k
>>
>>> Any help on that issue is much appreciated. Where can I
>>> file the appropriate bug and what information do I need to post from a
>>> technical standpoint.
>>
>> http://bugzilla.kernel.org/ is where you would file it, the information
>> you've already given here is a good start.
>>
>> --
>> Bob Copeland %% www.bobcopeland.com
>>
>
