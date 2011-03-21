Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33879 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1CUOby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 10:31:54 -0400
Received: by vxi39 with SMTP id 39so5068719vxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 07:31:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110318191337.GA9288@sig21.net>
References: <AANLkTik9wfkskAHEpmsm4_gPM0FFBf=q8OVXM99NBRjO@mail.gmail.com>
	<201103172107.25316.helmut.schaa@googlemail.com>
	<AANLkTi=u3dw1D1-+-Cy9aEPc2H1MAF+cUi=ucvMTNrNc@mail.gmail.com>
	<201103181642.28386.helmut.schaa@googlemail.com>
	<AANLkTi=oAQ1M=XmFpyjh+2zkHidN_AdG7880A=TGsM-h@mail.gmail.com>
	<20110318165626.GA12889@sig21.net>
	<AANLkTim7QdUByYTDC=ZjjY5ZrAuwhvEUZOKUeGYctXN2@mail.gmail.com>
	<20110318191337.GA9288@sig21.net>
Date: Mon, 21 Mar 2011 15:31:53 +0100
Message-ID: <AANLkTinQNUN2Eyg1pxKEkV2nEAt884Mmre3ojdYsY_eB@mail.gmail.com>
Subject: Re: [rt2x00-users] rt2800usb stops working with big file transfers in
 AP and IBSS
From: Juan Carlos Garza <juancarlosgarza@gmail.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Fri, Mar 18, 2011 at 8:13 PM, Johannes Stezenbach <js@sig21.net> wrote:
> On Fri, Mar 18, 2011 at 06:24:56PM +0100, Juan Carlos Garza wrote:
>> On Fri, Mar 18, 2011 at 5:56 PM, Johannes Stezenbach <js@sig21.net> wrote:
>> > On Fri, Mar 18, 2011 at 05:15:04PM +0100, Ivo Van Doorn wrote:
>> >> I have to do a performance test to see if there are any issues remaining,
>> >> but so far all those patches resulted in poorer performance (reduced
>> >> association successes).
>> >
>> > IIRC you did no report any newer test results after
>> > http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-January/003070.html
>>
>> I did get once or twice a warning saying:
>> Queue 14 failed to flush, and I think it did not work afterwards...

I tried to reproduce it today (the warning) and couldn't. I think I
got that warning after loading the unpatched driver, doing a transfer
(and thus stalling it) and then loading the patched driver. So
basically we can ignore that I wrote that.

I will report anyother problems that I might find.

>
> With my patches applied?  That's not good.  I hope I can find some
> time next week to retest with a current wireless-testing tree.
>
>> I do not need to associate, as I use the Access Point rather than a
>> Station. Clients could associate with the access point without
>> problems. But this patch might bring more stability... can someone
>> give me the path to the experimental branch git repository?
>
> http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git
>
> Please be aware that rt2800usb AP currently does not work with
> power saving stations, i.e. you have to disable power saving
> on the stations (iwconfig wlan0 power off).  Which you
> can't on some mobile devices...
>
> (And IIRC rt2800usb stations also still have issues with power saving.)
>
> I was working on a patch for AP mode but I ran out of time and got sucked
> into other projects.  There is a broken half-baked patch
> in rt2x00/experimental which needs to be reverted, please
> no not use.
> http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=66045e31c8475f69178aea0ef650e7e087929d62
> You can find some recent discussion about it in the
> rt2x00-users archives.
>
>
> Johannes
>


Best Regards,
Juan Carlos
