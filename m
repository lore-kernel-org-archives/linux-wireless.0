Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58299 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990Ab1IZXzo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 19:55:44 -0400
Date: Mon, 26 Sep 2011 16:50:11 -0700
From: Greg KH <greg@kroah.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 09/20] staging: brcm80211: use endian annotated
 structures in brcmsmac
Message-ID: <20110926235011.GA3878@kroah.com> (sfid-20110927_015547_935781_DE9679F5)
References: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
 <1316830148-28661-10-git-send-email-frankyl@broadcom.com>
 <1316860721.3952.5.camel@jlt3.sipsolutions.net>
 <4E7DCE39.1010406@broadcom.com>
 <1317029844.4117.31.camel@jlt3.sipsolutions.net>
 <4E80C3CE.9010001@broadcom.com>
 <4E80CFE1.506@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E80CFE1.506@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 26, 2011 at 12:17:53PM -0700, Franky Lin wrote:
> On 09/26/2011 11:26 AM, Arend van Spriel wrote:
> >On 09/26/2011 11:37 AM, Johannes Berg wrote:
> >>On Sat, 2011-09-24 at 14:34 +0200, Arend van Spriel wrote:
> >>>On 09/24/2011 12:38 PM, Johannes Berg wrote:
> >>>>On Fri, 2011-09-23 at 19:08 -0700, Franky Lin wrote:
> >>>>>    struct d11rxhdr {
> >>>>>    	u16 RxFrameSize;
> >>>>>    	u16 PAD;
> >>>>>+	union {
> >>>>>+		struct d11rxhdr_le rxh_le;
> >>>>>+		struct d11rxhdr rxh_cpu;
> >>>>>+	};
> >>>>This seems a little strange. Why would it be both in LE and CPU byte
> >>>>order?
> >>>Indeed. When we receive it from the device it is in LE and we convert it
> >>>to CPU order for further processing using rxh_cpu.
> >>That seems a confusing and error-prone -- you'll have to remember
> >>whether you're before or after conversion. Would it be possible to have
> >>two versions of the outer structure and change the pointer type at that
> >>point?
> >>
> >>johannes
> >
> >For me knowing the driver design (a little ;-) it is not difficult to
> >remember. Your feedback has valid arguments so I will reconsider. Franky
> >is looking whether dropping it will affect the other patches submitted
> >to Greg.
> >
> >Gr. AvS
> 
> Dropping this one will affect some following patches in the series.
> Since it's not a bug, shall we keep this one and change it as
> Johannes suggested in future commit?

How about just resend the whole series, that way I don't accidentally
apply it, or the other one you wanted dropped?

I've dropped this whole series from my to-apply queue now.

thanks,

greg k-h
