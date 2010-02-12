Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:23476 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab0BLIFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2010 03:05:25 -0500
Subject: Re: [PATCH 1/1] mac80211: fix handling of null-rate control in
 rate_control_get_rate
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "ext Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>
In-Reply-To: <43e72e891002112357k4b261c38x5f4d0fdc598bff3a@mail.gmail.com>
References: <1265961128-21301-1-git-send-email-juuso.oikarinen@nokia.com>
	 <43e72e891002112357k4b261c38x5f4d0fdc598bff3a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Feb 2010 10:03:09 +0200
Message-ID: <1265961789.3381.105.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-02-12 at 08:57 +0100, ext Luis R. Rodriguez wrote:
> On Thu, Feb 11, 2010 at 11:52 PM, Juuso Oikarinen
> <juuso.oikarinen@nokia.com> wrote:
> > For hardware with IEEE80211_HW_HAS_RATE_CONTROL the rate controller is not
> > initialized. However, calling functions such as ieee80211_beacon_get result
> > in the rate_control_get_rate function getting called, which is accessing
> > (in this case uninitialized) rate control structures unconditionally.
> >
> > Fix by exiting the function before setting the rates for HW with
> > IEEE80211_HW_HAS_RATE_CONTROL set. The initialization of the ieee80211_tx_info
> > struct is intentionally still executed.
> >
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
> 
> I meant adding it on the commit log, below the Reviewed-by line.
> 
>   Luis

Sorry, I misunderstood. 

I will resend it once again.

-Juuso

