Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:53812 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071AbXK0JME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 04:12:04 -0500
Received: by mu-out-0910.google.com with SMTP id i10so1168163mue
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 01:12:02 -0800 (PST)
Message-ID: <c85cb4470711270112l15d408ebx8c3f64bec68b42c7@mail.gmail.com> (sfid-20071127_091209_753046_C51530B6)
Date: Tue, 27 Nov 2007 11:12:01 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 0/15] mac80211/iwlwifi (#everything): integrate IEEE802.11n support
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	tomas.winkler@intel.com
In-Reply-To: <43e72e890711261734s17621900yc9ee5946bc30482e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
	 <43e72e890711261734s17621900yc9ee5946bc30482e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Ron I haven't been able to review your 802.11n patches yet due to time
> but I do remember seeing some "channel" variable in a struct somewhere
> at a quick glance on your 802.11n patch series. It was determined a
> little while ago that we'd move from static channels to frequency
> instead. One reason for this is to stick to 'one' thing later for
> regulatory purposes. Another reason that came up later is that
> frequency be relied upon even on 5GHz reliably contrary to channel
> number -- in 5GHz the channel numbers can be mapped arbitrarily
> depending on the regulatory agency your country falls under. Would it
> be too much if you used frequency instead of channel or does the the
> 802.11n draft specs say you have to use channel somewhere?
>
> Sorry I couldn't pin point the specific patch yet.

it will be helpful to know the specific place where you spotted it,
but i will assume you are relating to the channel width and offset?.
in that case i took the 802.11n spec name from 2 reasons:
1 - to be clearer to code readers as to right place in the spec
2 - the spec strongly relates to 20/40 Mhz capabilities of the
channel, not to the channel itself, (e.g. extention channel), so i saw
no reason to break it and to go to frequencies.

ron

>
>  Luis
