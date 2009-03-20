Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:28239 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbZCTB4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 21:56:10 -0400
Received: by fg-out-1718.google.com with SMTP id e12so131853fga.17
        for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2009 18:56:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49C2D537.6080406@giuppi.com>
References: <49C12DFA.80308@giuppi.com>
	 <3ace41890903191439q1c375925md2e4227f79147399@mail.gmail.com>
	 <49C2D537.6080406@giuppi.com>
Date: Fri, 20 Mar 2009 01:56:05 +0000
Message-ID: <3ace41890903191856s234118c9j2f4de15486cb37a9@mail.gmail.com> (sfid-20090320_025613_913770_D89A84B0)
Subject: Re: rtl8187 bug report
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Info[at]Giuppi" <info@giuppi.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 19, 2009 at 11:28 PM, Info[at]Giuppi <info@giuppi.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hin-Tak Leung ha scritto:
>>
>> I am not familiar with aircrack-ng, but I believe it can be used with
>> a modified version of the vendor rtl8187 driver, (and the aircrack-ng
>> people hosts a modified version of the vendor driver on their web
>> site). I have not actually looked at their modification so I have no
>> idea what modification is required for aircrack-ng to work well, but I
>> believe *some* adaptation is required?
> RTL8187B has no official linux support by the vendor. The driver
> you're referencing to has been adapted by one guy and "works" for old
> kernel versions only.
> I'm very happy with this new rtl8187. The problem in not related to
> the aircrack-ng software. I'm just saying I think there's something
> wrong with WEP networks in monitor mode. Using a tool from the suite
> to scan local wireless networks I've found out that strange behaviour
> only with WEPs.

You are somewhat wrong about Realtek's position - I am speaking as one
of the 3 current maintainers of the new rtl8187 code, by the way, if
you didn't know that... - Realtek staff have been quite co-operative,
and while the vendor driver is behind and have some other issues, they
have regular releases through OEM channels. (there is also a chance
that the "one guy" you refer to is me - at least 3 people had tried to
port the vendor driver forward).

>> On a different issue - I think such adaptation are frown upon and will
>> not make it into the standard kernel, due to its nature of typical
>> usage in a controversal scenario. Maybe other wireless dev people,
>> especially Herton and Larry, can advise.
> As far as I know there are no adaptations needed. Wanted or not, it
> already works in those "controversal scenario".
> The rt73usb driver comes from the same compat-wireless package and it
> hasn't that problem, for example. The rtl8187 driver itself works
> great for networks other than WEP.
>
> Thanks very much for your reply, I hope some of the devs can take the
> time to check if I'm wrong.

According to http://www.aircrack-ng.org/doku.php?id=rtl8187 , two
small patches are recommended.
vs the vendor driver, which needs one rather big patch:
http://www.aircrack-ng.org/doku.php?id=r8187

The fragmentation patch applies to both rtl8187 anf rt73usb, but the
injection patch is rtl8187-specific. If the latter works better for
you and have no detrimental effect on "normal" usage, we can consider
putting it in. (it looks a bit wrong though)
