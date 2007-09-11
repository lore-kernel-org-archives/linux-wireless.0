Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:31965 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761514AbXIKKD0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2007 06:03:26 -0400
Received: by an-out-0708.google.com with SMTP id d31so197697and
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2007 03:03:25 -0700 (PDT)
Message-ID: <1ba2fa240709110303s56077295p814c0518d36aacbe@mail.gmail.com>
Date: Tue, 11 Sep 2007 13:03:24 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Daniel Drake" <dsd@gentoo.org>
Subject: Re: zd-mac80211: Fix TX status reports.
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Buesch" <mb@bu3sch.de>,
	"Ulrich Kunitz" <kune@deine-taler.de>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <46E64935.9010905@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200709082341.31720.mb@bu3sch.de> <200709091259.00237.mb@bu3sch.de>
	 <1189421542.4506.46.camel@johannes.berg>
	 <200709101258.39619.mb@bu3sch.de>
	 <1189422611.4506.58.camel@johannes.berg>
	 <1ba2fa240709102050l75402df4w19ef746d6243dbab@mail.gmail.com>
	 <46E64935.9010905@gentoo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/11/07, Daniel Drake <dsd@gentoo.org> wrote:
> Tomas Winkler wrote:
> > Receiving all ACKs packets will degraded performance greatly for sure,
> > even on PCI interface.
> > Receving ACK can maybe allowed selectively only for management packets
> > including EAPOLS in some synchronous way, yet this is still error
> > prone.
>
> I don't think we have such control. It's either all ACKs or no ACKs.
>
For MLME completeness
Set timer for direct management frames and EAPOLs cancel the timer on
failure TX in interrupt  arrival. Send TX status success from the
timer handler.
For data frames just report success otherwise it will effect performance.
The drawback is that you need to watch each TX frame in the driver.
..
You probably have to implement your own rate scale statistic
collection like iwlwifi does

> > It looks strange to me that there is no other HW mechanism that does that?
> > Is this driver reverse engineered?
>
> No. There is another mechanism for detecting failed transmissions: we
> get an interrupt for every failed TX. I feel that this should be enough
> to implement rate control, however mac80211 at the moment requires
> reports of both success and failure for rate control to work. Detecting
> success is the tricky part.
>
> Daniel
>
>
