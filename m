Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:20216 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757630AbZAWXJS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 18:09:18 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2717455fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 15:09:15 -0800 (PST)
Subject: Re: [BUG] latest wireless-testing (compat-wireless) doesn't work
 with  iwl3945
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Bob Copeland <bcopeland@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <b6c5339f0901231456g1b749430v28890b95e1c06337@mail.gmail.com>
References: <1232672850.7913.6.camel@maxim-laptop>
	 <1232733061.6513.2.camel@maxim-laptop>
	 <b6c5339f0901231027j22c9c797x6ad3a29b719eee99@mail.gmail.com>
	 <b6c5339f0901231456g1b749430v28890b95e1c06337@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 24 Jan 2009 01:09:11 +0200
Message-Id: <1232752151.13493.0.camel@maxim-laptop> (sfid-20090124_000923_211210_60CD69A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-01-23 at 17:56 -0500, Bob Copeland wrote:
> [dropped ipw3945 from cc, not intel specific, and I didn't want the
>  moderation bounce]
> 
> On Fri, Jan 23, 2009 at 1:27 PM, Bob Copeland <bcopeland@gmail.com> wrote:
> > On Fri, Jan 23, 2009 at 12:51 PM, Maxim Levitsky
> > <maximlevitsky@gmail.com> wrote:
> >> On Fri, 2009-01-23 at 03:07 +0200, Maxim Levitsky wrote:
> >>
> >>
> >> I noticed another wierd bug, somehow iwl3945 manages now to break
> >> suspend to disk (hands on suspend) but not suspend to ram.
> >
> > Probably related to my mac80211 changes :(  Can you boot with
> > no_console_suspend=1?
> 
> Actually... I have a pretty good idea why this happens and a nice one
> liner fix.  Can you try changing "create_freezeable_workqueue" in
> net/mac80211/main.c (there's only one) to "create_singlethread_workqueue"?
> 
Done, and thanks, works fine now.

Best regards,
	Maxim Levitsky

