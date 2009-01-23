Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:24583 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473AbZAWW43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 17:56:29 -0500
Received: by wf-out-1314.google.com with SMTP id 27so5803705wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 14:56:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0901231027j22c9c797x6ad3a29b719eee99@mail.gmail.com>
References: <1232672850.7913.6.camel@maxim-laptop>
	 <1232733061.6513.2.camel@maxim-laptop>
	 <b6c5339f0901231027j22c9c797x6ad3a29b719eee99@mail.gmail.com>
Date: Fri, 23 Jan 2009 17:56:28 -0500
Message-ID: <b6c5339f0901231456g1b749430v28890b95e1c06337@mail.gmail.com> (sfid-20090123_235634_253372_A196C43B)
Subject: Re: [BUG] latest wireless-testing (compat-wireless) doesn't work with
	iwl3945
From: Bob Copeland <bcopeland@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[dropped ipw3945 from cc, not intel specific, and I didn't want the
 moderation bounce]

On Fri, Jan 23, 2009 at 1:27 PM, Bob Copeland <bcopeland@gmail.com> wrote:
> On Fri, Jan 23, 2009 at 12:51 PM, Maxim Levitsky
> <maximlevitsky@gmail.com> wrote:
>> On Fri, 2009-01-23 at 03:07 +0200, Maxim Levitsky wrote:
>>
>>
>> I noticed another wierd bug, somehow iwl3945 manages now to break
>> suspend to disk (hands on suspend) but not suspend to ram.
>
> Probably related to my mac80211 changes :(  Can you boot with
> no_console_suspend=1?

Actually... I have a pretty good idea why this happens and a nice one
liner fix.  Can you try changing "create_freezeable_workqueue" in
net/mac80211/main.c (there's only one) to "create_singlethread_workqueue"?

-- 
Bob Copeland %% www.bobcopeland.com
