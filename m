Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.233]:55147 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbXLKBOG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 20:14:06 -0500
Received: by wr-out-0506.google.com with SMTP id c49so1544496wra
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2007 17:14:05 -0800 (PST)
Message-ID: <b2d05de20712101714x38c2dec6la9c4f496732b053d@mail.gmail.com> (sfid-20071211_011411_488598_981042AB)
Date: Mon, 10 Dec 2007 17:14:05 -0800
From: "Brennan Ashton" <comphappy@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: b43 regression
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <200712101136.48669.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200712101136.48669.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 10, 2007 2:36 AM, Michael Buesch <mb@bu3sch.de> wrote:
> I have identified another regression introduced by
> commit f04b3787bbce4567e28069a9ec97dcd804626ac7.
>
> On my device it shows up as broken transmission after
> a suspend/resume cycle. The workaround for it is to boot
> a known good driver (in my case the vendor driver in OSX)
> and then reboot (without turning the machine off) into the
> broken driver.
>
> It seems like we unintentionally removed some significant
> initialization step in that patch. I could not identify it, yet.
> The patch I sent yesterday did fix two other bugs, but not this one.
>
> I am trying to find the reason for this.
> If someone wants to help searching, the best way would be to look
> at that patch I mentioned above and compare the stuff that it
> removes to the stuff that it adds. There must be some tiny line
> that it removes but does not re-add it at another place.
> Four eyes see more than two.
>
> I have no idea how this bug could be related to the few bugreports
> in the redhat bugzilla. Though, one could test that by trying a
> kernel that does not include the patch.
>
> Sorry for the inconvenience.
>
> --
> Greetings Michael.
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>
RE:
https://bugzilla.redhat.com/show_bug.cgi?id=412861
I downloaded the source for 2.6.23.8-63.fc8.src.rpm the package that
things started to stop working at, and could not find any part of this
patch applied, so at least for that bug it is something else.

-- 
Brennan Ashton
Bellingham, Washington

"The box said, 'Requires Windows XP or better'. So I installed Linux"
