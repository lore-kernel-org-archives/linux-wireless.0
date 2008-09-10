Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.190]:62768 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbYIJVcx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 17:32:53 -0400
Received: by gv-out-0910.google.com with SMTP id e6so24874gvc.37
        for <linux-wireless@vger.kernel.org>; Wed, 10 Sep 2008 14:32:51 -0700 (PDT)
Message-ID: <1ba2fa240809101432u23bf198bqcf9bd0e9f91a2ae8@mail.gmail.com> (sfid-20080910_233257_974111_01AA8674)
Date: Thu, 11 Sep 2008 00:32:51 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: scan on IBSS mode like on STA mode
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Ester Kummer" <ester.kummer@intel.com>,
	"Luis Carlos Cobo" <luisca@cozybit.com>
In-Reply-To: <1ba2fa240809081524ia1860e3o3327a64c933a09a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220880686-5620-1-git-send-email-tomas.winkler@intel.com>
	 <1220885742.31304.67.camel@johannes.berg>
	 <1220886337.31304.71.camel@johannes.berg>
	 <1220887018.31304.74.camel@johannes.berg>
	 <1ba2fa240809080953mfe2ab86l5417679e4cb29df1@mail.gmail.com>
	 <1220897594.31304.83.camel@johannes.berg>
	 <1ba2fa240809081524ia1860e3o3327a64c933a09a3@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 9, 2008 at 1:24 AM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Mon, Sep 8, 2008 at 9:13 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Mon, 2008-09-08 at 19:53 +0300, Tomas Winkler wrote:
>>
>>> The bug is that scan can be triggered in STA and IBSS internally. If
>>> you request scan from the application (iwlist) while
>>> internally scan is running application won't fetch scan results
>>> because the -EBUSY is returned on scan request.
>>
>> But -EBUSY won't be returned if that same interface is already scanning,
>> then 0 will be returned, so I don't understand?
>
> Me either, but empirically the fix from Esti cured the problem. The
> problem is seen only in IBSS. Will dig into this tomorrow.

Okay so here is the scenario. Iwlwifi reject scan that is triggered
withing fixed period after
association to leave time to finish EAPOL exchange.
We never hit the problem in STA mode because of this code

 if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
		return ieee80211_sta_start_scan(dev, ssid, ssid_len);

which makes it go through the work queue, just pure timing luck.
I will remove this delay for IBSS, there is no association and no 1X
is going on.

For BSS I suggest to enforce similar delay already mac80211, iwlwifi I
just return empty scan completion and buffered results will be
returned.

Tomas
