Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43589 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab1DGWEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 18:04:52 -0400
Received: by gwaa18 with SMTP id a18so1024405gwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 15:04:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D8EB693.5010704@users.sourceforge.net>
References: <813132.20275.qm@web29506.mail.ird.yahoo.com>
	<20110318085401.GB2162@redhat.com>
	<4D8EB693.5010704@users.sourceforge.net>
Date: Thu, 7 Apr 2011 23:04:51 +0100
Message-ID: <BANLkTin9qc-oMNJu=TXYimqe81TcQ0g7og@mail.gmail.com>
Subject: Re: rtl8187b throughput-related regression in 2.6.35.x fixed in 2.6.37.x
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	herton@mandriva.com.br,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 27, 2011 at 5:01 AM, Hin-Tak Leung
<htl10@users.sourceforge.net> wrote:
> Stanislaw Gruszka wrote:
>>
>> On Fri, Mar 18, 2011 at 05:18:25AM +0000, Hin-Tak Leung wrote:
>>>
>>> Hi Larry/Herton/John,
>>>
>>> There appears to be some kind of throughput related regression in
>>> 2.6.35.x (11-85-ish fedora, current long-term maintainance kernel) which is
>>> fixed by putting compat-wireless 2.6.37.x (4) on. I just thought I should
>>> mention this, in case somebody files a bug about rtl8187(b) being too slow,
>>> that putting compat-wireless on might help.
>>>
>>> My AP machine was out for almost a year so I have not been using my
>>> rtl8187b for a while. When I finally got that fixed, after a while I noticed
>>> the throughput between the two machines was low (60KB/s, or 0.5Mb/s,
>>> although iwconfig says rate=11Mb/s, etc). Putting compat-wireless on gets me
>>> back the throughput I expect from a year ago (400KB/s+ onwards, or a few
>>> Mb/s at least). So 2.6.31.x a year ago was okay, 2.6.37.x is okay, but there
>>> appear to be something not quite right with 2.6.35.x in the middle. There
>>> are too many changes, and it is probably not important since current-ish
>>> kernel head is okay.
>>
>> Would be nice to have this fixed in stable.
>>
>> We have already one AP mode bug opened:
>> http://bugzilla.redhat.com/show_bug.cgi?id=671514
>>
>> It was recognized that this patch is needed in .35.11 (.35.9 is ok):
>> http://git.kernel.org/linus/09a02fdb919876c01e8f05960750a418b3f7fa48
>>
>> Not sure if this is the same issue, but perhaps you could try above
>> patch. If it does not help, could you check if problem is
>> 2.6.35.x -> 2.6.35.11 regression?
>>
>> Stanislaw
>>
>
> Just checked again, downloading and using a bunch of compat tar balls. It
> appeared that the throughput problem I reported above was fixed between
> 2.6.37.4 and 2.6.38-rc7. In any case, it does not appear to be the ones you
> mentioned.
>
> I might spend a bit more time eventually to see what fixes it. The one thing
> interesting
> about those two versions were Herton's house-keeping
>
> rtl8187: restore anaparam registers after reset with 8187B
> rtl8187: fix wrong register initialization in 8187B
>
> and Thadeu Lima de Souza Cascardo
> rtl8187b: do not do per packet TX AGC
>
> And the Signal level did seem to change from about -40 dBm to -30
>
> But these are a bit curious how I did get good throughput with 2.6.31.x-ish

Down to between:
compat-wireless-2.6.37-4-sn.tar.bz2
compat-wireless-2.6.38-rc3-3.tar.bz2

compat-wireless-2.6.38-rc3-2.tar.bz2 doesn't build.
