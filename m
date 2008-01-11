Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:10461 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759952AbYAKSUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 13:20:32 -0500
Received: by py-out-1112.google.com with SMTP id u52so1768959pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2008 10:20:31 -0800 (PST)
Message-ID: <c85cb4470801111020w6de28dc7jb58f0eacac513978@mail.gmail.com> (sfid-20080111_182037_384799_7DD70CE2)
Date: Fri, 11 Jan 2008 20:20:30 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/8 v3] mac80211: A-MPDU Rx adding basic functionality
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1199976980.3861.87.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11985948383801-git-send-email-ron.rindjunsky@intel.com>
	 <11985948451654-git-send-email-ron.rindjunsky@intel.com>
	 <1199976980.3861.87.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> [32566.907283] rx BA session requested to stop on inactive tid 0
> [32566.907290] rx BA session requested to stop on inactive tid 1
> [...]
>
> I suppose the message isn't really necessary except from
> ieee80211_sta_process_delba(), or something. Either way, we should get
> rid of it in the regular case.
>
> johannes
>

what about putting it inside CONFIG_MAC80211_HT_DEBUG ? i don't want
to lose this print, there are several cases were it might help - timer
expirations, delBA, and fragmented frames.
