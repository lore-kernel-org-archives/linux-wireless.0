Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:57580 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752196Ab2AURCr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 12:02:47 -0500
Received: by obcva7 with SMTP id va7so1778890obc.19
        for <linux-wireless@vger.kernel.org>; Sat, 21 Jan 2012 09:02:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F19262B.4000102@broadcom.com>
References: <CAC9WiBj8VkYe7ku7rc-e_+d7yNEAtEiozs8tnR_A1T1H3XjiSA@mail.gmail.com>
	<CAC9WiBh5-vS6UmCYCs911WAudmWDtsgDPmHim71LtvaC81HsWQ@mail.gmail.com>
	<4F19262B.4000102@broadcom.com>
Date: Sat, 21 Jan 2012 18:02:47 +0100
Message-ID: <CAC9WiBi2Zo_WbDOhLnr-e8YV+xvDufTmg7PWQ0fZPtjVae-+hw@mail.gmail.com> (sfid-20120121_180250_808587_A3CE8F1C)
Subject: Re: brcmsmac broken with 3.2
From: Francis Moreau <francis.moro@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Alwin Beukers <alwin@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Julian Calaby <julian.calaby@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 20, 2012 at 9:30 AM, Arend van Spriel <arend@broadcom.com> wrote:
>
> Did this problem occur with plain 3.2 kernel. I checked out the v3.2
> mainline tag and looked at line 2979:ieee80211_rx():
> 2975:        /*
> 2976:         * The same happens when we're not even started,
> 2977:         * but that's worth a warning.
> 2978:         */
> 2979:        if (WARN_ON(!local->started))
> 2980:                goto drop;
>
>>> ieee80211_rx+0x91b/0x9e0 [mac80211]()
>>> [36370.370775] Hardware name: Vostro 3500
>>> [36370.370870] Pid: 0, comm: swapper/0 Tainted: G        WC O 3.2.0
>
> I guess brcmsmac is sending up a received wireless packet to mac80211
> and it is dropped, because mac80211 did not yet call the start callback.
> It is just a warning so if you are having problems connecting to an AP
> you may have other issues.

After this warning I can't connect to an AP anymore, I have to unload
and reload the brcmsmac module.

Thanks for your time.
-- 
Francis
