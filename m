Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55318 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab3EOSMt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 14:12:49 -0400
Message-ID: <1368641562.20897.11.camel@jlt4.sipsolutions.net> (sfid-20130515_201252_204088_F1EC64BC)
Subject: Re: [PATCHv2 03/18] mac80211: fix various components for the new 5
 and 10 MHz widths
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Leffler <sleffler@google.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 15 May 2013 20:12:42 +0200
In-Reply-To: <CA+yqC4a6W6i9TUoEc1Boxe6a5eun_TSjLB0F+w3F2L_Hn+v_gA@mail.gmail.com> (sfid-20130515_191656_282119_D9E15517)
References: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1368627549-22518-4-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <CA+yqC4a6W6i9TUoEc1Boxe6a5eun_TSjLB0F+w3F2L_Hn+v_gA@mail.gmail.com>
	 (sfid-20130515_191656_282119_D9E15517)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-05-15 at 10:16 -0700, Sam Leffler wrote:
> On Wed, May 15, 2013 at 7:18 AM, Simon Wunderlich
> <simon.wunderlich@s2003.tu-chemnitz.de> wrote:
>         This is a collection of minor fixes:
>          * don't allow HT IEs in IBSS for 5/10 MHz
>          * don't allow HT IEs in Mesh for 5/10 MHz
>          * consider 5 and 10 MHz channels when downgrading
>          * don't try HT rates for 5 and 10 MHz channels when selecting
>         rates
> 
> 
> Perhaps I missed a standards discussion but unilaterally disallowing
> HT rates on 5/10 channels breaks existing functionality (e.g. I use
> them on openwrt).  NOHT should be a regulatory constraint just like it
> is for 20 channels.

I don't see how this would break anything, since we wouldn't advertise
HT capabilities (for now). My point was that that the standard doesn't
(currently) define this, so I think it should be a separate second step
for 5/10 MHz channels to see how to do it in a way that wouldn't break
when/if the standard is changed to allow it, etc.

johannes


