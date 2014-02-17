Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:37808 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaBQPtf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 10:49:35 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so7044891eei.21
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 07:49:33 -0800 (PST)
Message-ID: <1392652166.878.19.camel@umadbro> (sfid-20140217_164939_308086_764FF45A)
Subject: Re: [RFC 1/4] mac80211: Allow 5/10 MHz channel setting (for OCB)
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de
Date: Mon, 17 Feb 2014 16:49:26 +0100
In-Reply-To: <1392644957.5202.7.camel@jlt4.sipsolutions.net>
References: <1392643374-3545-1-git-send-email-lisovy@gmail.com>
	 <1392643374-3545-2-git-send-email-lisovy@gmail.com>
	 (sfid-20140217_142311_364138_9794E9CF) <1392644957.5202.7.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Johannes;
Thank you for your feedback.

On Mon, 2014-02-17 at 14:49 +0100, Johannes Berg wrote:
> On Mon, 2014-02-17 at 14:22 +0100, Rostislav Lisovy wrote:
> > Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
> 
> Err, some text is definitely needed.
> 
> > ---
> >  include/net/cfg80211.h       |  19 ++++++-
> >  include/net/mac80211.h       |   4 +-
> >  include/uapi/linux/nl80211.h |  17 ++++++-
> >  net/wireless/chan.c          |   8 +++
> >  net/wireless/core.c          |   3 --
> >  net/wireless/nl80211.c       |  14 ++++++
> >  net/wireless/reg.c           | 115 ++++++++++++++++++++++++++++++++++++++-----
> >  7 files changed, 161 insertions(+), 19 deletions(-)

> 
> Umm.
> 
> Might have mentioned that in your 0/4 that you want help on specific
> things :)
> 
> [I haven't even really reviewed the regulatory code]


As you have already noticed, this is work in progress. I agree it is
necessary to keep the code clean if I want others to read it -- I try to
do so but it does not always go very well.

One thing I am not sure about (mentioned in 0/4) and need some
suggestions is frequency setting in the OCB mode.
Since there are no beacons containing the information about the
frequency to set, the frequency is set manually. Since the
'set_channel()' function is not present anymore (and we do not have
'ocb_join()' function, thus we cannot use 'preset_chandef'), I was not
able to figure out how to set a fixed channel.
If I would want to set the frequency with the
ieee80211_vif_use_channel() function, I would need to somehow obtain the
*sdata. If I check ieee80211_set_monitor_channel() I see how *sdata is
obtained there, but I am not sure if it is a good idea to add *ocb_sdata
to struct ieee80211_local?

Best regards;
Rostislav Lisovy

