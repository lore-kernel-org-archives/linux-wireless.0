Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:27392 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYCELKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 06:10:39 -0500
Received: by rv-out-0910.google.com with SMTP id k20so857754rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2008 03:10:39 -0800 (PST)
Message-ID: <b25c3fa70803050310i71023046gc3f40d4042038ba6@mail.gmail.com> (sfid-20080305_111043_433679_3BE9BF66)
Date: Wed, 5 Mar 2008 20:10:39 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix races between siwessid and siwencode
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1204710843.25502.50.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1204710009-10040-1-git-send-email-joonwpark81@gmail.com>
	 <1204710843.25502.50.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/3/5, Johannes Berg <johannes@sipsolutions.net>:
>
> On Wed, 2008-03-05 at 18:40 +0900, Joonwoo Park wrote:
> > resolve: http://bughost.org/bugzilla/show_bug.cgi?id=1522
> >
> > The function ieee80211_ioctl_siwencode shouldn't be called if
> > authentication process is not completed.
> > This patch makes the ieee80211_ioctl_siwessid to wait for authentication
> > is completed.
>

Johannes,
Thank you for reviewing this.

> This looks wrong. You could restart association when a key is set but
> really the race is by design in WEXT so the only way to fix it is to set
> the key first.
>

Do you mean fix iwconfig to always do set key before set essid?
As you said, It could be a possible solution.
But, doing It cannot solve a race from two seperated iwconfig process, I think.
(eg: iwconfig essid ESSID; iwconfig enc ENC)
Moreover, now we just wake auth request task up and return when setting essid.
Don't we need to wait a moment until the task is scheduled to be
polite to iwconifg? :)

Thanks,
Joonwoo
