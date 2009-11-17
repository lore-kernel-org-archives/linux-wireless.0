Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:55512 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbZKQWmw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 17:42:52 -0500
MIME-Version: 1.0
In-Reply-To: <1258490898.21197.42.camel@johannes.local>
References: <1258465585.3682.7.camel@johannes.local> <1258490898.21197.42.camel@johannes.local>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 18 Nov 2009 09:42:38 +1100
Message-ID: <646765f40911171442m467efbc8ped7abc9d529ed095@mail.gmail.com>
Subject: Re: [RFC v2] mac80211: disallow bridging managed/adhoc interfaces
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 18, 2009 at 07:48, Johannes Berg <johannes@sipsolutions.net> wrote:
> --- wireless-testing.orig/net/mac80211/iface.c  2009-11-17 14:20:19.000000000 +0100
> +++ wireless-testing/net/mac80211/iface.c       2009-11-17 17:56:08.000000000 +0100
> @@ -745,6 +745,11 @@ int ieee80211_if_change_type(struct ieee
>        if (type == sdata->vif.type)
>                return 0;
>
> +       /* if it's part of a bridge, reject changing type to station/ibss */
> +       if (sdata->dev->br_port && (type == NL80211_IFTYPE_ADHOC ||
> +                                   type == NL80211_IFTYPE_STATION))
> +               return -EBUSY;

Busy doesn't seem like the right error here ... maybe use -EOPNOTSUPP
like the next test?

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
