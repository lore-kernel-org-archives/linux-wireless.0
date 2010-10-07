Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40567 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab0JGSmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 14:42:31 -0400
Received: by yxp4 with SMTP id 4so63421yxp.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Oct 2010 11:42:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CAE13F6.2010003@candelatech.com>
References: <4CAB59B2.5050106@candelatech.com> <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com>
 <4CAB5F3D.9060201@candelatech.com> <AANLkTimV3GrwU+9PPtirT4sCzveLY2egr3PRQhfDBET1@mail.gmail.com>
 <4CAB627F.8020804@candelatech.com> <AANLkTi=sT5QJe4V8gFGjF-nzx0uJAMLG_XG2715qrEEd@mail.gmail.com>
 <4CAB64AD.4080105@candelatech.com> <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com>
 <4CAB6B08.4050801@candelatech.com> <4CAE0474.4090605@candelatech.com>
 <1286475250.20974.22.camel@jlt3.sipsolutions.net> <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com>
 <4CAE13F6.2010003@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 7 Oct 2010 11:42:09 -0700
Message-ID: <AANLkTimEZ5GY7WFz-F4YyC+6MEwNn2Dki4tonp645XrS@mail.gmail.com>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 7, 2010 at 11:39 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 10/07/2010 11:29 AM, Luis R. Rodriguez wrote:
>>
>> On Thu, Oct 7, 2010 at 11:14 AM, Johannes Berg
>> <johannes@sipsolutions.net>  wrote:
>>>
>>> On Thu, 2010-10-07 at 10:33 -0700, Ben Greear wrote:
>>>>
>>>> In case it helps, here is a dump of where the corrupted SKB was deleted.
>>>
>>> I wonder, do you have a machine with a decent IOMMU? Adding IOMMU
>>> debugging into the mix could help you figure out if it's a DMA problem.
>>
>> Ben, how much traffic are you RX'ing on these virtual interfaces?
>
> I disabled my user-space application, and this script alone can reproduce
> the problem fairly quickly on my system.  You will need to change some
> of those first variables.  Just start it and wait a few minutes and
> watch the splats show on the console :)
>
> Note that I am not generating any traffic, but the wpa_supplicants are
> doing their thing of course...
>
> I'm using the kernel found here:
> http://dmz2.candelatech.com/git/gitweb.cgi?p=linux.wireless-testing.ct/.git;a=summary
>
> It's latest wireless-testing with some of my own patches, and some
> I've gathered from here an there.  I doubt I'm causing this problem,
> but if you can't reproduce it with this script on your kernels,
> I can try with base wireless-testing or whatever you are using.

I'll run this now, but can you try a vanilla wireless-testing? I hear
the latest wireless-testing is borked so maybe try (git reset --hard
master-2010-09-29), its what I'm on.

  Luis
