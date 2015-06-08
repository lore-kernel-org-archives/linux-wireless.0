Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:32795 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbbFHRK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 13:10:58 -0400
Received: by yhpn97 with SMTP id n97so42750793yhp.0
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2015 10:10:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAVw_ZFi3Q1hi+uoeO_V=XUMNhZCViVq5iPrrJL9UakKB46Mag@mail.gmail.com>
References: <CAAVw_ZFi3Q1hi+uoeO_V=XUMNhZCViVq5iPrrJL9UakKB46Mag@mail.gmail.com>
Date: Mon, 8 Jun 2015 10:10:57 -0700
Message-ID: <CAAnMG+Oeps87PaxV4DAqyOokz9T6ikf3Xv0vA_EC+impRM5Fxg@mail.gmail.com> (sfid-20150608_191110_511650_06A5A954)
Subject: Re: mac80211 modification
From: Alexis Green <agreen@cococorp.com>
To: Duy Tai Nguyen <duytai.cse@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You should build mac80211 as module instead of built-in driver and
"make modules" instead of full make. This way you'll be just
rebuilding mac80211.ko instead of the whole thing.

On Mon, Jun 8, 2015 at 2:39 AM, Duy Tai Nguyen <duytai.cse@gmail.com> wrote:
> Hi,
>
> I want to inject particular data into beacon frame in Android device.
> I found two approaches:
> 1. Write loadable kernel module.
> 2. Modify MAC80211 subsystem
> In the first approach, I found that I could not include directly
> source code from MAC80211 sub system in folder /net/mac80211/. Thus, I
> used the second approach, but, every time I change any line of source
> code, it takes 30 minutes to build zImage  then install new kernel in
> my Android device. Finally, I was stuck.
> Therefore, my questions are:
> 1. Is it right approach to modify MAC80211 subsystem?
> 2. Are there any faster approach to modify MAC80211 and test source code?
> 3. I am curious about the way you write code and test MAC80211. Could
> you explain in details?
> Best Regards,
> Duy Tai.
> ------------------------------------------------------------------------------------------------------------
> Nguyen Duy Tai
> Ym: kimjiwoo741
> Phone: +841676919422
> Faculty of Computer Science and Engineering.
> University of Technology HCMC.
> ------------------------------------------------------------------------------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
