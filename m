Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45285 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab0ITQ5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 12:57:18 -0400
Received: by pzk34 with SMTP id 34so1201404pzk.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Sep 2010 09:57:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinoe86gtsMJMJ-jitj3yHo35FBdyiqbPKuUAe_R@mail.gmail.com>
References: <1284921651.24835.11.camel@i7.infradead.org> <AANLkTinoe86gtsMJMJ-jitj3yHo35FBdyiqbPKuUAe_R@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 20 Sep 2010 09:56:57 -0700
Message-ID: <AANLkTi=sbh-y73+VuEWQz8ni47zaeBXCBRQGUH=0j_Zr@mail.gmail.com>
Subject: Re: [PATCH] b43/b43legacy - Credit Broadcom with enabling the
 development of the drivers
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/20 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Sun, Sep 19, 2010 at 8:40 PM, David Woodhouse <dwmw2@infradead.org> wrote:
>> Broadcom seem bizarrely paranoid about the legal consequences of
>> "enabling" users to violate regulatory requirements.
>>
>> For some reason they seem to think that an open source driver is more of
>> a problem than a closed-source driver. Even though it's often actually
>> *easier* for end-users to use a hex editor to NOP out certain conditional
>> jumps or change constants used in comparisons for regulatory enforcement,
>> than it is for them to patch and rebuild an open source driver.
>>
>> The reverse engineering is hard, of course, but the end-users don't have
>> to do that for themselves -- they only need to follow instructions like
>> 'set the byte at 0x4572 to 0x90'. More to the point, the reverse-engineering
>> part is required *anyway* in order to document the hardware so we can write
>> the open source drivers. We couldn't do an open driver without *first*
>> knowing enough about the closed one that we can bypass the regulatory
>> code in it.
>>
>> Everything we do in the b43 and b43legacy drivers is enabled by
>> Broadcom's original binary-only drivers.
>>
>> So let's make that 'enablement' by Broadcom's binary drivers clear in
>> our source code -- in the hope that it'll narrow the 'risk gap' that
>> they falsely perceive between open and closed source drivers.
>>
>> Or failing that, in the hope that it'll give their crack-addled lawyers
>> aneurysms, and they'll hire some saner ones to replace them.
>>
>> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
>> ---
>> I'd like to see the b43 reverse engineering folks release more such
>> instructions on bypassing the regulatory requirements (boosting TX
>> power, using wrong channels, etc.) in the Windows and OSX drivers; that
>> would be another good way to demonstrate how crack-inspired the Broadcom
>> position on closed vs. open drivers is.
>
> Only one problem: the license agreement of these drivers explicitly
> forbids any reverse-engineering for any purpose. One can debate a lot
> about whether these are enforceable - however, in the US, a similar
> case (though that one was about resale, rather than
> reverse-engineering) was recently decided in the plaintiff's favor.
> And I believe Broadcom would indeed sue if they thought they were
> risking their FCC approval by not doing so.

As silly as some legal department's position may be I still believe we
should not promote breaking regulatory rules and a few of us respect
these ideas [1] in order to help bring traction and relationship with
vendors [1]. Although we know its possible we simply won't allow
patches upstream which break regulatory considerations and vendors are
encouraged to help with this and in case they don't we have a
framework to already provide some help with some central regulatory
control. What hackers do out-of-tree is up to them but within Linux we
should respect regulatory considerations.

The truth of the matter is current legislation simply is out of date,
the change that we need is a shift in liability down to the user for
modified supported drivers / firmware much like a person renting a
golf cart can run over someone or cause a huge accident with it. Until
then different vendors' legal departments will take on different
positions and dance all around this doing as big of a show as
possible, and while I do think some legal departments positions are
extremely naive, the best approach really is to ignore them and lead
by example and providing real solutions to the actual problems so that
when and if legislation ever does consider a change its clear that
there is a path for a change. We need to build a strong consensus
towards this slowly.

[1] http://wireless.kernel.org/en/developers/Regulatory/statement

  Luis
