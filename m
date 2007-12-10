Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:54244 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbXLJMRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 07:17:33 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3319247wah
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2007 04:17:32 -0800 (PST)
Message-ID: <1ba2fa240712100417y10577d1mf23f53119e2ba1d9@mail.gmail.com> (sfid-20071210_121736_746763_3928C9EC)
Date: Mon, 10 Dec 2007 14:17:31 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: pass in PS_POLL frames
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, yi.zhu@intel.com
In-Reply-To: <1197288539.6035.55.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1197278205280-git-send-email-ron.rindjunsky@intel.com>
	 <1197288539.6035.55.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 10, 2007 2:08 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > -     if ((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
> > -                     cpu_to_le16(IEEE80211_FTYPE_CTL))
> > +     if (((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
> > +                     cpu_to_le16(IEEE80211_FTYPE_CTL)) &&
> > +         ((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_STYPE)) !=
> > +                     cpu_to_le16(IEEE80211_STYPE_PSPOLL)))
>
> Hm. Don't we have macros for this?
>
Not in mac80211 as far as I know. There were some in ieee80211.
Iwlwifi have them in iwl-helpers.h  as inline functions
Tomas
