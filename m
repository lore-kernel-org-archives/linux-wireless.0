Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55633 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab0JLBDu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 21:03:50 -0400
Received: by iwn7 with SMTP id 7so48477iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Oct 2010 18:03:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CB378CD.1080800@candelatech.com>
References: <4CAB59B2.5050106@candelatech.com> <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com>
 <4CAB5F3D.9060201@candelatech.com> <AANLkTimV3GrwU+9PPtirT4sCzveLY2egr3PRQhfDBET1@mail.gmail.com>
 <4CAB627F.8020804@candelatech.com> <AANLkTi=sT5QJe4V8gFGjF-nzx0uJAMLG_XG2715qrEEd@mail.gmail.com>
 <4CAB64AD.4080105@candelatech.com> <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com>
 <4CAB6B08.4050801@candelatech.com> <4CAE0474.4090605@candelatech.com>
 <1286475250.20974.22.camel@jlt3.sipsolutions.net> <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com>
 <4CAE13F6.2010003@candelatech.com> <AANLkTimEZ5GY7WFz-F4YyC+6MEwNn2Dki4tonp645XrS@mail.gmail.com>
 <4CAE1DFB.303@candelatech.com> <1286479642.20974.32.camel@jlt3.sipsolutions.net>
 <AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com>
 <AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com>
 <AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com> <4CB378CD.1080800@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 11 Oct 2010 18:03:29 -0700
Message-ID: <AANLkTim42zmDwf744BCrPwa1kT5ph57bNMyvSyOpesVv@mail.gmail.com>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 11, 2010 at 1:51 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 10/07/2010 02:59 PM, Luis R. Rodriguez wrote:
>>
>> On Thu, Oct 7, 2010 at 2:36 PM, Luis R. Rodriguez<mcgrof@gmail.com>
>>  wrote:
>
>>>> But other than this I got nothing. I left the box sit there for about
>>>> 1 hour and came back and it was still going with no issues. Mind you,
>>>> I can't ping but that seems like another issue.
>>>>
>>>> You can find my logs here:
>>>>
>>>>
>>>> http://www.kernel.org/pub/linux/kernel/people/mcgrof/logs/2010/10-07-stress-sta-01/
>>>
>>> Doh, I did not have CONFIG_SLUB_DEBUG_ON=y so building now with that.
>>
>> Yay I can reproduce now. I'll be back, going to dig now.
>
> Any luck tracking this down?

No, today for example I just finished reading e-mail and its already
6pm PST... But Friday I did get do do a lot of work and testing on
this. The only pattern I see so far is that skb_copy() is used on the
poison all the time. I am not sure if its because skb_copy() happens
to run the poison check or what. I'll work on this tomorrow.

  Luis
