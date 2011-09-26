Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52051 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab1IZJh3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 05:37:29 -0400
Subject: Re: [PATCH 09/20] staging: brcm80211: use endian annotated
 structures in brcmsmac
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4E7DCE39.1010406@broadcom.com>
References: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
	 <1316830148-28661-10-git-send-email-frankyl@broadcom.com>
	 ( sfid-20110924_040943_301385_9930B29B) <1316860721.3952.5.camel@jlt3.sipsolutions.net>
	 <4E7DCE39.1010406@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 11:37:24 +0200
Message-ID: <1317029844.4117.31.camel@jlt3.sipsolutions.net> (sfid-20110926_113732_779408_1B96751A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-09-24 at 14:34 +0200, Arend van Spriel wrote:
> On 09/24/2011 12:38 PM, Johannes Berg wrote:
> > On Fri, 2011-09-23 at 19:08 -0700, Franky Lin wrote:
> >>   struct d11rxhdr {
> >>   	u16 RxFrameSize;
> >>   	u16 PAD;
> >> +	union {
> >> +		struct d11rxhdr_le rxh_le;
> >> +		struct d11rxhdr rxh_cpu;
> >> +	};
> > This seems a little strange. Why would it be both in LE and CPU byte
> > order?
> 
> Indeed. When we receive it from the device it is in LE and we convert it 
> to CPU order for further processing using rxh_cpu.

That seems a confusing and error-prone -- you'll have to remember
whether you're before or after conversion. Would it be possible to have
two versions of the outer structure and change the pointer type at that
point?

johannes

