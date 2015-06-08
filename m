Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:34323 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbbFHTey (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 15:34:54 -0400
Received: by igbhj9 with SMTP id hj9so67427747igb.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2015 12:34:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAnMG+Oeps87PaxV4DAqyOokz9T6ikf3Xv0vA_EC+impRM5Fxg@mail.gmail.com>
References: <CAAVw_ZFi3Q1hi+uoeO_V=XUMNhZCViVq5iPrrJL9UakKB46Mag@mail.gmail.com>
 <CAAnMG+Oeps87PaxV4DAqyOokz9T6ikf3Xv0vA_EC+impRM5Fxg@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 9 Jun 2015 01:04:33 +0530
Message-ID: <CABPxzYKr4uszh5g2KURj4tVG_vKNrNFaz4JyhCK4FuaRzdvhpQ@mail.gmail.com> (sfid-20150608_213505_254155_B4D1C268)
Subject: Re: mac80211 modification
To: Alexis Green <agreen@cococorp.com>
Cc: Duy Tai Nguyen <duytai.cse@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 8, 2015 at 10:40 PM, Alexis Green <agreen@cococorp.com> wrote:
>
> You should build mac80211 as module instead of built-in driver and
> "make modules" instead of full make. This way you'll be just
> rebuilding mac80211.ko instead of the whole thing.
>
> On Mon, Jun 8, 2015 at 2:39 AM, Duy Tai Nguyen <duytai.cse@gmail.com> wrote:
> > Hi,
> >
> > I want to inject particular data into beacon frame in Android device.
> > I found two approaches:
> > 1. Write loadable kernel module.
> > 2. Modify MAC80211 subsystem
> > In the first approach, I found that I could not include directly
> > source code from MAC80211 sub system in folder /net/mac80211/. Thus, I
> > used the second approach, but, every time I change any line of source
> > code, it takes 30 minutes to build zImage  then install new kernel in
> > my Android device. Finally, I was stuck.
> > Therefore, my questions are:
> > 1. Is it right approach to modify MAC80211 subsystem?
> > 2. Are there any faster approach to modify MAC80211 and test source code?
> > 3. I am curious about the way you write code and test MAC80211. Could
> > you explain in details?

The way i do it is, as below:

1) First time compile the full kernel. With mac80211=m
2) Next time: after changing source :
       make modules M=net/mac80211
       make modules_install M=net/mac80211

       modprobe -v mac80211 -r
       modprobe -v mac80211
3) I normally use mac80211_hwsim to test the mac80211 code.
 Refer: https://wireless.wiki.kernel.org/en/users/drivers/mac80211_hwsim
In that case:

       modprobe -v mac80211_hwsim -r
       modprobe -v mac80211_hwsim
