Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:44167 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbXLWRiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 12:38:22 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1407137fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 23 Dec 2007 09:38:21 -0800 (PST)
Message-ID: <c85cb4470712230938j7e84d43dx2a85911b54d1b062@mail.gmail.com> (sfid-20071223_173826_830575_45D4EF06)
Date: Sun, 23 Dec 2007 19:38:20 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/8] mac80211: A-MPDU Rx handling aggregation reordering
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1198430920.4541.11.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070782762-git-send-email-ron.rindjunsky@intel.com>
	 <1198145667.16241.23.camel@johannes.berg>
	 <c85cb4470712200432w3640359dje70f57c86be3497a@mail.gmail.com>
	 <1198154463.16241.46.camel@johannes.berg>
	 <c85cb4470712230815u158cd19fjc1ff58a7e2c83fbc@mail.gmail.com>
	 <1198430920.4541.11.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> So I'd see the flow as:
>
> tasklet/driver
> __ieee80211_rx()
>        __rx_pre_monitor()
>        __rx_pre_load()
>        __rx_pre_qos()
>
>        if (agg)
>                __rx_handle_reorder()
>        else
>                __rx_handle_packet()
>
> and __rx_handle_reorder() calls __rx_handle_packet() which does all the
> rest, I guess.
>

that's the general idea, but __rx_pre_qos() won't be able to be in
__ieee80211_rx(), as it handles txrx_data. if it will be there i am
back in the original problem - the need to restore txrx_data per
frame. i will have to put it inside __rx_handle_packet().
