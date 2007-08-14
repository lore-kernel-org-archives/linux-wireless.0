Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:19417 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbXHNMPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 08:15:05 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1668503fkz
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2007 05:15:03 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/3] mac80211: remove management interface
Date: Tue, 14 Aug 2007 14:21:17 +0200
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <20070813074504.416717000@sipsolutions.net> <200708130844.27516.flamingice@sourmilk.net> <1187091766.4069.5.camel@johannes.berg>
In-Reply-To: <1187091766.4069.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708141421.17748.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 14 August 2007, Johannes Berg wrote:
> On Mon, 2007-08-13 at 08:44 -0700, Michael Wu wrote:
> > On Monday 13 August 2007 00:45, Johannes Berg wrote:
> > > Oh and somebody needs to fix zd1211rw-mac80211. It abused the
> > > MGMT interface constant that was explicitly mentioned to be
> > > not for drivers... I've "fixed" it for now but readers of the
> > > code may not be happy with it.
> 
> > I've done this in all my drivers. It's perfectly fine. If you're going to drop 
> > the MGMT enum, please post a patch to s/IEEE80211_IF_TYPE_MGMT/-1/ for all 
> > drivers.
> 
> Oh, I thought zd1211 was the only one doing that. I could add a
> IF_TYPE_INVALID if you really require that, but I don't see the point.
> As soon as the driver wants to work with multiple interfaces this stuff
> has to go anyway.

Also rt2x00 was using IEEE80211_IF_TYPE_MGMT as value to indicate no
interface has been configured. So if you are going to run
s/IEEE80211_IF_TYPE_MGMT/-1/ please include rt2x00.h in that run too.

Thanks :)

Ivo
