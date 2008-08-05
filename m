Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:18614 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbYHEHOI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 03:14:08 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2475652rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Aug 2008 00:14:07 -0700 (PDT)
Message-ID: <1ba2fa240808050014t6e315fe5s607aff1656c1f8d1@mail.gmail.com> (sfid-20080805_091413_342850_C31A6EE5)
Date: Tue, 5 Aug 2008 10:14:06 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: filter probes in ieee80211_rx_mgmt_probe_resp
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1217787259.4721.18.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217763121-9057-1-git-send-email-tomas.winkler@intel.com>
	 <1217787259.4721.18.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 3, 2008 at 9:14 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2008-08-03 at 14:32 +0300, Tomas Winkler wrote:
>> This patch moves filtering statement from ieee80211_rx_bss_info
>> which is called for both beacon and probe to ieee80211_rx_mgmt_probe_resp
>> and save few cycles in beacon parsing.
>
> Sounds alright to me, but maybe we should then document that
> rx_bss_info() only expects data for the right BSSID?

Probes are filtered on destination address not on BSSID, to exclude
probe responses not directed to the station.
bss_info treats any BSSID this is what creates the bss list after all
if I'm not mistaken.
Tomas
