Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:46493 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3IJJOp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 05:14:45 -0400
Message-ID: <1378804510.4799.69.camel@porter.coelho.fi> (sfid-20130910_111453_918734_5760ADDA)
Subject: Re: [PATCH 06/12] wlcore: send EAPOL frames with voice priority
From: Luca Coelho <luca@coelho.fi>
To: Arik Nemtsov <arik@wizery.com>
Cc: Eliad Peller <eliad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 10 Sep 2013 12:15:10 +0300
In-Reply-To: <CA+XVXfc6RG1BngT_+doiOUhtYAgnG9Q0-oXns-ckJkU7XhE5ag@mail.gmail.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	 <1378218848-7853-6-git-send-email-eliad@wizery.com>
	 <1378795636.4799.44.camel@porter.coelho.fi>
	 <CA+XVXfc6RG1BngT_+doiOUhtYAgnG9Q0-oXns-ckJkU7XhE5ag@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-10 at 11:11 +0200, Arik Nemtsov wrote:
> On Tue, Sep 10, 2013 at 9:47 AM, Luca Coelho <luca@coelho.fi> wrote:
> > On Tue, 2013-09-03 at 17:34 +0300, Eliad Peller wrote:
> >> From: Igal Chernobelsky <igalc@ti.com>
> >>
> >> Send EAPOL frames with voice priority by setting TX_HW_ATTR_EAPOL_FRAME
> >> new bit in tx attribute. Sending EAPOL with voice priority fixes
> >> re-key timeout during heavy traffic issue.
> >>
> >> Signed-off-by: Igal Chernobelsky <igalc@ti.com>
> >> Signed-off-by: Eliad Peller <eliad@wizery.com>
> >> ---
> >
> > This seems to be the same problem that Ben had and debugged by himself
> > [1].  Fixing this in hostapd/wpa_supplicant seems more appropriate?
> >
> > This patch seems to take an advantage of some sort of hack in the
> > firmware that will change the priority by itself when the
> > TX_HW_ATTR_EAPOL_GRAME bit is set.  If we have a good reason to use this
> > patch, we need to take care of the firmware version as well.  This
> > probably doesn't work with the latest published firmware.
> >
> > [1] http://mid.gmane.org/522E18E5.1020503@candelatech.com
> 
> I believe he only fixed one mode (AP - hostapd) but not the other (GO
> - wpa_supplicant). Anyway that's what we tested at the time.

Okay, I didn't dig much into it.


> Anyway marking it as this level doesn't do any harm. You're right
> about the FW version though - it should be upstreamed first.

Fair enough.  If the firmware implements this, no reason why not use it.
But I'll wait for the new firmware before applying this.

--
Luca.

